#ifndef __LIBS_STDIIO_H__
#define __LIBS_STDIIO_H__

#include <libs/defs.h>
#include <libs/stdarg.h>
#include <libs/log.h>

extern int cprintf(const char* fmt, ...);
extern int vcprintf(const char* fmt, va_list ap);
extern void cputchar(int c);
extern int cputs(const char* str);
extern int getchar(void);

extern char* readline(const char* prompt, int need_print);

extern void printfmt(void (*putch)(int, void*, int), int fd, void* putdat, const char* fmt, ...);
extern void vprintfmt(void (*putch)(int, void*, int), int fd, void* putdat, const char* fmt, va_list ap);
extern int snprintf(char* str, size_t size, const char* fmt, ...);
extern int vsnprintf(char* str, size_t size, const char* fmt, va_list ap);

#define ENDIANNESS ({\
		union { char c[4]; unsigned long l; } endian_test = { { 'l', '?', '?', 'b' } }; \
		(char)endian_test.l; \
		})

#define L2B32(little)  (((little&0xff)<<24) | ((little&0xff00)<<8) | ((little&0xff0000)>>8) | ((little&0xff000000)>>24))

// ============================================================wait if

#endif
