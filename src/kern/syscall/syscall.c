#include <libs/defs.h>
#include <libs/unistd.h>
#include <libs/stat.h>
#include <libs/dirent.h>
#include <libs/stdio.h>
#include <kern/process/proc.h>
#include <kern/syscall/syscall.h>
#include <kern/trap/trap.h>
#include <kern/mm/pmm.h>
#include <kern/debug/assert.h>
#include <kern/debug/kcommand.h>
#include <kern/driver/clock.h>
#include <kern/fs/sysfile.h>

static int sys_exit(uint32_t arg[])
{
	int error_code = (int)arg[0];
	utest("[pid:%d, proc:%s] args[0x%x, 0x%x, 0x%x, 0x%x, 0x%x]\n", g_current->pid, g_current->name, arg[0], arg[1], arg[2], arg[3], arg[4]);
	return do_exit(error_code);
}

//TODO
static int sys_exit_group(uint32_t arg[])
{
	int error_code = (int)arg[0];
	utest("[pid:%d, proc:%s] args[0x%x, 0x%x, 0x%x, 0x%x, 0x%x]\n", g_current->pid, g_current->name, arg[0], arg[1], arg[2], arg[3], arg[4]);
	return do_exit(error_code);
}

static int sys_fork(uint32_t arg[])
{
	struct trapframe *tf = g_current->tf;
	uintptr_t stack = tf->tf_esp;
	utest("[pid:%d, proc:%s] args[0x%x, 0x%x, 0x%x, 0x%x, 0x%x]\n", g_current->pid, g_current->name, arg[0], arg[1], arg[2], arg[3], arg[4]);
	return do_fork(0, stack, tf);
}

static int sys_wait(uint32_t arg[])
{
	int pid = (int)arg[0];
	int *store = (int *)arg[1];
	utest("[pid:%d, proc:%s] args[0x%x, 0x%x, 0x%x, 0x%x, 0x%x]\n", g_current->pid, g_current->name, arg[0], arg[1], arg[2], arg[3], arg[4]);
	return do_wait(pid, store);
}

static int sys_execve(uint32_t arg[])
{
	const char *name = (const char *)arg[0];
	int argc = (int)arg[1];
	const char **argv = (const char **)arg[2];
	return do_execve(name, argc, argv);
}

static int sys_sched_yield(uint32_t arg[])
{
	utest("[pid:%d, proc:%s] args[0x%x, 0x%x, 0x%x, 0x%x, 0x%x]\n", g_current->pid, g_current->name, arg[0], arg[1], arg[2], arg[3], arg[4]);
	return do_yield();
}

static int sys_kill(uint32_t arg[])
{
	int pid = (int)arg[0];
	utest("[pid:%d, proc:%s] args[0x%x, 0x%x, 0x%x, 0x%x, 0x%x]\n", g_current->pid, g_current->name, arg[0], arg[1], arg[2], arg[3], arg[4]);
	return do_kill(pid);
}

static int sys_getpid(uint32_t arg[])
{
	utest("[pid:%d, proc:%s] args[0x%x, 0x%x, 0x%x, 0x%x, 0x%x]\n", g_current->pid, g_current->name, arg[0], arg[1], arg[2], arg[3], arg[4]);
	return g_current->pid;
}

static int sys_clock_gettime32(uint32_t arg[])
{
	utest("[pid:%d, proc:%s] args[0x%x, 0x%x, 0x%x, 0x%x]\n", g_current->pid, g_current->name, arg[0], arg[1], arg[2], arg[3]);
	return (int)g_ticks;
}

static int sys_set_priority(uint32_t arg[])
{
	uint32_t priority = (uint32_t)arg[0];
	utest("[pid:%d, proc:%s] args[0x%x, 0x%x, 0x%x, 0x%x, 0x%x]\n", g_current->pid, g_current->name, arg[0], arg[1], arg[2], arg[3], arg[4]);
	set_priority(priority);
	return 0;
}

static int sys_nanosleep(uint32_t arg[])
{
	unsigned int time = (unsigned int)arg[0];
	utest("[pid:%d, proc:%s] args[0x%x, 0x%x, 0x%x, 0x%x, 0x%x]\n", g_current->pid, g_current->name, arg[0], arg[1], arg[2], arg[3], arg[4]);
	return do_sleep(time);
}

static int sys_open(uint32_t arg[])
{
	const char *path = (const char *)arg[0];
	uint32_t open_flags = (uint32_t)arg[1];
	utest("[pid:%d, proc:%s] args[0x%x, 0x%x, 0x%x, 0x%x, 0x%x]\n", g_current->pid, g_current->name, arg[0], arg[1], arg[2], arg[3], arg[4]);
	return sysfile_open(path, open_flags);
}

static int sys_close(uint32_t arg[])
{
	int fd = (int)arg[0];
	utest("[pid:%d, proc:%s] args[0x%x, 0x%x, 0x%x, 0x%x, 0x%x]\n", g_current->pid, g_current->name, arg[0], arg[1], arg[2], arg[3], arg[4]);
	return sysfile_close(fd);
}

static int sys_read(uint32_t arg[])
{
	int fd = (int)arg[0];
	void *base = (void *)arg[1];
	size_t len = (size_t)arg[2];
	utest("[pid:%d, proc:%s] args[0x%x, 0x%x, 0x%x, 0x%x, 0x%x]\n", g_current->pid, g_current->name, arg[0], arg[1], arg[2], arg[3], arg[4]);
	return sysfile_read(fd, base, len);
}

static int sys_write(uint32_t arg[])
{
	int fd = (int)arg[0];
	void *base = (void *)arg[1];
	size_t len = (size_t)arg[2];
	utest("[pid:%d, proc:%s] args[0x%x, 0x%x, 0x%x, 0x%x, 0x%x]\n", g_current->pid, g_current->name, arg[0], arg[1], arg[2], arg[3], arg[4]);
	return sysfile_write(fd, base, len);
}

static int sys_writev(uint32_t arg[])
{
	int fd = (int)arg[0];
	struct iovec *iov = (void *)arg[1];
	size_t iovcnt = (size_t)arg[2];
	utest("[pid:%d, proc:%s] args[0x%x, 0x%x, 0x%x, 0x%x, 0x%x]\n", g_current->pid, g_current->name, arg[0], arg[1], arg[2], arg[3], arg[4]);
	int i = 0;
	int ret = 0;
	for (i=0; i<iovcnt; i++) {
		//uclean("+++%d\n", i);
		//uclean("%d, iovcnt=%d, base=0x%x, len=0x%d\n", i, iovcnt, iov[i].iov_base, iov[i].iov_len);
		ret += sysfile_write(fd, iov[i].iov_base, iov[i].iov_len);
	}
	return ret;
}

static int sys_lseek(uint32_t arg[])
{
	int fd = (int)arg[0];
	off_t pos = (off_t)arg[1];
	int whence = (int)arg[2];
	utest("[pid:%d, proc:%s] args[0x%x, 0x%x, 0x%x, 0x%x, 0x%x]\n", g_current->pid, g_current->name, arg[0], arg[1], arg[2], arg[3], arg[4]);
	return sysfile_seek(fd, pos, whence);
}

static int sys_fstat(uint32_t arg[])
{
	int fd = (int)arg[0];
	struct stat *stat = (struct stat *)arg[1];
	utest("[pid:%d, proc:%s] args[0x%x, 0x%x, 0x%x, 0x%x, 0x%x]\n", g_current->pid, g_current->name, arg[0], arg[1], arg[2], arg[3], arg[4]);
	return sysfile_fstat(fd, stat);
}

static int sys_fsync(uint32_t arg[])
{
	int fd = (int)arg[0];
	utest("[pid:%d, proc:%s] args[0x%x, 0x%x, 0x%x, 0x%x, 0x%x]\n", g_current->pid, g_current->name, arg[0], arg[1], arg[2], arg[3], arg[4]);
	return sysfile_fsync(fd);
}

static int sys_getcwd(uint32_t arg[])
{
	char *buf = (char *)arg[0];
	size_t len = (size_t)arg[1];
	utest("[pid:%d, proc:%s] args[0x%x, 0x%x, 0x%x, 0x%x, 0x%x]\n", g_current->pid, g_current->name, arg[0], arg[1], arg[2], arg[3], arg[4]);
	return sysfile_getcwd(buf, len);
}

static int sys_getdirentry(uint32_t arg[])
{
	int fd = (int)arg[0];
	utest("[pid:%d, proc:%s] args[0x%x, 0x%x, 0x%x, 0x%x, 0x%x]\n", g_current->pid, g_current->name, arg[0], arg[1], arg[2], arg[3], arg[4]);
	struct dirent *direntp = (struct dirent *)arg[1];
	return sysfile_getdirentry(fd, direntp);
}

static int sys_dup(uint32_t arg[])
{
	int fd1 = (int)arg[0];
	int fd2 = (int)arg[1];
	utest("[pid:%d, proc:%s] args[0x%x, 0x%x, 0x%x, 0x%x, 0x%x]\n", g_current->pid, g_current->name, arg[0], arg[1], arg[2], arg[3], arg[4]);
	return sysfile_dup(fd1, fd2);
}

static int sys_ioctl(uint32_t arg[])
{
	int fd = (int)arg[0];
	utest("[pid:%d, proc:%s] args[0x%x, 0x%x, 0x%x, 0x%x, 0x%x]\n", g_current->pid, g_current->name, arg[0], arg[1], arg[2], arg[3], arg[4]);
	return sysfile_ioctl(fd);
}

static int sys_putc(uint32_t arg[])
{
	utest("[pid:%d, proc:%s] args[0x%x, 0x%x, 0x%x, 0x%x, 0x%x]\n", g_current->pid, g_current->name, arg[0], arg[1], arg[2], arg[3], arg[4]);
	int c = (int)arg[0];
	cputchar(c);
	return 0;
}

static int sys_pgdir(uint32_t arg[])
{
	utest("[pid:%d, proc:%s] args[0x%x, 0x%x, 0x%x, 0x%x, 0x%x]\n", g_current->pid, g_current->name, arg[0], arg[1], arg[2], arg[3], arg[4]);
	print_pg();
	return 0;
}

static int (*syscalls[])(uint32_t arg[]) = {
	[SYS_exit]              sys_exit,
	[SYS_exit_group]        sys_exit_group,
	[SYS_fork]              sys_fork,
	[SYS_wait]              sys_wait,
	[SYS_execve]            sys_execve,
	[SYS_sched_yield]       sys_sched_yield,
	[SYS_kill]              sys_kill,
	[SYS_getpid]            sys_getpid,
	[SYS_clock_gettime32]   sys_clock_gettime32,
	[SYS_set_priority]      sys_set_priority,
	[SYS_nanosleep]         sys_nanosleep,
	[SYS_open]              sys_open,
	[SYS_close]             sys_close,
	[SYS_read]              sys_read,
	[SYS_write]             sys_write,
	[SYS_writev]            sys_writev,
	[SYS_lseek]             sys_lseek,
	[SYS_ioctl]             sys_ioctl,
	[SYS_fstat]             sys_fstat,
	[SYS_fsync]             sys_fsync,
	[SYS_getcwd]            sys_getcwd,
	[SYS_getdirentry]       sys_getdirentry,
	[SYS_dup]               sys_dup,

	//user defined
	[SYS_putc]              sys_putc,
	[SYS_pgdir]             sys_pgdir,
};

#define NUM_SYSCALLS        ((sizeof(syscalls)) / (sizeof(syscalls[0])))

void syscall(void) {
	struct trapframe *tf = g_current->tf;
	uint32_t arg[5];
	int num = tf->tf_regs.reg_eax;
	if (num >= 0 && num < NUM_SYSCALLS) {
		if (syscalls[num] != NULL) {
			arg[0] = tf->tf_regs.reg_ebx;
			arg[1] = tf->tf_regs.reg_ecx;
			arg[2] = tf->tf_regs.reg_edx;
			arg[3] = tf->tf_regs.reg_esi;
			arg[4] = tf->tf_regs.reg_edi;
			int ret = syscalls[num](arg);
			tf->tf_regs.reg_eax = ret;
			return ;
		}
	}
	uerror("undefined syscall %d, pid = %d, name = %s.\n",
			num, g_current->pid, g_current->name);
}


