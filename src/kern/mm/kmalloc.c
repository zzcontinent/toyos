#include <libs/libs_all.h>
#include <kern/mm/memlayout.h>
#include <kern/debug/assert.h>
#include <kern/mm/kmalloc.h>
#include <kern/sync/sync.h>
#include <kern/mm/pmm.h>

/*
 * SLOB Allocator: Simple List Of Blocks
 *
 * Matt Mackall <mpm@selenic.com> 12/30/03
 *
 * How SLOB works:
 *
 * The core of SLOB is a traditional K&R style heap allocator, with
 * support for returning aligned objects. The granularity of this
 * allocator is 8 bytes on x86, though it's perhaps possible to reduce
 * this to 4 if it's deemed worth the effort. The slob heap is a
 * singly-linked list of pages from __get_free_page, grown on demand
 * and allocation from the heap is currently first-fit.
 *
 * Above this is an implementation of kmalloc/kfree. Blocks returned
 * from kmalloc are 8-byte aligned and prepended with a 8-byte header.
 * If kmalloc is asked for objects of PAGE_SIZE or larger, it calls
 * __get_free_pages directly so that it can return page-aligned blocks
 * and keeps a linked list of such pages and their orders. These
 * objects are detected in kfree() by their page alignment.
 *
 * SLAB is emulated on top of SLOB by simply calling constructors and
 * destructors for every SLAB allocation. Objects are returned with
 * the 8-byte alignment unless the SLAB_MUST_HWCACHE_ALIGN flag is
 * set, in which case the low-level allocator will fragment blocks to
 * create the proper alignment. Again, objects of page-size or greater
 * are allocated by calling __get_free_pages. As SLAB objects know
 * their size, no separate size bookkeeping is necessary and there is
 * essentially no allocation space overhead.
 */


//some helper
#define spin_lock_irqsave(l, f) local_intr_save(f)
#define spin_unlock_irqrestore(l, f) local_intr_restore(f)
typedef unsigned int gfp_t;
#ifndef PAGE_SIZE
#define PAGE_SIZE PGSIZE
#endif

#ifndef L1_CACHE_BYTES
#define L1_CACHE_BYTES 64
#endif

#ifndef ALIGN
#define ALIGN(addr,size)   (((addr)+(size)-1)&(~((size)-1)))
#endif


struct slob_block {
	int units;
	struct slob_block *next;
};

#define SLOB_UNIT sizeof(struct slob_block)
#define SLOB_UNITS(size) (((size) + SLOB_UNIT - 1)/SLOB_UNIT)
#define SLOB_ALIGN L1_CACHE_BYTES

struct bigblock {
	int order;
	void *pages;
	struct bigblock *next;
};

static struct slob_block arena = { .next = &arena, .units = 1 };
static struct slob_block *slobfree = &arena;
static struct bigblock *bigblocks;


static void* __slob_get_free_pages(int order)
{
	struct page * page = alloc_pages(1 << order);
	if(!page)
		return NULL;
	return page2kva(page);
}

#define __slob_get_free_page() __slob_get_free_pages(0)

static inline void __slob_free_pages(unsigned long kva, int order)
{
	free_pages(kva2page((void *)kva), 1 << order);
}

static void slob_free(void *b, int size);

static void *slob_alloc(size_t size, int align)
{
	assert( (size + SLOB_UNIT) < PAGE_SIZE );

	struct slob_block *prev, *cur, *aligned = 0;
	int delta = 0, units = SLOB_UNITS(size);
	unsigned long flags;

	spin_lock_irqsave(&slob_lock, flags);
	prev = slobfree;
	for (cur = prev->next; ; prev = cur, cur = cur->next) {
		if (align) {
			aligned = (struct slob_block *)ALIGN((unsigned long)cur, align);
			delta = aligned - cur;
		}
		if (cur->units >= units + delta) { /* room enough? */
			if (delta) { /* need to fragment head to align? */
				aligned->units = cur->units - delta;
				aligned->next = cur->next;
				cur->next = aligned;
				cur->units = delta;
				prev = cur;
				cur = aligned;
			}

			if (cur->units == units) /* exact fit? */
				prev->next = cur->next; /* unlink */
			else { /* fragment */
				prev->next = cur + units;
				prev->next->units = cur->units - units;
				prev->next->next = cur->next;
				cur->units = units;
			}

			slobfree = prev;
			spin_unlock_irqrestore(&slob_lock, flags);
			return cur;
		}
		if (cur == slobfree) {
			spin_unlock_irqrestore(&slob_lock, flags);

			if (size == PAGE_SIZE) /* trying to shrink arena? */
				return 0;

			cur = (struct slob_block *)__slob_get_free_page();
			if (!cur)
				return 0;

			slob_free(cur, PAGE_SIZE);
			spin_lock_irqsave(&slob_lock, flags);
			cur = slobfree;
		}
	}
}

static void slob_free(void *block, int size)
{
	struct slob_block *cur, *b = (struct slob_block *)block;
	unsigned long flags;

	if (!block)
		return;

	if (size)
		b->units = SLOB_UNITS(size);

	/* Find reinsertion point */
	spin_lock_irqsave(&slob_lock, flags);
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
		if (cur >= cur->next && (b > cur || b < cur->next))
			break;

	if (b + b->units == cur->next) {
		b->units += cur->next->units;
		b->next = cur->next->next;
	} else
		b->next = cur->next;

	if (cur + cur->units == b) {
		cur->units += b->units;
		cur->next = b->next;
	} else
		cur->next = b;

	slobfree = cur;

	spin_unlock_irqrestore(&slob_lock, flags);
}

void check_slab(void)
{
	cprintf("check_slab() success\n");
}

void slab_init(void)
{
	cprintf("use SLOB allocator\n");
	check_slab();
}

inline void kmalloc_init(void)
{
	slab_init();
	cprintf("kmalloc_init() succeeded!\n");
}

static int find_order(int size)
{
	int order = 0;
	for ( ; size > 4096 ; size >>=1)
		order++;
	return order;
}

void* kmalloc(size_t size)
{
	struct slob_block *m;
	struct bigblock *bb;
	unsigned long flags;

	if (size < PAGE_SIZE - SLOB_UNIT) {
		m = slob_alloc(size + SLOB_UNIT, 0);
		return m ? (void *)(m + 1) : 0;
	}

	bb = slob_alloc(sizeof(struct bigblock), 0);
	if (!bb)
		return 0;

	bb->order = find_order(size);
	bb->pages = (void *)__slob_get_free_pages(bb->order);

	if (bb->pages) {
		spin_lock_irqsave(&block_lock, flags);
		bb->next = bigblocks;
		bigblocks = bb;
		spin_unlock_irqrestore(&block_lock, flags);
		return bb->pages;
	}

	slob_free(bb, sizeof(struct bigblock));
	return 0;
}


void kfree(void *block)
{
	struct bigblock *bb, **last = &bigblocks;
	unsigned long flags;

	if (!block)
		return;

	if (!((unsigned long)block & (PAGE_SIZE-1))) {
		/* might be on the big block list */
		spin_lock_irqsave(&block_lock, flags);
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next) {
			if (bb->pages == block) {
				*last = bb->next;
				spin_unlock_irqrestore(&block_lock, flags);
				__slob_free_pages((unsigned long)block, bb->order);
				slob_free(bb, sizeof(struct bigblock));
				return;
			}
		}
		spin_unlock_irqrestore(&block_lock, flags);
	}

	slob_free((struct slob_block *)block - 1, 0);
	return;
}


unsigned int ksize(const void *block)
{
	struct bigblock *bb;
	unsigned long flags;

	if (!block)
		return 0;

	if (!((unsigned long)block & (PAGE_SIZE-1))) {
		spin_lock_irqsave(&block_lock, flags);
		for (bb = bigblocks; bb; bb = bb->next)
			if (bb->pages == block) {
				spin_unlock_irqrestore(&slob_lock, flags);
				return PAGE_SIZE << bb->order;
			}
		spin_unlock_irqrestore(&block_lock, flags);
	}

	return ((struct slob_block *)block - 1)->units * SLOB_UNIT;
}

