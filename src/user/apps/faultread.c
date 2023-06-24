#include <libs/stdio.h>
#include <user/libs/ulib.h>

int main(void) 
{
	cprintf("I read %8x from 0.\n", *(unsigned int *)0);
	panic("FAIL: T.T\n");
}

