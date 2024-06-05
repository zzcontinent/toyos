#ifndef  __PAGE_H__
#define  __PAGE_H__
#include <libs/libs_all.h>

/* flags describing the status of a page frame */
#define PG_reserved 0
#define PG_property 1
#define SET_PAGE_RESERVED(page) set_bit(PG_reserved, &((page)->flags))
#define CLEAR_PAGE_RESERVED(page) clear_bit(PG_reserved, &((page)->flags))
#define PAGE_RESERVED(page) test_bit(PG_reserved, &((page)->flags))
#define SET_PAGE_PROPERTY(page) set_bit(PG_property, &((page)->flags))
#define CLEAR_PAGE_PROPERTY(page) clear_bit(PG_property, &((page)->flags))
#define PAGE_PROPERTY(page) test_bit(PG_property, &((page)->flags))

typedef uintptr_t pde_t;
typedef uintptr_t pte_t;
typedef pte_t swap_entry_t; // the pte can also be a swap entry


#define le2page(le, member) \
	to_struct((le), struct page, member)

struct page {
	int            ref;                 // page frame's reference counter
	u32            flags;               // array of flags that describe the status of the page frame
	unsigned int   property;            // used in buddy system, stores the order (the X in 2^X) of the continuous memory block
	int            zone_num;            // used in buddy system, the No. of zone which the page belongs to
	list_entry_t   page_link;           // free list link
	list_entry_t   pra_page_link;       // used for pra (page replace algorithm)
	uintptr_t      pra_vaddr;           // used for pra (page replace algorithm)
};


#endif  /* __PAGE_H__ */
