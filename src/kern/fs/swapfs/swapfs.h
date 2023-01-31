#ifndef  __SWAPFS_H__
#define  __SWAPFS_H__

#include <kern/mm/memlayout.h>
#include <kern/fs/swapfs/swap.h>

void swapfs_init(void);
int swapfs_read(swap_entry_t entry, struct Page *page);
int swapfs_write(swap_entry_t entry, struct Page *page);

#endif  /* __SWAPFS_H__ */
