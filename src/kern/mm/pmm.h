#ifndef __KERN_MM_PMM_H__
#define __KERN_MM_PMM_H__

#include <defs.h>
#include <mmu.h>
#include <memlayout.h>
#include <atomic.h>
#include <assert.h>

struct pmm_manager {
	const char* name;
	void (*init)(void);
	void (*init_memmap)(struct Page* base, size_t n);
	struct Page* (*alloc_pages)(size_t n);
	void (*free_pages)(struct Page* base, size_t n);
	size_t (*nr_free_pages)(void);
	void (*check)(void);
};

extern const struct pmm_manager* pmm_manager;
extern pde_t* boot_pgdir;
extern uintptr_t boot_cr3;

extern struct Page* pages;
extern size_t npage;

extern char bootstack[], bootstacktop[];

void pmm_init(void);
struct Page* alloc_pages(size_t n);
void free_pages(struct Page* base, size_t n);
size_t nr_free_pages(void);

#define alloc_page() alloc_pages(1)
#define free_page(page) free_pages(page, 1)

pte_t* get_pte(pde_t* pgdir, uintptr_t la, bool create);
struct Page* get_page(pde_t* pgdir, uintptr_t la, pte_t** ptep_store);
void page_remove(pde_t* pgdir, uintptr_t la);
int page_insert(pde_t* pgdir, struct Page* page, uintptr_t la, uint32_t perm);

void load_esp0(uintptr_t esp0);
void tlb_invalidate(pde_t* pgdir, uintptr_t la);
struct Page* pgdir_alloc_page(pde_t* pgdir, uintptr_t la, uint32_t perm);
void unmap_range(pde_t* pgdir, uintptr_t start, uintptr_t end);
void exit_range(pde_t* pgdir, uintptr_t start, uintptr_t end);
int copy_range(pde_t* to, pde_t* from, uintptr_t start, uintptr_t end, bool share);

void print_pgdir(void);

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
		if (__m_ppn >= npage) {                                  \
		panic("KADDR called with invalid pa %08lx", __m_pa); \
		}                                                        \
		(void*)(__m_pa + KERNBASE);                              \
		})

static inline ppn_t page2ppn(struct Page* page)
{
	return page - pages;
}

static inline uintptr_t page2pa(struct Page* page)
{
	return page2ppn(page) << PGSHIFT;
}

static inline struct Page* pa2page(uintptr_t pa)
{
	if (PPN(pa) >= npage) {
		panic("pa2page called with invalid pa");
	}
	return &pages[PPN(pa)];
}

static inline void* page2kva(struct Page* page)
{
	return KADDR(page2pa(page));
}

static inline struct Page* pte2page(pte_t pte)
{
	if (!(pte & PTE_P)) {
		panic("pte2page call with invalid pte");
	}
	return pa2page(PTE_ADDR(pte));
}

static inline struct Page* pde2page(pde_t pde)
{
	return pa2page(PDE_ADDR(pde));
}

static inline int page_ref(struct Page* page)
{
	return page->ref;
}

static inline void set_page_ref(struct Page* page, int val)
{
	page->ref = val;
}

static inline int page_ref_inc(struct Page* page)
{
	page->ref += 1;
	return page->ref;
}

static inline int page_ref_dec(struct Page* page)
{
	page->ref -= 1;
	return page->ref;
}

static inline struct Page * kva2page(void *kva) {
	return pa2page(PADDR(kva));
}


#endif /* __KERN_MM_PMM_H__ */
