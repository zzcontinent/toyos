#ifndef  __STDLIB_H__
#define  __STDLIB_H__

#include <libs/defs.h>

/* the largest number rand will return */
#define RAND_MAX    2147483647UL

/* libs/rand.c */
int rand(void);
void srand(unsigned int seed);

/* libs/hash.c */
uint32_t hash32(uint32_t val, unsigned int bits);

#endif  /* __STDLIB_H__ */
