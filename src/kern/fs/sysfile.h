#ifndef  __SYSFILE_H__
#define  __SYSFILE_H__

#include <libs/defs.h>
#include <libs/stat.h>
#include <libs/dirent.h>

extern int sysfile_open(const char *path, uint32_t open_flags);        // Open or create a file. FLAGS/MODE per the syscall.
extern int sysfile_close(int fd);                                      // Close a vnode opened  
extern int sysfile_read(int fd, void *base, size_t len);               // Read file
extern int sysfile_write(int fd, void *base, size_t len);              // Write file
extern int sysfile_seek(int fd, off_t pos, int whence);                // Seek file  
extern int sysfile_fstat(int fd, struct stat *stat);                   // Stat file 
extern int sysfile_fsync(int fd);                                      // Sync file
extern int sysfile_chdir(const char *path);                            // change DIR  
extern int sysfile_mkdir(const char *path);                            // create DIR
extern int sysfile_link(const char *path1, const char *path2);         // set a path1's link as path2
extern int sysfile_rename(const char *path1, const char *path2);       // rename file
extern int sysfile_unlink(const char *path);                           // unlink a path
extern int sysfile_getcwd(char *buf, size_t len);                      // get current working directory
extern int sysfile_getdirentry(int fd, struct dirent *direntp);        // get the file entry in DIR 
extern int sysfile_dup(int fd1, int fd2);                              // duplicate file
extern int sysfile_pipe(int *fd_store);                                // build PIPE   
extern int sysfile_mkfifo(const char *name, uint32_t open_flags);      // build named PIPE
extern int sysfile_ioctl(int fd);

#endif  /* __SYSFILE_H__ */
