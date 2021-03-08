#include <string.h>
#include <x86.h>

void* memset(void* s, char c, size_t n)
{
#ifdef __HAVE_ARCH_MEMSET
	return __memset(s, c, n);
#else
	char* p = s;
	while (n-- > 0)
	{
		*p++ = c;
	}
	return s;
#endif
}
