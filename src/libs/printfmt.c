#include "stdarg.h"
#include "trap.h"
#include <defs.h>
#include <error.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <x86.h>

static const char* const error_string[MAXERROR + 1] = {
	[0] NULL,
	[E_UNSPECIFIED] "unspecified error",
	[E_BAD_PROC] "bad process",
	[E_INVAL] "invalid parameter",
	[E_NO_MEM] "out of memory",
	[E_NO_FREE_PROC] "out of processes",
	[E_FAULT] "segmentation fault",
	[E_INVAL_ELF] "invalid elf file",
	[E_KILLED] "process is killed",
	[E_PANIC] "panic failure",
	[E_NO_DEV] "no such device",
	[E_NA_DEV] "device not available",
	[E_BUSY] "device/file is busy",
	[E_NOENT] "no such file or directory",
	[E_ISDIR] "is a directory",
	[E_NOTDIR] "not a directory",
	[E_XDEV] "cross device link",
	[E_UNIMP] "unimplemented feature",
	[E_SEEK] "illegal seek",
	[E_MAX_OPEN] "too many files are open",
	[E_EXISTS] "file or directory already exists",
	[E_NOTEMPTY] "directory is not empty",
};

static void printnum((void* putch)(int, void*, int), int fd, void* putdat, unsigned long long num, unsigned base, int width, int padc)
{
	unsigned long long result = num;
	unsigned mod = do_div(result, base);
	if (num > base) {
		printnum(putch, fd, putdat, result, base, width - 1, padc);
	} else {
		while (--width > 0) {
			putch(padc, putdat, fd);
		}
	}
	putch("0123456789abcdef"[mod], putdat, fd);
}

static unsigned long long getuint(va_list* ap, int lflag)
{
	if (lflag >= 2) {
		return va_arg(*ap, unsigned long long);
	} else if (lflag) {
		return va_arg(*ap, unsigned long);
	} else {
		return va_arg(*ap, unsigned int);
	}
}

void vprintfmt(void (*putch)(int, void*, int), int fd, void* putdat, const char* fmt, va_list ap)
{
	register const char* p;
	register int ch, err;
	unsigned long long num;
	int base, width, precision, lflag, altflag;
	while (1) {
		while ((ch = *(unsigned char*)fmt++) != '%') {
			if (ch == '\0') {
				return;
			}
			putch(ch, putdat, fd);
		}

		char padc = ' ';
		width = precision = -1;
		lflag = altflag = 0;
reswitch:
		switch (ch = *(unsigned char*)fmt++) {
			case '-':
				padc = '-';
				goto reswitch;
			case '0':
				padc = '0';
				goto reswitch;
			case '1' ... '9':
				for (precision = 0;; ++fmt) {
					precision = precision * 10 + ch - '0';
					ch = *fmt;
					if (ch < '0' || ch > '9') {
						break;
					}
				}
				goto process_precision;
			case '*':
				precision = va_arg(ap, int);
				goto process_precision;
			case '.':
				if (width < 0)
					width = 0;
				goto reswitch;
			case '#':
				altflag = 1;
				goto reswitch;
process_precision:
				if (width < 0)
					width = precision, precision = -1;
			case 'l':
				lflag++;
				goto reswitch;

			case 'c':
				putch(va_arg(ap, int), putdat, fd);
				break;
			case 'e':
				err = va_arg(ap, int);
				if (err < 0) {
					err = -err;
				}
				if (err > MAXERROR || (p = error_string[err]) == NULL) {
					printfmt(putch, fd, putdat, "error %d", err);
				} else {
					printfmt(putch, fd, putdat, "%s", p);
				}
				break;
		}
	}
}
