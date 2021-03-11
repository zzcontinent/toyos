#include <intr.h>
#include <x86.h>

void intr_enable(void)
{
	sti();
}

void intr_disable(void)
{
	cli();
}
