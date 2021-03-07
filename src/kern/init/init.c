#include <defs.h>
#include <stdio.h>

int kern_init(void) __attribute__((__noreturn));

int kern_init(void)
{
	extern char edata[], end[];
	memset(edata, 0, end -edata);
	cons_init();
	const char* message = "toyos is loading ...";
	cprintf("%s\n", message);

	print_kerninfo();
	print_stackframe();

	pmm_init();
	pic_init();

	vmm_init();
	sched_init();
	proc_init();

	ide_init();
	swap_init();
	fs_init();

	clock_init();
	intr_enable();

	cpu_idle();
}
