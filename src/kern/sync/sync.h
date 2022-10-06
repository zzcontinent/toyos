#ifndef __KERN_SYNC_SYNC_H__
#define __KERN_SYNC_SYNC_H__

#include <kern/driver/intr.h>
#include <kern/mm/mmu.h>
#include <libs/x86.h>

static inline bool __intr_save(void)
{
	if (read_eflags() & FL_IF) {
		intr_disable();
		return 1;
	}
	return 0;
}

static inline void __intr_restore(bool flag)
{
	if (flag) {
		intr_enable();
	}
}

#define local_intr_save(x) do { x = __intr_save();} while(0)
#define local_intr_restore(x) __intr_restore(x)

#endif /* !__KERN_SYNC_SYNC_H__ */
