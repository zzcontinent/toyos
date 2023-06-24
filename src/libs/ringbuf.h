#ifndef  __RINGBUF_H__
#define  __RINGBUF_H__
#include <libs/defs.h>
#include <libs/types.h>

struct ringbuf {
	volatile u8* buf;
	volatile int len;
	volatile int used;
	volatile int rpos;
	volatile int wpos;
};

#define rb_used(rb)           ((rb)->used)
#define rb_free(rb)           ((rb)->len - (rb)->used)
#define rb_pos_next(rb, pos)  ((pos+1) % (rb)->len)

int rb_init(struct ringbuf *rb, u8* buf, int len);
int rb_read(struct ringbuf *rb, u8 *rdata, int len);
int rb_write(struct ringbuf *rb, u8* wbuf, int len);
int rb_dup(struct ringbuf *rb, u8 *rdata, int len);
int test_rb();

#endif  /* __RINGBUF_H__ */
