#include <libs/libs_all.h>
#include <kern/driver/serial.h>
#include <kern/driver/kbd.h>
#include <kern/driver/cga.h>
#include <kern/debug/assert.h>
#include <kern/driver/console.h>
#include <kern/mm/memlayout.h>
#include <kern/driver/pic.h>
#include <kern/trap/trap.h>
#include <kern/sync/sync.h>
#include <kern/fs/devs/dev.h>

#define CONSBUFFSIZE 512
static u8 __g_cbuf[CONSBUFFSIZE];
static struct ringbuf g_cbuf;
static volatile u32 __cons_type = CONS_TYPE_SERIAL_POLL;

void set_cons_type(u32 type)
{
	__cons_type = type;
}

u32 get_cons_type()
{
	return __cons_type;
}

void cons_wait_feed_buf(int (*proc)(void))
{
	int c;
	while ((c = (*proc)()) != -1) {
		if (c != 0) {
			rb_write(&g_cbuf, (u8*)&c, 1);
		}
	}
}

void cons_init(u32 type)
{
	printf("init type:%d\n", type);
	rb_init(&g_cbuf, __g_cbuf, CONSBUFFSIZE);

	set_cons_type(type);
	if (type & CONS_TYPE_CGA) {
		cga_init();
	}

	if ((type & CONS_TYPE_SERIAL_POLL) || (type & CONS_TYPE_SERIAL_ISR_DEV_STDIN)) {
		serial_init();
	}

	if (type & CONS_TYPE_KEYBOARD_POLL) {
		kbd_init();
	}
	if (!serial_exists) {
		cprintf("serial port does not exist!\n");
	}
}

void cons_putc(int c)
{
	bool intr_flag;
	local_intr_save(intr_flag);
	{
		int type = get_cons_type();
		if (type & CONS_TYPE_CGA) {
			cga_putc(c);
		}
		if (type & CONS_TYPE_SERIAL_POLL || type & CONS_TYPE_SERIAL_ISR_DEV_STDIN) {
			serial_putc(c);
		}
	}
	local_intr_restore(intr_flag);
}

int cons_getc(void)
{
	int c = 0;
	bool intr_flag;
	local_intr_save(intr_flag);
	{
		int type = get_cons_type();
		if ((type & CONS_TYPE_SERIAL_POLL)) {
			cons_wait_feed_buf(serial_getc);
		}
		if (type & CONS_TYPE_KEYBOARD_POLL) {
			cons_wait_feed_buf(kbd_proc_data);
		}
		//always read char form g_cbuf
		rb_read(&g_cbuf, (u8*)&c, 1);
	}
	local_intr_restore(intr_flag);
	return c;
}

int cons_dupc(void)
{
	int c = 0;
	bool intr_flag;
	local_intr_save(intr_flag);
	{
		rb_dup(&g_cbuf, (u8*)&c, 1);
	}
	local_intr_restore(intr_flag);
	return c;
}

void cons_isr()
{
	int type = get_cons_type();
	udebug("type=0x%x\n", type);
	if (type & CONS_TYPE_SERIAL_ISR_DEV_STDIN) {
		cons_wait_feed_buf(serial_getc);
		dev_stdin_write(cons_getc());
	}
	if (type & CONS_TYPE_KEYBOARD_ISR) {
		cons_wait_feed_buf(kbd_proc_data);
	}
}

