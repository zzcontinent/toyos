#include <libs/stdio.h>
#include <user/libs/ulib.h>

int main(void)
{
	asm volatile("int $14");
	panic("FAIL: T.T\n");
}

