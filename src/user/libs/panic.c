#include <libs/defs.h>
#include <libs/string.h>
#include <libs/stat.h>
#include <libs/dirent.h>
#include <libs/error.h>
#include <libs/unistd.h>
#include <libs/stdarg.h>
#include <user/libs/file.h>
#include <user/libs/dir.h>
#include <user/libs/syscall.h>

void __panic(const char *file, int line, const char *fmt, ...)
{
	// print the 'message'
	va_list ap;
	va_start(ap, fmt);
	cprintf("user panic at %s:%d:\n    ", file, line);
	vcprintf(fmt, ap);
	cprintf("\n");
	va_end(ap);
	exit(-E_PANIC);
}

void __warn(const char *file, int line, const char *fmt, ...)
{
	va_list ap;
	va_start(ap, fmt);
	cprintf("user warning at %s:%d:\n    ", file, line);
	vcprintf(fmt, ap);
	cprintf("\n");
	va_end(ap);
}

