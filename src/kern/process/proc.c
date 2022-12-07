#include <libs/string.h>
#include <libs/error.h>
#include <libs/unistd.h>
#include <libs/hash.h>
#include <libs/log.h>
#include <kern/sync/sync.h>
#include <kern/mm/memlayout.h>
#include <kern/mm/pmm.h>
#include <kern/mm/vmm.h>
#include <kern/mm/kmalloc.h>
#include <kern/process/proc.h>
#include <kern/schedule/sched.h>
#include <kern/debug/kcommand.h>

extern void switch_to(struct context *from, struct context *to);
extern void kernel_thread_entry(void);
struct proc_struct *g_initproc = NULL;
struct proc_struct *g_idleproc = NULL;
struct proc_struct *g_current = NULL;

list_entry_t g_proc_list;
static list_entry_t hash_list[HASH_LIST_SIZE];
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

static int user_main(void *arg)
{
	while(1)
		DEBUG_CONSOLE;
	panic("user_main execve failed.\n");
}

static int init_main(void *arg)
{
	udebug("\r\n");
	//int ret;
	//if ((ret = vfs_set_bootfs("disk0:")) != 0) {
	//	panic("set boot fs failed: %e.\n", ret);
	//}

	size_t nr_free_pages_store = nr_free_pages();

	int pid = kernel_thread(user_main, NULL, 0);
	if (pid <= 0) {
		panic("create user_main failed.\n");
	}
	//extern void check_sync(void);
	//check_sync();                // check philosopher sync problem

	udebug("\r\n");
	while (do_wait(0, NULL) == 0) {
		udebug("\r\n");
		schedule();
	}

	//fs_cleanup();

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
		proc->lab6_run_pool.left = proc->lab6_run_pool.right = proc->lab6_run_pool.parent = NULL;
		proc->lab6_stride = 0;
		proc->lab6_priority = 0;
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
	list_add(hash_list + hash32(proc->pid), &(proc->hash_link));
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
	//if (copy_fs(clone_flags, proc) != 0) { //for LAB8
	//	goto bad_fork_cleanup_kstack;
	//}
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

bad_fork_cleanup_fs:  //for LAB8
		      //put_fs(proc);
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
		list_entry_t *list = hash_list + hash32(pid), *le = list;
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
		list_init(hash_list + i);
	}

	if ((g_idleproc = alloc_proc()) == NULL) {
		panic("cannot alloc g_idleproc.\n");
	}

	g_idleproc->pid = 0;
	g_idleproc->state = PROC_RUNNABLE;
	g_idleproc->kstack = (uintptr_t)bootstack;
	g_idleproc->need_resched = 1;

#if 0
	if ((g_idleproc->filesp = files_create()) == NULL) {
		panic("create filesp (g_idleproc) failed.\n");
	}
	files_count_inc(g_idleproc->filesp);
#endif

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
	//put_fs(g_current); //for LAB8
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
	udebug("\r\n");
	struct mm_struct *mm = g_current->mm;
	if (code_store != NULL) {
		if (!user_mem_check(mm, (uintptr_t)code_store, sizeof(int), 1)) {
			return -E_INVAL;
		}
	}
	udebug("\r\n");

	struct proc_struct *proc;
	bool intr_flag, haskid;
repeat:
	haskid = 0;
	if (pid != 0) {
		udebug("\r\n");
		proc = find_proc(pid);
		if (proc != NULL && proc->parent == g_current) {
			haskid = 1;
			if (proc->state == PROC_ZOMBIE) {
				goto found;
			}
		}
	} else {
		udebug("\r\n");
		proc = g_current->cptr;
		for (; proc != NULL; proc = proc->optr) {
			haskid = 1;
			if (proc->state == PROC_ZOMBIE) {
				udebug("\r\n");
				goto found;
			}
		}
		udebug("\r\n");
	}
	udebug("\r\n");
	if (haskid) {
		udebug("\r\n");
		g_current->state = PROC_SLEEPING;
		g_current->wait_state = WT_CHILD;
		schedule();
		if (g_current->flags & PF_EXITING) {
			udebug("\r\n");
			do_exit(-E_KILLED);
		}
		goto repeat;
	}
	udebug("\r\n");
	return -E_BAD_PROC;

found:
	udebug("\r\n");
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

