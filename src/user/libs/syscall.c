#include <libs/defs.h>
#include <libs/string.h>
#include <libs/stat.h>
#include <libs/dirent.h>
#include <libs/error.h>
#include <libs/unistd.h>
#include <libs/stdarg.h>
#include <user/libs/syscall.h>


#define MAX_ARGS            5

static inline int syscall(int num, ...)
{
	va_list ap;
	va_start(ap, num);
	uint32_t a[MAX_ARGS];
	int i, ret;
	for (i = 0; i < MAX_ARGS; i ++) {
		a[i] = va_arg(ap, uint32_t);
	}
	va_end(ap);

	asm volatile (
			"int %1"
			: "=a" (ret)
			: "i" (T_SYSCALL),
			"a" (num),
			"b" (a[0]),
			"c" (a[1]),
			"d" (a[2]),
			"S" (a[3]),
			"D" (a[4])
			: "cc", "memory");
	return ret;
}

int sys_exit(int error_code)
{
	return syscall(SYS_exit, error_code);
}

int sys_exit_group(int error_code)
{
	return syscall(SYS_exit_group, error_code);
}

int sys_fork(void)
{
	return syscall(SYS_fork);
}

int sys_wait(int pid, int *store)
{
	return syscall(SYS_wait, pid, store);
}

int sys_yield(void)
{
	return syscall(SYS_sched_yield);
}

int sys_kill(int pid)
{
	return syscall(SYS_kill, pid);
}

int sys_getpid(void)
{
	return syscall(SYS_getpid);
}

int sys_nanosleep(unsigned int time)
{
	return syscall(SYS_nanosleep, time);
}

size_t sys_gettime(void)
{
	return syscall(SYS_clock_gettime32);
}

int sys_execve(const char *name, int argc, const char **argv)
{
	return syscall(SYS_execve, name, argc, argv);
}

int sys_open(const char *path, uint32_t open_flags)
{
	return syscall(SYS_open, path, open_flags);
}

int sys_close(int fd)
{
	return syscall(SYS_close, fd);
}

int sys_read(int fd, void *base, size_t len)
{
	return syscall(SYS_read, fd, base, len);
}

int sys_write(int fd, void *base, size_t len)
{
	return syscall(SYS_write, fd, base, len);
}

int sys_ioctl(const char *path, uint32_t open_flags)
{
	return syscall(SYS_ioctl, path, open_flags);
}

int sys_lseek(int fd, off_t pos, int whence)
{
	return syscall(SYS_lseek, fd, pos, whence);
}

int sys_fstat(int fd, struct stat *stat)
{
	return syscall(SYS_fstat, fd, stat);
}

int sys_fsync(int fd)
{
	return syscall(SYS_fsync, fd);
}

int sys_getcwd(char *buffer, size_t len)
{
	return syscall(SYS_getcwd, buffer, len);
}

int sys_getdirentry(int fd, struct dirent *dirent)
{
	return syscall(SYS_getdirentry, fd, dirent);
}

int sys_dup(int fd1, int fd2)
{
	return syscall(SYS_dup, fd1, fd2);
}


//user defined

int sys_putc(int c)
{
	return syscall(SYS_putc, c);
}

int sys_pgdir()
{
	return syscall(SYS_pgdir);
}

void sys_set_priority(uint32_t priority)
{
	syscall(SYS_set_priority, priority);
}

