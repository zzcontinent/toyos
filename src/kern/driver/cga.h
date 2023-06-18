#ifndef  __CGA_H__
#define  __CGA_H__

#define MONO_BASE       0x3B4
#define MONO_BUF        0xB0000

#define CGA_BASE        0x3D4
#define CGA_BUF         0xB8000
#define CRT_ROWS        25
#define CRT_COLS        80
#define CRT_SIZE        (CRT_ROWS * CRT_COLS)

extern void cga_init(void);
extern void cga_putc(int c);

#endif  /* __CGA_H__ */
