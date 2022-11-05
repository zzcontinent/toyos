/* ******************************************************************************************
 * FILE NAME   : vmm.c
 * PROGRAMMER  : zhaozz
 * DESCRIPTION : kernel vmm implement
 * DATE        : 2022-01-08 00:38:00
 * *****************************************************************************************/
#include <libs/defs.h>
#include <libs/error.h>
#include <libs/stdio.h>
#include <kern/mm/pmm.h>
#include <kern/mm/kmalloc.h>
#include <kern/mm/vmm.h>
#include <kern/mm/swap.h>

volatile u32 pgfault_num = 0;

struct mm_struct* mm_create(void)
{
	struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
	if (mm != NULL) {
		list_init(&(mm->mmap_list));
		mm->mmap_cache = NULL;
		mm->pgdir = NULL;
		mm->map_count = 0;

		//TODO
		//if (swap_init_ok) swap_init_mm(mm);
		//else mm->sm_priv = NULL;

		//set_mm_count(mm, 0);
		//sem_init(&(mm->mm_sem), 1);
	}
	return mm;
}

struct vma_struct* vma_create(uintptr_t vm_start, uintptr_t vm_end, u32 vm_flags)
{
	struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
	if (vma != NULL) {
		vma->vm_start = vm_start;
		vma->vm_end = vm_end;
		vma->vm_flags = vm_flags;
	}
	return vma;
}

struct vma_struct* find_vma(struct mm_struct *mm, uintptr_t addr)
{
	struct vma_struct *vma = NULL;
	if (mm != NULL)
	{
		vma = mm->mmap_cache;
		if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr))
		{
			bool found = 0;
			list_entry_t *list = &(mm->mmap_list), *le = list;
			while ((le = list_next(le)) != list)
			{
				vma = le2vma(le, list_link);
				if (vma->vm_start<=addr && addr < vma->vm_end)
				{
					found = 1;
					break;
				}
			}
			if (!found)
			{
				vma = NULL;
			}
		}
		if (vma != NULL)
		{
			mm->mmap_cache = vma;
		}
	}
	return vma;
}

static inline void check_vma_overlap(struct vma_struct *prev, struct vma_struct *next)
{
	assert(prev->vm_start < prev->vm_end);
	assert(prev->vm_end <= next->vm_start);
	assert(next->vm_start < next->vm_end);
}

void insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma)
{
	assert(vma->vm_start < vma->vm_end);
	list_entry_t *list = &(mm->mmap_list);
	list_entry_t *le_prev = list, *le_next;

	list_entry_t *le = list;
	while ((le = list_next(le)) != list)
	{
		struct vma_struct *mmap_cur = le2vma(le, list_link);
		if (mmap_cur->vm_start > vma->vm_start)
		{
			break;
		}
		le_prev = le;
	}

	le_next = list_next(le_prev);

	if (le_prev != list) {
		check_vma_overlap(le2vma(le_prev, list_link), vma);
	}
	if (le_next != list) {
		check_vma_overlap(vma, le2vma(le_next, list_link));
	}

	vma->vm_mm = mm;
	list_add_after(le_prev, &(vma->list_link));

	mm->map_count ++;
}

int do_pgfault(struct mm_struct *mm, u32 error_code, uintptr_t addr) {
	int ret = -E_INVAL;
	//try to find a vma which include addr
	struct vma_struct *vma = find_vma(mm, addr);

	pgfault_num++;
	//If the addr is in the range of a mm's vma?
	if (vma == NULL || vma->vm_start > addr) {
		uerror("not valid addr %x, and  can not find it in vma\n", addr);
		goto failed;
	}
	//check the error_code
	switch (error_code & 3) {
		default:
			/* error code flag : default is 3 ( W/R=1, P=1): write, present */
		case 2: /* error code flag : (W/R=1, P=0): write, not present */
			if (!(vma->vm_flags & VM_WRITE)) {
				uerror("do_pgfault failed: error code flag = write AND not present, but the addr's vma cannot write\n");
				goto failed;
			}
			break;
		case 1: /* error code flag : (W/R=0, P=1): read, present */
			uerror("do_pgfault failed: error code flag = read AND present\n");
			goto failed;
		case 0: /* error code flag : (W/R=0, P=0): read, not present */
			if (!(vma->vm_flags & (VM_READ | VM_EXEC))) {
				uerror("do_pgfault failed: error code flag = read AND not present, but the addr's vma cannot read or exec\n");
				goto failed;
			}
	}
	/* IF (write an existed addr ) OR
	 *    (write an non_existed addr && addr is writable) OR
	 *    (read  an non_existed addr && addr is readable)
	 * THEN
	 *    continue process
	 */
	u32 perm = PTE_U;
	if (vma->vm_flags & VM_WRITE) {
		perm |= PTE_W;
	}
	addr = ROUNDDOWN(addr, PGSIZE);

	ret = -E_NO_MEM;

	pte_t *ptep=NULL;
	// try to find a pte, if pte's PT(Page Table) isn't existed, then create a PT.
	// (notice the 3th parameter '1')
	if ((ptep = get_pte(mm->pgdir, addr, 1)) == NULL) {
		uinfo("get_pte in do_pgfault failed\n");
		goto failed;
	}

	if (*ptep == 0) { // if the phy addr isn't exist, then alloc a page & map the phy addr with logical addr
		//if (pgdir_alloc_page(mm->pgdir, addr, perm) == NULL) {
		//	uinfo("pgdir_alloc_page in do_pgfault failed\n");
		//	goto failed;
		//}
	} else {
		struct page_frame *page=NULL;
		uinfo("do pgfault: ptep %x, pte %x\n",ptep, *ptep);
		if (*ptep & PTE_P) {
			panic("error write a non-writable pte");
		} else{
			// if this pte is a swap entry, then load data from disk to a page with phy addr
			// and call page_insert to map the phy addr with logical addr
			if(swap_init_ok) {
				//if ((ret = swap_in(mm, addr, &page)) != 0) {
				//	uerror("swap_in in do_pgfault failed\n");
				//	goto failed;
				//}
			} else {
				uerror("no swap_init_ok but ptep is %x, failed\n",*ptep);
				goto failed;
			}
		}
		page_insert(mm->pgdir, page, addr, perm);
		//swap_map_swappable(mm, addr, page, 1);
		page->pra_vaddr = addr;
	}
	ret = 0;
failed:
	return ret;
}

