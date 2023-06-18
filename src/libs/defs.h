#ifndef  __DEFS_H__
#define  __DEFS_H__

#ifndef NULL
#define NULL ((void*)0)
#endif

#define __always_inline    __attribute__((always_inline))
#define __noinline         __attribute__((__noinline))
#define __noreturn         __attribute__((noreturn))

#define CHAR_BIT 8


#define ROUNDDOWN(a, n)              \
	({                               \
	size_t __a = (size_t)(a);    \
	(typeof(a))(__a - __a % (n)); \
	})

#define ROUNDUP(a, n)                                     \
	({                                                    \
	size_t __n = (size_t)(n);                         \
	(typeof(a))(ROUNDDOWN((size_t)a + __n - 1, __n)); \
	})

#define ROUNDUP_DIV(a, n)                   \
	({                                      \
	size_t __n = (size_t)(n);            \
	(typeof(a))(((a) + __n - 1) / __n); \
	})

#define offsetof(type, member) \
	((size_t)(&((type*)0)->member))

#define to_struct(ptr, type, member) \
	((type*)((char*)(ptr)-offsetof(type, member)))


#endif  /* __DEFS_H__ */
