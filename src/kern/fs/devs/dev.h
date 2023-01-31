#ifndef  __DEV_H__
#define  __DEV_H__

#include <libs/defs.h>
#include <libs/iobuf.h>
#include <kern/fs/vfs/inode.h>

struct device {
	size_t d_blocks;
	size_t d_blocksize;
	int (*d_open)(struct device *dev, uint32_t open_flags);
	int (*d_close)(struct device *dev);
	int (*d_io)(struct device *dev, struct iobuf *iob, bool write);
	int (*d_ioctl)(struct device *dev, int op, void *data);
};


#define init_device(x)                                  \
	do {                                                \
		extern void dev_init_##x(void);                 \
		dev_init_##x();                                 \
	} while (0)


/*
 * Filesystem-namespace-accessible device.
 * d_io is for both reads and writes; the iobuf will indicates the direction.
 */
#define dop_open(dev, open_flags)           ((dev)->d_open(dev, open_flags))
#define dop_close(dev)                      ((dev)->d_close(dev))
#define dop_io(dev, iob, write)             ((dev)->d_io(dev, iob, write))
#define dop_ioctl(dev, op, data)            ((dev)->d_ioctl(dev, op, data))

extern void dev_init(void);
extern struct inode *dev_create_inode(void);


#endif  /* __DEV_H__ */
