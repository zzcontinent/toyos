#ifndef __LIBS_DEFS_H__
#define __LIBS_DEFS_H__

#ifndef NULL
#define NULL ((void*)0)
#endif

#define __always_inline inline __attribute__((always_inline))
#define __noinline __attribute__((__noinline))
#define __noreturn __attribute__((noreturn))

#define CHAR_BIT 8
typedef int bool;
typedef char int8_t;
typedef unsigned char uint8_t;
typedef short int16_t;
typedef unsigned short uint16_t;
typedef int int32_t;
typedef unsigned int uint32_t;
typedef long long int64_t;
typedef unsigned long long uint64_t;

/*
 * Pointers and addresses are 32-bit long.
 * Use pointer types to represent addresses,
 * uintptr_t to represent the numerical values of addresses.
 * */
typedef int32_t intptr_t;
typedef uint32_t uintprt_t;

/*size_t is used for memory object size*/
typedef uintprt_t size_t;

/* off_t is used for file offset and lengths */
typedef intptr_t off_t;

/* used fo rpage numbers */
typedef size_t ppn_t;

/*round up + round down + round up div*/
#define ROUNDDOWN(a, n)              \
	({                               \
	size_t __a = (size_t)(a);    \
	(typeof(a))(__a - __a % (n)) \
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

#endif /* !__LIBS_DEFS_H__ */
