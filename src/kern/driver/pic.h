#ifndef  __PIC_H__
#define  __PIC_H__

#define IRQ_OFFSET 32

#define IRQ_OFFSET              32  // IRQ 0 corresponds to int IRQ_OFFSET
#define IRQ_TIMER               0
#define IRQ_KBD                 1
#define IRQ_COM1                4
#define IRQ_IDE1                14
#define IRQ_IDE2                15
#define IRQ_ERROR               19
#define IRQ_SPURIOUS            31

extern void pic_init(void);
extern void pic_enable(unsigned int irq);

#endif  /* __PIC_H__ */
