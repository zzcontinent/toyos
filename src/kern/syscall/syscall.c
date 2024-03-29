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
#include <kern/driver/clock.h>
#include <kern/fs/sysfile.h>

static int sys_exit(uint32_t arg[])
{
	int error_code = (int)arg[0];
	uclean("[SYSC] exit [%d][%s] %e\n", g_current->pid, g_current->name, error_code);
	return do_exit(error_code);
}

static int sys_fork(uint32_t arg[])
{
	struct trapframe *tf = g_current->tf;
	uintptr_t stack = tf->tf_esp;
	uclean("[SYSC] fork [%d][%s]\n", g_current->pid, g_current->name);
	return do_fork(0, stack, tf);
}

static int sys_wait(uint32_t arg[])
{
	int pid = (int)arg[0];
	int *store = (int *)arg[1];
	uclean("[SYSC] wait [%d][%s] -> [%d]\n", g_current->pid, g_current->name, pid);
	return do_wait(pid, store);
}

static int sys_exec(uint32_t arg[])
{
	const char *name = (const char *)arg[0];
	int argc = (int)arg[1];
	const char **argv = (const char **)arg[2];
	uclean("[SYSC] exec [%d][%s] -> [%s]\n", g_current->pid, g_current->name, name);
	return do_execve(name, argc, argv);
}

static int sys_yield(uint32_t arg[])
{
	uclean("[SYSC] yield [%d][%s]\n", g_current->pid, g_current->name);
	return do_yield();
}

static int sys_kill(uint32_t arg[])
{
	int pid = (int)arg[0];
	uclean("[SYSC] kill [%d][%s] -> [%d]\n", g_current->pid, g_current->name, pid);
	return do_kill(pid);
}

static int sys_getpid(uint32_t arg[])
{
	return g_current->pid;
}

static int sys_putc(uint32_t arg[])
{
	int c = (int)arg[0];
	cputchar(c);
	return 0;
}

static int sys_pgdir(uint32_t arg[])
{
	print_pg();
	return 0;
}

static int sys_gettime(uint32_t arg[])
{
	return (int)g_ticks;
}

static int sys_set_priority(uint32_t arg[])
{
	uint32_t priority = (uint32_t)arg[0];
	set_priority(priority);
	return 0;
}

static int sys_sleep(uint32_t arg[])
{
	unsigned int time = (unsigned int)arg[0];
	uclean("[SYSC] sleep [%d][%s] -> [%d]\n", g_current->pid, g_current->name, time);
	return do_sleep(time);
}

static int sys_open(uint32_t arg[]) 
{
	const char *path = (const char *)arg[0];
	uint32_t open_flags = (uint32_t)arg[1];
	//uclean("[SYSC] open [%d][%s] -> [%s]\n", g_current->pid, g_current->name, path);
	return sysfile_open(path, open_flags);
}

static int sys_close(uint32_t arg[])
{
	int fd = (int)arg[0];
	//uclean("[SYSC] close [%d][%s] -> fd:[%d]\n", g_current->pid, g_current->name, fd);
	return sysfile_close(fd);
}

static int sys_read(uint32_t arg[])
{
	int fd = (int)arg[0];
	void *base = (void *)arg[1];
	size_t len = (size_t)arg[2];
	//uclean("[SYSC] read [%d][%s] -> fd:[%d]\n", g_current->pid, g_current->name, fd);
	return sysfile_read(fd, base, len);
}

static int sys_write(uint32_t arg[])
{
	int fd = (int)arg[0];
	void *base = (void *)arg[1];
	size_t len = (size_t)arg[2];
	//uclean("[SYSC] write [%d][%s] -> fd:[%d]\n", g_current->pid, g_current->name, fd);
	return sysfile_write(fd, base, len);
}

static int sys_seek(uint32_t arg[])
{
	int fd = (int)arg[0];
	off_t pos = (off_t)arg[1];
	int whence = (int)arg[2];
	//uclean("[SYSC] seek [%d][%s] -> fd:[%d]\n", g_current->pid, g_current->name, fd);
	return sysfile_seek(fd, pos, whence);
}

static int sys_fstat(uint32_t arg[])
{
	int fd = (int)arg[0];
	struct stat *stat = (struct stat *)arg[1];
	return sysfile_fstat(fd, stat);
}

static int sys_fsync(uint32_t arg[])
{
	int fd = (int)arg[0];
	return sysfile_fsync(fd);
}

static int sys_getcwd(uint32_t arg[])
{
	char *buf = (char *)arg[0];
	size_t len = (size_t)arg[1];
	return sysfile_getcwd(buf, len);
}

static int sys_getdirentry(uint32_t arg[])
{
	int fd = (int)arg[0];
	struct dirent *direntp = (struct dirent *)arg[1];
	return sysfile_getdirentry(fd, direntp);
}

static int sys_dup(uint32_t arg[])
{
	int fd1 = (int)arg[0];
	int fd2 = (int)arg[1];
	//uclean("[SYSC] dup [%d][%s] -> fd:[%d-%d]\n", g_current->pid, g_current->name, fd1, fd2);
	return sysfile_dup(fd1, fd2);
}

static int (*syscalls[])(uint32_t arg[]) = {
	[SYS_exit]              sys_exit,
	[SYS_fork]              sys_fork,
	[SYS_wait]              sys_wait,
	[SYS_exec]              sys_exec,
	[SYS_yield]             sys_yield,
	[SYS_kill]              sys_kill,
	[SYS_getpid]            sys_getpid,
	[SYS_putc]              sys_putc,
	[SYS_pgdir]             sys_pgdir,
	[SYS_gettime]           sys_gettime,
	[SYS_set_priority]      sys_set_priority,
	[SYS_sleep]             sys_sleep,
	[SYS_open]              sys_open,
	[SYS_close]             sys_close,
	[SYS_read]              sys_read,
	[SYS_write]             sys_write,
	[SYS_seek]              sys_seek,
	[SYS_fstat]             sys_fstat,
	[SYS_fsync]             sys_fsync,
	[SYS_getcwd]            sys_getcwd,
	[SYS_getdirentry]       sys_getdirentry,
	[SYS_dup]               sys_dup,
};

#define NUM_SYSCALLS        ((sizeof(syscalls)) / (sizeof(syscalls[0])))

void syscall(void) {
	struct trapframe *tf = g_current->tf;
	uint32_t arg[5];
	int num = tf->tf_regs.reg_eax;
	if (num >= 0 && num < NUM_SYSCALLS) {
		if (syscalls[num] != NULL) {
			udebug("syscall:%d\n", num);
			arg[0] = tf->tf_regs.reg_edx;
			arg[1] = tf->tf_regs.reg_ecx;
			arg[2] = tf->tf_regs.reg_ebx;
			arg[3] = tf->tf_regs.reg_edi;
			arg[4] = tf->tf_regs.reg_esi;
			tf->tf_regs.reg_eax = syscalls[num](arg);
			return ;
		}
	}
	print_trapframe(tf);
	panic("undefined syscall %d, pid = %d, name = %s.\n",
			num, g_current->pid, g_current->name);
}


