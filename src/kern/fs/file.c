#include <libs/defs.h>
#include <libs/string.h>
#include <libs/unistd.h>
#include <libs/log.h>
#include <libs/stat.h>
#include <libs/error.h>
#include <libs/iobuf.h>
#include <kern/debug/assert.h>
#include <kern/process/proc.h>
#include <kern/mm/kmalloc.h>
#include <kern/fs/fs.h>
#include <kern/fs/vfs/inode.h>
#include <kern/fs/vfs/vfs.h>
#include <kern/fs/file.h>


// get_fd_array - get current process's open files table
static struct file * get_fd_array(void)
{
	struct files_struct *filesp = g_current->filesp;
	assert(filesp != NULL && files_count(filesp) > 0);
	return filesp->fd_array;
}

// fd_array_init - initialize the open files table
void fd_array_init(struct file *fd_array)
{
	int fd;
	struct file *file = fd_array;
	for (fd = 0; fd < FILES_STRUCT_NENTRY; fd ++, file ++) {
		file->open_count = 0;
		file->status = FD_NONE, file->fd = fd;
	}
}

// fs_array_alloc - allocate a free file item (with FD_NONE status) in open files table
static int fd_array_alloc(int fd, struct file **file_store)
{
	//    panic("debug");
	struct file *file = get_fd_array();
	if (fd == NO_FD) {
		for (fd = 0; fd < FILES_STRUCT_NENTRY; fd ++, file ++) {
			if (file->status == FD_NONE) {
				goto found;
			}
		}
		return -E_MAX_OPEN;
	} else {
		if (testfd(fd)) {
			file += fd;
			if (file->status == FD_NONE) {
				goto found;
			}
			return -E_BUSY;
		}
		return -E_INVAL;
	}
found:
	assert(fopen_count(file) == 0);
	file->status = FD_INIT, file->node = NULL;
	*file_store = file;
	return 0;
}

// fd_array_free - free a file item in open files table
static void fd_array_free(struct file *file)
{
	assert(file->status == FD_INIT || file->status == FD_CLOSED);
	assert(fopen_count(file) == 0);
	if (file->status == FD_CLOSED) {
		vfs_close(file->node);
	}
	file->status = FD_NONE;
}

static void fd_array_acquire(struct file *file)
{
	assert(file->status == FD_OPENED);
	fopen_count_inc(file);
}

// fd_array_release - file's open_count--; if file's open_count-- == 0 , then call fd_array_free to free this file item
static void fd_array_release(struct file *file)
{
	assert(file->status == FD_OPENED || file->status == FD_CLOSED);
	assert(fopen_count(file) > 0);
	if (fopen_count_dec(file) == 0) {
		fd_array_free(file);
	}
}

// fd_array_open - file's open_count++, set status to FD_OPENED
void fd_array_open(struct file *file)
{
	assert(file->status == FD_INIT && file->node != NULL);
	file->status = FD_OPENED;
	fopen_count_inc(file);
}

// fd_array_close - file's open_count--; if file's open_count-- == 0 , then call fd_array_free to free this file item
void fd_array_close(struct file *file)
{
	assert(file->status == FD_OPENED);
	assert(fopen_count(file) > 0);
	file->status = FD_CLOSED;
	if (fopen_count_dec(file) == 0) {
		fd_array_free(file);
	}
}

//fs_array_dup - duplicate file 'from'  to file 'to'
void fd_array_dup(struct file *to, struct file *from)
{
	udebug("[fd_array_dup]from fd=%d, to fd=%d\n",from->fd, to->fd);
	assert(to->status == FD_INIT && from->status == FD_OPENED);
	to->pos = from->pos;
	to->readable = from->readable;
	to->writable = from->writable;
	struct inode *node = from->node;
	vop_ref_inc(node), vop_open_inc(node);
	to->node = node;
	fd_array_open(to);
}

// fd2file - use fd as index of fd_array, return the array item (file)
static inline int fd2file(int fd, struct file **file_store)
{
	if (testfd(fd)) {
		struct file *file = get_fd_array() + fd;
		if (file->status == FD_OPENED && file->fd == fd) {
			*file_store = file;
			return 0;
		}
	}
	return -E_INVAL;
}

// file_testfd - test file is readble or writable?
bool file_testfd(int fd, bool readable, bool writable)
{
	int ret;
	struct file *file;
	if ((ret = fd2file(fd, &file)) != 0) {
		return 0;
	}
	if (readable && !file->readable) {
		return 0;
	}
	if (writable && !file->writable) {
		return 0;
	}
	return 1;
}

// open file
int file_open(char *path, uint32_t open_flags)
{
	bool readable = 0, writable = 0;
	switch (open_flags & O_ACCMODE) {
		case O_RDONLY: readable = 1; break;
		case O_WRONLY: writable = 1; break;
		case O_RDWR:
			       readable = writable = 1;
			       break;
		default:
			       return -E_INVAL;
	}

	int ret;
	struct file *file;
	if ((ret = fd_array_alloc(NO_FD, &file)) != 0) {
		return ret;
	}

	struct inode *node;
	if ((ret = vfs_open(path, open_flags, &node)) != 0) {
		fd_array_free(file);
		return ret;
	}

	file->pos = 0;
	if (open_flags & O_APPEND) {
		struct stat __stat, *stat = &__stat;
		if ((ret = vop_fstat(node, stat)) != 0) {
			vfs_close(node);
			fd_array_free(file);
			return ret;
		}
		file->pos = stat->st_size;
	}

	file->node = node;
	file->readable = readable;
	file->writable = writable;
	fd_array_open(file);
	return file->fd;
}

// close file
int file_close(int fd)
{
	int ret;
	struct file *file;
	if ((ret = fd2file(fd, &file)) != 0) {
		return ret;
	}
	fd_array_close(file);
	return 0;
}

// read file
int file_read(int fd, void *base, size_t len, size_t *copied_store)
{
	udebug("\n");
	int ret;
	struct file *file;
	*copied_store = 0;
	if ((ret = fd2file(fd, &file)) != 0) {
		udebug("\n");
		return ret;
	}
	udebug("\n");
	if (!file->readable) {
		udebug("\n");
		return -E_INVAL;
	}
	udebug("\n");
	fd_array_acquire(file);

	udebug("\n");
	struct iobuf __iob, *iob = iobuf_init(&__iob, base, len, file->pos);
	udebug("iob=0x%x\n", iob);
	ret = vop_read(file->node, iob);

	udebug("\n");
	size_t copied = iobuf_used(iob);
	udebug("\n");
	if (file->status == FD_OPENED) {
		file->pos += copied;
	}
	*copied_store = copied;
	fd_array_release(file);
	return ret;
}

// write file
int file_write(int fd, void *base, size_t len, size_t *copied_store)
{
	int ret;
	struct file *file;
	*copied_store = 0;
	if ((ret = fd2file(fd, &file)) != 0) {
		return ret;
	}
	if (!file->writable) {
		return -E_INVAL;
	}
	fd_array_acquire(file);

	struct iobuf __iob, *iob = iobuf_init(&__iob, base, len, file->pos);
	ret = vop_write(file->node, iob);

	size_t copied = iobuf_used(iob);
	if (file->status == FD_OPENED) {
		file->pos += copied;
	}
	*copied_store = copied;
	fd_array_release(file);
	return ret;
}

// seek file
int file_seek(int fd, off_t pos, int whence)
{
	struct stat __stat, *stat = &__stat;
	int ret;
	struct file *file=NULL;
	if ((ret = fd2file(fd, &file)) != 0) {
		return ret;
	}
	udebug("fd:%d, pos=%d, whence:%d, file:0x%x\n", fd, pos, whence, file);
	fd_array_acquire(file);

	switch (whence) {
		case LSEEK_SET: break;
		case LSEEK_CUR: pos += file->pos; break;
		case LSEEK_END:
				if ((ret = vop_fstat(file->node, stat)) == 0) {
					pos += stat->st_size;
				}
				break;
		default: ret = -E_INVAL;
	}

	if (ret == 0) {
		if ((ret = vop_tryseek(file->node, pos)) == 0) {
			file->pos = pos;
		}
		udebug("file_seek, pos=%d, whence=%d, ret=%d\n", pos, whence, ret);
	}
	fd_array_release(file);
	return ret;
}

// stat file
int file_fstat(int fd, struct stat *stat)
{
	int ret;
	struct file *file;
	if ((ret = fd2file(fd, &file)) != 0) {
		return ret;
	}
	fd_array_acquire(file);
	ret = vop_fstat(file->node, stat);
	fd_array_release(file);
	return ret;
}

// sync file
int file_fsync(int fd)
{
	int ret;
	struct file *file;
	if ((ret = fd2file(fd, &file)) != 0) {
		return ret;
	}
	fd_array_acquire(file);
	ret = vop_fsync(file->node);
	fd_array_release(file);
	return ret;
}

// get file entry in DIR
int file_getdirentry(int fd, struct dirent *direntp)
{
	int ret;
	struct file *file;
	if ((ret = fd2file(fd, &file)) != 0) {
		return ret;
	}
	fd_array_acquire(file);

	struct iobuf __iob, *iob = iobuf_init(&__iob, direntp->name, sizeof(direntp->name), direntp->offset);
	if ((ret = vop_getdirentry(file->node, iob)) == 0) {
		direntp->offset += iobuf_used(iob);
	}
	fd_array_release(file);
	return ret;
}

// duplicate file
int file_dup(int fd1, int fd2)
{
	int ret;
	struct file *file1, *file2;
	if ((ret = fd2file(fd1, &file1)) != 0) {
		return ret;
	}
	if ((ret = fd_array_alloc(fd2, &file2)) != 0) {
		return ret;
	}
	fd_array_dup(file2, file1);
	return file2->fd;
}

void lock_files(struct files_struct *filesp)
{
	//udebug("filesp:0x%x, filesp->files_sem:0x%x\n", filesp, &filesp->files_sem);
	down(&(filesp->files_sem));
}

void unlock_files(struct files_struct *filesp)
{
	up(&(filesp->files_sem));
}

//Called when a new proc init
struct files_struct * files_create(void)
{
	udebug("[files_create]\n");
	static_assert((int)FILES_STRUCT_NENTRY > 128);
	struct files_struct *filesp;
	if ((filesp = kmalloc(sizeof(struct files_struct) + FILES_STRUCT_BUFSIZE)) != NULL) {
		filesp->pwd = NULL;
		filesp->fd_array = (void *)(filesp + 1);
		filesp->files_count = 0;
		sem_init(&(filesp->files_sem), 1);
		fd_array_init(filesp->fd_array);
	}
	return filesp;
}

//Called when a proc exit
void files_destroy(struct files_struct *filesp)
{
	udebug("[files_destroy]\n");
	assert(filesp != NULL && files_count(filesp) == 0);
	if (filesp->pwd != NULL) {
		vop_ref_dec(filesp->pwd);
	}
	int i;
	struct file *file = filesp->fd_array;
	for (i = 0; i < FILES_STRUCT_NENTRY; i ++, file ++) {
		if (file->status == FD_OPENED) {
			fd_array_close(file);
		}
		assert(file->status == FD_NONE);
	}
	kfree(filesp);
}

void files_closeall(struct files_struct *filesp)
{
	udebug("[files_closeall]\n");
	assert(filesp != NULL && files_count(filesp) > 0);
	int i;
	struct file *file = filesp->fd_array;
	//skip the stdin & stdout
	for (i = 2, file += 2; i < FILES_STRUCT_NENTRY; i ++, file ++) {
		if (file->status == FD_OPENED) {
			fd_array_close(file);
		}
	}
}

int dup_files(struct files_struct *to, struct files_struct *from)
{
	udebug("[dup_files]\n");
	assert(to != NULL && from != NULL);
	assert(files_count(to) == 0 && files_count(from) > 0);
	if ((to->pwd = from->pwd) != NULL) {
		vop_ref_inc(to->pwd);
	}
	int i;
	struct file *to_file = to->fd_array, *from_file = from->fd_array;
	for (i = 0; i < FILES_STRUCT_NENTRY; i ++, to_file ++, from_file ++) {
		if (from_file->status == FD_OPENED) {
			/* alloc_fd first */
			to_file->status = FD_INIT;
			fd_array_dup(to_file, from_file);
		}
	}
	return 0;
}

