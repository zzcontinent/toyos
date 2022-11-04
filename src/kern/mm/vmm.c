/* ******************************************************************************************
 * FILE NAME   : vmm.c
 * PROGRAMMER  : zhaozz
 * DESCRIPTION : kernel vmm implement
 * DATE        : 2022-01-08 00:38:00
 * *****************************************************************************************/


int do_pgfault(struct mm_struct *mm, uint32_t error_code, uintptr_t addr) {
	int ret = -E_INVAL;
	//try to find a vma which include addr
	struct vma_struct *vma = find_vma(mm, addr);

	pgfault_num++;
	//If the addr is in the range of a mm's vma?
	if (vma == NULL || vma->vm_start > addr) {
		cprintf("not valid addr %x, and  can not find it in vma\n", addr);
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
	uint32_t perm = PTE_U;
	if (vma->vm_flags & VM_WRITE) {
		perm |= PTE_W;
	}
	addr = ROUNDDOWN(addr, PGSIZE);

	ret = -E_NO_MEM;

	pte_t *ptep=NULL;
	// try to find a pte, if pte's PT(Page Table) isn't existed, then create a PT.
	// (notice the 3th parameter '1')
	if ((ptep = get_pte(mm->pgdir, addr, 1)) == NULL) {
		cprintf("get_pte in do_pgfault failed\n");
		goto failed;
	}

	if (*ptep == 0) { // if the phy addr isn't exist, then alloc a page & map the phy addr with logical addr
		if (pgdir_alloc_page(mm->pgdir, addr, perm) == NULL) {
			cprintf("pgdir_alloc_page in do_pgfault failed\n");
			goto failed;
		}
	} else {
		struct Page *page=NULL;
		cprintf("do pgfault: ptep %x, pte %x\n",ptep, *ptep);
		if (*ptep & PTE_P) {
			panic("error write a non-writable pte");
		} else{
			// if this pte is a swap entry, then load data from disk to a page with phy addr
			// and call page_insert to map the phy addr with logical addr
			if(swap_init_ok) {
				if ((ret = swap_in(mm, addr, &page)) != 0) {
					uerror("swap_in in do_pgfault failed\n");
					goto failed;
				}
			} else {
				uerror("no swap_init_ok but ptep is %x, failed\n",*ptep);
				goto failed;
			}
		}
		page_insert(mm->pgdir, page, addr, perm);
		swap_map_swappable(mm, addr, page, 1);
		page->pra_vaddr = addr;
	}
	ret = 0;
failed:
	return ret;
}

