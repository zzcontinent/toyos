#ifndef  __SYSCALL_H__
#define  __SYSCALL_H__
#include <libs/types.h>

extern void syscall(void);

struct iovec { void *iov_base; size_t iov_len; };

#endif  /* __SYSCALL_H__ */
