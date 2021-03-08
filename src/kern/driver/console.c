#include "picirq.h"
#include <console.h>
#include <defs.h>
#include <memlayout.h>
#include <stdio.h>
#include <string.h>
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

static void serial_intr(void)
{
	// turn off FIFO
	outb(COM1 + COM_FCR, 0);

	// set speed: require DLAB latch
	outb(COM1 + COM_LCR, COM_LCR_DLAB);
	outb(COM1 + COM_DLL, (uint8_t) (115200 / 9600));
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
	(void) inb(COM1 + COM_IIR);
	(void) inb(COM1 + COM_RX);

	if (serial_exists)
	{
		pic_enable(IRQ_COM1);
	}
}


















