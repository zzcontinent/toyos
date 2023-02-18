#ifndef  __SYSCALL_H__
#define  __SYSCALL_H__

#include <libs/stat.h>
#include <libs/dirent.h>

extern int sys_exit(int error_code);
extern int sys_fork(void);
extern int sys_wait(int pid, int *store);
extern int sys_exec(const char *name, int argc, const char **argv);
extern int sys_yield(void);
extern int sys_kill(int pid);
extern int sys_getpid(void);
extern int sys_putc(int c);
extern int sys_pgdir(void);
extern int sys_sleep(unsigned int time);
extern size_t sys_gettime(void);

extern int sys_open(const char *path, uint32_t open_flags);
extern int sys_close(int fd);
extern int sys_read(int fd, void *base, size_t len);
extern int sys_write(int fd, void *base, size_t len);
extern int sys_seek(int fd, off_t pos, int whence);
extern int sys_fstat(int fd, struct stat *stat);
extern int sys_fsync(int fd);
extern int sys_getcwd(char *buffer, size_t len);
extern int sys_getdirentry(int fd, struct dirent *dirent);
extern int sys_dup(int fd1, int fd2);
extern void sys_set_priority(uint32_t priority); //only for lab6


#endif  /* __SYSCALL_H__ */
