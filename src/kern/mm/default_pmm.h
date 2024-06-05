#ifndef  __DEFAULT_PMM_H__
#define  __DEFAULT_PMM_H__

#include <libs/list.h>
#include <kern/mm/pmm.h>

typedef struct {
	list_entry_t free_list;
	unsigned int nr_free;
	unsigned int nr_memmap_total;
} free_area_t;

extern const struct pmm_manager default_pmm_manager;
extern free_area_t free_area;
extern void print_free_pages();

#endif  /* __DEFAULT_PMM_H__ */
