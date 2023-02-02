/* ********************************************************************************
 * FILE NAME   : string.c
 * PROGRAMMER  : zhaozz
 * DESCRIPTION : string operations
 * DATE        : 2022-11-12 11:43:13
 * *******************************************************************************/
#include <libs/string.h>
#include <kern/mm/kmalloc.h>

char* strdup(const char *src)
{
	size_t len = strlen(src);
	char *dst = kmalloc(len + 1);
	if (dst != NULL) {
		memcpy(dst, src, len);
		dst[len] = '\0';
	}
	return dst;
}

char* stradd(const char *src1, const char *src2)
{
	char *ret, *dst;
	size_t len1 = strlen(src1), len2 = strlen(src2);
	if ((ret = dst = kmalloc(len1 + len2 + 1)) != NULL) {
		memcpy(dst, src1, len1), dst += len1;
		memcpy(dst, src2, len2), dst += len2;
		*dst = '\0';
	}
	return ret;
}

