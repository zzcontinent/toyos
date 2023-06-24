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

	int rpos = rb->rpos;

	for (i=0; i<len_min; i++)
	{
		rdata[i] = rb->buf[rpos];
		rpos = rb_pos_next(rb, rpos);
		++ret_r;
	}
	uclean("\n[%d]-[%c]\n", len_min, rdata[0]);
	return ret_r;
}

void print_rb(struct ringbuf *rb)
{
	uclean(
			"rb       : 0x%x\n"
			"|- buf   : 0x%x\n"
			"|- len   : %d\n"
			"|- used  : %d\n"
			"|- rpos  : %d\n"
			"`- wpos  : %d\n",
			rb,
			rb->buf,
			rb->len,
			rb->used,
			rb->rpos,
			rb->wpos);
	int used = rb->used;
	u8 rpos = rb->rpos;
	u8 curb;
	while(used--)
	{
		curb = rb->buf[rpos];
		uclean("0x%x(%c)\n", curb, curb);
		rpos = (rpos + 1) % rb->len;
	}
}

