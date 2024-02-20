/* ********************************************************************************
 * FILE NAME   : log.h
 * PROGRAMMER  : zhaozz
 * DESCRIPTION : ???
 * DATE        : 2022-11-13 01:26:30
 * *******************************************************************************/
#ifndef  __LOG_H__
#define  __LOG_H__
#include <libs/defs.h>

#define wait_if(expr, cnt, desc) ({\
		udebug("wait:%d, desc:%s", cnt, desc); \
		int _i = 0; \
		for (;_i < cnt; _i++) { if (!(expr)) break; if (0 == _i%100) uclean(".");} \
		if (_i == cnt) uerror("==>[%d/%d] [timeout]\n", _i, cnt); \
		else uclean("==>[%d/%d]\n", _i, cnt); \
		(_i == cnt && cnt > 0);\
		})
// ============================================================wait if

// ============================================================log
#define LEVEL_DEBUG  0x1
#define LEVEL_INFO   0x2
#define LEVEL_ERROR  0x4
#define LEVEL_TEST   0x8
#define LEVEL_OFF    0x10
//#define ULOG_LEVEL LEVEL_DEBUG
//#define ULOG_LEVEL LEVEL_INFO
//#define ULOG_LEVEL LEVEL_ERROR
//#define ULOG_LEVEL LEVEL_TEST
//#define ULOG_LEVEL LEVEL_OFF

#define ULOG_LEVEL (LEVEL_INFO | LEVEL_TEST)


extern int cprintf(const char* fmt, ...);
#define printf cprintf

#if ULOG_LEVEL & LEVEL_OFF
#define udebug(fmt, args...)
#define uinfo(fmt, args...)
#define uerror(fmt, args...)
#define uclean(fmt, args...)
#define uonly(fmt, args...)
#endif

#if ULOG_LEVEL & LEVEL_DEBUG
#define udebug(fmt, args...) printf("[D][%s:%d][%s] " fmt, __FILE__, __LINE__, __FUNCTION__, ##args)
#define uinfo(fmt, args...) printf("[I][%s:%d][%s] " fmt,  __FILE__, __LINE__, __FUNCTION__, ##args)
#define uerror(fmt, args...) printf("[E][%s:%d][%s] " fmt, __FILE__, __LINE__, __FUNCTION__, ##args)
#endif

#if ULOG_LEVEL & LEVEL_INFO
#define uinfo(fmt, args...) printf("[I][%s:%d][%s] " fmt, __FILE__, __LINE__, __FUNCTION__, ##args)
#define uerror(fmt, args...) printf("[E][%s:%d][%s] " fmt, __FILE__, __LINE__, __FUNCTION__, ##args)
#endif

#if ULOG_LEVEL & LEVEL_ERROR
#define uerror(fmt, args...) printf("[E][%s:%d][%s] " fmt, __FILE__, __LINE__, __FUNCTION__, ##args)
#endif

#if ULOG_LEVEL & LEVEL_TEST
#define utest(fmt, args...) printf("[O][%s:%d][%s] " fmt, __FILE__, __LINE__, __FUNCTION__, ##args)
#endif

#ifndef udebug
#define udebug(fmt, args...)
#endif
#ifndef uinfo
#define uinfo(fmt, args...)
#endif
#ifndef uerror
#define uerror(fmt, args...)
#endif
#ifndef uclean
#define uclean printf
#endif
#ifndef utest
#define utest(fmt, args...)
#endif

#endif  /* __LOG_H__ */
