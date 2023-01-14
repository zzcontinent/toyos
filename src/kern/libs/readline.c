#include <libs/libs_all.h>


#define READLINE_BUFSIZE 256
static char buf[READLINE_BUFSIZE];

char* readline(const char *prompt, int need_print) {
	if (prompt != NULL && need_print) {
		cprintf("%s", prompt);
	}
	int i = 0, c;
	while (1) {
		c = getchar();
		if (c < 0) {
			return NULL;
		} else if (c >= ' ' && i < READLINE_BUFSIZE - 1) {
			if (need_print) cputchar(c);
			buf[i++] = c;
		} else if (c == '\b' && i > 0) {
			if (need_print) cputchar(c);
			i--;
		} else if (c == '\n' || c == '\r') {
			if (need_print) {
				cputchar('\r');
				cputchar('\n');
			}
			buf[i] = '\0';
			return buf;
		}
	}
}


