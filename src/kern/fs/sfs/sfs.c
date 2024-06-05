/* ********************************************************************************
 * FILE NAME   : sfs.c
 * PROGRAMMER  : zhaozz
 * DESCRIPTION : sfs(simple filesystem)
 * DATE        : 2023-01-31 19:56:19
 * *******************************************************************************/
#include <libs/defs.h>
#include <libs/error.h>
#include <libs/stdio.h>
#include <libs/string.h>
#include <kern/mm/kmalloc.h>
#include <kern/fs/sfs/sfs.h>
#include <kern/fs/vfs/vfs.h>
#include <kern/fs/sfs/bitmap.h>

void sfs_init(void)
{
	int ret;
	if ((ret = sfs_mount("disk")) != 0) {
		panic("failed: sfs: sfs_mount: %e.\n", ret);
	}
}

/*
 * sfs_sync - sync sfs's superblock and freemap in memroy into disk
 */
static int sfs_sync(struct vfs *fs)
{
	struct sfs_fs *sfs = fsop_info(fs, sfs);
	lock_sfs_fs(sfs);
	{
		list_entry_t *list = &(sfs->inode_list), *le = list;
		while ((le = list_next(le)) != list) {
			struct sfs_inode *sin = le2sin(le, inode_link);
			vop_fsync(info2node(sin, sfs_inode));
		}
	}
	unlock_sfs_fs(sfs);

	int ret;
	if (sfs->super_dirty) {
		sfs->super_dirty = 0;
		if ((ret = sfs_sync_super(sfs)) != 0) {
			sfs->super_dirty = 1;
			return ret;
		}
		if ((ret = sfs_sync_freemap(sfs)) != 0) {
			sfs->super_dirty = 1;
			return ret;
		}
	}
	return 0;
}

/*
 * sfs_get_root - get the root directory inode  from disk (SFS_BLKN_ROOT,1)
 */
static struct inode * sfs_get_root(struct vfs *fs)
{
	struct inode *node;
	int ret;
	if ((ret = sfs_load_inode(fsop_info(fs, sfs), &node, SFS_BLKN_ROOT)) != 0) {
		panic("load sfs root failed: %e", ret);
	}
	return node;
}

/*
 * sfs_unmount - unmount sfs, and free the memorys contain sfs->freemap/sfs_buffer/hash_liskt and sfs itself.
 */
static int sfs_unmount(struct vfs *fs)
{
	struct sfs_fs *sfs = fsop_info(fs, sfs);
	if (!list_empty(&(sfs->inode_list))) {
		return -E_BUSY;
	}
	assert(!sfs->super_dirty);
	bitmap_destroy(sfs->freemap);
	kfree(sfs->sfs_buffer);
	kfree(sfs->hash_list);
	kfree(sfs);
	return 0;
}

/*
 * sfs_cleanup - when sfs failed, then should call this function to sync sfs by calling sfs_sync
 *
 * NOTICE: nouse now.
 */
static void sfs_cleanup(struct vfs *fs)
{
	struct sfs_fs *sfs = fsop_info(fs, sfs);
	uint32_t blocks = sfs->super.blocks, unused_blocks = sfs->super.unused_blocks;
	cprintf("sfs: cleanup: '%s' (%d/%d/%d)\n", sfs->super.info,
			blocks - unused_blocks, unused_blocks, blocks);
	int i, ret;
	for (i = 0; i < 32; i ++) {
		if ((ret = fsop_sync(fs)) == 0) {
			break;
		}
	}
	if (ret != 0) {
		uerror("sfs: sync error: '%s': %e.\n", sfs->super.info, ret);
	}
}

/*
 * sfs_init_read - used in sfs_do_mount to read disk block(blkno, 1) directly.
 *
 * @dev:        the block device
 * @blkno:      the NO. of disk block
 * @blk_buffer: the buffer used for read
 *
 *      (1) init iobuf
 *      (2) read dev into iobuf
 */
static int sfs_init_read(struct device *dev, uint32_t blkno, void *blk_buffer)
{
	struct iobuf __iob, *iob = iobuf_init(&__iob, blk_buffer, SFS_BLKSIZE, blkno * SFS_BLKSIZE);
	return dop_io(dev, iob, 0);
}

/*
 * sfs_init_freemap - used in sfs_do_mount to read freemap data info in disk block(blkno, nblks) directly.
 *
 * @dev:        the block device
 * @bitmap:     the bitmap in memroy
 * @blkno:      the NO. of disk block
 * @nblks:      Rd number of disk block
 * @blk_buffer: the buffer used for read
 *
 *      (1) get data addr in bitmap
 *      (2) read dev into iobuf
 */
static int sfs_init_freemap(struct device *dev, struct bitmap *freemap, uint32_t blkno, uint32_t nblks, void *blk_buffer)
{
	size_t len;
	void *data = bitmap_getdata(freemap, &len);
	assert(data != NULL && len == nblks * SFS_BLKSIZE);
	while (nblks != 0) {
		int ret;
		if ((ret = sfs_init_read(dev, blkno, data)) != 0) {
			return ret;
		}
		blkno ++, nblks --, data += SFS_BLKSIZE;
	}
	return 0;
}

/*
 * sfs_do_mount - mount sfs file system.
 *
 * @dev:        the block device contains sfs file system
 * @fs_store:   the fs struct in memroy
 */
static int sfs_do_mount(struct device *dev, struct vfs **fs_store)
{
	static_assert(SFS_BLKSIZE >= sizeof(struct sfs_super));
	static_assert(SFS_BLKSIZE >= sizeof(struct sfs_disk_inode));
	static_assert(SFS_BLKSIZE >= sizeof(struct sfs_disk_entry));

	if (dev->d_blocksize != SFS_BLKSIZE) {
		return -E_NA_DEV;
	}

	/* allocate fs structure */
	struct vfs *fs;
	if ((fs = alloc_fs(sfs)) == NULL) {
		return -E_NO_MEM;
	}
	struct sfs_fs *sfs = fsop_info(fs, sfs);
	sfs->dev = dev;

	int ret = -E_NO_MEM;

	void *sfs_buffer;
	if ((sfs->sfs_buffer = sfs_buffer = kmalloc(SFS_BLKSIZE)) == NULL) {
		goto failed_cleanup_fs;
	}

	/* load and check superblock */
	if ((ret = sfs_init_read(dev, SFS_BLKN_SUPER, sfs_buffer)) != 0) {
		goto failed_cleanup_sfs_buffer;
	}

	ret = -E_INVAL;

	struct sfs_super *super = sfs_buffer;
	if (super->magic != SFS_MAGIC) {
		cprintf("sfs: wrong magic in superblock. (%08x should be %08x).\n",
				super->magic, SFS_MAGIC);
		goto failed_cleanup_sfs_buffer;
	}
	if (super->blocks > dev->d_blocks) {
		cprintf("sfs: fs has %u blocks, device has %u blocks.\n",
				super->blocks, dev->d_blocks);
		goto failed_cleanup_sfs_buffer;
	}
	super->info[SFS_MAX_INFO_LEN] = '\0';
	sfs->super = *super;

	ret = -E_NO_MEM;

	uint32_t i;

	/* alloc and initialize hash list */
	list_entry_t *hash_list;
	if ((sfs->hash_list = hash_list = kmalloc(sizeof(list_entry_t) * HASH_LIST_SIZE)) == NULL) {
		goto failed_cleanup_sfs_buffer;
	}
	for (i = 0; i < HASH_LIST_SIZE; i ++) {
		list_init(hash_list + i);
	}

	/* load and check freemap */
	struct bitmap *freemap;
	uint32_t freemap_size_nbits = sfs_freemap_bits(super);
	if ((sfs->freemap = freemap = bitmap_create(freemap_size_nbits)) == NULL) {
		goto failed_cleanup_hash_list;
	}
	uint32_t freemap_size_nblks = sfs_freemap_blocks(super);
	if ((ret = sfs_init_freemap(dev, freemap, SFS_BLKN_FREEMAP, freemap_size_nblks, sfs_buffer)) != 0) {
		goto failed_cleanup_freemap;
	}

	uint32_t blocks = sfs->super.blocks, unused_blocks = 0;
	for (i = 0; i < freemap_size_nbits; i ++) {
		if (bitmap_test(freemap, i)) {
			unused_blocks ++;
		}
	}
	assert(unused_blocks == sfs->super.unused_blocks);

	/* and other fields */
	sfs->super_dirty = 0;
	sem_init(&(sfs->fs_sem), 1);
	sem_init(&(sfs->io_sem), 1);
	sem_init(&(sfs->mutex_sem), 1);
	list_init(&(sfs->inode_list));
	cprintf("sfs: mount: '%s' (%d/%d/%d)\n", sfs->super.info,
			blocks - unused_blocks, unused_blocks, blocks);

	/* link addr of sync/get_root/unmount/cleanup funciton  fs's function pointers*/
	fs->fs_sync = sfs_sync;
	fs->fs_get_root = sfs_get_root;
	fs->fs_unmount = sfs_unmount;
	fs->fs_cleanup = sfs_cleanup;
	*fs_store = fs;
	return 0;

failed_cleanup_freemap:
	bitmap_destroy(freemap);
failed_cleanup_hash_list:
	kfree(hash_list);
failed_cleanup_sfs_buffer:
	kfree(sfs_buffer);
failed_cleanup_fs:
	kfree(fs);
	return ret;
}

int sfs_mount(const char *devname)
{
	return vfs_mount(devname, sfs_do_mount);
}


/*
 * lock_sfs_fs - lock the process of  SFS Filesystem Rd/Wr Disk Block
 *
 * called by: sfs_load_inode, sfs_sync, sfs_reclaim
 */
void lock_sfs_fs(struct sfs_fs *sfs)
{
	down(&(sfs->fs_sem));
}

/*
 * lock_sfs_io - lock the process of SFS File Rd/Wr Disk Block
 *
 * called by: sfs_rwblock, sfs_clear_block, sfs_sync_super
 */
void lock_sfs_io(struct sfs_fs *sfs)
{
	down(&(sfs->io_sem));
}

/*
 * unlock_sfs_fs - unlock the process of  SFS Filesystem Rd/Wr Disk Block
 *
 * called by: sfs_load_inode, sfs_sync, sfs_reclaim
 */
void unlock_sfs_fs(struct sfs_fs *sfs)
{
	up(&(sfs->fs_sem));
}

/*
 * unlock_sfs_io - unlock the process of sfs Rd/Wr Disk Block
 *
 * called by: sfs_rwblock sfs_clear_block sfs_sync_super
 */
void unlock_sfs_io(struct sfs_fs *sfs)
{
	up(&(sfs->io_sem));
}


//Basic block-level I/O routines

/* sfs_rwblock_nolock - Basic block-level I/O routine for Rd/Wr one disk block,
 *                      without lock protect for mutex process on Rd/Wr disk block
 * @sfs:   sfs_fs which will be process
 * @buf:   the buffer uesed for Rd/Wr
 * @blkno: the NO. of disk block
 * @write: BOOL: Read or Write
 * @check: BOOL: if check (blono < sfs super.blocks)
 */
static int sfs_rwblock_nolock(struct sfs_fs *sfs, void *buf, uint32_t blkno, bool write, bool check)
{
	assert((blkno != 0 || !check) && blkno < sfs->super.blocks);
	struct iobuf __iob, *iob = iobuf_init(&__iob, buf, SFS_BLKSIZE, blkno * SFS_BLKSIZE);
	return dop_io(sfs->dev, iob, write);
}

/* sfs_rwblock - Basic block-level I/O routine for Rd/Wr N disk blocks ,
 *               with lock protect for mutex process on Rd/Wr disk block
 * @sfs:   sfs_fs which will be process
 * @buf:   the buffer uesed for Rd/Wr
 * @blkno: the NO. of disk block
 * @nblks: Rd/Wr number of disk block
 * @write: BOOL: Read - 0 or Write - 1
 */
static int sfs_rwblock(struct sfs_fs *sfs, void *buf, uint32_t blkno, uint32_t nblks, bool write)
{
	int ret = 0;
	lock_sfs_io(sfs);
	{
		while (nblks != 0) {
			if ((ret = sfs_rwblock_nolock(sfs, buf, blkno, write, 1)) != 0) {
				break;
			}
			blkno ++, nblks --;
			buf += SFS_BLKSIZE;
		}
	}
	unlock_sfs_io(sfs);
	return ret;
}

/* sfs_rblock - The Wrap of sfs_rwblock function for Rd N disk blocks ,
 *
 * @sfs:   sfs_fs which will be process
 * @buf:   the buffer uesed for Rd/Wr
 * @blkno: the NO. of disk block
 * @nblks: Rd/Wr number of disk block
 */
int sfs_rblock(struct sfs_fs *sfs, void *buf, uint32_t blkno, uint32_t nblks)
{
	return sfs_rwblock(sfs, buf, blkno, nblks, 0);
}

/* sfs_wblock - The Wrap of sfs_rwblock function for Wr N disk blocks ,
 *
 * @sfs:   sfs_fs which will be process
 * @buf:   the buffer uesed for Rd/Wr
 * @blkno: the NO. of disk block
 * @nblks: Rd/Wr number of disk block
 */
int sfs_wblock(struct sfs_fs *sfs, void *buf, uint32_t blkno, uint32_t nblks)
{
	return sfs_rwblock(sfs, buf, blkno, nblks, 1);
}

/* sfs_rbuf - The Basic block-level I/O routine for  Rd( non-block & non-aligned io) one disk block(using sfs->sfs_buffer)
 *            with lock protect for mutex process on Rd/Wr disk block
 * @sfs:    sfs_fs which will be process
 * @buf:    the buffer uesed for Rd
 * @len:    the length need to Rd
 * @blkno:  the NO. of disk block
 * @offset: the offset in the content of disk block
 */
int sfs_rbuf(struct sfs_fs *sfs, void *buf, size_t len, uint32_t blkno, off_t offset)
{
	assert(offset >= 0 && offset < SFS_BLKSIZE && offset + len <= SFS_BLKSIZE);
	int ret;
	lock_sfs_io(sfs);
	{
		if ((ret = sfs_rwblock_nolock(sfs, sfs->sfs_buffer, blkno, 0, 1)) == 0) {
			memcpy(buf, sfs->sfs_buffer + offset, len);
		}
	}
	unlock_sfs_io(sfs);
	return ret;
}

/* sfs_wbuf - The Basic block-level I/O routine for  Wr( non-block & non-aligned io) one disk block(using sfs->sfs_buffer)
 *            with lock protect for mutex process on Rd/Wr disk block
 * @sfs:    sfs_fs which will be process
 * @buf:    the buffer uesed for Wr
 * @len:    the length need to Wr
 * @blkno:  the NO. of disk block
 * @offset: the offset in the content of disk block
 */
int sfs_wbuf(struct sfs_fs *sfs, void *buf, size_t len, uint32_t blkno, off_t offset)
{
	assert(offset >= 0 && offset < SFS_BLKSIZE && offset + len <= SFS_BLKSIZE);
	int ret;
	lock_sfs_io(sfs);
	{
		if ((ret = sfs_rwblock_nolock(sfs, sfs->sfs_buffer, blkno, 0, 1)) == 0) {
			memcpy(sfs->sfs_buffer + offset, buf, len);
			ret = sfs_rwblock_nolock(sfs, sfs->sfs_buffer, blkno, 1, 1);
		}
	}
	unlock_sfs_io(sfs);
	return ret;
}

/*
 * sfs_sync_super - write sfs->super (in memory) into disk (SFS_BLKN_SUPER, 1) with lock protect.
 */
int sfs_sync_super(struct sfs_fs *sfs)
{
	int ret;
	lock_sfs_io(sfs);
	{
		memset(sfs->sfs_buffer, 0, SFS_BLKSIZE);
		memcpy(sfs->sfs_buffer, &(sfs->super), sizeof(sfs->super));
		ret = sfs_rwblock_nolock(sfs, sfs->sfs_buffer, SFS_BLKN_SUPER, 1, 0);
	}
	unlock_sfs_io(sfs);
	return ret;
}

/*
 * sfs_sync_freemap - write sfs bitmap into disk (SFS_BLKN_FREEMAP, nblks)  without lock protect.
 */
int sfs_sync_freemap(struct sfs_fs *sfs)
{
	uint32_t nblks = sfs_freemap_blocks(&(sfs->super));
	return sfs_wblock(sfs, bitmap_getdata(sfs->freemap, NULL), SFS_BLKN_FREEMAP, nblks);
}

/*
 * sfs_clear_block - write zero info into disk (blkno, nblks)  with lock protect.
 * @sfs:   sfs_fs which will be process
 * @blkno: the NO. of disk block
 * @nblks: Rd/Wr number of disk block
 */
int sfs_clear_block(struct sfs_fs *sfs, uint32_t blkno, uint32_t nblks)
{
	int ret;
	lock_sfs_io(sfs);
	{
		memset(sfs->sfs_buffer, 0, SFS_BLKSIZE);
		while (nblks != 0) {
			if ((ret = sfs_rwblock_nolock(sfs, sfs->sfs_buffer, blkno, 1, 1)) != 0) {
				break;
			}
			blkno ++, nblks --;
		}
	}
	unlock_sfs_io(sfs);
	return ret;
}

