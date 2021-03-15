#include <assert.h>
#include <pmm.h>
#include <vmm.h>
#include <kmalloc.h>
#include <defs.h>
#include <x86.h>
#include <stdio.h>
#include <string.h>
#include <memlayout.h>
#include <mmu.h>
#include <default_pmm.h>

/*
 * Task State Segment
 * the Task Register(TR) holds a segment selector that points to a
 * valid TSS segment descriptor which resides in the GDT.
 * Therefore, to use a TSS the following must be done in gdt_init:
 *   - create a TSS descriptor entry in GDT.
 *   - add enough information to the TSS in memory as needed
 *   - load the TR register with a segment selector for that segment
 * The field SS0 contains the stack segment selector for CPL = 0,
 * and the ESP0 contains the new ESP value for CPL=0.
 * When an interrupt happens in protected mode, the x86 CPU will look in the
 * TSS for SS0 and ESP0 and load their value into SS and ESP respectively.
 * */
static struct taskstate ts = {0};

// virtual address of physicall page array
struct Page* pages;
// amount of physical memory(in pages)
size_t npage = 0;

// virtual address of boot-time page directory
extern pde_t __boot_pgdir;
pde_t* boot_pgdir = &__boot_pgdir;
// physical address of boot-time page directory
uintptr_t boot_cr3;

// physical memory management
const struct pmm_manager* pmm_manager;

/*
 * pde(page table entry)  corresponding to the virtual address range
 * [VPT, VPT+PTSIZE) points to the page directory itself.
 * Thus, the page directory is treated as a page table as well as a
 * page directory.
 * */
pde_t* const vpd = (pde_t*)PGADDR(PDX(VPT),PDX(VPT),0);
pte_t* const vpt = (pte_t*)VPT; // 1111 1010 1100 0000 0000 0000 0000 0000

/*
 * Gloable Descriptor Table:
 * The kernel and user segment are identical(except for the DPL).
 * To load the %ss register, the CPL must equal the DPL.
 *   - 0x0 : unused(always faults -- for trapping NULL for pointers)
 *   - 0x8 : kernel code segment
 *   - 0x10: kernel data segment
 *   - 0x18: user code segment
 *   - 0x20: user data segment
 *   - 0x28: defined for tss, initialized in gdt_init
 * */
static struct segdesc gdt[] = {
	SEG_NULL,
	[SEG_KTEXT] = SEG(STA_X | STA_R, 0x0, 0xFFFFFFFF, DPL_KERNEL),
	[SEG_KDATA] = SEG(STA_W, 0x0, 0xFFFFFFFF, DPL_KERNEL),
	[SEG_UTEXT] = SEG(STA_X | STA_R, 0x0, 0xFFFFFFFF, DPL_USER),
	[SEG_UDATA] = SEG(STA_W, 0x0, 0xFFFFFFFF, DPL_USER),
	[SEG_TSS] = SEG_NULL,
};

static struct pseudodesc_gdt_pd = {
	sizeof(gdt) - 1, (uintptr_t)gdt
};

static void check_alloc_page(void);
static void check_pgdir(void);
static void check_boot_pgdir(void);

/*
 * lgdt load the global descriptor table register and reset the
 * data/code segment register for kernel.
 * */
static inline void lgdt(struct pseudodesc* pd)
{
	asm volatile("lgdt (%0)" :: "r" (pd));
	asm volatile("movw %%ax, %%gs" :: "a" (USER_DS));
	asm volatile("movw %%ax, %%fs" :: "a" (USER_DS));
	asm volatile("movw %%ax, %%es" :: "a" (KERNEL_DS));
	asm volatile("movw %%ax, %%ds" :: "a" (KERNEL_DS));
	asm volatile("movw %%ax, %%ss" :: "a" (KERNEL_DS));
	// reload cs
	asm volatile("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
}


