#ifndef __KERN_DRIVER_CONSOLE_H__
#define __KERN_DRIVER_CONSOLE_H__

#define CONS_TYPE_SERIAL_POLL   (1<<0)
#define CONS_TYPE_SERIAL_ISR    (1<<1)
#define CONS_TYPE_CGA           (1<<2)
#define CONS_TYPE_KEYBOARD_POLL (1<<3)
#define CONS_TYPE_KEYBOARD_ISR  (1<<4)

extern void set_cons_type(int type);
extern int get_cons_type();

extern void cons_init();
extern void cons_putc(int c);
extern int  cons_getc(void);
extern void cons_feed_buf(int (*proc)(void));

#endif
