/* ******************************************************************************************
 * FILE NAME   : init.c
 * PROGRAMMER  : zhaozz
 * DESCRIPTION : kernel entry
 * DATE        : 2022-01-08 00:38:27
 * *****************************************************************************************/
#include <libs/defs.h>
#include <libs/stdio.h>
#include <libs/string.h>
#include <kern/debug/kdebug.h>
#include <kern/debug/udebug.h>
#include <kern/driver/clock.h>
#include <kern/driver/console.h>
#include <kern/driver/ide.h>
#include <kern/driver/intr.h>
#include <kern/driver/picirq.h>
#include <kern/mm/pmm.h>
#include <kern/mm/swap.h>
#include <kern/mm/vmm.h>
#include <kern/process/proc.h>
#include <kern/trap/trap.h>

static char *welcome = "\n"
" _\n"
"| |_ ___  _   _  ___  ___ \n"
"| __/ _ \\| | | |/ _ \\/ __|\n"
"| || (_) | |_| | (_) \\__ \\\n"
" \\__\\___/ \\__, |\\___/|___/\n"
"          |___/\n";

int kern_init(void) __attribute__((noreturn));
extern char bootstacktop[], bootstack[];

int kern_init(void)
{
	extern char edata[], end[];
	memset(edata, 0, end - edata);
	cons_init();

	cprintf("%s\n", welcome);
	cprintf("bootstack:0x%x, bootstacktop:0x%x\n", bootstack, bootstacktop);
	cprintf("edata:0x%x, end:0x%x\n", edata, end);

	print_kerninfo();
	print_stackframe();

	pmm_init();
	pic_init();
	idt_init();                 // init interrupt descriptor table


	//vmm_init();
	//sched_init();
	//proc_init();

	//ide_init();
	//swap_init();
	//fs_init();

	//clock_init();
	//intr_enable();

	//cpu_idle();
	udebug("\r\n");
	while(1);
}
