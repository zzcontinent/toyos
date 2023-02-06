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
		_i;\
		})
// ============================================================wait if

// ============================================================log
#define LEVEL_DEBUG  0
#define LEVEL_INFO   1
#define LEVEL_ERROR  2
#define LEVEL_OFF    3
#define LEVEL_SIMPLE 4
//#define ULOG_LEVEL LEVEL_SIMPLE
//#define ULOG_LEVEL LEVEL_DEBUG
#define ULOG_LEVEL LEVEL_INFO
//#define ULOG_LEVEL LEVEL_ERROR
//#define ULOG_LEVEL LEVEL_SIMPLE
//#define ULOG_LEVEL LEVEL_OFF


extern int cprintf(const char* fmt, ...);
#define printf cprintf

#if ULOG_LEVEL == LEVEL_OFF
#define udebug(fmt, args...)
#define uinfo(fmt, args...)
#define uerror(fmt, args...)
#define uclean(fmt, args...)
#define ulog(fmt, args...)
#elif ULOG_LEVEL == LEVEL_DEBUG
#define udebug(fmt, args...) printf("[D][%s:%d][%s] " fmt, __FILE__, __LINE__, __FUNCTION__, ##args)
#define uinfo(fmt, args...) printf("[I][%s:%d][%s] " fmt, __FILE__, __LINE__, __FUNCTION__, ##args)
#define uerror(fmt, args...) printf("[E][%s:%d][%s] " fmt, __FILE__, __LINE__, __FUNCTION__, ##args)
#define uclean printf
#define ulog uinfo
#elif ULOG_LEVEL == LEVEL_INFO
#define udebug(fmt, args...)
#define uinfo(fmt, args...) printf("[I][%s:%d][%s] " fmt, __FILE__, __LINE__, __FUNCTION__, ##args)
#define uerror(fmt, args...) printf("[E][%s:%d][%s] " fmt, __FILE__, __LINE__, __FUNCTION__, ##args)
#define uclean printf
#define ulog uinfo
#elif ULOG_LEVEL == LEVEL_ERROR
#define udebug(fmt, args...)
#define uinfo(fmt, args...)
#define uerror(fmt, args...) printf("[E][%s:%d][%s] " fmt, __FILE__, __LINE__, __FUNCTION__, ##args)
#define uclean printf
#define ulog uinfo
#elif ULOG_LEVEL == LEVEL_SIMPLE
#define udebug(fmt, args...) printf("[D][%d][%s] " fmt, __LINE__, __FUNCTION__, ##args)
#define uinfo(fmt, args...) printf("[I][%d][%s] " fmt, __LINE__, __FUNCTION__, ##args)
#define uerror(fmt, args...) printf("[E][%s:%d][%s] " fmt, __FILE__, __LINE__, __FUNCTION__, ##args)
#define uclean printf
#define ulog uinfo
#else
#define udebug printf
#define uinfo printf
#define uerror printf
#define uclean printf
#define ulog printf
#endif

#endif  /* __LOG_H__ */
