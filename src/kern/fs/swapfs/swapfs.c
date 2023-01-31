#include <kern/mm/swap.h>
#include <kern/fs/swapfs/swapfs.h>
#include <kern/mm/mmu.h>
#include <kern/fs/fs.h>
#include <kern/driver/ide.h>
#include <kern/mm/pmm.h>
#include <kern/debug/assert.h>

#if 0
#define SECTSIZE 512
void swapfs_init(void)
{
	static_assert((PGSIZE % SECTSIZE) == 0);
	if (!ide_device_valid(SWAP_DEV_NO)) {
		panic("swap fs isn't available.\n");
	}
	max_swap_offset = ide_device_size(SWAP_DEV_NO) / (PGSIZE / SECTSIZE);
}

int swapfs_read(swap_entry_t entry, struct page *page)
{
	return ide_read_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
}

int swapfs_write(swap_entry_t entry, struct page *page)
{
	return ide_write_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
}
#endif
