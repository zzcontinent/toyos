#ifndef __KERN_MM_MEMLAYOUT_H__
#define __KERN_MM_MEMLAYOUT_H__
#include <libs/defs.h>

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

#define USERBASE 0x00000000
#define UTEXT 0x00000000
#define USTAB USERBASE

#define USER_ACCESS(start , end) \
	(USERBASE <= (start) && (start) < (end) && (end) <= USERTOP)

#define KERN_ACCESS(start, end) \
	(KERNBASE <= (start) && (start) < (end) && (end) <= KERNTOP)

/*
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


#endif /* !__KERN_MM_MEMLAYOUT_H__ */
