/* ********************************************************************************
 * FILE NAME   : ringbuf.c
 * PROGRAMMER  : zhaozz
 * DESCRIPTION : ring buf
 * DATE        : 2023-01-28 22:55:34
 * *******************************************************************************/
#include <libs/ringbuf.h>
#include <libs/log.h>

int rb_init(struct ringbuf *rb, u8* buf, int len)
{
	if (!rb || !buf || len<0)
	{
		return -1;
	}
	rb->buf = buf;
	rb->len = len;
	rb->used = 0;
	rb->rpos = 0;
	rb->wpos = 0;
	return 0;
}

static int rb_write_byte(struct ringbuf *rb, u8 wdata)
{
	if (rb->used >= rb->len)
	{
		return 0;
	}
	rb->buf[rb->wpos] = wdata;
	rb->wpos = (rb->wpos+1)%rb->len;
	++rb->used;
	return 1;
}

int rb_write(struct ringbuf *rb, u8* wbuf, int len)
{
	int ret_w = 0;
	int i = 0;
	for (i=0; i<len; i++)
	{
		if (1 != rb_write_byte(rb, wbuf[i]))
			break;
		++ret_w;
	}
	return ret_w;
}

static int rb_read_byte(struct ringbuf *rb, u8 *rdata)
{
	if (rb->used == 0)
	{
		return 0;
	}
	*rdata = rb->buf[rb->rpos];
	rb->rpos = (rb->rpos + 1)%rb->len;
	--rb->used;
	return 1;
}

int rb_read(struct ringbuf *rb, u8 *rdata, int len)
{
	int ret_r = 0;

	int i = 0;
	u8 r_byte = 0;
	for (i=0; i<len; i++)
	{
		if (1 != rb_read_byte(rb, &r_byte))
			break;
		rdata[i] = r_byte;
		++ret_r;
	}
	return ret_r;
}

int rb_dup(struct ringbuf *rb, u8 *rdata, int len)
{
	int ret_r = 0;

	int i = 0;
	int len_min = rb_used(rb) < len ? rb_used(rb) : len;

	for (i=0; i<len_min; i++)
	{
		rdata[i] = rb->buf[rb->rpos+i];
		++ret_r;
	}
	return ret_r;
}

#if 0
static u8 rb_buf[256];
static u8 buf_w[258] = {[0]=0x12, [255]=0x23, [256]=0x34};
static u8 buf_r[256];

int test_rb()
{
	struct ringbuf rb;
	if (rb_init(&rb, rb_buf, 256)) {
		uerror("rb_init failed\n");
		return -1;
	}
	uclean("rb_buf:0x%x, buf_w:0x%x, buf_r:0x%x\n", rb_buf, buf_w, buf_r);

	if (256 != rb_write(&rb, buf_w, 258)) {
		uerror("rb_write != 256\n");
		return -2;
	}

	if (255 != rb_read(&rb, buf_r, 255)) {
		uerror("rb_read != 255\n");
		return -3;
	}

	if (1 != rb_used(&rb) || 255 != rb_free(&rb)) {
		uerror("rb_used:%d, rb_free:%d\n", rb_used(&rb), rb_free(&rb));
		return -4;
	}

	if (1 != rb_read(&rb, buf_r+255, 1)) {
		uerror("rb_read != 1\n");
		return -5;
	}

	if (0 != rb_used(&rb) || 256 != rb_free(&rb)) {
		uerror("rb_used:%d, rb_free:%d\n", rb_used(&rb), rb_free(&rb));
		return -6;
	}

	int i = 0;
	for (i=0; i<256; i++)
	{
		if (buf_w[i] != buf_r[i])
		{
			uclean("not same! [%d]: 0x%x vs 0x%x\n", i, buf_w[i], buf_r[i]);
		}
	}
	return 0;
}

#endif

