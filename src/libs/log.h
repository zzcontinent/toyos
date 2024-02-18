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
#define LEVEL_DEBUG  0
#define LEVEL_INFO   1
#define LEVEL_ERROR  2
#define LEVEL_ONLY   3
#define LEVEL_OFF    4
//#define uonly_LEVEL LEVEL_DEBUG
//#define uonly_LEVEL LEVEL_INFO
#define uonly_LEVEL LEVEL_ERROR
//#define uonly_LEVEL LEVEL_ONLY
//#define uonly_LEVEL LEVEL_OFF


extern int cprintf(const char* fmt, ...);
#define printf cprintf

#if uonly_LEVEL == LEVEL_OFF
#define udebug(fmt, args...)
#define uinfo(fmt, args...)
#define uerror(fmt, args...)
#define uclean(fmt, args...)
#define uonly(fmt, args...)
#elif uonly_LEVEL == LEVEL_DEBUG
#define udebug(fmt, args...) printf("[D][%s:%d][%s] " fmt, __FILE__, __LINE__, __FUNCTION__, ##args)
#define uinfo(fmt, args...) printf("[I][%s:%d][%s] " fmt,  __FILE__, __LINE__, __FUNCTION__, ##args)
#define uerror(fmt, args...) printf("[E][%s:%d][%s] " fmt, __FILE__, __LINE__, __FUNCTION__, ##args)
#define uclean printf
#define uonly(fmt, args...)
#elif uonly_LEVEL == LEVEL_INFO
#define udebug(fmt, args...)
#define uinfo(fmt, args...) printf("[I][%s:%d][%s] " fmt, __FILE__, __LINE__, __FUNCTION__, ##args)
#define uerror(fmt, args...) printf("[E][%s;%d][%s] " fmt, __FILE__, __LINE__, __FUNCTION__, ##args)
#define uclean printf
#define uonly(fmt, args...)
#elif uonly_LEVEL == LEVEL_ERROR
#define udebug(fmt, args...)
#define uinfo(fmt, args...)
#define uerror(fmt, args...) printf("[E][%s:%d][%s] " fmt, __FILE__, __LINE__, __FUNCTION__, ##args)
#define uclean printf
#define uonly(fmt, args...)
#elif uonly_LEVEL == LEVEL_ONLY
#define udebug(fmt, args...)
#define uinfo(fmt, args...)
#define uerror(fmt, args...)
#define uclean printf
#define uonly(fmt, args...) printf("[O][%d][%s] " fmt, __LINE__, __FUNCTION__, ##args)

#else
#define udebug printf
#define uinfo printf
#define uerror printf
#define uclean printf
#define uonly printf
#endif

#endif  /* __LOG_H__ */
