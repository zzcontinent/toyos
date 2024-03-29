#include <kern/mm/mmu.h>
#include <kern/mm/memlayout.h>

#define REALLOC(x) (x - KERNBASE)

.text
.globl kern_entry
kern_entry:
	# load pa of boot pgdir
	movl $REALLOC(__boot_pgdir), %eax
	movl %eax, %cr3

	# enable paging
	movl %cr0, %eax
	orl $(CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP), %eax
	andl $~(CR0_TS | CR0_EM), %eax
	movl %eax, %cr0

	# update eip
	# now eip = 0x1...
	leal next, %eax
	# set eip = KERNBASE + 0x1...
	jmp *%eax
next:
	# unmap va 0-4M, it's temporary mapping
	xorl %eax, %eax
	movl %eax, __boot_pgdir
	# set ebp,esp
	movl $0x0, %ebp
	# the kernel stack region: bootstack(bootstacktop) ~ +KSTACKSIZE(8KB) (in memlayout.h)
	movl $bootstacktop, %esp
	call kern_init

# should never get here
spin:
	jmp spin

.data
.align PGSIZE
.globl bootstack
bootstack:
	.space KSTACKSIZE
.globl bootstacktop
bootstacktop:
# kernel builtin pgdir: an initial page directory (page directory table: PDT)
.section .data.pgdir
.align PGSIZE
__boot_pgdir:
.globl __boot_pgdir
	# map va 0-4M to pa 0-4M (temporary)
	.long REALLOC(__boot_pt1) + (PTE_P | PTE_U | PTE_W)
	# pad to PDE of KERNBASE
	.space (KERNBASE >> PGSHIFT >> 10 << 2) - (. - __boot_pgdir)
	# map va KERNBASE + (0-4M) to pa 0-4M
	.long REALLOC(__boot_pt1) + (PTE_P | PTE_U | PTE_W)
	# pad to PGSIZE
	.space PGSIZE - (. - __boot_pgdir)

.set i,0
__boot_pt1:
.rept 1024
	.long i * PGSIZE + (PTE_P | PTE_W)
	.set i, i + 1
.endr

