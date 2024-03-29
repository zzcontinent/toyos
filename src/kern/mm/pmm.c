#include <libs/libs_all.h>
#include <kern/driver/console.h>
#include <kern/debug/assert.h>
#include <kern/mm/default_pmm.h>
#include <kern/mm/kmalloc.h>
#include <kern/mm/memlayout.h>
#include <kern/mm/mmu.h>
#include <kern/mm/pmm.h>
#include <kern/sync/sync.h>
#include <kern/mm/vmm.h>
#include <kern/mm/swap.h>

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
struct page* g_page_base;
// amount of physical memory(in pages)
size_t g_npages = 0;

// virtual address of boot-time page directory
extern pde_t __boot_pgdir;
pde_t* boot_pgdir = &__boot_pgdir;
// physical address of boot-time page directory
uintptr_t boot_cr3;

// physical memory management
const struct pmm_manager* g_pmm_manager;

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
	g_pmm_manager = &default_pmm_manager;
	uclean("memory management: %s\n", g_pmm_manager->name);
	g_pmm_manager->init();
}

// call pmm->init_memmap to build Page struct for free memory
static void init_memmap(struct page* base, size_t n)
{
	g_pmm_manager->init_memmap(base, n);
}

// call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory
struct page* alloc_pages(size_t n)
{
	struct page* page = NULL;
	bool intr_flag;

	for (;;) {
		local_intr_save(intr_flag);
		{
			page = g_pmm_manager->alloc_pages(n);
		}
		local_intr_restore(intr_flag);
		// todo ...
		if (page != NULL || n > 1 || swap_init_ok == 0)
			break;
		//extern struct mm_struct *check_mm_struct;
		//swap_out(check_mm_struct, n, 0);
	}
	return page;
}

void free_pages(struct page* base, size_t n)
{
	bool intr_flag;
	local_intr_save(intr_flag);
	{
		g_pmm_manager->free_pages(base, n);
	}
	local_intr_restore(intr_flag);
}

size_t nr_free_pages(void)
{
	size_t ret;
	bool intr_flag;
	local_intr_save(intr_flag);
	{
		ret = g_pmm_manager->nr_free_pages();
	}
	local_intr_restore(intr_flag);
	return ret;
}

// initialize the physical memory management
static void page_init(void)
{
	struct e820map* memmap = (struct e820map*)(0x8000 + KERNBASE);
	u64 maxpa = 0;
	int i;
	for (i = 0; i < memmap->nr_map; i++) {
		u64 begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
		if (memmap->map[i].type == E820_ARM) {
			if (maxpa < end && begin < KMEMSIZE) {
				maxpa = end;
			}
		}
	}
	if (maxpa > KMEMSIZE) {
		maxpa = KMEMSIZE;
	}
	extern char end[];
	g_npages = maxpa / PGSIZE;
	g_page_base = (struct page*)ROUNDUP((void*)end, PGSIZE);
	for (i = 0; i < g_npages; i++) {
		SET_PAGE_RESERVED(g_page_base + i);
	}

	uintptr_t freemem = PADDR((uintptr_t)g_page_base + sizeof(struct page) * g_npages);

	for (i = 0; i < memmap->nr_map; i ++) {
		u64 begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
		if (memmap->map[i].type == E820_ARM) {
			if (begin < freemem) {
				begin = freemem;
			}
			if (end > KMEMSIZE) {
				end = KMEMSIZE;
			}
			if (begin < end) {
				begin = ROUNDUP(begin, PGSIZE);
				end = ROUNDDOWN(end, PGSIZE);
				if (begin < end) {
					init_memmap(pa2page(begin), (end - begin) / PGSIZE);
				}
			}
		}
	}
}

/*
 * setup & enable the paging machanism
 * la: linear address of this memory need to map (after x86 segment map)
 * size: memory size
 * pa: physical address of this memory
 * perm: permission of this memory
 * */
static void boot_map_segment(pde_t* pgdir, uintptr_t la, size_t size, uintptr_t pa, u32 perm)
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

/*
 * allocate one page using pmm->alloc_pages(1)
 * return: the kernel virtual address of this allocated page
 * note: this function is used to get the memory for PDT and PT
 * */
void* boot_alloc_page(void)
{
	struct page* p = alloc_page();
	if (p == NULL) {
		panic("boot_alloc_page failed.\n");
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
	// use pmm->check to verify the correctness of the alloc/freee function in a pmm
	check_alloc_page();
	check_pgdir();

	static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);
	boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;

	// map all physical memory to linear memory with base linear
	// addr KERNBASE linear_addr KERNBASE - KERNBASE + KMEMSIZE
	// = phy_addr 0~KMEMSIZE
	boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);

	// since we are using bootloader's GDT
	// we should reload gdt to get user segments and the TSS
	// map virtual_addr 0~4G = linear_addr 0~4G
	// then set kernel stack (ss:esp) in TSS, setup tss in
	// gdt, load TSS
	gdt_init();

	// now the basic memory map is established.
	// check the correctness of the basic virtual memory map.
	check_boot_pgdir();

	print_pg();
	kmalloc_init();
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
		struct page* page;
		if (!create || (page = alloc_page()) == NULL) {
			return NULL;
		}
		set_page_ref(page, 1);
		uintptr_t pa = page2pa(page);
		memset(KADDR(pa), 0, PGSIZE);
		*pdep = pa | PTE_U | PTE_W | PTE_P;
	}
	pte_t* ret = &((pte_t*)KADDR(PTE_ADDR(*pdep)))[PTX(la)];
	return ret;
}

// get related Page struct for linear address la using PDT pgdir
struct page* get_page(pde_t* pgdir, uintptr_t la, pte_t** ptep_store)
{
	pte_t* ptep = get_pte(pgdir, la, 0);
	if (ptep_store != NULL) {
		*ptep_store = ptep;
	}
	if (ptep != NULL && *ptep & PTE_P) {
		return pte2page(*ptep);
	}
	return NULL;
}

// free an Page struct which is related linear address la
// and clean(invalidate) pte which is related linear address la
// note: PT is changed, so the TLB need to be invalidate
static inline void page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep)
{
	if (*ptep & PTE_P)
	{
		struct page *page = pte2page(*ptep);
		if (page_ref_dec(page) == 0)
		{
			free_page(page);
		}
		*ptep = 0;
		tlb_invalidate(pgdir, la);
	}
}

//page_remove - free an Page which is related linear address la and has an validated pte
void page_remove(pde_t *pgdir, uintptr_t la)
{
	pte_t *ptep = get_pte(pgdir, la, 0);
	if (ptep != NULL) {
		page_remove_pte(pgdir, la, ptep);
	}
}

//page_insert - build the map of phy addr of an Page with the linear addr la
// paramemters:
//  pgdir: the kernel virtual base address of PDT
//  page:  the Page which need to map
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate
int page_insert(pde_t *pgdir, struct page *page, uintptr_t la, u32 perm) {
	udebug("pgdir=0x%x, la=0x%x\r\n", pgdir, la);
	pte_t *ptep = get_pte(pgdir, la, 1);
	if (ptep == NULL) {
		return -E_NO_MEM;
	}
	page_ref_inc(page);
	if (*ptep & PTE_P) {
		struct page *p = pte2page(*ptep);
		if (p == page) {
			page_ref_dec(page);
		}
		else {
			page_remove_pte(pgdir, la, ptep);
		}
	}
	*ptep = page2pa(page) | PTE_P | perm;
	tlb_invalidate(pgdir, la);
	return 0;
}

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void tlb_invalidate(pde_t *pgdir, uintptr_t la)
{
	if (rcr3() == PADDR(pgdir))
	{
		invlpg((void*)la);
	}
}

void unmap_range(pde_t *pgdir, uintptr_t start, uintptr_t end)
{
	assert(start %PGSIZE == 0 && end %PGSIZE == 0);
	assert(USER_ACCESS(start, end));
	do {
		pte_t *ptep = get_pte(pgdir, start, 0);
		if (ptep == NULL) {
			start = ROUNDDOWN(start + PTSIZE, PTSIZE);
			continue ;
		}
		if (*ptep != 0) {
			page_remove_pte(pgdir, start, ptep);
		}
		start += PGSIZE;
	} while (start != 0 && start < end);
}

void exit_range(pde_t *pgdir, uintptr_t start, uintptr_t end)
{
	assert(start %PGSIZE == 0 && end %PGSIZE == 0);
	assert(USER_ACCESS(start, end));

	start = ROUNDDOWN(start, PTSIZE);
	do {
		int pde_idx = PDX(start);
		if (pgdir[pde_idx] & PTE_P)
		{
			free_page(pde2page(pgdir[pde_idx]));
			pgdir[pde_idx] = 0;
		}
		start += PTSIZE;
	} while (start != 0 && start < end);
}

/*
 * copy content of memory(start, end) of one process A to another process B
 * @to: the addr of process B's Page Directory
 * @from: the addr of process A's Page Directory
 * @share: flags to indicate to dup OR share. we just use dup.
 * CALL GRAPH: copy_mm -> dup_mmap -> copy_range
 * */
int copy_range(pde_t* to, pde_t *from, uintptr_t start, uintptr_t end, bool share)
{
	assert(start %PGSIZE == 0 && end %PGSIZE == 0);
	assert(USER_ACCESS(start, end));

	do{
		// call get_pte to find process A's pte according to the addr start
		pte_t *ptep = get_pte(from, start, 0), *nptep;
		if (ptep == NULL)
		{
			start = ROUNDDOWN(start + PTSIZE, PTSIZE);
			continue;
		}
		// call get_pte to find process B's pte according to the addr start.
		// if pte is NULL, just alloc a PT.
		if (*ptep & PTE_P) {
			if ((nptep = get_pte(to, start, 1)) == NULL) {
				return -E_NO_MEM;
			}
			uint32_t perm = (*ptep & PTE_USER);
			//get page from ptep
			struct page *page = pte2page(*ptep);
			// alloc a page for process B
			struct page *npage = alloc_page();
			assert(page!=NULL);
			assert(npage!=NULL);

			void * kva_src = page2kva(page);
			void * kva_dst = page2kva(npage);

			memcpy(kva_dst, kva_src, PGSIZE);

			int ret = page_insert(to, npage, start, perm);
			assert(ret == 0);
		}
		start += PGSIZE;
	} while (start != 0 && start < end);
	return 0;
}

struct page *pgdir_alloc_page(pde_t *pgdir, uintptr_t la, uint32_t perm)
{
	struct page *page = alloc_page();
	if (page != NULL) {
		if (page_insert(pgdir, page, la, perm) != 0) {
			free_page(page);
			return NULL;
		}
#if 0
		if (swap_init_ok){
			if(g_check_mm_struct!=NULL) {
				swap_map_swappable(g_check_mm_struct, la, page, 0);
				page->pra_vaddr=la;
				assert(page_ref(page) == 1);
			}
			else  {  //now current is existed, should fix it in the future
				swap_map_swappable(current->mm, la, page, 0);
				//page->pra_vaddr=la;
				//assert(page_ref(page) == 1);
				//panic("pgdir_alloc_page: no pages. now current is existed, should fix it in the future\n");
			}
		}
#endif
	}

	return page;
}

static void check_alloc_page(void)
{
	g_pmm_manager->check();
	uclean("check_alloc_page succeed!\n");
}

static void check_pgdir(void)
{
	assert(g_npages <= KMEMSIZE / PGSIZE);
	assert(boot_pgdir != NULL && (u32)PGOFF(boot_pgdir) == 0);
	assert(get_page(boot_pgdir, 0x0, NULL) == NULL);

	struct page *p1, *p2;
	p1 = alloc_page();
	assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);

	pte_t* ptep;
	assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
	assert(pte2page(*ptep) == p1);
	assert(page_ref(p1) == 1);
	ptep = &((pte_t*)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
	assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);

	p2 = alloc_page();
	assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
	assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
	assert(*ptep & PTE_U);
	assert(*ptep & PTE_W);
	assert(boot_pgdir[0] & PTE_U);
	assert(page_ref(p2) == 1);

	assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
	assert(page_ref(p1) == 2);
	assert(page_ref(p2) == 0);
	assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
	assert(pte2page(*ptep) == p1);
	assert((*ptep & PTE_U) == 0);

	assert(page_ref(p1) == 2);
	page_remove(boot_pgdir, 0x0);
	assert(page_ref(p1) == 1);
	assert(page_ref(p2) == 0);

	page_remove(boot_pgdir, PGSIZE);
	assert(page_ref(p1) == 0);
	assert(page_ref(p2) == 0);

	assert(page_ref(pde2page(boot_pgdir[0])) == 1);
	free_page(pde2page(boot_pgdir[0]));
	boot_pgdir[0] = 0;
	uclean("check_pgdir succeed!\n");
}

static void check_boot_pgdir(void)
{
	pte_t* ptep;
	for (int i = 0; i < g_npages; i += PGSIZE) {
		assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
		assert(PTE_ADDR(*ptep) == i);
	}
	assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
	assert(boot_pgdir[0] == 0);

	struct page* p;
	p = alloc_page();
	assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
	assert(page_ref(p) == 1);
	assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
	assert(page_ref(p) == 2);

	const char* str = "ucore: hello world!";
	strcpy((void*)0x100, str);
	assert(strcmp((void*)0x100, (void*)(0x100 + PGSIZE)) == 0);

	*(char*)(page2kva(p) + 0x100) = '\0';
	assert(strlen((const char*)0x100) == 0);

	free_page(p);
	free_page(pde2page(boot_pgdir[0]));
	boot_pgdir[0] = 0;
	cprintf("check_boot_pgdir succeed!\n");
}

static const char* perm2str(int perm)
{
	static char str[4];
	str[0] = (perm & PTE_U) ? 'u' : '-';
	str[1] = 'r';
	str[2] = (perm & PTE_W) ? 'w' : '-';
	str[3] = '\0';
	return str;
}

static int get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t* table, size_t* left_store, size_t* right_store)
{
	if (start >= right) {
		return 0;
	}
	while (start < right && !(table[start] & PTE_P)) {
		++start;
	}
	if (start < right) {
		if (left_store != NULL) {
			*left_store = start;
		}
		int perm = (table[start++] & PTE_USER);
		while (start < right && (table[start] & PTE_USER) == perm) {
			++start;
		}
		if (right_store != NULL) {
			*right_store = start;
		}
		return perm;
	}
	return 0;
}


void print_mem()
{
	struct e820map* memmap = (struct e820map*)(0x8000 + KERNBASE);
	cprintf("e820map:\n");
	int i;
	for (i = 0; i < memmap->nr_map; i++) {
		u64 begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
		cprintf("|--memory: size:%08llx(%8lldKB), [%08llx, %08llx], type = %d - %s\n",
				(u64)memmap->map[i].size,
				(u64)(memmap->map[i].size/1024),
				begin, end - 1, memmap->map[i].type, E820MAP_TYPE(memmap->map[i].type));
	}
}

void print_pg(void)
{
	cprintf("--------BEGIN--------\n");
	size_t left, right = 0, perm;
	while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
		cprintf("PDE(%03x) %08x-%08x %08x(%8dKB) %s\n", right - left,
				left * PTSIZE, right * PTSIZE,
				(right - left) * PTSIZE, (right-left) *(PTSIZE/1024), perm2str(perm));
		size_t l, r = left * NPTEENTRY;
		while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
			cprintf("  |-- PTE(%05x) %08x-%08x %08x(%8dKB) %s\n", r - l, l * PGSIZE, r * PGSIZE,
					(r - l) * PGSIZE, (r-l)*PGSIZE/1024, perm2str(perm));
		}
	}
	cprintf("--------END--------\n");
}
