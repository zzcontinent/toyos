#include <libs/stdio.h>
#include <user/libs/ulib.h>
#include <libs/string.h>

int main(void)
{
	cprintf("Hello world!!.\n");
	cprintf("I am process %d.\n", getpid());
	cprintf("hello pass.\n");
	return 0;
}

