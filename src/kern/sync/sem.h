#ifndef  __SEM_H__
#define  __SEM_H__

#include <libs/defs.h>
#include <libs/atomic.h>
#include <kern/sync/wait.h>

typedef struct {
    int value;
    wait_queue_t wait_queue;
} semaphore_t;

void sem_init(semaphore_t *sem, int value);
void up(semaphore_t *sem);
void down(semaphore_t *sem);
bool try_down(semaphore_t *sem);

#endif  /* __SEM_H__ */
