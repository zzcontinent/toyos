#include <libs/stdio.h>
#include <user/libs/ulib.h>

int zero;

int main(void)
{
	cprintf("value is %d.\n", 1 / zero);
	panic("FAIL: T.T\n");
}

