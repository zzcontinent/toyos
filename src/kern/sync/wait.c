/* ********************************************************************************
 * FILE NAME   : wait.c
 * PROGRAMMER  : zhaozz
 * DESCRIPTION : wait
 * DATE        : 2022-11-12 12:29:24
 * *******************************************************************************/
#include <libs/defs.h>
#include <libs/list.h>
#include <kern/debug/assert.h>
#include <kern/sync/sync.h>
#include <kern/sync/wait.h>
#include <kern/process/proc.h>
#include <kern/schedule/sched.h>

void wait_init(wait_t *wait, struct proc_struct *proc)
{
	wait->proc = proc;
	wait->wakeup_flags = WT_INTERRUPTED;
	list_init(&(wait->wait_link));
}

void wait_queue_init(wait_queue_t *queue)
{
	list_init(&(queue->wait_head));
}

void wait_queue_add(wait_queue_t *queue, wait_t *wait)
{
	assert(list_empty(&(wait->wait_link)) && wait->proc != NULL);
	wait->wait_queue = queue;
	list_add_before(&(queue->wait_head), &(wait->wait_link));
}

void wait_queue_del(wait_queue_t *queue, wait_t *wait)
{
	assert(!list_empty(&(wait->wait_link)) && wait->wait_queue == queue);
	list_del_init(&(wait->wait_link));
}

wait_t* wait_queue_next(wait_queue_t *queue, wait_t *wait)
{
	assert(!list_empty(&(wait->wait_link)) && wait->wait_queue == queue);
	list_entry_t *le = list_next(&(wait->wait_link));
	if (le != &(queue->wait_head)) {
		return le2wait(le, wait_link);
	}
	return NULL;
}

wait_t* wait_queue_prev(wait_queue_t *queue, wait_t *wait)
{
	assert(!list_empty(&(wait->wait_link)) && wait->wait_queue == queue);
	list_entry_t *le = list_prev(&(wait->wait_link));
	if (le != &(queue->wait_head)) {
		return le2wait(le, wait_link);
	}
	return NULL;
}

wait_t* wait_queue_first(wait_queue_t *queue)
{
	list_entry_t *le = list_next(&(queue->wait_head));
	if (le != &(queue->wait_head)) {
		return le2wait(le, wait_link);
	}
	return NULL;
}

wait_t* wait_queue_last(wait_queue_t *queue)
{
	list_entry_t *le = list_prev(&(queue->wait_head));
	if (le != &(queue->wait_head)) {
		return le2wait(le, wait_link);
	}
	return NULL;
}

bool wait_queue_empty(wait_queue_t *queue)
{
	return list_empty(&(queue->wait_head));
}

bool wait_in_queue(wait_t *wait)
{
	return !list_empty(&(wait->wait_link));
}

void wakeup_wait(wait_queue_t *queue, wait_t *wait, u32 wakeup_flags, bool del)
{
	if (del) {
		wait_queue_del(queue, wait);
	}
	wait->wakeup_flags = wakeup_flags;
	wakeup_proc(wait->proc);
}

void wakeup_first(wait_queue_t *queue, u32 wakeup_flags, bool del)
{
	wait_t *wait;
	if ((wait = wait_queue_first(queue)) != NULL) {
		wakeup_wait(queue, wait, wakeup_flags, del);
	}
}

void wakeup_queue(wait_queue_t *queue, u32 wakeup_flags, bool del)
{
	wait_t *wait;
	if ((wait = wait_queue_first(queue)) != NULL) {
		if (del) {
			do {
				wakeup_wait(queue, wait, wakeup_flags, 1);
			} while ((wait = wait_queue_first(queue)) != NULL);
		} else {
			do {
				wakeup_wait(queue, wait, wakeup_flags, 0);
			} while ((wait = wait_queue_next(queue, wait)) != NULL);
		}
	}
}

void wait_current_set(wait_queue_t *queue, wait_t *wait, u32 wait_state)
{
	assert(g_current != NULL);
	wait_init(wait, g_current);
	g_current->state = PROC_SLEEPING;
	g_current->wait_state = wait_state;
	wait_queue_add(queue, wait);
}

