#ifndef  __BITMAP_H__
#define  __BITMAP_H__

struct bitmap {
	uint32_t nbits;
	uint32_t nwords;
	WORD_TYPE *map;
};

extern struct bitmap *bitmap_create(uint32_t nbits);                     // allocate a new bitmap object.
extern int bitmap_alloc(struct bitmap *bitmap, uint32_t *index_store);   // locate a cleared bit, set it, and return its index.
extern bool bitmap_test(struct bitmap *bitmap, uint32_t index);          // return whether a particular bit is set or not.
extern void bitmap_free(struct bitmap *bitmap, uint32_t index);          // according index, set related bit to 1
extern void bitmap_destroy(struct bitmap *bitmap);                       // free memory contains bitmap
extern void *bitmap_getdata(struct bitmap *bitmap, size_t *len_store);   // return pointer to raw bit data (for I/O)

#endif  /* __BITMAP_H__ */
