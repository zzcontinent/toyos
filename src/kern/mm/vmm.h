/* ********************************************************************************
 * FILE NAME   : vmm.h
 * PROGRAMMER  : zhaozz
 * DESCRIPTION : vmm header
 * DATE        : 2022-11-12 22:06:38
 * *******************************************************************************/
#ifndef  __VMM_H__
#define  __VMM_H__
#include <libs/defs.h>
#include <libs/list.h>
#include <kern/mm/memlayout.h>
#include <kern/sync/sync.h>
#include <kern/process/proc.h>
#include <kern/sync/sem.h>

#define le2vma(le, member) \
	to_struct(le, struct vma_struct, member)

#define VM_READ    0x00000001
#define VM_WRITE   0x00000002
#define VM_EXEC    0x00000004
#define VM_STACK   0x00000008

struct mm_struct;

struct mm_struct {
	list_entry_t mmap_list;
	struct vma_struct *mmap_cache;
	pde_t *pgdir;
	int map_count;
	void *sm_priv;
	int mm_count;
	semaphore_t mm_sem;
	int locked_by;
};

struct vma_struct {
	struct mm_struct *vm_mm;
	uintptr_t vm_start;
	uintptr_t vm_end;
	uintptr_t vm_flags;
	list_entry_t list_link;
};

extern struct mm_struct* g_check_mm_struct;
extern void vmm_init(void);
extern int do_pgfault(struct mm_struct *mm, u32 error_code, uintptr_t addr);

#endif  /* __VMM_H__ */
