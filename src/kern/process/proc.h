#ifndef  __PROC_H__
#define  __PROC_H__

#include <libs/defs.h>
#include <libs/list.h>
#include <kern/trap/trap.h>
#include <kern/mm/memlayout.h>
#include <libs/skew_heap.h>

#define PROC_NAME_LEN 50
#define MAX_PROCESS 4096
#define MAX_PID (MAX_PROCESS * 2)
#define PF_EXITING            0x00000001      // getting shutdown
#define WT_INTERRUPTED        0x80000000     // the wait state could be interrupted
#define WT_CHILD              (0x00000001 | WT_INTERRUPTED)  // wait child process
#define WT_KSEM               0x00000100                    // wait kernel semaphore
#define WT_TIMER              (0x00000002 | WT_INTERRUPTED)  // wait timer
#define WT_KBD                (0x00000004 | WT_INTERRUPTED)  // wait the input of keyboard



#define le2proc(le, member)         \
    to_struct((le), struct proc_struct, member)
extern struct proc_struct *g_idleproc, *g_initproc, *g_current;

struct inode;

enum proc_state {
	PROC_UNINIT = 0,
	PROC_SLEEPING,
	PROC_RUNNABLE,
	PROC_ZOMBIE,
};

struct context {
	u32 eip;
	u32 esp;
	u32 ebx;
	u32 ecx;
	u32 edx;
	u32 esi;
	u32 edi;
	u32 ebp;
};

struct proc_struct {
	char name[PROC_NAME_LEN + 1];
	struct proc_struct *parent;
	struct proc_struct *cptr, *yptr, *optr;
	enum proc_state state;
	int pid;
	int runs;
	uintptr_t kstack;
	volatile bool need_resched;
	struct mm_struct *mm;
	struct context context;
	struct trapframe *tf;
	uintptr_t cr3;
	u32 flags;
	list_entry_t list_link;
	list_entry_t hash_link;
	list_entry_t run_link;
	int exit_code;
	u32 wait_state;
	struct run_queue *rq;
	int time_slice;
	skew_heap_entry_t run_pool;
	u32 stride;
	u32 priority;
	struct files_struct *filesp;
};

extern void proc_init(void);
extern void proc_run(struct proc_struct *proc);
extern int kernel_thread(int (*fn)(void *), void *arg, uint32_t clone_flags);
extern char *set_proc_name(struct proc_struct *proc, const char *name);
extern char *get_proc_name(struct proc_struct *proc);
extern void cpu_idle(void) __attribute__((noreturn));
extern struct proc_struct *find_proc(int pid);
extern int do_fork(uint32_t clone_flags, uintptr_t stack, struct trapframe *tf);
extern int do_exit(int error_code);
extern int do_yield(void);
extern int do_execve(const char *name, int argc, const char **argv);
extern int do_wait(int pid, int *code_store);
extern int do_kill(int pid);
extern void set_priority(uint32_t priority);
extern int do_sleep(unsigned int time);
extern void forkrets(struct trapframe *tf);

#endif  /* __PROC_H__ */
