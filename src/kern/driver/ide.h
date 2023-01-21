#ifndef  __IDE_H__
#define  __IDE_H__

#include <libs/defs.h>

void ide_init(void);
bool ide_device_valid(u16 ideno);
size_t ide_device_size(u16 ideno);

int ide_read_secs(u16 ideno, uint32_t secno, void *dst, size_t nsecs, size_t sectsize);
int ide_write_secs(u16 ideno, uint32_t secno, const void *src, size_t nsecs, size_t sectsize);


#endif  /* __IDE_H__ */
