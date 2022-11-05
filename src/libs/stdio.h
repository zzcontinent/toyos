#ifndef __LIBS_STDIIO_H__
#define __LIBS_STDIIO_H__

#include <libs/defs.h>
#include <libs/stdarg.h>

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
#define wait_if(expr, cnt, desc) ({\
		udebug("wait:%d, desc:%s", cnt, desc); \
		int _i = 0; \
		for (;_i < cnt; _i++) { if (!(expr)) break; if (0 == _i%100) uclean(".");} \
		if (_i == cnt) uerror("==>[%d/%d] [timeout]\n", _i, cnt); \
		else uclean("==>[%d/%d]\n", _i, cnt); \
		_i;\
		})
// ============================================================wait if

// ============================================================log
#define LEVEL_DEBUG  0
#define LEVEL_INFO   1
#define LEVEL_ERROR  2
#define LEVEL_OFF    3
#define LEVEL_SIMPLE 4
#define ULOG_LEVEL LEVEL_DEBUG
//#define ULOG_LEVEL LEVEL_OFF

#define printf cprintf

#if ULOG_LEVEL == LEVEL_OFF
#define udebug(fmt, args...)
#define uinfo(fmt, args...)
#define uerror(fmt, args...)
#define uclean(fmt, args...)
#define ulog(fmt, args...)
#elif ULOG_LEVEL == LEVEL_DEBUG
#define udebug(fmt, args...) printf("[D][%s:%d][%s] " fmt, __FILE__, __LINE__, __FUNCTION__, ##args)
#define uinfo(fmt, args...) printf("[I][%d][%s] " fmt, __LINE__, __FUNCTION__, ##args)
#define uerror(fmt, args...) printf("[E][%d][%s] " fmt, __LINE__, __FUNCTION__, ##args)
#define uclean printf
#define ulog uinfo
#elif ULOG_LEVEL == LEVEL_INFO
#define udebug(fmt, args...)
#define uinfo(fmt, args...) printf("[I][%d][%s] " fmt, __LINE__, __FUNCTION__, ##args)
#define uerror(fmt, args...) printf("[E][%d][%s] " fmt, __LINE__, __FUNCTION__, ##args)
#define uclean printf
#define ulog uinfo
#elif ULOG_LEVEL == LEVEL_ERROR
#define udebug(fmt, args...)
#define uinfo(fmt, args...)
#define uerror(fmt, args...) printf("[E][%d][%s] " fmt, __LINE__, __FUNCTION__, ##args)
#define uclean printf
#define ulog uinfo
#elif ULOG_LEVEL == LEVEL_SIMPLE
#define udebug(fmt, args...) printf("[D][%d] " fmt, __LINE__, ##args)
#define uinfo(fmt, args...) printf("[I][%d] " fmt, __LINE__, ##args)
#define uerror(fmt, args...) printf("[E][%d] " fmt, __LINE__, ##args)
#define uclean printf
#define ulog uinfo
#else
#define udebug printf
#define uinfo printf
#define uerror printf
#define uclean printf
#define ulog printf
#endif

#endif
