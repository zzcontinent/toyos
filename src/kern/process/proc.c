#include <proc.h>

sturct proc_struct *current = NULL;

void cpu_idle(void)
{
	while(1)
	{
		if (current->need_resched)
		{
			schedule();
		}
	}
}
