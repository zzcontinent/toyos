#include <assert.h>
#include <console.h>
#include <defs.h>
#include <kbdreg.h>
#include <memlayout.h>
#include <picirq.h>
#include <stdio.h>
#include <string.h>
#include <trap.h>
#include <x86.h>

static uint16_t* crt_buf;
static uint16_t crt_pos;
static uint16_t addr_6845;

static void delay(void)
{
	inb(0x84);
	inb(0x84);
	inb(0x84);
	inb(0x84);
}

static void cga_init(void)
{
	volatile uint16_t* cp = (uint16_t*)(CGA_BUF + KERNBASE);
	uint16_t was = *cp;
	*cp = (uint16_t)0xA55A;
	if (*cp != 0xA55A) {
		cp = (uint16_t*)(MONO_BUF + KERNBASE);
		addr_6845 = MONO_BASE;
	} else {
		*cp = was;
		addr_6845 = CGA_BASE;
	}

	// extract cursor location
	uint32_t pos;
	outb(addr_6845, 14);
	pos = inb(addr_6845 + 1) << 8;
	outb(addr_6845, 15);
	pos |= inb(addr_6845 + 1);

	crt_buf = (uint16_t*)cp;
	crt_pos = pos;
}

static bool serial_exists = 0;

void serial_init(void)
{
	// turn off FIFO
	outb(COM1 + COM_FCR, 0);

	// set speed: require DLAB latch
	outb(COM1 + COM_LCR, COM_LCR_DLAB);
	outb(COM1 + COM_DLL, (uint8_t)(115200 / 9600));
	outb(COM1 + COM_DLM, 0);

	// 8 bits data, 1 stop bit, parity off; turn off DLAB latch
	outb(COM1 + COM_MCR, 0);

	// no modem control
	outb(COM1 + COM_MCR, 0);
	// enable rcv interrupts
	outb(COM1 + COM_IER, COM_IER_RDI);

	//clear any preexisting overrun indications and interrupts
	// serial port doesn't exist if COM_LSR returns 0xFF
	serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
	(void)inb(COM1 + COM_IIR);
	(void)inb(COM1 + COM_RX);

	if (serial_exists) {
		pic_enable(IRQ_COM1);
	}
}

static void lpt_putc_sub(int c)
{
	int i;
	for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i++) {
		delay();
	}
	outb(LPTPORT + 0, c);
	outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
	outb(LPTPORT + 2, 0x08);
}

/* lpt_putc - copy console output to parallel port */
static void lpt_putc(int c)
{
	if (c != '\b') {
		lpt_putc_sub(c);
	} else {
		lpt_putc_sub('\b');
		lpt_putc_sub(' ');
		lpt_putc_sub('\b');
	}
}

/* cga_putc - print character to console */
static void cga_putc(int c)
{
	// set black on white
	if (!(c & ~0xFF)) {
		c |= 0x0700;
	}
	switch (c & 0xFF) {
		case '\b':
			if (crt_pos > 0) {
				crt_pos--;
				crt_buf[crt_pos] = (c & ~0xFF) | ' ';
			}
			break;
		case '\n':
			crt_pos += CRT_COLS;
		case '\r':
			crt_pos -= (crt_pos % CRT_COLS);
			break;
		default:
			crt_buf[crt_pos++] = c; // write the character
			break;
	}

	// what is the purpose of this?
	if (crt_pos >= CRT_SIZE) {
		int i;
		memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
		for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++) {
			crt_buf[i] = 0x0700 | ' ';
		}
		crt_pos -= CRT_COLS;
	}

	// move that little blinky thing
	outb(addr_6845, 14);
	outb(addr_6845 + 1, crt_pos >> 8);
	outb(addr_6845, 15);
	outb(addr_6845 + 1, crt_pos);
}

static void serial_putc_sub(int c)
{
	for (int i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i++) {
		delay();
	}
	outb(COM1 + COM_TX, c);
}

static void serial_putc(int c)
{
	if (c != '\b') {
		serial_putc_sub(c);
	} else {
		serial_putc_sub('\b');
		serial_putc_sub(' ');
		serial_putc_sub('\b');
	}
}

/*
 * manage the console input buffer, where we stash characters received
 * from the keyboard or serial port  whenever the corresponding
 * interrupt occurs.
 * */

#define CONSBUFFSIZE 512

static struct {
	uint8_t buf[CONSBUFFSIZE];
	uint32_t rpos;
	uint32_t wpos;
} cons;

/*
 * called by device interrupt routines to feed input
 * characters into circular console input buffer.
 * */
static void cons_intr(int (*proc)(void))
{
	int c;
	while ((c = (*proc)()) != -1) {
		if (c != 0) {
			cons.buf[cons.wpos++] = c;
			if (cons.wpos == CONSBUFFSIZE) {
				cons.wpos = 0;
			}
		}
	}
}

/* get data from serial port */
static int serial_proc_data(void)
{
	if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
		return -1;
	}
	int c = inb(COM1 + COM_RX);
	if (c == 127) {
		c = '\b';
	}
	return c;
}

/* try to feed input characters from serial port */
void serial_intr(void)
{
	if (serial_exists) {
		cons_intr(serial_proc_data);
	}
}

/************ keyboard input code ************/

#define NO 0
#define SHIFT (1 << 0)
#define CTL (1 << 1)
#define ALT (1 << 2)
#define CAPSLOCK (1 << 3)
#define NUMLOACK (1 << 4)
#define SCROLLLOCK (1 << 5)
#define E0ESC (1 << 6)

static uint8_t shiftcode[256] = {
	[0x1D] CTL,
	[0x2A] SHIFT,
	[0x36] SHIFT,
	[0x38] ALT,
	[0x2A] CTL,
	[0x2A] ALT,
};

static uint8_t togglecode[256] = {
	[0x3A] CAPSLOCK,
	[0x45] NUMLOACK,
	[0x46] SCROLLLOCK,
};

static uint8_t normalmap[256] = {
	NO, 0x1B, '1', '2', '3', '4', '5', '6', // 0x00
	'7', '8', '9', '0', '-', '=', '\b', '\t',
	'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', // 0x10
	'o', 'p', '[', ']', '\n', NO, 'a', 's',
	'd', 'f', 'g', 'h', 'j', 'k', 'l', ';', // 0x20
	'\'', '`', NO, '\\', 'z', 'x', 'c', 'v',
	'b', 'n', 'm', ',', '.', '/', NO, '*', // 0x30
	NO, ' ', NO, NO, NO, NO, NO, NO,
	NO, NO, NO, NO, NO, NO, NO, '7', // 0x40
	'8', '9', '-', '4', '5', '6', '+', '1',
	'2', '3', '0', '.', NO, NO, NO, NO, // 0x50
	[0xC7] KEY_HOME, [0x9C] '\n' /*KP_Enter*/,
	[0xB5] '/' /*KP_Div*/, [0xC8] KEY_UP,
	[0xC9] KEY_PGUP, [0xCB] KEY_LF,
	[0xCD] KEY_RT, [0xCF] KEY_END,
	[0xD0] KEY_DN, [0xD1] KEY_PGDN,
	[0xD2] KEY_INS, [0xD3] KEY_DEL
};

static uint8_t shiftmap[256] = {
	NO, 033, '!', '@', '#', '$', '%', '^', // 0x00
	'&', '*', '(', ')', '_', '+', '\b', '\t',
	'Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', // 0x10
	'O', 'P', '{', '}', '\n', NO, 'A', 'S',
	'D', 'F', 'G', 'H', 'J', 'K', 'L', ':', // 0x20
	'"', '~', NO, '|', 'Z', 'X', 'C', 'V',
	'B', 'N', 'M', '<', '>', '?', NO, '*', // 0x30
	NO, ' ', NO, NO, NO, NO, NO, NO,
	NO, NO, NO, NO, NO, NO, NO, '7', // 0x40
	'8', '9', '-', '4', '5', '6', '+', '1',
	'2', '3', '0', '.', NO, NO, NO, NO, // 0x50
	[0xC7] KEY_HOME, [0x9C] '\n' /*KP_Enter*/,
	[0xB5] '/' /*KP_Div*/, [0xC8] KEY_UP,
	[0xC9] KEY_PGUP, [0xCB] KEY_LF,
	[0xCD] KEY_RT, [0xCF] KEY_END,
	[0xD0] KEY_DN, [0xD1] KEY_PGDN,
	[0xD2] KEY_INS, [0xD3] KEY_DEL
};

#define C(x) (x - '@')

static uint8_t ctlmap[256] = {
	NO, NO, NO, NO, NO, NO, NO, NO,
	NO, NO, NO, NO, NO, NO, NO, NO,
	C('Q'), C('W'), C('E'), C('R'), C('T'), C('Y'), C('U'), C('I'),
	C('O'), C('P'), NO, NO, '\r', NO, C('A'), C('S'),
	C('D'), C('F'), C('G'), C('H'), C('J'), C('K'), C('L'), NO,
	NO, NO, NO, C('\\'), C('Z'), C('X'), C('C'), C('V'),
	C('B'), C('N'), C('M'), NO, NO, C('/'), NO, NO,
	[0x97] KEY_HOME,
	[0xB5] C('/'), [0xC8] KEY_UP,
	[0xC9] KEY_PGUP, [0xCB] KEY_LF,
	[0xCD] KEY_RT, [0xCF] KEY_END,
	[0xD0] KEY_DN, [0xD1] KEY_PGDN,
	[0xD2] KEY_INS, [0xD3] KEY_DEL
};

static uint8_t* charcode[4] = {
	normalmap,
	shiftmap,
	ctlmap,
	ctlmap,
};

static int kbd_proc_data(void)
{
	int c;
	uint8_t data;
	static uint32_t shift;
	if ((inb(KBSTATP) & KBS_DIB) == 0) {
		return -1;
	}
	data = inb(KBDATAP);
	if (data == 0xE0) {

	} else if (data & 0x80) {

	} else if (shift & E0ESC) {
	}

	shift |= shiftcode[Data];
	shift ^= togglecode[data];
	c = charcode[shift & (CTL | shift)][data];
	if (shift & CAPSLOCK) {
		if ('a' <= c && c <= 'z')
			c += 'A' - 'a';
		else if ('A' <= c && c <= 'Z')
			c += 'a' - 'A';
	}
	// process sepcial keys: CTRL-ALT-DEL: reboot
	if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
		cprintf("rebooting...\n");
		outb(0x92, 0x3);
	}
	return c;
}

static void kbd_intr(void)
{
	cons_intr(kbd_proc_data);
}

static void kbd_init(void)
{
	kbd_intr();
	pic_enable(IRQ_KBD);
}

void cons_init(void)
{
	cga_init();
	serial_init();
	kbd_init();
	if (!serial_exists) {
		cprintf("serial port does not exist!\n");
	}
}

void cons_putc(int c)
{
	bool intr_flag;
	local_intr_save(intr_flag);
	{
		lpt_putc(c);
		cga_putc(c);
		serial_putc(c);
	}
	local_intr_restore(intr_flag);
}

int cons_getc(void)
{
	int c = 0;
	bool intr_flag;
	local_intr_save(intr_flag);
	{
		kbd_intr();
		if (cons.rpos != cons.wpos) {
			c = cons.buf[cons.rpos++];
			if (cons.rpos == CONSBUFFSIZE) {
				cons.rpos = 0;
			}
		}
	}
	local_intr_restore(intr_flag);
	return c;
}
