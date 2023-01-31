#ifndef  __FS_H__
#define  __FS_H__

#include <libs/defs.h>

#define SWAP_DEV_NO         1
#define DISK0_DEV_NO        2
#define DISK1_DEV_NO        3

/*
//file.h
struct file;
struct files_struct;

//inode.h
struct inode;
struct inode_ops;

//vfs.h
struct vfs;

//sfs.h
struct sfs_inode;
struct sfs_super;
struct sfs_disk_inode;
struct sfs_disk_entry;
struct sfs_fs;

//bitmap.h
struct bitmap;

//dev.h
struct device;
*/

extern void fs_init(void);
extern void fs_cleanup(void);

#endif  /* __FS_H__ */
