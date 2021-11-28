/* ********************************************
 * FILE NAME  : udebug.h
 * PROGRAMMER : zhaozz
 * START DATE : 2021-09-01 17:39:59
 * DESCIPTION : standalone udebug
 * *******************************************/

#ifndef  __UDEBUG_H__
#define  __UDEBUG_H__


typedef unsigned char __U8;
typedef unsigned short int __U16;
typedef unsigned int __U32;
typedef unsigned long __U64;

// ============================================================wait if
#define wait_if(expr, cnt, desc) ({\
		udebug("wait max=%d, desc=%s", cnt, desc); \
		int _i = 0; \
		for (;_i < cnt; _i++) { if (!(expr)) break; if (0 == _i%100) uclean(".");} \
		uclean("==> ret=%d\n", _i); \
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
#define udebug(fmt, args...) printf("[DEBUG][%s:%d][%s] " fmt, __FILE__, __LINE__, __FUNCTION__, ##args)
#define uinfo(fmt, args...) printf("[INFO][%s:%d][%s] " fmt, __FILE__, __LINE__, __FUNCTION__, ##args)
#define uerror(fmt, args...) printf("[ERROR][%s:%d][%s] " fmt, __FILE__, __LINE__, __FUNCTION__, ##args)
#define uclean printf
#define ulog uinfo
#elif ULOG_LEVEL == LEVEL_INFO
#define udebug(fmt, args...)
#define uinfo(fmt, args...) printf("[INFO][%s:%d][%s] " fmt, __FILE__, __LINE__, __FUNCTION__, ##args)
#define uerror(fmt, args...) printf("[ERROR][%s:%d][%s] " fmt, __FILE__, __LINE__, __FUNCTION__, ##args)
#define uclean printf
#define ulog uinfo
#elif ULOG_LEVEL == LEVEL_ERROR
#define udebug(fmt, args...)
#define uinfo(fmt, args...)
#define uerror(fmt, args...) printf("[ERROR][%s:%d][%s] " fmt, __FILE__, __LINE__, __FUNCTION__, ##args)
#define uclean printf
#define ulog uinfo
#elif ULOG_LEVEL == LEVEL_SIMPLE
#define udebug(fmt, args...) printf("[DEBUG][%d] " fmt, __LINE__, ##args)
#define uinfo(fmt, args...) printf("[INFO][%d] " fmt, __LINE__, ##args)
#define uerror(fmt, args...) printf("[ERROR][%d] " fmt, __LINE__, ##args)
#define uclean printf
#define ulog uinfo
#else
#define udebug printf
#define uinfo printf
#define uerror printf
#define uclean printf
#define ulog printf
#endif
// ============================================================log
#endif  /* __UDEBUG_H__ */


