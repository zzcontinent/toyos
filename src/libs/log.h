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
#define LEVEL_DEBUG  1
#define LEVEL_TEST   2
#define LEVEL_INFO   4
#define LEVEL_ERROR  8

#ifndef ULOG_LEVEL_MASK
//#define ULOG_LEVEL_MASK (LEVEL_INFO|LEVEL_ERROR)
#define ULOG_LEVEL_MASK (LEVEL_ERROR)
#endif


extern int cprintf(const char* fmt, ...);
#define printf cprintf
#define ulog(level, fmt, args...) do { if (ULOG_LEVEL_MASK & level) {printf("[L%x][%s:%d][%s] " fmt, level, __FILE__, __LINE__, __FUNCTION__, ##args);} } while(0)

#define udebug(fmt, args...)  ulog(LEVEL_DEBUG, fmt, ##args)
#define uinfo(fmt, args...)   ulog(LEVEL_INFO, fmt, ##args)
#define uerror(fmt, args...)  ulog(LEVEL_ERROR, fmt, ##args)
#define uclean(fmt, args...)  printf(fmt, ##args)
#define utest(fmt, args...)   ulog(LEVEL_TEST, fmt, ##args)

#endif  /* __LOG_H__ */
