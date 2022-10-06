#include <kern/driver/intr.h>
#include <libs/x86.h>

void intr_enable(void)
{
	sti();
}

void intr_disable(void)
{
	cli();
}
