#include <libs/stdio.h>
#include <user/libs/ulib.h>

int main(void)
{
	cprintf("I am %d, print pgdir.\n", getpid());
	print_pgdir();
	cprintf("pgdir pass.\n");
	return 0;
}

