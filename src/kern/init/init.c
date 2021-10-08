#include <clock.h>
#include <console.h>
#include <defs.h>
#include <fs.h>
#include <ide.h>
#include <intr.h>
#include <kdebug.h>
#include <picirq.h>
#include <pmm.h>
#include <proc.h>
#include <stdio.h>
#include <string.h>
#include <swap.h>
#include <trap.h>
#include <vmm.h>

int kern_init(void) __attribute__((noreturn));

int kern_init(void)
{
	extern char edata[], end[];
	memset(edata, 0, end - edata);
	cons_init();
	const char* message = "toyos is loading ...";
	cprintf("%s\n", message);

	print_kerninfo();
	//print_stackframe();

	//pmm_init();
	//pic_init();

	//vmm_init();
	//sched_init();
	//proc_init();

	//ide_init();
	//swap_init();
	//fs_init();

	//clock_init();
	//intr_enable();

	//cpu_idle();
	while(1);
}
