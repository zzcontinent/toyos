#include <libs/libs_all.h>
#include <kern/debug/kdebug.h>
#include <kern/debug/kcommand.h>
#include <kern/driver/console.h>
#include <kern/sync/sync.h>

static bool is_panic = 0;

void __panic(const char* file, int line, const char* fmt, ...)
{
	set_cons_type(CONS_TYPE_SERIAL_POLL);
	if (is_panic) {
		goto panic_dead;
	}
	is_panic = 1;

	va_list ap;
	va_start(ap, fmt);
	vcprintf(fmt, ap);
	va_end(ap);
panic_dead:
	intr_disable();
	while (1) {
		kcmd_loop();
	}
}

bool is_kernel_panic(void)
{
	return is_panic;
}
