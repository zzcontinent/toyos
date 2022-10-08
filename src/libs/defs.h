#ifndef  __DEFS_H__
#define  __DEFS_H__

#ifndef NULL
#define NULL ((void*)0)
#endif

#define __always_inline __attribute__((always_inline))
#define __noinline __attribute__((__noinline))
#define __noreturn __attribute__((noreturn))

#define CHAR_BIT 8
typedef int bool;
typedef char i8;
typedef unsigned char u8;
typedef short i16;
typedef unsigned short u16;
typedef int i32;
typedef unsigned int u32;
typedef long long i64;
typedef unsigned long long u64;

/*
 * Pointers and addresses are 32-bit long.
 * Use pointer types to represent addresses,
 * uintptr_t to represent the numerical values of addresses.
 * */
typedef i32 intptr_t;
typedef u32 uintptr_t;

/*size_t is used for memory object size*/
typedef uintptr_t size_t;

/* off_t is used for file offset and lengths */
typedef intptr_t off_t;

/* used fo rpage numbers */
typedef size_t ppn_t;

/*round up + round down + round up div*/
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
	size_t __n = (size_t n);            \
	(typeof(a))(((a) + __n - 1) / __n); \
	})

/*
 * Get the struct pointer from a member pointer and member type
 * */
#define offsetof(type, member) \
	((size_t)(&((type*)0)->member))

#define to_struct(ptr, type, member) \
	((type*)((char*)(ptr)-offsetof(type, member)))

#endif  /* __DEFS_H__ */
