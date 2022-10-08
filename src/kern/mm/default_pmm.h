#ifndef  __DEFAULT_PMM_H__
#define  __DEFAULT_PMM_H__

#include <kern/mm/pmm.h>

extern const struct pmm_manager default_pmm_manager;
extern free_area_t free_area;
void print_free_pages();

#endif  /* __DEFAULT_PMM_H__ */
