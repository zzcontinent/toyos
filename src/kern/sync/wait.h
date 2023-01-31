#ifndef  __WAIT_H__
#define  __WAIT_H__

#include <libs/list.h>
typedef struct {
	list_entry_t wait_head;
} wait_queue_t;

#include <kern/process/proc.h>
typedef struct {
	struct proc_struct *proc;
	u32 wakeup_flags;
	wait_queue_t *wait_queue;
	list_entry_t wait_link;
} wait_t;

#define le2wait(le, member)         \
	to_struct((le), wait_t, member)

extern void wait_init(wait_t *wait, struct proc_struct *proc);
extern void wait_queue_init(wait_queue_t *queue);
extern void wait_queue_add(wait_queue_t *queue, wait_t *wait);
extern void wait_queue_del(wait_queue_t *queue, wait_t *wait);

extern wait_t *wait_queue_next(wait_queue_t *queue, wait_t *wait);
extern wait_t *wait_queue_prev(wait_queue_t *queue, wait_t *wait);
extern wait_t *wait_queue_first(wait_queue_t *queue);
extern wait_t *wait_queue_last(wait_queue_t *queue);

extern bool wait_queue_empty(wait_queue_t *queue);
extern bool wait_in_queue(wait_t *wait);
extern void wakeup_wait(wait_queue_t *queue, wait_t *wait, u32 wakeup_flags, bool del);
extern void wakeup_first(wait_queue_t *queue, u32 wakeup_flags, bool del);
extern void wakeup_queue(wait_queue_t *queue, u32 wakeup_flags, bool del);

extern void wait_current_set(wait_queue_t *queue, wait_t *wait, u32 wait_state);

#define wait_current_del(queue, wait)                                       \
	do {                                                                \
		if (wait_in_queue(wait)) {                                  \
			wait_queue_del(queue, wait);                        \
		}                                                           \
	} while (0)

#endif  /* __WAIT_H__ */
