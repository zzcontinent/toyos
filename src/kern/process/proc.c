#include <libs/string.h>
#include <libs/error.h>
#include <libs/unistd.h>
#include <kern/sync/sync.h>
#include <kern/mm/memlayout.h>
#include <kern/mm/pmm.h>
#include <kern/mm/kmalloc.h>
#include <kern/process/proc.h>
#include <kern/schedule/sched.h>

#define HASH_SHIFT          10
#define HASH_LIST_SIZE      (1 << HASH_SHIFT)
#define pid_hashfn(x)       (hash32(x, HASH_SHIFT))

extern void switch_to(struct context *from, struct context *to);
extern void kernel_thread_entry(void);
struct proc_struct *idleproc = NULL;
struct proc_struct *current = NULL;

list_entry_t g_proc_list;
static list_entry_t g_hash_list[HASH_LIST_SIZE];
static int g_nr_process = 0;

void proc_run(struct proc_struct *proc)
{
	if (proc != current) {
		bool intr_flag;
		struct proc_struct *prev = current, *next = proc;
		local_intr_save(intr_flag);
		{
			current = proc;
			load_esp0(next->kstack + KSTACKSIZE);
			lcr3(next->cr3);
			switch_to(&(prev->context), &(next->context));
		}
		local_intr_restore(intr_flag);
	}
}

static int init_main(void *arg)
{
#if 0
	int ret;
	if ((ret = vfs_set_bootfs("disk0:")) != 0) {
		panic("set boot fs failed: %e.\n", ret);
	}

	size_t nr_free_pages_store = nr_free_pages();
	size_t kernel_allocated_store = kallocated();

	int pid = kernel_thread(user_main, NULL, 0);
	if (pid <= 0) {
		panic("create user_main failed.\n");
	}
	extern void check_sync(void);
	check_sync();                // check philosopher sync problem

	while (do_wait(0, NULL) == 0) {
		schedule();
	}

	fs_cleanup();

	cprintf("all user-mode processes have quit.\n");
	assert(initproc->cptr == NULL && initproc->yptr == NULL && initproc->optr == NULL);
	assert(nr_process == 2);
	assert(list_next(&proc_list) == &(initproc->list_link));
	assert(list_prev(&proc_list) == &(initproc->list_link));
	assert(nr_free_pages_store == nr_free_pages());
	assert(kernel_allocated_store == kallocated());
	cprintf("init check memory pass.\n");
#endif
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
	 *   copy_mm:      process "proc" duplicate OR share process "current"'s mm according clone_flags
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

	proc->parent = current;
	assert(current->wait_state == 0);

	if (setup_kstack(proc) != 0) {
		goto bad_fork_cleanup_proc;
	}
	//if (copy_fs(clone_flags, proc) != 0) { //for LAB8
	//	goto bad_fork_cleanup_kstack;
	//}
	//if (copy_mm(clone_flags, proc) != 0) {
	//	goto bad_fork_cleanup_fs;
	//}
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
	put_fs(proc);
bad_fork_cleanup_kstack:
	put_kstack(proc);
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

void proc_init(void)
{
	int i;
	list_init(&g_proc_list);
	for (i = 0; i < HASH_LIST_SIZE; i ++) {
		list_init(g_hash_list + i);
	}

	if ((idleproc = alloc_proc()) == NULL) {
		panic("cannot alloc idleproc.\n");
	}

	idleproc->pid = 0;
	idleproc->state = PROC_RUNNABLE;
	idleproc->kstack = (uintptr_t)bootstack;
	idleproc->need_resched = 1;

#if 0
	if ((idleproc->filesp = files_create()) == NULL) {
		panic("create filesp (idleproc) failed.\n");
	}
	files_count_inc(idleproc->filesp);
#endif

	set_proc_name(idleproc, "idle");
	g_nr_process ++;

	current = idleproc;

	int pid = kernel_thread(init_main, NULL, 0);
	if (pid <= 0) {
		panic("create init_main failed.\n");
	}

	initproc = find_proc(pid);
	set_proc_name(initproc, "init");

	assert(idleproc != NULL && idleproc->pid == 0);
	assert(initproc != NULL && initproc->pid == 1);
}

// cpu_idle - at the end of kern_init, the first kernel thread idleproc will do below works
void cpu_idle(void)
{
	while (1) {
		if (current->need_resched) {
			schedule();
		}
	}
}

