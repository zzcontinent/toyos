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
}
