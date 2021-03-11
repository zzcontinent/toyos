#include <defs.h>
#include <error.h>
#include <stdarg.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>

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
static long long getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
	{
		return va_arg(*ap, long long);
	}else if(lflag){
		return va_arg(*ap, long);
	}else{
		return va_arg(*ap, int);
	}
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

void printfmt(void (*putch)(int, void*, int), int fd, void* putdat, const char* *fmt,...)
{
	va_list ap;
	va_start(ap,fmt);
	vprintfmt(putch, fd, putdat, fmt, ap);
	va_end(ap);
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
			case 's':
				if ((p = va_arg(ap, char*)) == NULL){
					p = "(null)";
				}
				if (width > 0 && padc != '-')
				{
					for (width -= strnlen(p, precision);width > 0 ; width --)
					{
						putch(padc, putdat, fd);
					}
				}
				for (;(ch = *p++) != '\0' && (precision <0 || --precision >=0);width--)
				{
					if (altflag && (ch < ' ' || ch > '~'))
					{
						putch('?', putdat, fd);
					}else{
						putch(ch, putdat, fd);
					}
				}
				for (;width > 0; width --)
				{
					putch(' ', putdat, fd);
				}
				break;
			case 'd':
				num = getuint(&ap, lflag);
				if ((long long)num < 0)
				{
					putch('-', putdat, fd);
					num = -(long long)num;
				}
				base = 10;
				goto number;
			case 'u':
				num = getuint(&ap, lflag);
				base = 10;
				goto number;
			case 'o':
				num = getuint(&ap, lflag);
				base = 8;
				goto number;
			case 'p':
				putch('0', putdat, fd);
				putch('x', putdat, fd);
				num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
				base = 16;
				goto number;
			case 'x':
				num = getuint(&ap, lflag);
				base =16;
number:
				printnum(putch, fd, putdat, num, base, width, padc);
				break;
			case '%':
				putch(ch, putdat, fd);
				break;
			default:
				putch('%', putdat, fd);
				for (fmt --; fmt[-1] != '%'; fmt--)
					;
				break;
		}
	}
}



struct sprintbuf{
	char*buf;
	char* ebuf;
	int cnt;
};

static void snprintputch(int ch, struct sprintbuf* b)
{
	b->cnt ++;
	if (b->buf < b->ebuf)
	{
		*b->buf ++ = ch;
	}
}


int snprintf(char* str, size_t size, const char* fmt,...)
{
	va_list ap;
	int cnt;
	va_start(ap, fmt);
	cnt = vsnprintf(str, size, fmt, ap);
	va_end(ap);
	return cnt;
}

int vsnprintf(char* str, size_t size, const char* fmt, va_list ap)
{
	struct sprintbuf b = {str, str+size -1, 0};
	if (str ==NULL || b.buf > b.ebuf)
	{
		return -E_INVAL;
	}
	vprintfmt((void*) snprintputch, NO_FD, &b, fmt, ap);
	*b.buf = '\0';
	return b.cnt;
}





