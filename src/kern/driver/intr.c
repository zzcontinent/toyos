#include <kern/driver/intr.h>
#include <libs/libs_all.h>


void intr_enable(void)
{
	sti();
}

void intr_disable(void)
{
	cli();
}
