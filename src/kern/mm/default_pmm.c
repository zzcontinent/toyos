#include "memlayout.h"
#include <libs/libs_all.h>
#include <kern/mm/pmm.h>
#include <kern/mm/default_pmm.h>

free_area_t g_free_area;

#define g_free_list (g_free_area.free_list)
#define g_nr_free (g_free_area.nr_free)
#define g_nr_memmap_total (g_free_area.nr_memmap_total)

static void default_init(void)
{
	list_init(&g_free_list);
	g_nr_free = 0;
	g_nr_memmap_total = 0;
}

static void default_init_memmap(struct page *base, size_t n) {
	assert(n > 0);
	struct page *p = base;
	for (; p != base + n; p ++) {
		assert(PAGE_RESERVED(p));
		CLEAR_PAGE_RESERVED(p);
		CLEAR_PAGE_PROPERTY(p);
		set_page_ref(p, 0);
	}
	base->property = n;
	SET_PAGE_PROPERTY(base);
	g_nr_free += n;
	g_nr_memmap_total += n;

	list_add_before(&g_free_list, &(base->page_link));
}

static struct page * default_alloc_pages(size_t n)
{
	assert(n > 0);
	if (n > g_nr_free) {
		return NULL;
	}
	struct page *page = NULL;
	list_entry_t *le = &g_free_list;
	// TODO: optimize (next-fit)
	while ((le = list_next(le)) != &g_free_list) {
		struct page *p = le2page(le, page_link);
		if (p->property >= n) {
			page = p;
			break;
		}
	}
	if (page != NULL) {
		if (page->property > n) {
			struct page *p = page + n;
			p->property = page->property - n;
			SET_PAGE_PROPERTY(p);
			list_add_after(&(page->page_link), &(p->page_link));
		}
		list_del(&(page->page_link));
		g_nr_free -= n;
		CLEAR_PAGE_PROPERTY(page);
	}
	return page;
}

static void default_free_pages(struct page *base, size_t n)
{
	assert(n > 0);
	struct page *p = base;
	for (; p != base + n; p ++) {
		assert(!PAGE_RESERVED(p) && !PAGE_PROPERTY(p));
		set_page_ref(p, 0);
	}
	base->property = n;
	SET_PAGE_PROPERTY(base);
	list_entry_t *le = list_next(&g_free_list);
	while (le != &g_free_list) {
		p = le2page(le, page_link);
		le = list_next(le);
		// TODO: optimize
		if (base + base->property == p) {
			base->property += p->property;
			CLEAR_PAGE_PROPERTY(p);
			list_del(&(p->page_link));
		}
		else if (p + p->property == base) {
			p->property += base->property;
			CLEAR_PAGE_PROPERTY(base);
			base = p;
			list_del(&(p->page_link));
		}
	}
	g_nr_free += n;
	le = list_next(&g_free_list);
	while (le != &g_free_list) {
		p = le2page(le, page_link);
		if (base + base->property <= p) {
			assert(base + base->property != p);
			break;
		}
		le = list_next(le);
	}
	list_add_before(le, &(base->page_link));
}

static size_t default_nr_free_pages(void)
{
	return g_nr_free;
}

static void basic_check(void)
{
	struct page *p0, *p1, *p2;
	p0 = p1 = p2 = NULL;
	assert((p0 = alloc_page()) != NULL);
	assert((p1 = alloc_page()) != NULL);
	assert((p2 = alloc_page()) != NULL);

	assert(p0 != p1 && p0 != p2 && p1 != p2);
	assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);

	assert(page2pa(p0) < g_npages * PGSIZE);
	assert(page2pa(p1) < g_npages * PGSIZE);
	assert(page2pa(p2) < g_npages * PGSIZE);

	list_entry_t free_list_store = g_free_list;
	list_init(&g_free_list);
	assert(list_empty(&g_free_list));

	unsigned int nr_free_store = g_nr_free;
	g_nr_free = 0;

	assert(alloc_page() == NULL);

	free_page(p0);
	free_page(p1);
	free_page(p2);
	assert(g_nr_free == 3);

	assert((p0 = alloc_page()) != NULL);
	assert((p1 = alloc_page()) != NULL);
	assert((p2 = alloc_page()) != NULL);

	assert(alloc_page() == NULL);

	free_page(p0);
	assert(!list_empty(&g_free_list));

	struct page *p;
	assert((p = alloc_page()) == p0);
	assert(alloc_page() == NULL);

	assert(g_nr_free == 0);
	g_free_list = free_list_store;
	g_nr_free = nr_free_store;

	free_page(p);
	free_page(p1);
	free_page(p2);
}

static void default_check(void)
{
	int count = 0, total = 0;
	list_entry_t *le = &g_free_list;
	while ((le = list_next(le)) != &g_free_list) {
		struct page *p = le2page(le, page_link);
		assert(PAGE_PROPERTY(p));
		count ++, total += p->property;
	}
	assert(total == nr_free_pages());

	basic_check();

	struct page *p0 = alloc_pages(5), *p1, *p2;
	assert(p0 != NULL);
	assert(!PAGE_PROPERTY(p0));

	list_entry_t free_list_store = g_free_list;
	list_init(&g_free_list);
	assert(list_empty(&g_free_list));
	assert(alloc_page() == NULL);

	unsigned int nr_free_store = g_nr_free;
	g_nr_free = 0;

	free_pages(p0 + 2, 3);
	assert(alloc_pages(4) == NULL);
	assert(PAGE_PROPERTY(p0 + 2) && p0[2].property == 3);
	assert((p1 = alloc_pages(3)) != NULL);
	assert(alloc_page() == NULL);
	assert(p0 + 2 == p1);

	p2 = p0 + 1;
	free_page(p0);
	free_pages(p1, 3);
	assert(PAGE_PROPERTY(p0) && p0->property == 1);
	assert(PAGE_PROPERTY(p1) && p1->property == 3);

	assert((p0 = alloc_page()) == p2 - 1);
	free_page(p0);
	assert((p0 = alloc_pages(2)) == p2 + 1);

	free_pages(p0, 2);
	free_page(p2);

	assert((p0 = alloc_pages(5)) != NULL);
	assert(alloc_page() == NULL);

	assert(g_nr_free == 0);
	g_nr_free = nr_free_store;

	g_free_list = free_list_store;
	free_pages(p0, 5);

	le = &g_free_list;
	while ((le = list_next(le)) != &g_free_list) {
		struct page *p = le2page(le, page_link);
		count --, total -= p->property;
	}
	assert(count == 0);
	assert(total == 0);
}

void print_free_pages()
{
	list_entry_t *le = &g_free_list;
	struct page *p;
	do {
		p = le2page(le, page_link);
		uclean(
				"-------------------\n"
				"page          :0x%x\n"
				"ref           :0x%x\n"
				"flags         :0x%x\n"
				"property      :0x%x(%dKB)\n"
				"page_link     :0x%x\n"
				"pra_vaddr     :0x%x\n",
				p               ,
				p->ref          ,
				p->flags        ,
				p->property     , (4*p->property),
				p->page_link    ,
				p->pra_vaddr    );
	} while ((le = list_next(le)) != &g_free_list);

	u32 total = g_nr_memmap_total;
	u32 free = g_nr_free;
	u32 used = total - free;
	u32 free_per_h = (free*100/total);
	u32 free_per_l = (free*1000/total)%10;
	u32 used_per_h = (used*100)/total;
	u32 used_per_l = (used*1000/total)%10;
	uclean(
			"+++++++++++++++++++\n"
			"total         :%d(%dKB)\n"
			"used          :%d(%dKB) = %d.%d%%\n"
			"free          :%d(%dKB) = %d.%d%%\n"
			"+++++++++++++++++++\n",
			total, 4*total,
			used, 4*used, used_per_h, used_per_l,
			free, 4*free, free_per_h, free_per_l);
}

const struct pmm_manager default_pmm_manager = {
	.name = "default_pmm_manager",
	.init = default_init,
	.init_memmap = default_init_memmap,
	.alloc_pages = default_alloc_pages,
	.free_pages = default_free_pages,
	.nr_free_pages = default_nr_free_pages,
	.check = default_check,
};
