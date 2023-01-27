#ifndef  __DIRENT_H__
#define  __DIRENT_H__

#include <libs/defs.h>
#include <libs/unistd.h>

struct dirent {
	off_t offset;
	char name[FS_MAX_FNAME_LEN + 1];
};

#endif  /* __DIRENT_H__ */
