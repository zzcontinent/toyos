#include <libs/defs.h>
#include <libs/x86.h>
#include <libs/elf.h>

#define SECTSIZE 512
#define ELFHDR ((struct elfhdr*)0x10000) // scratch space

static void waitdisk(void)
{
	while ((inb(0x1F7) & 0xC0) != 0x40);
}

/* read_sect -  read a single sector at @secnum into @dst*/
static void read_sect(void* dst, u32 secnum)
{
	waitdisk();
	outb(0x1F2, 1);
	outb(0x1F3, secnum & 0xFF);
	outb(0x1F4, (secnum >> 8) & 0xFF);
	outb(0x1F5, (secnum >> 16) & 0xFF);
	outb(0x1F6, ((secnum >> 24) & 0xF) | 0xE0);
	outb(0x1F7, 0x20);  // cmd 0x20 - read sectors

	waitdisk();
	insl(0x1F0, dst, SECTSIZE / 4);
	waitdisk();
}

/*
 * read_seg - read @count bytes at @offset from kernel into virtual address @va,
 * might copy more than asked
 * */
static void read_seg(uintptr_t va, u32 count, u32 offset)
{
	uintptr_t end_va = va + count;
	va -= offset % SECTSIZE;
	u32 secnum = (offset / SECTSIZE) + 1;
	for (; va < end_va; va += SECTSIZE, secnum++) {
		read_sect((void*)va, secnum);
	}
}

void bootmain(void)
{
	read_seg((uintptr_t)ELFHDR, SECTSIZE * 8, 0);
	if (ELFHDR->e_magic != ELF_MAGIC) {
		goto bad;
	}
	struct proghdr *ph, *eph;
	ph = (struct proghdr*)((uintptr_t)ELFHDR + ELFHDR->e_phoff);
	eph = ph + ELFHDR->e_phnum;
	for (; ph < eph; ph++) {
		read_seg(ph->p_va & 0xFFFFFF, ph->p_memsz, ph->p_offset);
	}
	// call the entry point from the ELF header
	// note: does not return
	((void (*)(void))(ELFHDR->e_entry & 0xFFFFFF))();

bad:
	outw(0x8A00, 0x8A00);
	outw(0x8A00, 0x8E00);

	while (1);
}
