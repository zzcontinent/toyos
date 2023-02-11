#ifndef  __FILE_H__
#define  __FILE_H__

#include <libs/defs.h>
#include <libs/stat.h>


extern int open(const char *path, uint32_t open_flags);
extern int close(int fd);
extern int read(int fd, void *base, size_t len);
extern int write(int fd, void *base, size_t len);
extern int seek(int fd, off_t pos, int whence);
extern int fstat(int fd, struct stat *stat);
extern int fsync(int fd);
extern int dup(int fd);
extern int dup2(int fd1, int fd2);
extern int pipe(int *fd_store);
extern int mkfifo(const char *name, uint32_t open_flags);

void print_stat(const char *name, int fd, struct stat *stat);

#endif  /* __FILE_H__ */
