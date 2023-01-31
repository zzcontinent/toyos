#ifndef  __FILE_H__
#define  __FILE_H__

#include <kern/sync/sem.h>
#include <kern/process/proc.h>
#include <libs/stat.h>
#include <libs/dirent.h>

struct file {
	enum {
		FD_NONE, FD_INIT, FD_OPENED, FD_CLOSED,
	} status;
	bool readable;
	bool writable;
	int fd;
	off_t pos;
	struct inode *node;
	int open_count;
};

struct files_struct {
	struct inode *pwd;      // inode of present working directory
	struct file *fd_array;  // opened files array
	int files_count;        // the number of opened files
	semaphore_t files_sem;  // lock protect sem
};


#define FILES_STRUCT_BUFSIZE                       (PGSIZE - sizeof(struct files_struct))
#define FILES_STRUCT_NENTRY                        (FILES_STRUCT_BUFSIZE / sizeof(struct file))
#define testfd(fd)                          ((fd) >= 0 && (fd) < FILES_STRUCT_NENTRY)

extern void fd_array_init(struct file *fd_array);
extern void fd_array_open(struct file *file);
extern void fd_array_close(struct file *file);
extern void fd_array_dup(struct file *to, struct file *from);
extern bool file_testfd(int fd, bool readable, bool writable);

extern int file_open(char *path, uint32_t open_flags);
extern int file_close(int fd);
extern int file_read(int fd, void *base, size_t len, size_t *copied_store);
extern int file_write(int fd, void *base, size_t len, size_t *copied_store);
extern int file_seek(int fd, off_t pos, int whence);
extern int file_fstat(int fd, struct stat *stat);
extern int file_fsync(int fd);
extern int file_getdirentry(int fd, struct dirent *dirent);
extern int file_dup(int fd1, int fd2);
extern int file_pipe(int fd[]);
extern int file_mkfifo(const char *name, uint32_t open_flags);

extern void lock_files(struct files_struct *filesp);
extern void unlock_files(struct files_struct *filesp);
extern struct files_struct *files_create(void);
extern void files_destroy(struct files_struct *filesp);
extern void files_closeall(struct files_struct *filesp);
extern int dup_files(struct files_struct *to, struct files_struct *from);

#endif  /* __FILE_H__ */
