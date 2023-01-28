#ifndef  __RINGBUF_H__
#define  __RINGBUF_H__
#include <libs/defs.h>

struct ringbuf {
	u8 * buf;
	int len;
	int used;
	int rpos;
	int wpos;
};

#define rb_used(rb)  ((rb)->used)
#define rb_free(rb)  ((rb)->len - (rb)->used)

int rb_init(struct ringbuf *rb, u8* buf, int len);
int rb_read(struct ringbuf *rb, u8 *rdata, int len);
int rb_write(struct ringbuf *rb, u8* wbuf, int len);
int test_rb();

#endif  /* __RINGBUF_H__ */
