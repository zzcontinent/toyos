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

typedef char int8_t;
typedef unsigned char uint8_t;
typedef short int16_t;
typedef unsigned short uint16_t;
typedef int int32_t;
typedef unsigned int uint32_t;
typedef long long int64_t;
typedef unsigned long long uint64_t;

typedef i32 intptr_t;
typedef u32 uintptr_t;

typedef uintptr_t size_t;

typedef intptr_t off_t;

typedef size_t ppn_t;

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

#define offsetof(type, member) \
	((size_t)(&((type*)0)->member))

#define to_struct(ptr, type, member) \
	((type*)((char*)(ptr)-offsetof(type, member)))

#endif  /* __DEFS_H__ */
