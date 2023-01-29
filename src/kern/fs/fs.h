#ifndef  __FS_H__
#define  __FS_H__

#include <libs/defs.h>

#define SWAP_DEV_NO         1
#define DISK0_DEV_NO        2
#define DISK1_DEV_NO        3

extern void fs_init(void);
extern void fs_cleanup(void);

#endif  /* __FS_H__ */
