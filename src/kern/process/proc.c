#include <kern/sync/sync.h>
#include <kern/mm/memlayout.h>
#include <kern/mm/pmm.h>
#include <kern/process/proc.h>


//defined in switch.S
extern void switch_to(struct context *from, struct context *to);
struct proc_struct *idleproc = NULL;
struct proc_struct *current = NULL;

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
//
//void cpu_idle(void)
//{
//	while(1)
//	{
//		if (current->need_resched)
//		{
//			schedule();
//		}
//	}
//}
