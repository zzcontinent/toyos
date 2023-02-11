#ifndef  __ULIB_H__
#define  __ULIB_H__


#include <defs.h>

void __warn(const char *file, int line, const char *fmt, ...);
void __noreturn __panic(const char *file, int line, const char *fmt, ...);

#define warn(...)                                       \
	__warn(__FILE__, __LINE__, __VA_ARGS__)

#define panic(...)                                      \
	__panic(__FILE__, __LINE__, __VA_ARGS__)

#define assert(x)                                       \
	do {                                                \
		if (!(x)) {                                     \
			panic("assertion failed: %s", #x);          \
		}                                               \
	} while (0)

// static_assert(x) will generate a compile-time error if 'x' is false.
#define static_assert(x)                                \
	switch (x) { case 0: case (x): ; }

extern int fprintf(int fd, const char *fmt, ...);
extern void __noreturn exit(int error_code);
extern int fork(void);
extern int wait(void);
extern int waitpid(int pid, int *store);
extern void yield(void);
extern int kill(int pid);
extern int getpid(void);
extern void print_pgdir(void);
extern int sleep(unsigned int time);
extern unsigned int gettime_msec(void);
extern int __exec(const char *name, const char **argv);

#define __exec0(name, path, ...)                \
	({ const char *argv[] = {path, ##__VA_ARGS__, NULL}; __exec(name, argv); })

#define exec(path, ...)                         __exec0(NULL, path, ##__VA_ARGS__)
#define nexec(name, path, ...)                  __exec0(name, path, ##__VA_ARGS__)

void set_priority(uint32_t priority); //only for lab6

#endif  /* __ULIB_H__ */
