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
#include <udebug.h>

static char *welcome = "\n"
" _\n"
"| |_ ___  _   _  ___  ___ \n"
"| __/ _ \\| | | |/ _ \\/ __|\n"
"| || (_) | |_| | (_) \\__ \\\n"
" \\__\\___/ \\__, |\\___/|___/\n"
"          |___/\n";

int kern_init(void) __attribute__((noreturn));
extern char bootstacktop[], bootstack[]; 

void st0()
{
	print_stackframe();
}

void st1()
{
	st0();
}
void st2()
{
	st1();
}
void st3()
{
	st2();
}
void st4()
{
	st3();
}

int kern_init(void)
{
	extern char edata[], end[];
	memset(edata, 0, end - edata);
	cons_init();
	cprintf("%s\n", welcome);
	cprintf("bootstack:0x%x, bootstacktop:0x%x\n", bootstack, bootstacktop);

	udebug("\r\n");
	//print_kerninfo();
	udebug("\r\n");
	//print_stackframe();
	st4();
	udebug("\r\n");

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
