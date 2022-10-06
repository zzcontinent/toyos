#ifndef __KERN_DEBUG_KDEBUG_H__
#define __KERN_DEBUG_KDEBUG_H__

#include <libs/stdio.h>
#include <kern/trap/trap.h>
#include <libs/defs.h>

static union { char c[4]; unsigned long l; } endian_test = { { 'l', '?', '?', 'b' } };
#define ENDIANNESS ((char)endian_test.l)
#define L2B32(little)  (((little&0xff)<<24) | ((little&0xff00)<<8) | ((little&0xff0000)>>8) | ((little&0xff000000)>>24))



void print_kerninfo(void);
void print_stackframe(void);

#endif /* __KERN_DEBUG_KDEBUG_H__ */
