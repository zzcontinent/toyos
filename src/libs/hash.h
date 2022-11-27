#ifndef  __HASH_H__
#define  __HASH_H__

#include <libs/defs.h>
/* 2^31 + 2^29 - 2^25 + 2^22 - 2^19 - 2^16 + 1 */
#define GOLDEN_RATIO_PRIME_32       0x9e370001UL
#define HASH_SHIFT                              10
#define HASH_LIST_SIZE                          (1 << HASH_SHIFT)

#define __hash32(val, bits) ({ \
		(u32)((u32)((u32)val * GOLDEN_RATIO_PRIME_32) >> (32 - bits)); })

#define hash32(val) ({ \
		__hash32(val, HASH_SHIFT); })

#endif  /* __HASH_H__ */
