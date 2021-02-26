#include <defs.h>
#include <elf.h>

#define SECTSIZE 512
#define ELFHDR ((struct elfhdr *)0x10000) // scratch space

void bootmain(void)
{

}

void readseg(uintprt_t va, uint32_t count, uint32_t offset)
{

}

void readsect(void *dst, uint32_t secno)
{

}

static void waitdisk(void)
{

}

