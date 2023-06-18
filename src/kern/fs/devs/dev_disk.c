#include <libs/defs.h>
#include <libs/types.h>
#include <kern/mm/mmu.h>
#include <kern/mm/kmalloc.h>
#include <kern/sync/sem.h>
#include <kern/driver/ide.h>
#include <kern/fs/vfs/inode.h>
#include <kern/fs/devs/dev.h>
#include <kern/fs/vfs/vfs.h>
#include <kern/fs/fs.h>
#include <libs/iobuf.h>
#include <libs/error.h>
#include <kern/debug/assert.h>

#define SECTSIZE 512
#define DISK_BLKSIZE                   PGSIZE
#define DISK_BUFSIZE                   (4 * DISK_BLKSIZE)
#define DISK_BLK_NSECT                 (DISK_BLKSIZE / SECTSIZE)

static char *disk_buffer; static semaphore_t disk_sem;

static void lock_disk(void)
{
	down(&(disk_sem));
}

static void unlock_disk(void)
{
	up(&(disk_sem));
}

static int disk_open(struct device *dev, uint32_t open_flags)
{
	return 0;
}

static int disk_close(struct device *dev)
{
	return 0;
}

static void disk_read_blks_nolock(uint32_t blkno, uint32_t nblks)
{
	int ret;
	uint32_t sectno = blkno * DISK_BLK_NSECT, nsecs = nblks * DISK_BLK_NSECT;
	if ((ret = ide_read_secs(DISK_DEV_NO, sectno, disk_buffer, nsecs, SECTSIZE)) != 0) {
		panic("disk: read blkno = %d (sectno = %d), nblks = %d (nsecs = %d): 0x%08x.\n",
				blkno, sectno, nblks, nsecs, ret);
	}
}

static void disk_write_blks_nolock(uint32_t blkno, uint32_t nblks)
{
	int ret;
	uint32_t sectno = blkno * DISK_BLK_NSECT, nsecs = nblks * DISK_BLK_NSECT;
	if ((ret = ide_write_secs(DISK_DEV_NO, sectno, disk_buffer, nsecs, SECTSIZE)) != 0) {
		panic("disk: write blkno = %d (sectno = %d), nblks = %d (nsecs = %d): 0x%08x.\n",
				blkno, sectno, nblks, nsecs, ret);
	}
}

static int disk_io(struct device *dev, struct iobuf *iob, bool write)
{
	off_t offset = iob->io_offset;
	size_t resid = iob->io_resid;
	uint32_t blkno = offset / DISK_BLKSIZE;
	uint32_t nblks = resid / DISK_BLKSIZE;

	/* don't allow I/O that isn't block-aligned */
	if ((offset % DISK_BLKSIZE) != 0 || (resid % DISK_BLKSIZE) != 0) {
		return -E_INVAL;
	}

	/* don't allow I/O past the end of disk */
	if (blkno + nblks > dev->d_blocks) {
		return -E_INVAL;
	}

	/* read/write nothing ? */
	if (nblks == 0) {
		return 0;
	}

	lock_disk();
	while (resid != 0) {
		size_t copied, alen = DISK_BUFSIZE;
		if (write) {
			iobuf_move(iob, disk_buffer, alen, 0, &copied);
			assert(copied != 0 && copied <= resid && copied % DISK_BLKSIZE == 0);
			nblks = copied / DISK_BLKSIZE;
			disk_write_blks_nolock(blkno, nblks);
		}
		else {
			if (alen > resid) {
				alen = resid;
			}
			nblks = alen / DISK_BLKSIZE;
			disk_read_blks_nolock(blkno, nblks);
			iobuf_move(iob, disk_buffer, alen, 1, &copied);
			assert(copied == alen && copied % DISK_BLKSIZE == 0);
		}
		resid -= copied, blkno += nblks;
	}
	unlock_disk();
	return 0;
}

static int disk_ioctl(struct device *dev, int op, void *data)
{
	return -E_UNIMP;
}

static void disk_device_init(struct device *dev)
{
	static_assert(DISK_BLKSIZE % SECTSIZE == 0);
	if (!ide_device_valid(DISK_DEV_NO)) {
		panic("disk device isn't available.\n");
	}
	dev->d_blocks = ide_device_size(DISK_DEV_NO) / DISK_BLK_NSECT;
	dev->d_blocksize = DISK_BLKSIZE;
	dev->d_open = disk_open;
	dev->d_close = disk_close;
	dev->d_io = disk_io;
	dev->d_ioctl = disk_ioctl;
	sem_init(&(disk_sem), 1);

	static_assert(DISK_BUFSIZE % DISK_BLKSIZE == 0);
	if ((disk_buffer = kmalloc(DISK_BUFSIZE)) == NULL) {
		panic("disk alloc buffer failed.\n");
	}
}

void dev_init_disk(void)
{
	struct inode *node;
	if ((node = dev_create_inode()) == NULL) {
		panic("disk: dev_create_node.\n");
	}
	disk_device_init(vop_info(node, device));

	int ret;
	if ((ret = vfs_add_dev("disk", node, 1)) != 0) {
		panic("disk: vfs_add_dev: %e.\n", ret);
	}
}


