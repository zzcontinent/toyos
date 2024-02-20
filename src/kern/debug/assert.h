#ifndef  __ASSERT_H__
#define  __ASSERT_H__
#include <libs/defs.h>
#include <kern/trap/trap.h>

void __warn(const char* file, int line, const char* fmt, ...);
void __noreturn __panic(const char* file, int line, const char* fmt, ...);

#define warn(...) __warn(__FILE__, __LINE__, __VA_ARGS__)

#define panic(...) do {uclean("\r\n\r\n===>   PANIC  <===\r\n\r\n");WARN_ON(1); __panic(__FILE__, __LINE__, __VA_ARGS__);} while(0)

#define assert(x)                                            \
	do {                                                 \
		if (!(x)) {                                  \
			panic("assertion failed!: %s", #x);  \
		}                                            \
	} while (0)

#define static_assert(x) \
	switch (x) {         \
		case 0:              \
		case (x):;           \
	}

#endif  /* __ASSERT_H__ */
