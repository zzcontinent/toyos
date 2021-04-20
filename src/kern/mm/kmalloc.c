#include <kmalloc.h>
#include <defs.h>
#include <stdio.h>

void check_slab(void)
{
	cprintf("check_slab() succeeded!\n");
}

void slab_init(void)
{
	check_slab();
	cprintf("use SLOB allocator!\n");
}

inline void kmalloc_init(void)
{
	slab_init();
	cprintf("kmalloc_init() succeeded!\n");
}
