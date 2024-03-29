#include <libs/libs_all.h>
#include <kern/debug/kdebug.h>
#include <kern/debug/kcommand.h>
#include <kern/sync/sync.h>

static bool is_panic = 0;

void __panic(const char* file, int line, const char* fmt, ...)
{
	if (is_panic) {
		goto panic_dead;
	}
	is_panic = 1;

	va_list ap;
	va_start(ap, fmt);
	cprintf("kernel panic at %s:%d:\n", file, line);
	vcprintf(fmt, ap);
	cprintf("\n");
	cprintf("stack trackback:\n");
	print_stackframe();
	va_end(ap);
panic_dead:
	intr_disable();
	while (1) {
		kcmd_loop();
	}
}

void __warn(const char* file, int line, const char* fmt, ...)
{
	va_list ap;
	va_start(ap, fmt);
	cprintf("kernel warning at %s:%d:\n", file, line);
	vcprintf(fmt, ap);
	cprintf("\n");
	va_end(ap);
}

bool is_kernel_panic(void)
{
	return is_panic;
}
