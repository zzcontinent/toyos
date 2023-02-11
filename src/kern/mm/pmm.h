#ifndef  __PMM_H__
#define  __PMM_H__

#include <libs/defs.h>
#include <kern/mm/mmu.h>
#include <kern/mm/memlayout.h>
#include <libs/atomic.h>
#include <kern/debug/assert.h>

struct pmm_manager {
	const char* name;
	void (*init)(void);
	void (*init_memmap)(struct page* base, size_t n);
	struct page* (*alloc_pages)(size_t n);
	void (*free_pages)(struct page* base, size_t n);
	size_t (*nr_free_pages)(void);
	void (*check)(void);
};

extern const struct pmm_manager* pmm_manager;
extern pde_t* boot_pgdir;
extern uintptr_t boot_cr3;

extern struct page* g_page_base;
extern size_t g_npages;

extern char bootstack[], bootstacktop[];

extern void pmm_init(void);
extern struct page* alloc_pages(size_t n);
extern void free_pages(struct page* base, size_t n);
extern size_t nr_free_pages(void);

#define alloc_page() alloc_pages(1)
#define free_page(page) free_pages(page, 1)

extern pte_t* get_pte(pde_t* pgdir, uintptr_t la, bool create);
extern struct page* get_page(pde_t* pgdir, uintptr_t la, pte_t** ptep_store);
extern void page_remove(pde_t* pgdir, uintptr_t la);
extern int page_insert(pde_t* pgdir, struct page* page, uintptr_t la, u32 perm);

extern void load_esp0(uintptr_t esp0);
extern void tlb_invalidate(pde_t* pgdir, uintptr_t la);
extern struct page* pgdir_alloc_page(pde_t* pgdir, uintptr_t la, u32 perm);
extern void unmap_range(pde_t* pgdir, uintptr_t start, uintptr_t end);
extern void exit_range(pde_t* pgdir, uintptr_t start, uintptr_t end);
extern int copy_range(pde_t* to, pde_t* from, uintptr_t start, uintptr_t end, bool share);

extern void print_pg(void);
extern void print_mem();

/*
 * takes a kernel virtual address(above KERNBASE)
 * returns the corresponding physical address.
 * */
#define PADDR(kva) (                                               \
		{                                                              \
		uintptr_t __m_kva = (uintptr_t)(kva);                      \
		if (__m_kva < KERNBASE) {                                  \
		panic("PADDR called with invalid kva %08lx", __m_kva); \
		}                                                          \
		__m_kva - KERNBASE;                                        \
		})

/*
 * takes a physical address
 * returns the corresponding kernel virtual address
 * */
#define KADDR(pa) ({                                         \
		uintptr_t __m_pa = (pa);                                 \
		size_t __m_ppn = PPN(__m_pa);                            \
		if (__m_ppn >= g_npages) {                                  \
		panic("KADDR called with invalid pa %08lx", __m_pa); \
		}                                                        \
		(void*)(__m_pa + KERNBASE);                              \
		})

static inline ppn_t page2ppn(struct page* page)
{
	return page - g_page_base;
}

static inline uintptr_t page2pa(struct page* page)
{
	return page2ppn(page) << PGSHIFT;
}

static inline struct page* pa2page(uintptr_t pa)
{
	if (PPN(pa) >= g_npages) {
		panic("pa2page called with invalid pa");
	}
	return &g_page_base[PPN(pa)];
}

static inline void* page2kva(struct page* page)
{
	return KADDR(page2pa(page));
}

static inline struct page* pte2page(pte_t pte)
{
	if (!(pte & PTE_P)) {
		panic("pte2page call with invalid pte");
	}
	return pa2page(PTE_ADDR(pte));
}

static inline struct page* pde2page(pde_t pde)
{
	return pa2page(PDE_ADDR(pde));
}

static inline int page_ref(struct page* page)
{
	return page->ref;
}

static inline void set_page_ref(struct page* page, int val)
{
	page->ref = val;
}

static inline int page_ref_inc(struct page* page)
{
	page->ref += 1;
	return page->ref;
}

static inline int page_ref_dec(struct page* page)
{
	page->ref -= 1;
	return page->ref;
}

static inline struct page * kva2page(void *kva) {
	return pa2page(PADDR(kva));
}


#endif  /* __PMM_H__ */
