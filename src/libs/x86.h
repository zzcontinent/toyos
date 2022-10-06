#ifndef __LIBS_X86_H__
#define __LIBS_X86_H__

#include <libs/defs.h>

struct pseudodesc {
	u16 pd_lim;   // limit
	uintptr_t pd_base; // base address
} __attribute__((packed));

#define barrier() __asm__ __volatile__("" :: \
		: "memory")

#define do_div(n, base) ({                               \
		unsigned long __upper, __low, __high, __mod, __base; \
		__base = (base);                                     \
		asm(""                                               \
				: "=a"(__low), "=d"(__high)                      \
				: "A"(n));                                       \
				__upper = __high;                                    \
				if (__high != 0) {                                   \
				__upper = __high % __base;                       \
				__high = __high / __base;                        \
				}                                                    \
				asm("divl %2"                                        \
						: "=a"(__low), "=d"(__mod)                       \
						: "rm"(__base), "0"(__low), "1"(__upper));       \
						asm(""                                               \
								: "=A"(n)                                        \
								: "a"(__low), "d"(__high));                      \
								__mod;                                               \
								})

static inline void* __memset(void* s, char c, size_t n) __always_inline;
static inline void* __memmove(void* dst, const void* src, size_t n) __always_inline;
static inline void* __memcpy(void* dst, const void* src, size_t n) __always_inline;
static inline u32 read_ebp(void) __always_inline;


static inline u8 inb(u16 port)
{
	u8 data;
	asm volatile("inb %1, %0"
			: "=a"(data)
			: "d"(port)
			: "memory");
	return data;
}

static inline u16 inw(u16 port)
{
	u16 data;
	asm volatile("inw %1, %0"
			: "=a"(data)
			: "d"(port));
	return data;
}

static inline void insl(u32 port, void* addr, int cnt)
{
	asm volatile("cld;"
			"repne; insl;"
			: "=D"(addr), "=c"(cnt)
			: "d"(port), "0"(addr), "1"(cnt)
			: "memory", "cc");
}

static inline void outb(i16 port, u8 data)
{
	asm volatile("outb %0, %1" ::"a" (data), "d" (port)
			: "memory");
}

static inline void outw(i16 port, u16 data)
{
	asm volatile("outw %0, %1" ::"a"(data), "d"(port)
			: "memory");
}

static inline void outsl(u32 port, const void* addr, int cnt)
{
	asm volatile(
			"cld;"
			"repne; outsl;"
			: "=S"(addr), "=c"(cnt)
			: "d"(port), "0"(addr), "1"(cnt)
			: "memory", "cc");
}

static inline u32 read_esp(void)
{
	u32 esp;
	asm volatile("movl %%esp, %0" : "=r" (esp));
	return esp;
}
static inline u32 read_ebp(void)
{
	u32 ebp;
	asm volatile("movl %%ebp, %0" : "=r" (ebp));
	return ebp;
}

static inline u32 read_dr(unsigned regnum)
{
	u32 value = 0;
	switch (regnum) {
		case 0:
			asm volatile("movl %%db0, %0"
					: "=r"(value));
			break;
		case 1:
			asm volatile("movl %%db1, %0"
					: "=r"(value));
			break;
		case 2:
			asm volatile("movl %%db2, %0"
					: "=r"(value));
			break;
		case 3:
			asm volatile("movl %%db3, %0"
					: "=r"(value));
			break;
		case 6:
			asm volatile("movl %%db6, %0"
					: "=r"(value));
			break;
		case 7:
			asm volatile("movl %%db7, %0"
					: "=r"(value));
			break;
	}
	return value;
}

static inline void write_dr(unsigned regnum, u32 value)
{
	switch (regnum) {
		case 0:
			asm volatile("movl %0, %%db0" ::"r"(value));
			break;
		case 1:
			asm volatile("movl %0, %%db1" ::"r"(value));
			break;
		case 2:
			asm volatile("movl %0, %%db2" ::"r"(value));
			break;
		case 3:
			asm volatile("movl %0, %%db3" ::"r"(value));
			break;
		case 6:
			asm volatile("movl %0, %%db6" ::"r"(value));
			break;
		case 7:
			asm volatile("movl %0, %%db7" ::"r"(value));
			break;
	}
}

static inline void breakpoint(void)
{
	asm volatile("int $3");
}

static inline void lidt(struct pseudodesc* pd)
{
	asm volatile("lidt (%0)" ::"r"(pd)
			: "memory");
}

static inline void sti(void)
{
	asm volatile("sti");
}

static inline void cli(void)
{
	asm volatile("cli" ::
			: "memory");
}

static inline void ltr(u16 sel)
{
	asm volatile("ltr %0" ::"r"(sel)
			: "memory");
}

static inline u32 read_eflags(void)
{
	u32 eflags;
	asm volatile("pushfl; popl %0"
			: "=r"(eflags));
	return eflags;
}

static inline void write_eflags(u32 eflags)
{
	asm volatile("pushl %0; popfl" ::"r"(eflags));
}

static inline void lcr0(uintptr_t cr0)
{
	asm volatile("mov %0, %%cr0" ::"r"(cr0)
			: "memory");
}

static inline void lcr3(uintptr_t cr3)
{
	asm volatile("mov %0, %%cr3" ::"r"(cr3)
			: "memory");
}

static inline uintptr_t rcr0(void)
{
	uintptr_t cr0;
	asm volatile("mov %%cr0, %0"
			: "=r"(cr0)::"memory");
	return cr0;
}

static inline uintptr_t rcr1(void)
{
	uintptr_t cr1;
	asm volatile("mov %%cr1, %0"
			: "=r"(cr1)::"memory");
	return cr1;
}

static inline uintptr_t rcr2(void)
{
	uintptr_t cr2;
	asm volatile("mov %%cr2, %0"
			: "=r"(cr2)::"memory");
	return cr2;
}

static inline uintptr_t rcr3(void)
{
	uintptr_t cr3;
	asm volatile("mov %%cr3, %0"
			: "=r"(cr3)::"memory");
	return cr3;
}

static inline void invlpg(void* addr)
{
	asm volatile("invlpg (%0)" ::"r"(addr)
			: "memory");
}

#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int __strcmp(const char* s1, const char* s2)
{
	int d0, d1, ret;
	asm volatile(
			"1: lodsb;"
			"scasb;"
			"jne 2f;"
			"testb %%al, %%al;"
			"jne 1b;"
			"xorl %%eax, %%eax;"
			"jmp 3f;"
			"2: sbbl %%eax, %%eax;"
			"orb $1, %%al;"
			"3:"
			: "=a"(ret), "=&S"(d0), "=&D"(d1)
			: "1"(s1), "2"(s2)
			: "memory");
	return ret;
}
#endif /*__HAVE_ARCH_STRCMP*/

#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char* __strcpy(char* dst, const char* src)
{
	int d0, d1, d2;
	asm volatile("1: lodsb;"
			"stosb;"
			"testb %%al, %%al;"
			"jne 1b;"
			: "=&S"(d0), "=&D"(d1), "=&a"(d2)
			: "0"(src), "1"(dst)
			: "memory");
	return dst;
}
#endif /*__HAVE_ARCH_STRCPY*/

#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void* __memset(void* s, char c, size_t n)
{
	int d0, d1;
	asm volatile("rep; stosb;"
			: "=&c"(d0), "=&D"(d1)
			: "0"(n), "a"(c), "1"(s)
			: "memory");
	return s;
}
#endif /*__HAVE_ARCH_MEMSET*/


#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void* __memcpy(void* dst, const void* src, size_t n)
{
	int d0, d1, d2;
	asm volatile(
			"rep; movsl;"
			"movl %4, %%ecx;"
			"movl %3, %%ecx;"
			"jz 1f;"
			"rep; movsb;"
			"1:"
			: "=&c"(d0), "=&S"(d1), "=&D"(d2)
			: "0"(n / 4), "g"(n), "1"(dst), "2"(src)
			: "memory");
	return dst;
}
#endif /*__HAVE_ARCH_MEMCPY*/


#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void* __memmove(void* dst, const void* src, size_t n)
{
	if (dst < src) {
		return __memcpy(dst, src, n);
	}
	int d0, d1, d2;
	asm volatile("std;"
			"rep; movsb;"
			"cld;"
			: "=&c"(d0), "=&S"(d1), "=&D"(d2)
			: "0"(n), "1"(n - 1 + src), "2"(n - 1 + dst)
			: "memory");
	return dst;
}
#endif /*__HAVE_ARCH_MEMMOVE*/

#endif /*__LIBS_X86_H__*/
