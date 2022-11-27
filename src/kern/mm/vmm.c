/* ********************************************************************************
 * FILE NAME   : vmm.c
 * PROGRAMMER  : zhaozz
 * DESCRIPTION : vmm implement
 * DATE        : 2022-11-12 11:37:47
 * *******************************************************************************/
#include <libs/defs.h>
#include <libs/error.h>
#include <libs/stdio.h>
#include <libs/string.h>
#include <kern/mm/pmm.h>
#include <kern/mm/kmalloc.h>
#include <kern/mm/vmm.h>
#include <kern/mm/swap.h>
#include <kern/debug/assert.h>

volatile u32 g_pgfault_num = 0;
struct mm_struct* g_check_mm_struct;

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

		mm->mm_count = 0;
		sem_init(&(mm->mm_sem), 1);
	}
	return mm;
}

void mm_destroy(struct mm_struct *mm)
{
	assert(mm->mm_count == 0);
	list_entry_t *list = &(mm->mmap_list), *le;
	while ((le = list_next(list)) != list) {
		list_del(le);
		kfree(le2vma(le, list_link));
	}
	kfree(mm);
	mm=NULL;
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
		struct vma_struct *vma_cur = le2vma(le, list_link);
		if (vma_cur->vm_start > vma->vm_start)
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

int dup_mmap(struct mm_struct *to, struct mm_struct *from)
{
	assert(to != NULL && from != NULL);
	list_entry_t *list = &(from->mmap_list), *le = list;
	while ((le = list_prev(le)) != list) {
		struct vma_struct *vma, *nvma;
		vma = le2vma(le, list_link);
		nvma = vma_create(vma->vm_start, vma->vm_end, vma->vm_flags);
		if (nvma == NULL) {
			return -E_NO_MEM;
		}

		insert_vma_struct(to, nvma);

		bool share = 0;
		if (copy_range(to->pgdir, from->pgdir, vma->vm_start, vma->vm_end, share) != 0) {
			return -E_NO_MEM;
		}
	}
	return 0;
}

void exit_mmap(struct mm_struct *mm)
{
	assert(mm != NULL && mm->mm_count == 0);
	pde_t *pgdir = mm->pgdir;
	list_entry_t *list = &(mm->mmap_list), *le = list;
	while ((le = list_next(le)) != list) {
		struct vma_struct *vma = le2vma(le, list_link);
		unmap_range(pgdir, vma->vm_start, vma->vm_end);
	}
	while ((le = list_next(le)) != list) {
		struct vma_struct *vma = le2vma(le, list_link);
		exit_range(pgdir, vma->vm_start, vma->vm_end);
	}
}

bool is_user_mem(struct mm_struct *mm, uintptr_t addr, size_t len, bool write) {
	if (mm != NULL) {
		if (!USER_ACCESS(addr, addr + len)) {
			return 0;
		}
		struct vma_struct *vma;
		uintptr_t start = addr, end = addr + len;
		while (start < end) {
			if ((vma = find_vma(mm, start)) == NULL || start < vma->vm_start) {
				return 0;
			}
			if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ))) {
				return 0;
			}
			if (write && (vma->vm_flags & VM_STACK)) {
				if (start < vma->vm_start + PGSIZE) { //check stack start & size
					return 0;
				}
			}
			start = vma->vm_end;
		}
		return 1;
	} else {
		return KERN_ACCESS(addr, addr + len);
	}
}

bool copy_from_user(struct mm_struct *mm, void *dst, const void *src, size_t len, bool writable)
{
	if (!is_user_mem(mm, (uintptr_t)src, len, writable)) {
		return 0;
	}
	memcpy(dst, src, len);
	return 1;
}

bool copy_to_user(struct mm_struct *mm, void *dst, const void *src, size_t len)
{
	if (!is_user_mem(mm, (uintptr_t)dst, len, 1)) {
		return 0;
	}
	memcpy(dst, src, len);
	return 1;
}

bool copy_string(struct mm_struct *mm, char *dst, const char *src, size_t maxn)
{
	size_t alen, part = ROUNDDOWN((uintptr_t)src + PGSIZE, PGSIZE) - (uintptr_t)src;
	while (1) {
		if (part > maxn) {
			part = maxn;
		}
		if (!is_user_mem(mm, (uintptr_t)src, part, 0)) {
			return 0;
		}
		if ((alen = strnlen(src, part)) < part) {
			memcpy(dst, src, alen + 1);
			return 1;
		}
		if (part == maxn) {
			return 0;
		}
		memcpy(dst, src, part);
		dst += part, src += part, maxn -= part;
		part = PGSIZE;
	}
}

int do_pgfault(struct mm_struct *mm, u32 error_code, uintptr_t addr)
{
	int ret = -E_INVAL;
	//try to find a vma which include addr
	struct vma_struct *vma = find_vma(mm, addr);

	g_pgfault_num++;
	//If the addr is in the range of a mm's vma?
	if (vma == NULL || vma->vm_start > addr) {
		uerror("not valid addr 0x%x, and  can not find it in vma 0x%x\n", addr, vma);
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
		if (pgdir_alloc_page(mm->pgdir, addr, perm) == NULL) {
			uerror("pgdir_alloc_page in do_pgfault failed\n");
			goto failed;
		}
	} else {
		struct page *page=NULL;
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

void check_vma_struct(void)
{
	struct mm_struct *mm = mm_create();
	assert(mm != NULL);

	int step1 = 10, step2 = step1 * 10;

	int i;
	for (i = step1; i >= 1; i --)
	{
		struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
		assert(vma != NULL);
		insert_vma_struct(mm, vma);
	}

	for (i = step1 + 1; i <= step2; i ++)
	{
		struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
		assert(vma != NULL);
		insert_vma_struct(mm, vma);
	}

	list_entry_t *le = list_next(&(mm->mmap_list));

	for (i = 1; i <= step2; i ++) {
		assert(le != &(mm->mmap_list));
		struct vma_struct *mmap = le2vma(le, list_link);
		assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
		le = list_next(le);
	}

	for (i = 5; i <= 5 * step2; i +=5) {
		struct vma_struct *vma1 = find_vma(mm, i);
		assert(vma1 != NULL);
		struct vma_struct *vma2 = find_vma(mm, i+1);
		assert(vma2 != NULL);
		struct vma_struct *vma3 = find_vma(mm, i+2);
		assert(vma3 == NULL);
		struct vma_struct *vma4 = find_vma(mm, i+3);
		assert(vma4 == NULL);
		struct vma_struct *vma5 = find_vma(mm, i+4);
		assert(vma5 == NULL);

		assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
		assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
	}

	for (i =4; i>=0; i--) {
		struct vma_struct *vma_below_5= find_vma(mm,i);
		if (vma_below_5 != NULL ) {
			cprintf("vma_below_5: i %x, start %x, end %x\n",i, vma_below_5->vm_start, vma_below_5->vm_end);
		}
		assert(vma_below_5 == NULL);
	}

	mm_destroy(mm);
	cprintf("check_vma_struct() succeeded!\n");
}

void check_pgfault(void)
{
	size_t nr_free_pages_store = nr_free_pages();

	g_check_mm_struct = mm_create();
	assert(g_check_mm_struct != NULL);

	struct mm_struct* mm = g_check_mm_struct;
	pde_t *pgdir = mm->pgdir = boot_pgdir;
	assert(pgdir[0] == 0);

	struct vma_struct *vma = vma_create(0, PTSIZE, VM_WRITE);
	assert(vma != NULL);

	insert_vma_struct(mm, vma);

	uintptr_t addr = 0x100;
	assert(find_vma(mm, addr) == vma);

	int i, sum = 0;
	for (i = 0; i < 100; i ++) {
		*(char *)(addr + i) = i;
		sum += i;
	}
	for (i = 0; i < 100; i ++) {
		sum -= *(char *)(addr + i);
	}
	assert(sum == 0);

	page_remove(pgdir, ROUNDDOWN(addr, PGSIZE));
	free_page(pde2page(pgdir[0]));
	pgdir[0] = 0;

	mm->pgdir = NULL;
	mm_destroy(mm);
	g_check_mm_struct = NULL;

	assert(nr_free_pages_store == nr_free_pages());

	cprintf("check_pgfault() succeeded!\n");
}

bool user_mem_check(struct mm_struct *mm, uintptr_t addr, size_t len, bool write)
{
	if (mm != NULL) {
		if (!USER_ACCESS(addr, addr + len)) {
			return 0;
		}
		struct vma_struct *vma;
		uintptr_t start = addr, end = addr + len;
		while (start < end) {
			if ((vma = find_vma(mm, start)) == NULL || start < vma->vm_start) {
				return 0;
			}
			if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ))) {
				return 0;
			}
			if (write && (vma->vm_flags & VM_STACK)) {
				if (start < vma->vm_start + PGSIZE) { //check stack start & size
					return 0;
				}
			}
			start = vma->vm_end;
		}
		return 1;
	}
	return KERN_ACCESS(addr, addr + len);
}

void vmm_init(void)
{
	check_vma_struct();
	check_pgfault();
	uinfo("vmm_init succeeded.\n");
}

