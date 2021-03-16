#include <assert.h>
#include <default_pmm.h>
#include <defs.h>
#include <kmalloc.h>
#include <memlayout.h>
#include <mmu.h>
#include <pmm.h>
#include <stdio.h>
#include <string.h>
#include <vmm.h>
#include <x86.h>

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
static struct taskstate ts = { 0 };

// virtual address of physical page array
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
pde_t* const vpd = (pde_t*)PGADDR(PDX(VPT), PDX(VPT), 0);
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

static struct pseudodesc gdt_pd = {
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
	asm volatile("lgdt (%0)" ::"r"(pd));
	asm volatile("movw %%ax, %%gs" ::"a"(USER_DS));
	asm volatile("movw %%ax, %%fs" ::"a"(USER_DS));
	asm volatile("movw %%ax, %%es" ::"a"(KERNEL_DS));
	asm volatile("movw %%ax, %%ds" ::"a"(KERNEL_DS));
	asm volatile("movw %%ax, %%ss" ::"a"(KERNEL_DS));
	// reload cs
	asm volatile("ljmp %0, $1f\n 1:\n" ::"i"(KERNEL_CS));
}

void load_esp0(uintptr_t esp0)
{
	ts.ts_esp0 = esp0;
}

static void gdt_init(void)
{
	// set boot kernel stack and default SS0
	load_esp0((uintptr_t)bootstacktop);
	ts.ts_ss0 = KERNEL_DS;

	// initialize the TSS field of the gdt
	gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);

	// reload all segment registers
	lgdt(&gdt_pd);

	// load the TSS
	ltr(GD_TSS);
}

static void init_pmm_manager(void)
{
	pmm_manager = &default_pmm_manager;
	cprintf("memory management: %s\n", pmm_manager->name);
	pmm_manager->init();
}

// get pte and return the kernel virtual address of this pte for la
// if the PT contains this pte didn't exist, alloc a page for PT
// pgdir: the kernel virtual base address of PDT
// la:    the linear address need to map
// create:if alloc a page for PT
// return: the kernel virtual address of this pte
pte_t* get_pte(pde_t* pgdir, uintptr_t la, bool create)
{
	pde_t* pdep = &pgdir[PDX(la)];
	if (!(*pdep & PTE_P)) {
		struct Page* page;
		if (!create || (page == alloc_page()) == NULL) {
			return NULL;
		}
		set_page_ref(page, 1);
		uintptr_t pa = page2pa(page);
		memset(KADDR(pa), 0, PGSIZE);
		*pdep = pa | PTE_U | PTE_W | PTE_P;
	}
	return &((pte_t*)KADDR(PDE_ADDR(*pdep)))[PTX(la)];
}

/*
 * setup & enable the paging machanism
 * la: linear address of this memory need to map (after x86 segment map)
 * size: memory size
 * pa: physical address of this memory
 * perm: permission of this memory
 * */
static void boot_map_segment(pde_t* pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm)
{
	assert(PGOFF(la) == PGOFF(pa));
	size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
	la = ROUNDDOWN(la, PGSIZE);
	pa = ROUNDDOWN(pa, PGSIZE);
	for (; n > 0; n--, la += PGSIZE, pa += PGSIZE) {
		pte_t* ptep = get_pte(pgdir, la, 1);
		assert(ptep != NULL);
		*ptep = pa | PTE_P | perm;
	}
}

// initialize the physical memory management
static void page_init(void)
{
	struct e820map *memmap = (struct e820map*)(0x8000 + KERNBASE);
	uint64_t maxpa = 0;
	cprintf("e820map:\n");
	int i;
	for (i=0; i< memmap->nr_map; i++)
	{
		uint64_t begin = memmap->map[i].addr, end=begin + memcmp->map[i].size;
		cprintf("|-  memory: %08llx, [%08llx, %0xllx], type = %d.\n",
				memmap->map[i].size, begin, end-1, memmap->map[i].type)
		if (memmap->map[i].type == E820_ARM)
		{
			if (maxpa < end && begin < KMEMSIZE)
			{
				maxpa = end;
			}
		}
	}
	if (maxpa > KMEMSIZE)
	{
		maxpa = KMEMSIZE;
	}
	extern char end[];
	npage = maxpa / PGSIZE;
	pages = (struct Page*) ROUNDUP((void*)end, PGSIZE);
	for (i=0; i< npage; i++)
	{
		SetPageReserved(pages +i);
	}
}

// allocate one page using pmm->alloc_pages(1)
// return: the kernel virtual address of this allocated page
// note: this function is used to get the memory for PDT and PT
static void* boot_alloc_page(void)
{
	struct Page* p = alloc_page();
	if (p == NULL)
	{
		panic("boot_alloc_page failed.\n")
	}
	return page2kva(p);
}

void pmm_init(void)
{
	// we've enabled paging
	boot_cr3 = PADDR(boot_pgdir);

	// alloc/free the physical memory(4KB)
	// a framework of physical memory manager (struct pmm_manager) is defined in pmm.h
	init_pmm_manager();

	// detect physical memory space, reserve already used memory,
	// use pmm->init_memmap to create free page list
	page_init();
}

