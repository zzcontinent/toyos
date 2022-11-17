#include <libs/string.h>
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

