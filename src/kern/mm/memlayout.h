#ifndef __KERN_MM_MEMLAYOUT_H__
#define __KERN_MM_MEMLAYOUT_H__
#include <kern/mm/mmu.h>

/* global segment number */
#define SEG_KTEXT 1
#define SEG_KDATA 2
#define SEG_UTEXT 3
#define SEG_UDATA 4
#define SEG_TSS   5

/* global descriptor number */
#define GD_KTEXT  ((SEG_KTEXT) << 3)     // kernel text
#define GD_KDATA  ((SEG_KDATA) << 3)     // kernel data
#define GD_UTEXT  ((SEG_UTEXT) << 3)     // user text
#define GD_UDATA  ((SEG_UDATA) << 3)     // user data
#define GD_TSS  ((SEG_TSS) << 3)         // task segment seletoc

#define DPL_KERNEL (0)
#define DPL_USER (3)

#define KERNEL_CS  ((GD_KTEXT) | DPL_KERNEL)
#define KERNEL_DS  ((GD_KDATA) | DPL_KERNEL)
#define USER_CS    ((GD_UTEXT) | DPL_USER)
#define USER_DS    ((GD_UDATA) | DPL_USER)


#define KERNBASE  0xC0000000
#define KMEMSIZE  0x38000000   // the maximum amount of physical memory : 896MB
#define KERNTOP   (KERNBASE + KMEMSIZE)

#define VPT 0xFAC00000  // virtual page table. entry PDX[VPT] in the PD (page directory), PD maps all the PTEs for the entir virtual address space (4MB region starting at VPT)

#define KSTACKPAGE 2
#define KSTACKSIZE  (KSTACKPAGE * PGSIZE)

#define USERTOP  0xB0000000
#define USTACKTOP USERTOP
#define USTACKPAGE 256
#define USTACKSIZE (USTACKPAGE * PGSIZE)

#define USERBASE 0x00200000
#define UTEXT 0x00800000
#define USTAB USERBASE

#define USER_ACCESS(start , end) \
	(USERBASE <= (start) && (start) < (end) && (end) <= USERTOP)

#define KERN_ACCESS(start, end) \
	(KERNBASE <= (start) && (start) < (end) && (end) <= KERNTOP)

/* *
 * Virtual memory map:                                          Permissions
 *                                                              kernel/user
 *     4G ------------------> +---------------------------------+
 *                            |                                 |
 *                            |         Empty Memory (*)        |
 *                            |                                 |
 *                            +---------------------------------+ 0xFB000000
 *                            |   Cur. Page Table (Kern, RW)    | RW/-- PTSIZE
 *     VPT -----------------> +---------------------------------+ 0xFAC00000
 *                            |        Invalid Memory (*)       | --/--
 *     KERNTOP -------------> +---------------------------------+ 0xF8000000
 *                            |                                 |
 *                            |    Remapped Physical Memory     | RW/-- KMEMSIZE
 *                            |                                 |
 *     KERNBASE ------------> +---------------------------------+ 0xC0000000
 *                            |        Invalid Memory (*)       | --/--
 *     USERTOP -------------> +---------------------------------+ 0xB0000000
 *                            |           User stack            |
 *                            +---------------------------------+
 *                            |                                 |
 *                            :                                 :
 *                            |         ~~~~~~~~~~~~~~~~        |
 *                            :                                 :
 *                            |                                 |
 *                            ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 *                            |       User Program & Heap       |
 *     UTEXT ---------------> +---------------------------------+ 0x00800000
 *                            |        Invalid Memory (*)       | --/--
 *                            |  - - - - - - - - - - - - - - -  |
 *                            |    User STAB Data (optional)    |
 *     USERBASE, USTAB------> +---------------------------------+ 0x00200000
 *                            |        Invalid Memory (*)       | --/--
 *     0 -------------------> +---------------------------------+ 0x00000000
 * (*) Note: The kernel ensures that "Invalid Memory" is *never* mapped.
 *     "Empty Memory" is normally unmapped, but user programs may map pages
 *     there if desired.
 * */

#ifndef __ASSEMBLER__
#include <libs/defs.h>
#include <libs/atomic.h>
#include <libs/list.h>

typedef uintptr_t pde_t;
typedef uintptr_t pte_t;
typedef pte_t swap_entry_t; // the pte can also be a swap entry

// some constants for bios interrupt 15h AX = 0xE820
#define E820MAX 20 // number of entries in E820MAP
#define E820_ARM 1 // address range memory
#define E820_ARR 2 // address range reserved

struct e820map {
	int nr_map;
	struct {
		u64 addr;
		u64 size;
		u32 type;  // 1:memory, 2:reserved(ROM, memory-mapped device), 3:ACPI Reclaim memory, 4:ACPI NVS memory
	} __attribute__((packed)) map[E820MAX];
};

#define E820MAP_TYPE(type)  ({ \
		char *p_ret = ""; \
		if (type == 1) \
		p_ret = "memory"; \
		else if (type == 2) \
		p_ret = "reserved(ROM, memory-mapped device)"; \
		else if (type == 3) \
		p_ret = "ACPI Reclaim memory"; \
		else if (type == 4) \
		p_ret = "ACPI NVS memory"; \
		else \
		p_ret = "not defined!"; \
		p_ret; \
		})

/*
 * sturct page - page descriptor structures(physical page).
 * */
struct page {
	int            ref;                 // page frame's reference counter
	u32            flags;               // array of flags that describe the status of the page frame
	unsigned int   property;            // used in buddy system, stores the order (the X in 2^X) of the continuous memory block
	int            zone_num;            // used in buddy system, the No. of zone which the page belongs to
	list_entry_t   page_link;           // free list link
	list_entry_t   pra_page_link;       // used for pra (page replace algorithm)
	uintptr_t      pra_vaddr;           // used for pra (page replace algorithm)
};

/* flags describing the status of a page frame */
#define PG_reserved 0
#define PG_property 1
#define SET_PAGE_RESERVED(page) set_bit(PG_reserved, &((page)->flags))
#define CLEAR_PAGE_RESERVED(page) clear_bit(PG_reserved, &((page)->flags))
#define PAGE_RESERVED(page) test_bit(PG_reserved, &((page)->flags))
#define SET_PAGE_PROPERTY(page) set_bit(PG_property, &((page)->flags))
#define CLEAR_PAGE_PROPERTY(page) clear_bit(PG_property, &((page)->flags))
#define PAGE_PROPERTY(page) test_bit(PG_property, &((page)->flags))

#define le2page(le, member) \
	to_struct((le), struct page, member)

typedef struct{
	list_entry_t free_list;
	unsigned int nr_free;
	unsigned int nr_memmap_total;
} free_area_t;


#endif  /* !__ASSEMBLER__ */
#endif /* !__KERN_MM_MEMLAYOUT_H__ */
