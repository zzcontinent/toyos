#ifndef  __STDLIB_H__
#define  __STDLIB_H__

#include <libs/defs.h>

/* the largest number rand will return */
#define RAND_MAX    2147483647UL

extern int rand(void);
extern void srand(unsigned int seed);

#endif  /* __STDLIB_H__ */
