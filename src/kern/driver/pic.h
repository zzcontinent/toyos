#ifndef  __PIC_H__
#define  __PIC_H__

#define IRQ_OFFSET 32

extern void pic_init(void);
extern void pic_enable(unsigned int irq);

#endif  /* __PIC_H__ */
