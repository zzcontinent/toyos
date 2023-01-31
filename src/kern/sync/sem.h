#ifndef  __SEM_H__
#define  __SEM_H__

#include <libs/defs.h>
#include <kern/sync/wait.h>
typedef struct {
	int value;
	wait_queue_t wait_queue;
} semaphore_t;

#include <libs/atomic.h>


extern void sem_init(semaphore_t *sem, int value);
extern void up(semaphore_t *sem);
extern void down(semaphore_t *sem);
extern bool try_down(semaphore_t *sem);

#endif  /* __SEM_H__ */
