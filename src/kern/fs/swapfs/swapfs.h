#ifndef  __SWAPFS_H__
#define  __SWAPFS_H__

#include <kern/mm/memlayout.h>
#include <kern/mm/page.h>
#include <kern/fs/swapfs/swapfs.h>

void swapfs_init(void);
int swapfs_read(swap_entry_t entry, struct page *page);
int swapfs_write(swap_entry_t entry, struct page *page);

#endif  /* __SWAPFS_H__ */
