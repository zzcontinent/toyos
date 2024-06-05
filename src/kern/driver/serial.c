/* ********************************************************************************
 * FILE NAME   : serial.c
 * PROGRAMMER  : zhaozz
 * DESCRIPTION : serial driver
 * DATE        : 2023-06-18 17:56:52
 * *******************************************************************************/
#include <libs/libs_all.h>
#include <kern/driver/serial.h>
#include <kern/driver/pic.h>

bool serial_exists = 0;

void delay(void)
{
	inb(0x84);
	inb(0x84);
	inb(0x84);
	inb(0x84);
}

void serial_init()
{
	// turn off FIFO
	outb(COM1 + COM_FCR, 0);

	// set speed: require DLAB latch
	outb(COM1 + COM_LCR, COM_LCR_DLAB);
	outb(COM1 + COM_DLL, (u8)(115200 / 9600));
	outb(COM1 + COM_DLM, 0);

	// 8 bits data, 1 stop bit, parity off; turn off DLAB latch
	outb(COM1 + COM_LCR, COM_LCR_WLEN8 & ~COM_LCR_DLAB);

	// no modem control
	outb(COM1 + COM_MCR, 0);
	// enable rcv interrupts
	outb(COM1 + COM_IER, COM_IER_RDI);

	// clear any preexisting overrun indications and interrupts
	//  serial port doesn't exist if COM_LSR returns 0xFF
	serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
	(void)inb(COM1 + COM_IIR);
	(void)inb(COM1 + COM_RX);

	if (serial_exists) {
		pic_enable(IRQ_COM1);
	}
}

void serial_putc_sub(int c)
{
	for (int i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i++) {
		delay();
	}
	outb(COM1 + COM_TX, c);
}

void serial_putc(int c)
{
	if (c != '\b') {
		serial_putc_sub(c);
	} else {
		serial_putc_sub('\b');
		serial_putc_sub(' ');
		serial_putc_sub('\b');
	}
}

/* get data from serial port */
int serial_getc(void)
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

