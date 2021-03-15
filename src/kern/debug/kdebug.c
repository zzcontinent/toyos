#include "stdio.h"
#include <defs.h>
#include <x86.h>

void print_kerninfo(void)
{
	extern char etext[], edata[], end[], kern_init[];
	cprintf("special kernel symbols:\n");
	cprintf("|- entry 0x%08x (phys)\n", kern_init);
	cprintf("|- etext 0x%08x (phys)\n", etext);
	cprintf("|- edata 0x%08x (phys)\n", edata);
	cprintf("|- end   0x%08x (phys)\n", end);
	cprintf("kernel executable memory footprint: %dKB\n", (end - kern_init + 1023) / 1024);
}
