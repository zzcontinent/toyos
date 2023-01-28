/* ********************************************************************************
 * FILE NAME   : iobuf.c
 * PROGRAMMER  : zhaozz
 * DESCRIPTION : io buffer
 * DATE        : 2023-01-28 23:20:35
 * *******************************************************************************/
#include <libs/iobuf.h>
#include <libs/string.h>

struct iobuf* iobuf_init(struct iobuf *iob, void *base, size_t len, off_t offset)
{
	iob->io_base = base;
	iob->io_offset = offset;
	iob->io_len = iob->io_resid = len;
	return iob;
}

/* iobuf_move - move data  (iob->io_base ---> data OR  data --> iob->io.base) in memory
 * @copied_len:  the size of data memcopied
 *
 * iobuf_move may be called repeatedly on the same io to transfer
 * additional data until the available buffer space the io refers to
 * is exhausted.
 */
int iobuf_move(struct iobuf *iob, void *data, size_t len, bool m2b, size_t *copied_len)
{
	size_t alen;
	if ((alen = iob->io_resid) > len) {
		alen = len;
	}
	if (alen > 0) {
		void *src = iob->io_base, *dst = data;
		if (m2b) {
			void *tmp = src;
			src = dst, dst = tmp;
		}
		memmove(dst, src, alen);
		iobuf_skip(iob, alen), len -= alen;
	}
	if (copied_len != NULL) {
		*copied_len = alen;
	}
	return (len == 0) ? 0 : -1;
}

/*
 * iobuf_move_zeros - set io buffer zero
 * @copied_len:  the size of data memcopied
 */
int iobuf_move_zeros(struct iobuf *iob, size_t len, size_t *copied_len)
{
	size_t alen;
	if ((alen = iob->io_resid) > len) {
		alen = len;
	}
	if (alen > 0) {
		memset(iob->io_base, 0, alen);
		iobuf_skip(iob, alen), len -= alen;
	}
	if (copied_len != NULL) {
		*copied_len = alen;
	}
	return (len == 0) ? 0 : -1;
}

/*
 * iobuf_skip - change the current position of io buffer
 */
void iobuf_skip(struct iobuf *iob, size_t n)
{
	if (iob->io_resid < n)
		n = iob->io_resid;

	iob->io_base += n, iob->io_offset += n, iob->io_resid -= n;
}

