#ifndef __KERN_MM_VMM_H__
#define __KERN_MM_VMM_H__

#include <defs.h>
#include <list.h>
#include <memlayout.h>
#include <sync.h>
#include <proc.h>
#include <sem.h>

struct mm_struct;

struct vma_struct {
	struct mm_struct *vm_mm;
	uintptr_t vm_start;
	uintptr_t vm_end;
	uintptr_t vm_flags;
	list_entry_t list_link;
};

#define le2vma(le, member) \
	to_struct(le, struct vma_struct, member)

#define VM_READ    0x00000001
#define VM_WRITE   0x00000002
#define VM_EXEC    0x00000004
#define VM_STACK   0x00000008

struct mm_struct {
	list_entry_t mmap_list;
	struct vma_struct *mmap_cache;
	pde_t *pgdir;
	int map_count;
	void *sm_priv;
	int mm_count;
//	semaphore_t mm_sem;
	int locked_by;
};




#endif
