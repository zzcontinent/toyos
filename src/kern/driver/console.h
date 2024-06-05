#ifndef  __CONSOLE_H__
#define  __CONSOLE_H__

#define CONS_TYPE_SERIAL_POLL           (1U<<0)
#define CONS_TYPE_SERIAL_ISR_DEV_STDIN  (1U<<1)
#define CONS_TYPE_CGA                   (1U<<2)
#define CONS_TYPE_KEYBOARD_POLL         (1U<<3)
#define CONS_TYPE_KEYBOARD_ISR          (1U<<4)

extern void set_cons_type(u32 type);
extern u32 get_cons_type();

extern void cons_init(u32 type);
extern void cons_putc(int c);
extern int  cons_getc(void);
extern void cons_wait_feed_buf(int (*proc)(void));
extern void cons_isr();

#endif  /* __CONSOLE_H__ */
