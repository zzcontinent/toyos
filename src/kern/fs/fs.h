#ifndef  __FS_H__
#define  __FS_H__

#include <libs/defs.h>
#include <kern/mm/mmu.h>
#include <kern/sync/sem.h>
#include <libs/atomic.h>

#define SECTSIZE            512
#define PAGE_NSECT          (PGSIZE / SECTSIZE)

#define SWAP_DEV_NO         1
#define DISK0_DEV_NO        2
#define DISK1_DEV_NO        3

struct inode;
struct file;

/*
 * process's file related informaction
 */
struct files_struct {
	struct inode *pwd;      // inode of present working directory
	struct file *fd_array;  // opened files array
	int files_count;        // the number of opened files
	semaphore_t files_sem;  // lock protect sem
};

#define FILES_STRUCT_BUFSIZE                       (PGSIZE - sizeof(struct files_struct))
#define FILES_STRUCT_NENTRY                        (FILES_STRUCT_BUFSIZE / sizeof(struct file))

extern void fs_init(void);
extern void fs_cleanup(void);
extern void lock_files(struct files_struct *filesp);
extern void unlock_files(struct files_struct *filesp);

extern struct files_struct *files_create(void);
extern void files_destroy(struct files_struct *filesp);
extern void files_closeall(struct files_struct *filesp);
extern int dup_files(struct files_struct *to, struct files_struct *from);

static inline int files_count(struct files_struct *filesp) 
{
	return filesp->files_count;
}

static inline int files_count_inc(struct files_struct *filesp) 
{
	filesp->files_count += 1;
	return filesp->files_count;
}

static inline int files_count_dec(struct files_struct *filesp) 
{
	filesp->files_count -= 1;
	return filesp->files_count;
}


#endif  /* __FS_H__ */
