#include <libs/string.h>
#include <libs/error.h>
#include <libs/unistd.h>
#include <libs/hash.h>
#include <libs/log.h>
#include <libs/stdio.h>
#include <libs/elf.h>
#include <kern/sync/sync.h>
#include <kern/mm/memlayout.h>
#include <kern/mm/pmm.h>
#include <kern/mm/vmm.h>
#include <kern/mm/kmalloc.h>
#include <kern/process/proc.h>
#include <kern/schedule/sched.h>
#include <kern/debug/kcommand.h>
#include <kern/fs/file.h>
#include <kern/fs/sysfile.h>
#include <kern/fs/fs.h>
#include <kern/fs/vfs/vfs.h>

extern void switch_to(struct context *from, struct context *to);
extern void kernel_thread_entry(void);
struct proc_struct *g_initproc = NULL;
struct proc_struct *g_idleproc = NULL;
struct proc_struct *g_current = NULL;

list_entry_t g_proc_list;
static list_entry_t g_hash_list[HASH_LIST_SIZE];
int g_nr_process = 0;

void proc_run(struct proc_struct *proc)
{
	if (proc != g_current) {
		bool intr_flag;
		struct proc_struct *prev = g_current, *next = proc;
		local_intr_save(intr_flag);
		{
			g_current = proc;
			load_esp0(next->kstack + KSTACKSIZE);
			lcr3(next->cr3);
			switch_to(&(prev->context), &(next->context));
		}
		local_intr_restore(intr_flag);
	}
}

#define __KERNEL_EXECVE(name, path, ...) ({                         \
		const char *argv[] = {path, ##__VA_ARGS__, NULL};       \
		cprintf("kernel_execve: pid = %d, name = \"%s\".\n",    \
				g_current->pid, name);                            \
				kernel_execve(name, argv);                              \
				})

#define KERNEL_EXECVE(x, ...)                   __KERNEL_EXECVE(#x, #x, ##__VA_ARGS__)

static int user_main(void *arg)
{
	while(1)
		DEBUG_CONSOLE;
	panic("user_main execve failed.\n");
}

static int init_main(void *arg)
{
	int ret;
	if ((ret = vfs_set_bootfs("disk0:")) != 0) {
		panic("set boot fs failed: %e.\n", ret);
	}

	size_t nr_free_pages_store = nr_free_pages();

	int pid = kernel_thread(user_main, NULL, 0);
	if (pid <= 0) {
		panic("create user_main failed.\n");
	}
	//extern void check_sync(void);
	//check_sync();                // check philosopher sync problem

	while (do_wait(0, NULL) == 0) {
		schedule();
	}

	fs_cleanup();

	cprintf("all user-mode processes have quit.\n");
	assert(g_initproc->cptr == NULL && g_initproc->yptr == NULL && g_initproc->optr == NULL);
	assert(g_nr_process == 2);
	assert(list_next(&g_proc_list) == &(g_initproc->list_link));
	assert(list_prev(&g_proc_list) == &(g_initproc->list_link));
	assert(nr_free_pages_store == nr_free_pages());
	cprintf("init check memory pass.\n");
	return 0;
}

static struct proc_struct * alloc_proc(void)
{
	struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
	if (proc != NULL) {
		proc->state = PROC_UNINIT;
		proc->pid = -1;
		proc->runs = 0;
		proc->kstack = 0;
		proc->need_resched = 0;
		proc->parent = NULL;
		proc->mm = NULL;
		memset(&(proc->context), 0, sizeof(struct context));
		proc->tf = NULL;
		proc->cr3 = boot_cr3;
		proc->flags = 0;
		memset(proc->name, 0, PROC_NAME_LEN);
		proc->wait_state = 0;
		proc->cptr = proc->optr = proc->yptr = NULL;
		proc->rq = NULL;
		list_init(&(proc->run_link));
		proc->time_slice = 0;
		proc->run_pool.left = proc->run_pool.right = proc->run_pool.parent = NULL;
		proc->stride = 0;
		proc->priority = 0;
		proc->filesp = NULL;
	}
	return proc;
}

static int setup_kstack(struct proc_struct *proc)
{
	struct page *page = alloc_pages(KSTACKPAGE);
	if (page != NULL) {
		proc->kstack = (uintptr_t)page2kva(page);
		return 0;
	}
	return -E_NO_MEM;
}

static void forkret(void)
{
	forkrets(g_current->tf);
}

static void copy_thread(struct proc_struct *proc, uintptr_t esp, struct trapframe *tf)
{
	proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
	*(proc->tf) = *tf;
	proc->tf->tf_regs.reg_eax = 0;
	proc->tf->tf_esp = esp;
	proc->tf->tf_eflags |= FL_IF;

	proc->context.eip = (uintptr_t)forkret;
	proc->context.esp = (uintptr_t)(proc->tf);
}

static void hash_proc(struct proc_struct *proc)
{
	list_add(g_hash_list + hash32(proc->pid), &(proc->hash_link));
}

static void unhash_proc(struct proc_struct *proc)
{
	list_del(&(proc->hash_link));
}

static void set_links(struct proc_struct *proc)
{
	list_add(&g_proc_list, &(proc->list_link));
	proc->yptr = NULL;
	if ((proc->optr = proc->parent->cptr) != NULL) {
		proc->optr->yptr = proc;
	}
	proc->parent->cptr = proc;
	++g_nr_process;
}

static void remove_links(struct proc_struct *proc)
{
	list_del(&(proc->list_link));
	if (proc->optr != NULL) {
		proc->optr->yptr = proc->yptr;
	}
	if (proc->yptr != NULL) {
		proc->yptr->optr = proc->optr;
	}
	else {
		proc->parent->cptr = proc->optr;
	}
	--g_nr_process;
}

static int get_pid(void)
{
	static_assert(MAX_PID > MAX_PROCESS);
	struct proc_struct *proc;
	list_entry_t *list = &g_proc_list, *le;
	static int next_safe = MAX_PID, last_pid = MAX_PID;
	if (++ last_pid >= MAX_PID) {
		last_pid = 1;
		goto inside;
	}
	if (last_pid >= next_safe) {
inside:
		next_safe = MAX_PID;
repeat:
		le = list;
		while ((le = list_next(le)) != list) {
			proc = le2proc(le, list_link);
			if (proc->pid == last_pid) {
				if (++ last_pid >= next_safe) {
					if (last_pid >= MAX_PID) {
						last_pid = 1;
					}
					next_safe = MAX_PID;
					goto repeat;
				}
			} else if (proc->pid > last_pid && next_safe > proc->pid) {
				next_safe = proc->pid;
			}
		}
	}
	return last_pid;
}

static int setup_pgdir(struct mm_struct *mm)
{
	struct page *page;
	if ((page = alloc_page()) == NULL) {
		return -E_NO_MEM;
	}
	pde_t *pgdir = page2kva(page);
	memcpy(pgdir, boot_pgdir, PGSIZE);
	pgdir[PDX(VPT)] = PADDR(pgdir) | PTE_P | PTE_W;
	mm->pgdir = pgdir;
	return 0;
}

static void free_pgdir(struct mm_struct *mm)
{
	free_page(kva2page(mm->pgdir));
}

static void free_kstack(struct proc_struct *proc)
{
	free_pages(kva2page((void *)(proc->kstack)), KSTACKPAGE);
}

static int copy_mm(uint32_t clone_flags, struct proc_struct *proc)
{
	struct mm_struct *mm, *oldmm = g_current->mm;

	/* current is a kernel thread */
	if (oldmm == NULL) {
		return 0;
	}
	if (clone_flags & CLONE_VM) {
		mm = oldmm;
		goto good_mm;
	}

	int ret = -E_NO_MEM;
	if ((mm = mm_create()) == NULL) {
		goto bad_mm;
	}
	if (setup_pgdir(mm) != 0) {
		goto bad_pgdir_cleanup_mm;
	}

	lock_mm(oldmm);
	{
		ret = dup_mmap(mm, oldmm);
	}
	unlock_mm(oldmm);

	if (ret != 0) {
		goto bad_dup_cleanup_mmap;
	}

good_mm:
	mm_count_inc(mm);
	proc->mm = mm;
	proc->cr3 = PADDR((uintptr_t)(mm->pgdir));
	return 0;
bad_dup_cleanup_mmap:
	exit_mmap(mm);
	free_pgdir(mm);
bad_pgdir_cleanup_mm:
	mm_destroy(mm);
bad_mm:
	return ret;
}

//copy_fs&put_fs function used by do_fork
static int copy_proc_files(uint32_t clone_flags, struct proc_struct *proc)
{
	struct files_struct *filesp, *old_filesp = g_current->filesp;
	assert(old_filesp != NULL);

	if (clone_flags & CLONE_FS) {
		filesp = old_filesp;
		goto good_files_struct;
	}

	int ret = -E_NO_MEM;
	if ((filesp = files_create()) == NULL) {
		goto bad_files_struct;
	}

	if ((ret = dup_files(filesp, old_filesp)) != 0) {
		goto bad_dup_cleanup_fs;
	}

good_files_struct:
	files_count_inc(filesp);
	proc->filesp = filesp;
	return 0;

bad_dup_cleanup_fs:
	files_destroy(filesp);
bad_files_struct:
	return ret;
}


static void free_proc_files(struct proc_struct *proc)
{
	struct files_struct *filesp = proc->filesp;
	if (filesp != NULL) {
		if (files_count_dec(filesp) == 0) {
			files_destroy(filesp);
		}
	}
}

int do_fork(uint32_t clone_flags, uintptr_t stack, struct trapframe *tf)
{
	int ret = -E_NO_FREE_PROC;
	struct proc_struct *proc;
	if (g_nr_process >= MAX_PROCESS) {
		goto fork_out;
	}
	ret = -E_NO_MEM;
	/*
	 * Some Useful MACROs, Functions and DEFINEs, you can use them in below implementation.
	 * MACROs or Functions:
	 *   alloc_proc:   create a proc struct and init fields (lab4:exercise1)
	 *   setup_kstack: alloc pages with size KSTACKPAGE as process kernel stack
	 *   copy_mm:      process "proc" duplicate OR share process "g_current"'s mm according clone_flags
	 *                 if clone_flags & CLONE_VM, then "share" ; else "duplicate"
	 *   copy_thread:  setup the trapframe on the  process's kernel stack top and
	 *                 setup the kernel entry point and stack of process
	 *   hash_proc:    add proc into proc hash_list
	 *   get_pid:      alloc a unique pid for process
	 *   wakeup_proc:  set proc->state = PROC_RUNNABLE
	 * VARIABLES:
	 *   proc_list:    the process set's list
	 *   nr_process:   the number of process set
	 */

	//    1. call alloc_proc to allocate a proc_struct
	//    2. call setup_kstack to allocate a kernel stack for child process
	//    3. call copy_mm to dup OR share mm according clone_flag
	//    4. call copy_thread to setup tf & context in proc_struct
	//    5. insert proc_struct into hash_list && proc_list
	//    6. call wakeup_proc to make the new child process RUNNABLE
	//    7. set ret vaule using child proc's pid

	if ((proc = alloc_proc()) == NULL) {
		goto fork_out;
	}

	proc->parent = g_current;
	assert(g_current->wait_state == 0);

	if (setup_kstack(proc) != 0) {
		goto bad_fork_cleanup_proc;
	}
	if (copy_proc_files(clone_flags, proc) != 0) { //for LAB8
		goto bad_fork_cleanup_kstack;
	}
	if (copy_mm(clone_flags, proc) != 0) {
		goto bad_fork_cleanup_fs;
	}
	copy_thread(proc, stack, tf);

	bool intr_flag;
	local_intr_save(intr_flag);
	{
		proc->pid = get_pid();
		hash_proc(proc);
		set_links(proc);

	}
	local_intr_restore(intr_flag);

	wakeup_proc(proc);

	ret = proc->pid;
fork_out:
	return ret;

bad_fork_cleanup_fs:
	free_proc_files(proc);
bad_fork_cleanup_kstack:
	free_kstack(proc);
bad_fork_cleanup_proc:
	kfree(proc);
	goto fork_out;
}

int kernel_thread(int (*fn)(void *), void *arg, uint32_t clone_flags)
{
	struct trapframe tf;
	memset(&tf, 0, sizeof(struct trapframe));
	tf.tf_cs = KERNEL_CS;
	tf.tf_ds = tf.tf_es = tf.tf_ss = KERNEL_DS;
	tf.tf_regs.reg_ebx = (uint32_t)fn;
	tf.tf_regs.reg_edx = (uint32_t)arg;
	tf.tf_eip = (uint32_t)kernel_thread_entry;
	return do_fork(clone_flags | CLONE_VM, 0, &tf);
}

char *set_proc_name(struct proc_struct *proc, const char *name)
{
	memset(proc->name, 0, sizeof(proc->name));
	return memcpy(proc->name, name, PROC_NAME_LEN);
}

struct proc_struct * find_proc(int pid)
{
	if (0 < pid && pid < MAX_PID) {
		list_entry_t *list = g_hash_list + hash32(pid), *le = list;
		while ((le = list_next(le)) != list) {
			struct proc_struct *proc = le2proc(le, hash_link);
			if (proc->pid == pid) {
				return proc;
			}
		}
	}
	return NULL;
}

void proc_init(void)
{
	int i;
	list_init(&g_proc_list);
	for (i = 0; i < HASH_LIST_SIZE; i ++) {
		list_init(g_hash_list + i);
	}

	if ((g_idleproc = alloc_proc()) == NULL) {
		panic("cannot alloc g_idleproc.\n");
	}

	g_idleproc->pid = 0;
	g_idleproc->state = PROC_RUNNABLE;
	g_idleproc->kstack = (uintptr_t)bootstack;
	g_idleproc->need_resched = 1;

	if ((g_idleproc->filesp = files_create()) == NULL) {
		panic("create filesp (g_idleproc) failed.\n");
	}
	files_count_inc(g_idleproc->filesp);

	set_proc_name(g_idleproc, "idle");
	g_nr_process ++;

	g_current = g_idleproc;

	int pid = kernel_thread(init_main, NULL, 0);
	if (pid <= 0) {
		panic("create init_main failed.\n");
	}

	g_initproc = find_proc(pid);
	set_proc_name(g_initproc, "init");

	assert(g_idleproc != NULL && g_idleproc->pid == 0);
	assert(g_initproc != NULL && g_initproc->pid == 1);
}

int do_exit(int error_code)
{
	if (g_current == g_idleproc) {
		panic("idleproc exit.\n");
	}
	if (g_current == g_initproc) {
		panic("g_initproc exit.\n");
	}

	struct mm_struct *mm = g_current->mm;
	if (mm != NULL) {
		lcr3(boot_cr3);
		if (mm_count_dec(mm) == 0) {
			exit_mmap(mm);
			free_pgdir(mm);
			mm_destroy(mm);
		}
		g_current->mm = NULL;
	}
	free_proc_files(g_current); //for LAB8
	g_current->state = PROC_ZOMBIE;
	g_current->exit_code = error_code;

	bool intr_flag;
	struct proc_struct *proc;
	local_intr_save(intr_flag);
	{
		proc = g_current->parent;
		if (proc->wait_state == WT_CHILD) {
			wakeup_proc(proc);
		}
		while (g_current->cptr != NULL) {
			proc = g_current->cptr;
			g_current->cptr = proc->optr;

			proc->yptr = NULL;
			if ((proc->optr = g_initproc->cptr) != NULL) {
				g_initproc->cptr->yptr = proc;
			}
			proc->parent = g_initproc;
			g_initproc->cptr = proc;
			if (proc->state == PROC_ZOMBIE) {
				if (g_initproc->wait_state == WT_CHILD) {
					wakeup_proc(g_initproc);
				}
			}
		}
	}
	local_intr_restore(intr_flag);

	schedule();
	panic("do_exit will not return!! %d.\n", g_current->pid);
}

void cpu_idle(void)
{
	while (1) {
		if (g_current->need_resched) {
			schedule();
		}
	}
}

int do_wait(int pid, int *code_store)
{
	struct mm_struct *mm = g_current->mm;
	if (code_store != NULL) {
		if (!user_mem_check(mm, (uintptr_t)code_store, sizeof(int), 1)) {
			return -E_INVAL;
		}
	}

	struct proc_struct *proc;
	bool intr_flag, haskid;
repeat:
	haskid = 0;
	if (pid != 0) {
		proc = find_proc(pid);
		if (proc != NULL && proc->parent == g_current) {
			haskid = 1;
			if (proc->state == PROC_ZOMBIE) {
				goto found;
			}
		}
	} else {
		proc = g_current->cptr;
		for (; proc != NULL; proc = proc->optr) {
			haskid = 1;
			if (proc->state == PROC_ZOMBIE) {
				goto found;
			}
		}
	}
	if (haskid) {
		g_current->state = PROC_SLEEPING;
		g_current->wait_state = WT_CHILD;
		schedule();
		if (g_current->flags & PF_EXITING) {
			do_exit(-E_KILLED);
		}
		goto repeat;
	}
	return -E_BAD_PROC;

found:
	if (proc == g_idleproc || proc == g_initproc) {
		panic("wait idleproc or initproc.\n");
	}
	if (code_store != NULL) {
		*code_store = proc->exit_code;
	}
	local_intr_save(intr_flag);
	{
		unhash_proc(proc);
		remove_links(proc);
	}
	local_intr_restore(intr_flag);
	free_kstack(proc);
	kfree(proc);
	return 0;
}

// do_kill - kill process with pid by set this process's flags with PF_EXITING
int do_kill(int pid)
{
	struct proc_struct *proc;
	if ((proc = find_proc(pid)) != NULL) {
		if (!(proc->flags & PF_EXITING)) {
			proc->flags |= PF_EXITING;
			if (proc->wait_state & WT_INTERRUPTED) {
				wakeup_proc(proc);
			}
			return 0;
		}
		return -E_KILLED;
	}
	return -E_INVAL;
}

// do_sleep - set current process state to sleep and add timer with "time"
//          - then call scheduler. if process run again, delete timer first.
int do_sleep(unsigned int time)
{
	if (time == 0) {
		return 0;
	}
	bool intr_flag;
	local_intr_save(intr_flag);
	timer_t __timer, *timer = timer_init(&__timer, g_current, time);
	g_current->state = PROC_SLEEPING;
	g_current->wait_state = WT_TIMER;
	add_timer(timer);
	local_intr_restore(intr_flag);

	schedule();

	del_timer(timer);
	return 0;
}

static void free_kargv(int argc, char **kargv)
{
	while (argc > 0) {
		kfree(kargv[-- argc]);
	}
}

static int copy_kargv(struct mm_struct *mm, int argc, char **kargv, const char **argv)
{
	int i, ret = -E_INVAL;
	if (!user_mem_check(mm, (uintptr_t)argv, sizeof(const char *) * argc, 0)) {
		return ret;
	}
	for (i = 0; i < argc; i ++) {
		char *buffer;
		if ((buffer = kmalloc(EXEC_MAX_ARG_LEN + 1)) == NULL) {
			goto failed_nomem;
		}
		if (!copy_string(mm, buffer, argv[i], EXEC_MAX_ARG_LEN + 1)) {
			kfree(buffer);
			goto failed_cleanup;
		}
		kargv[i] = buffer;
	}
	return 0;

failed_nomem:
	ret = -E_NO_MEM;
failed_cleanup:
	free_kargv(i, kargv);
	return ret;
}

//load_icode_read is used by load_icode in LAB8
static int load_icode_read(int fd, void *buf, size_t len, off_t offset)
{
	int ret;
	if ((ret = sysfile_seek(fd, offset, LSEEK_SET)) != 0) {
		return ret;
	}
	if ((ret = sysfile_read(fd, buf, len)) != len) {
		return (ret < 0) ? ret : -1;
	}
	return 0;
}

static int load_icode(int fd, int argc, char **kargv)
{
	/* LAB8:EXERCISE2 YOUR CODE  HINT:how to load the file with handler fd  in to process's memory? how to setup argc/argv?
	 * MACROs or Functions:
	 *  mm_create        - create a mm
	 *  setup_pgdir      - setup pgdir in mm
	 *  load_icode_read  - read raw data content of program file
	 *  mm_map           - build new vma
	 *  pgdir_alloc_page - allocate new memory for  TEXT/DATA/BSS/stack parts
	 *  lcr3             - update Page Directory Addr Register -- CR3
	 */
	/* (1) create a new mm for current process
	 * (2) create a new PDT, and mm->pgdir= kernel virtual addr of PDT
	 * (3) copy TEXT/DATA/BSS parts in binary to memory space of process
	 *    (3.1) read raw data content in file and resolve elfhdr
	 *    (3.2) read raw data content in file and resolve proghdr based on info in elfhdr
	 *    (3.3) call mm_map to build vma related to TEXT/DATA
	 *    (3.4) callpgdir_alloc_page to allocate page for TEXT/DATA, read contents in file
	 *          and copy them into the new allocated pages
	 *    (3.5) callpgdir_alloc_page to allocate pages for BSS, memset zero in these pages
	 * (4) call mm_map to setup user stack, and put parameters into user stack
	 * (5) setup current process's mm, cr3, reset pgidr (using lcr3 MARCO)
	 * (6) setup uargc and uargv in user stacks
	 * (7) setup trapframe for user environment
	 * (8) if up steps failed, you should cleanup the env.
	 */
	assert(argc >= 0 && argc <= EXEC_MAX_ARG_NUM);

	if (g_current->mm != NULL) {
		panic("load_icode: g_current->mm must be empty.\n");
	}

	int ret = -E_NO_MEM;
	struct mm_struct *mm;
	if ((mm = mm_create()) == NULL) {
		goto bad_mm;
	}
	if (setup_pgdir(mm) != 0) {
		goto bad_pgdir_cleanup_mm;
	}

	struct page *page;

	struct elfhdr __elf, *elf = &__elf;
	if ((ret = load_icode_read(fd, elf, sizeof(struct elfhdr), 0)) != 0) {
		goto bad_elf_cleanup_pgdir;
	}

	if (elf->e_magic != ELF_MAGIC) {
		ret = -E_INVAL_ELF;
		goto bad_elf_cleanup_pgdir;
	}

	struct proghdr __ph, *ph = &__ph;
	uint32_t vm_flags, perm, phnum;
	for (phnum = 0; phnum < elf->e_phnum; phnum ++) {
		off_t phoff = elf->e_phoff + sizeof(struct proghdr) * phnum;
		if ((ret = load_icode_read(fd, ph, sizeof(struct proghdr), phoff)) != 0) {
			goto bad_cleanup_mmap;
		}
		if (ph->p_type != ELF_PT_LOAD) {
			continue ;
		}
		if (ph->p_filesz > ph->p_memsz) {
			ret = -E_INVAL_ELF;
			goto bad_cleanup_mmap;
		}
		if (ph->p_filesz == 0) {
			continue ;
		}
		vm_flags = 0, perm = PTE_U;
		if (ph->p_flags & ELF_PF_X) vm_flags |= VM_EXEC;
		if (ph->p_flags & ELF_PF_W) vm_flags |= VM_WRITE;
		if (ph->p_flags & ELF_PF_R) vm_flags |= VM_READ;
		if (vm_flags & VM_WRITE) perm |= PTE_W;
		if ((ret = mm_map(mm, ph->p_va, ph->p_memsz, vm_flags, NULL)) != 0) {
			goto bad_cleanup_mmap;
		}
		off_t offset = ph->p_offset;
		size_t off, size;
		uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);

		ret = -E_NO_MEM;

		end = ph->p_va + ph->p_filesz;
		while (start < end) {
			if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL) {
				ret = -E_NO_MEM;
				goto bad_cleanup_mmap;
			}
			off = start - la, size = PGSIZE - off, la += PGSIZE;
			if (end < la) {
				size -= la - end;
			}
			if ((ret = load_icode_read(fd, page2kva(page) + off, size, offset)) != 0) {
				goto bad_cleanup_mmap;
			}
			start += size, offset += size;
		}
		end = ph->p_va + ph->p_memsz;

		if (start < la) {
			/* ph->p_memsz == ph->p_filesz */
			if (start == end) {
				continue ;
			}
			off = start + PGSIZE - la, size = PGSIZE - off;
			if (end < la) {
				size -= la - end;
			}
			memset(page2kva(page) + off, 0, size);
			start += size;
			assert((end < la && start == end) || (end >= la && start == la));
		}
		while (start < end) {
			if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL) {
				ret = -E_NO_MEM;
				goto bad_cleanup_mmap;
			}
			off = start - la, size = PGSIZE - off, la += PGSIZE;
			if (end < la) {
				size -= la - end;
			}
			memset(page2kva(page) + off, 0, size);
			start += size;
		}
	}
	sysfile_close(fd);

	vm_flags = VM_READ | VM_WRITE | VM_STACK;
	if ((ret = mm_map(mm, USTACKTOP - USTACKSIZE, USTACKSIZE, vm_flags, NULL)) != 0) {
		goto bad_cleanup_mmap;
	}
	assert(pgdir_alloc_page(mm->pgdir, USTACKTOP-PGSIZE , PTE_USER) != NULL);
	assert(pgdir_alloc_page(mm->pgdir, USTACKTOP-2*PGSIZE , PTE_USER) != NULL);
	assert(pgdir_alloc_page(mm->pgdir, USTACKTOP-3*PGSIZE , PTE_USER) != NULL);
	assert(pgdir_alloc_page(mm->pgdir, USTACKTOP-4*PGSIZE , PTE_USER) != NULL);

	mm_count_inc(mm);
	g_current->mm = mm;
	g_current->cr3 = PADDR(mm->pgdir);
	lcr3(PADDR(mm->pgdir));

	//setup argc, argv
	uint32_t argv_size=0, i;
	for (i = 0; i < argc; i ++) {
		argv_size += strnlen(kargv[i],EXEC_MAX_ARG_LEN + 1)+1;
	}

	uintptr_t stacktop = USTACKTOP - (argv_size/sizeof(long)+1)*sizeof(long);
	char** uargv=(char **)(stacktop  - argc * sizeof(char *));

	argv_size = 0;
	for (i = 0; i < argc; i ++) {
		uargv[i] = strcpy((char *)(stacktop + argv_size ), kargv[i]);
		argv_size +=  strnlen(kargv[i],EXEC_MAX_ARG_LEN + 1)+1;
	}

	stacktop = (uintptr_t)uargv - sizeof(int);
	*(int *)stacktop = argc;

	struct trapframe *tf = g_current->tf;
	memset(tf, 0, sizeof(struct trapframe));
	tf->tf_cs = USER_CS;
	tf->tf_ds = tf->tf_es = tf->tf_ss = USER_DS;
	tf->tf_esp = stacktop;
	tf->tf_eip = elf->e_entry;
	tf->tf_eflags = FL_IF;
	ret = 0;
out:
	return ret;
bad_cleanup_mmap:
	exit_mmap(mm);
bad_elf_cleanup_pgdir:
	free_pgdir(mm);
bad_pgdir_cleanup_mm:
	mm_destroy(mm);
bad_mm:
	goto out;
}

// do_execve - call exit_mmap(mm)&free_pgdir(mm) to reclaim memory space of current process
//           - call load_icode to setup new memory space accroding binary prog.
int do_execve(const char *name, int argc, const char **argv)
{
	udebug("name=%s, argc=%d, argv=0x%x\n", name, argc, argv);
	static_assert(EXEC_MAX_ARG_LEN >= FS_MAX_FPATH_LEN);
	struct mm_struct *mm = g_current->mm;
	if (!(argc >= 1 && argc <= EXEC_MAX_ARG_NUM)) {
		return -E_INVAL;
	}

	char local_name[PROC_NAME_LEN + 1];
	memset(local_name, 0, sizeof(local_name));

	char *kargv[EXEC_MAX_ARG_NUM];
	const char *path;

	int ret = -E_INVAL;

	lock_mm(mm);
	if (name == NULL) {
		snprintf(local_name, sizeof(local_name), "<null> %d", g_current->pid);
	} else {
		if (!copy_string(mm, local_name, name, sizeof(local_name))) {
			unlock_mm(mm);
			return ret;
		}
	}

	if ((ret = copy_kargv(mm, argc, kargv, argv)) != 0) {
		unlock_mm(mm);
		return ret;
	}
	path = argv[0];
	unlock_mm(mm);
	files_closeall(g_current->filesp);

	/* sysfile_open will check the first argument path, thus we have to use a user-space pointer, and argv[0] may be incorrect */
	udebug("path=%s\n", path);
	int fd;
	if ((ret = fd = sysfile_open(path, O_RDONLY)) < 0) {
		udebug("\n");
		goto execve_exit;
	}
	udebug("\n");

	if (mm != NULL) {
		lcr3(boot_cr3);
		if (mm_count_dec(mm) == 0) {
			exit_mmap(mm);
			free_pgdir(mm);
			mm_destroy(mm);
		}
		g_current->mm = NULL;
	}
	ret= -E_NO_MEM;;
	if ((ret = load_icode(fd, argc, kargv)) != 0) {
		goto execve_exit;
	}
	free_kargv(argc, kargv);
	set_proc_name(g_current, local_name);
	return 0;

execve_exit:
	udebug("\n");
	free_kargv(argc, kargv);
	do_exit(ret);
	panic("already exit: %e.\n", ret);
}

// do_yield - ask the scheduler to reschedule
int do_yield(void)
{
	g_current->need_resched = 1;
	return 0;
}

void set_priority(uint32_t priority)
{
	if (priority == 0) {
		g_current->priority = 1;
	} else {
		g_current->priority = priority;
	}
}

// kernel_execve - do SYS_exec syscall to exec a user program called by user_main kernel_thread
int kernel_execve(const char *name, const char **argv)
{
	uclean("kernel_execve: pid = %d, name = \"%s\"\n", g_current->pid, name);
	int argc = 0, ret;
	while (argv[argc] != NULL) {
		argc ++;
	}

	asm volatile (
			"int %1;"
			: "=a" (ret)
			: "i" (T_SYSCALL), "0" (SYS_exec), "d" (name), "c" (argc), "b" (argv)
			: "memory");
	return ret;
}

