/* ********************************************************************************
 * FILE NAME   : cga.c
 * PROGRAMMER  : zhaozz
 * DESCRIPTION : cga driver
 * DATE        : 2023-06-18 23:43:23
 * *******************************************************************************/
#include <libs/defs.h>
#include <libs/types.h>
#include <libs/x86.h>
#include <libs/string.h>
#include <kern/driver/cga.h>
#include <kern/mm/memlayout.h>

static u16* crt_buf;
static u16 crt_pos;
static u16 addr_6845;

void cga_init(void)
{
	volatile u16* cp = (u16*)(CGA_BUF + KERNBASE);
	u16 was = *cp;
	*cp = (u16)0xA55A;
	if (*cp != 0xA55A) {
		cp = (u16*)(MONO_BUF + KERNBASE);
		addr_6845 = MONO_BASE;
	} else {
		*cp = was;
		addr_6845 = CGA_BASE;
	}

	// extract cursor location
	u32 pos;
	outb(addr_6845, 14);
	pos = inb(addr_6845 + 1) << 8;
	outb(addr_6845, 15);
	pos |= inb(addr_6845 + 1);

	crt_buf = (u16*)cp;
	crt_pos = pos;
}

/* cga_putc - print character to console */
void cga_putc(int c)
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
		memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(u16));
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

