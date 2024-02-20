#ifndef  __KDEBUG_H__
#define  __KDEBUG_H__

#define STACKFRAME_DEPTH 20
void print_kerninfo(void);
u32 read_eip(void);
void delay_cnt(int cnt);
void print_debuginfo(uintptr_t eip);

#endif  /* __KDEBUG_H__ */
