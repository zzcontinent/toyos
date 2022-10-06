#ifndef __KERN_PROCESS_PROC_H__
#define __KERN_PROCESS_PROC_H__

#include <libs/defs.h>
#include <libs/list.h>
#include <kern/trap/trap.h>
#include <kern/mm/memlayout.h>
#include <libs/skew_heap.h>

#define PROC_NAME_LEN 50
#define MAX_PROCESS 4096
#define MAX_PID (MAX_PROCESS * 2)

extern struct proc_struct *idleproc, *initproc, *current;

struct inode;

enum proc_state {
	PROC_UNINIT = 0,
	PROC_SLEEPING,
	PROC_RUNNABLE,
	PROC_ZOMBIE,
};

struct context {
	uint32_t eip;
	uint32_t esp;
	uint32_t ebx;
	uint32_t ecx;
	uint32_t edx;
	uint32_t esi;
	uint32_t edi;
	uint32_t ebp;
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
	uint32_t flags;
	list_entry_t list_link;
	list_entry_t hash_link;
	list_entry_t run_link;
	int exit_code;
	uint32_t wait_state;
	struct run_queue *rq;
	int time_slice;
	//skew_heap_entry_t lab6_run_pool;
	uint32_t lab6_stride;
	uint32_t lab6_priority;
	struct files_struct *filesp;
};

void cpu_idle(void) __attribute__((noreturn));


#endif /*__KERN_PROCESS_PROC_H__*/
