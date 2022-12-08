/* ********************************************************************************
 * FILE NAME   : init.c
 * PROGRAMMER  : zhaozz
 * DESCRIPTION : kernel entry
 * DATE        : 2022-11-12 22:07:16
 * *******************************************************************************/
#include <libs/libs_all.h>
#include <kern/debug/kdebug.h>
#include <kern/debug/kcommand.h>
#include <kern/driver/clock.h>
#include <kern/driver/console.h>
#include <kern/driver/ide.h>
#include <kern/driver/pic.h>
#include <kern/mm/pmm.h>
#include <kern/mm/swap.h>
#include <kern/mm/vmm.h>
#include <kern/process/proc.h>
#include <kern/trap/trap.h>
#include <kern/schedule/sched.h>

//http://patorjk.com/software/taag
static char *welcome ="\n"
" ______     ______     ______   \n"
"/\\___  \\   /\\  __ \\   /\\  ___\\   \n"
"\\/_/  /__  \\ \\ \\/\\ \\  \\ \\___  \\  \n"
"  /\\_____\\  \\ \\_____\\  \\/\\_____\\ \n"
"  \\/_____/   \\/_____/   \\/_____/ \n"
"                                ";

int kern_init(void) __attribute__((noreturn));
extern char bootstacktop[], bootstack[];
extern char edata[], end[];

int kern_init(void)
{
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

	vmm_init();
	sched_init();
	proc_init();

	//ide_init();
	//swap_init();
	//fs_init();

	clock_init();
	intr_enable();

	cpu_idle();
}
