#include <libs/libs_all.h>
#include <kern/driver/pic.h>

// I/O addresses of the two programmable interrupt controllers
#define IO_PIC1 0x20 // master (IRQs 0-7)
#define IO_PIC2 0xA0 // master (IRQs 0-7)

#define IRQ_SLAVE 2 // IRQ at which slave connects to master

// current IRQ mask
// initial IRQ mask has interrupt 2 enabled (for slave 8259A)
static u16 irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void pic_setmask(u16 mask)
{
	irq_mask = mask;
	if (did_init) {
		outb(IO_PIC1 + 1, mask);
		outb(IO_PIC2 + 1, mask >> 8);
	}
}

void pic_enable(unsigned int irq)
{
	pic_setmask(irq_mask & ~(1 << irq));
}

void pic_init(void)
{
	did_init = 1;

	// mask all interrupts
	outb(IO_PIC1 + 1, 0xFF);
	outb(IO_PIC2 + 1, 0xFF);

	// set up master (8259A-1)
	//  ICW1: 0001g0hi
	//  g: 0 = edge trig, 1 = level trig
	//  h: 0 = cascaded PICs, 1 = master only
	//  i: 0 = no ICW4, 1 = ICW4 required
	outb(IO_PIC1, 0x11);

	// ICW2: vector offset
	outb(IO_PIC1 + 1, IRQ_OFFSET);

	// ICW3: (master PIC) bit mask of IR lines connected to slaves
	//     (slave PIC) 3-bit # of slave's connection to master
	outb(IO_PIC1 + 1, 1 << IRQ_SLAVE);

	// ICW4: 000nbmap
	// n: 1 = special fully nested mode
	// b: 1 = buffered mode
	// m: 0 = slave PIC, 1 = master PIC
	//    ignored when b is 0, as the master/slave role can be hardwired
	// a: 1 = automatic EOI mode
	// p: 0 = MCS-80.85 mode, 1 = intel x86 mode
	outb(IO_PIC1 + 1, 0x3);

	// set up slave (8259A-2)
	outb(IO_PIC2, 0x11);           // ICW1
	outb(IO_PIC2 + 1, IRQ_OFFSET + 8); // ICW2
	outb(IO_PIC2 + 1, IRQ_SLAVE);      // ICW3

	// NB automatic EOI mode does not tend to work on slave
	// linux source code says it's "to be investigated".
	outb(IO_PIC2 + 1, 0x3); // ICW4

	// OCW3: 0ef01prs
	// ef:     0x = NOP, 10 = clear specific mask, 11 = set specific mask
	// p:     0 = no polling, 1 = polling mode
	// rs:     0x = NOP, 10 = read IRR, 11 = read ISR
	outb(IO_PIC1, 0x68); // clear specific mask
	outb(IO_PIC1, 0x0a); // read IRR by default
	outb(IO_PIC2, 0x68); // OCW3
	outb(IO_PIC2, 0x0a); // OCW3

	if (irq_mask != 0xFFFF) {
		pic_setmask(irq_mask);
	}
}
