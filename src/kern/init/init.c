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
static char *hello_msg ="\n"
"███████╗ █████╗ ███████╗██╗   ██╗ ██████╗ ███████╗\n"
"██╔════╝██╔══██╗██╔════╝╚██╗ ██╔╝██╔═══██╗██╔════╝\n"
"█████╗  ███████║███████╗ ╚████╔╝ ██║   ██║███████╗\n"
"██╔══╝  ██╔══██║╚════██║  ╚██╔╝  ██║   ██║╚════██║\n"
"███████╗██║  ██║███████║   ██║   ╚██████╔╝███████║\n"
"╚══════╝╚═╝  ╚═╝╚══════╝   ╚═╝    ╚═════╝ ╚══════╝\n";


int kern_init(void) __attribute__((noreturn));
extern char bootstacktop[], bootstack[];
extern char edata[], end[];

static int kernel_init_step = 0;
static int kernel_init_step_total = 12;
int kern_init(void)
{
	memset(edata, 0, end - edata);
	cons_init(CONS_TYPE_SERIAL_POLL);
	cprintf("%s\n", hello_msg);

	printf("[%d/%d] kernel info\n", ++kernel_init_step, kernel_init_step_total);
	print_kerninfo();

	printf("[%d/%d] physical memory info\n", ++kernel_init_step, kernel_init_step_total);
	print_mem();

	printf("[%d/%d] pmm init\n", ++kernel_init_step, kernel_init_step_total);
	pmm_init();

	printf("[%d/%d] pic init\n", ++kernel_init_step, kernel_init_step_total);
	pic_init();

	printf("[%d/%d] idt init\n", ++kernel_init_step, kernel_init_step_total);
	idt_init();                 // init interrupt descriptor table
	intr_enable();

	printf("[%d/%d] vmm init\n", ++kernel_init_step, kernel_init_step_total);
	vmm_init();

	printf("[%d/%d] scheduler init\n", ++kernel_init_step, kernel_init_step_total);
	sched_init();

	printf("[%d/%d] process init\n", ++kernel_init_step, kernel_init_step_total);
	proc_init();

	printf("[%d/%d] ide init\n", ++kernel_init_step, kernel_init_step_total);
	ide_init();
	//swap_init();

	printf("[%d/%d] file system init\n", ++kernel_init_step, kernel_init_step_total);
	fs_init();
	intr_disable();

	printf("[%d/%d] clock init\n", ++kernel_init_step, kernel_init_step_total);
	clock_init();
	intr_enable();

	printf("[%d/%d] idle loop\n", ++kernel_init_step, kernel_init_step_total);
	cpu_idle();
}
