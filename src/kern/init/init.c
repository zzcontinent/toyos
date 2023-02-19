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
#include <kern/fs/fs.h>

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

static int kernel_init_step = 0;
int kern_init(void)
{
	memset(edata, 0, end - edata);
	cons_init();
	cprintf("%s\n", welcome);

	printf("[%d] kernel info\n", ++kernel_init_step);

	print_kerninfo();

	printf("[%d] physical memory info\n", ++kernel_init_step);

	print_mem();

	printf("[%d] pmm init\n", ++kernel_init_step);

	pmm_init();

	printf("[%d] pic init\n", ++kernel_init_step);

	pic_init();

	printf("[%d] idt init\n", ++kernel_init_step);

	idt_init();                 // init interrupt descriptor table

	intr_enable();

	printf("[%d] vmm init\n", ++kernel_init_step);

	vmm_init();

	printf("[%d] schedular init\n", ++kernel_init_step);

	sched_init();

	printf("[%d] process init\n", ++kernel_init_step);

	proc_init();

	printf("[%d] ide init\n", ++kernel_init_step);

	ide_init();
	//swap_init();

	printf("[%d] file system init\n", ++kernel_init_step);

	fs_init();

	intr_disable();

	printf("[%d] clock init\n", ++kernel_init_step);

	clock_init();

	intr_enable();

	printf("[%d] idle loop\n", ++kernel_init_step);
	cpu_idle();
}
