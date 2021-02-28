#ifndef __LIBS_X86_H__
#define __LIBS_X86_H__

#include <defs.h>

static inline uint8_t inb(uint16_t port)
{
	uint8_t data;
	asm volatile("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
	return data;
}

static inline uint16_t inw(uint16_t port)
{
	uint16_t data;
	asm volatile ("inw %1, %0" : "=a" (data) : "d" (port));
	return data;
}

static inline void insl(uint32_t port, void* addr, int cnt)
{
	asm volatile ("cld;"
			"repne: insl;"
			: "=D" (addr), "=c" (cnt)
			: "d" (port), "0" (addr), "1" (cnt)
			: "memory", "cc");
}

static inline void outb(int16_t port, uint8_t data)
{
	asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
}

static inline void outw(int16_t port, uint16_t data)
{
	asm volatile ("outw %0, %1" :: "a" (data), "d" (port) : "memory");
}

static inline void outsl(uint32_t port, const void* addr, int cnt)
{
	asm volatile(
			"cld;"
			"repne; outsl;"
			: "=S" (addr), "=c" (cnt)
			: "d" (port), "0" (addr), "1" (cnt)
			: "memory", "cc");
}

static inline void sti(void)
{
	asm volatile ("sti");
}

static inline void cli(void)
{
	asm volatile ("cli" ::: "memory");
}

static inline uint32_t read_eflags(void)
{
	uint32_t eflags;
	asm volatile ("pushfl; popl %0" : "=r" (eflags));
	return eflags;
}

static inline void write_eflags(uint32_t eflags)
{
	asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int __strcmp(const char *s1, const char* s2)
{
	int d0, d1, ret;
	asm volatile (
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
			: "=a" (ret), "=&S" (d0), "=&D" (d1)
			: "1" (s1), "2" (s2)
			: "memory");
	return ret;
}
#endif /*__HAVE_ARCH_STRCMP*/

#endif /*__LIBS_X86_H__*/
