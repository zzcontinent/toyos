#ifndef  __INODE_H__
#define  __INODE_H__

#include <libs/defs.h>
#include <libs/stat.h>
#include <libs/iobuf.h>
#include <libs/atomic.h>
#include <libs/log.h>
#include <kern/debug/assert.h>
#include <kern/fs/devs/dev.h>
#include <kern/fs/sfs/sfs.h>

/*
 * A struct inode is an abstract representation of a file.
 *
 * It is an interface that allows the kernel's filesystem-independent
 * code to interact usefully with multiple sets of filesystem code.
 */

/*
 * Abstract low-level file.
 *
 * Note: in_info is Filesystem-specific data, in_type is the inode type
 *
 * open_count is managed using VOP_INCOPEN and VOP_DECOPEN by
 * vfs_open() and vfs_close(). Code above the VFS layer should not
 * need to worry about it.
 */

struct inode {
	union {
		struct device __device_info;
		struct sfs_inode __sfs_inode_info;
	} in_info;
	enum {
		inode_type_device_info = 0x1234,
		inode_type_sfs_inode_info,
	} in_type;
	int ref_count;
	int open_count;
	struct vfs *in_fs;
	const struct inode_ops *in_ops;
};

struct inode_ops {
	unsigned long vop_magic;
	int (*vop_open)(struct inode *node, uint32_t open_flags);
	int (*vop_close)(struct inode *node);
	int (*vop_read)(struct inode *node, struct iobuf *iob);
	int (*vop_write)(struct inode *node, struct iobuf *iob);
	int (*vop_fstat)(struct inode *node, struct stat *stat);
	int (*vop_fsync)(struct inode *node);
	int (*vop_namefile)(struct inode *node, struct iobuf *iob);
	int (*vop_getdirentry)(struct inode *node, struct iobuf *iob);
	int (*vop_reclaim)(struct inode *node);
	int (*vop_gettype)(struct inode *node, uint32_t *type_store);
	int (*vop_tryseek)(struct inode *node, off_t pos);
	int (*vop_truncate)(struct inode *node, off_t len);
	int (*vop_create)(struct inode *node, const char *name, bool excl, struct inode **node_store);
	int (*vop_lookup)(struct inode *node, char *path, struct inode **node_store);
	int (*vop_ioctl)(struct inode *node, int op, void *data);
};

#define __in_type(type)                                             inode_type_##type##_info

#define check_inode_type(node, type)                                ((node)->in_type == __in_type(type))

#define __vop_info(node, type)                                      \
	({                                                              \
	 struct inode *__node = (node);                              \
	 assert(__node != NULL && check_inode_type(__node, type));   \
	 &(__node->in_info.__##type##_info);                         \
	 })

#define vop_info(node, type)                                        __vop_info(node, type)

#define info2node(info, type)                                       \
	to_struct((info), struct inode, in_info.__##type##_info)

#define alloc_inode(type)                                           __alloc_inode(__in_type(type))

#define MAX_INODE_COUNT                     0x10000

extern struct inode *__alloc_inode(int type);
extern int inode_ref_inc(struct inode *node);
extern int inode_ref_dec(struct inode *node);
extern int inode_open_inc(struct inode *node);
extern int inode_open_dec(struct inode *node);
extern void inode_init(struct inode *node, const struct inode_ops *ops, struct vfs *fs);
extern void inode_kill(struct inode *node);

#define VOP_MAGIC                           0x8c4ba476

/*
 * Consistency check
 */
extern void inode_check(struct inode *node, const char *opstr);

#define __vop_op(node, sym)                                                                         \
	({                                                                                              \
	 struct inode *__node = (node);                                                              \
	 assert(__node != NULL);\
	 assert(__node->in_ops != NULL);\
	 assert(__node->in_ops->vop_##sym != NULL);                \
	 inode_check(__node, #sym);                                                                  \
	 __node->in_ops->vop_##sym;                                                                  \
	 })

#define vop_open(node, open_flags)                                  (__vop_op(node, open)(node, open_flags))
#define vop_close(node)                                             (__vop_op(node, close)(node))
#define vop_read(node, iob)                                         (__vop_op(node, read)(node, iob))
#define vop_write(node, iob)                                        (__vop_op(node, write)(node, iob))
#define vop_fstat(node, stat)                                       (__vop_op(node, fstat)(node, stat))
#define vop_fsync(node)                                             (__vop_op(node, fsync)(node))
#define vop_namefile(node, iob)                                     (__vop_op(node, namefile)(node, iob))
#define vop_getdirentry(node, iob)                                  (__vop_op(node, getdirentry)(node, iob))
#define vop_reclaim(node)                                           (__vop_op(node, reclaim)(node))
#define vop_ioctl(node, op, data)                                   (__vop_op(node, ioctl)(node, op, data))
#define vop_gettype(node, type_store)                               (__vop_op(node, gettype)(node, type_store))
#define vop_tryseek(node, pos)                                      (__vop_op(node, tryseek)(node, pos))
#define vop_truncate(node, len)                                     (__vop_op(node, truncate)(node, len))
#define vop_create(node, name, excl, node_store)                    (__vop_op(node, create)(node, name, excl, node_store))
#define vop_lookup(node, path, node_store)                          (__vop_op(node, lookup)(node, path, node_store))


#define vop_fs(node)                                                ((node)->in_fs)
#define vop_init(node, ops, fs)                                     inode_init(node, ops, fs)
#define vop_kill(node)                                              inode_kill(node)

/*
 * Reference count manipulation (handled above filesystem level)
 */
#define vop_ref_inc(node)                                           inode_ref_inc(node)
#define vop_ref_dec(node)                                           inode_ref_dec(node)
/*
 * Open count manipulation (handled above filesystem level)
 *
 * VOP_INCOPEN is called by vfs_open. VOP_DECOPEN is called by vfs_close.
 * Neither of these should need to be called from above the vfs layer.
 */
#define vop_open_inc(node)                                          inode_open_inc(node)
#define vop_open_dec(node)                                          inode_open_dec(node)

static inline int inode_ref_count(struct inode *node)
{
	return node->ref_count;
}

static inline int inode_open_count(struct inode *node)
{
	return node->open_count;
}

#endif  /* __INODE_H__ */
