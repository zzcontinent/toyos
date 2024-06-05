#ifndef  __TRAP_H__
#define  __TRAP_H__

#include <libs/defs.h>
#include <libs/types.h>
#include <libs/log.h>
#include <libs/x86.h>
#include <kern/debug/kdebug.h>

/* Trap Numbers */
/* Processor-defined: */
#define T_DIVIDE                0   // divide error
#define T_DEBUG                 1   // debug exception
#define T_NMI                   2   // non-maskable interrupt
#define T_BRKPT                 3   // breakpoint
#define T_OFLOW                 4   // overflow
#define T_BOUND                 5   // bounds check
#define T_ILLOP                 6   // illegal opcode
#define T_DEVICE                7   // device not available
#define T_DBLFLT                8   // double fault
				    // #define T_COPROC             9   // reserved (not used since 486)
#define T_TSS                   10  // invalid task switch segment
#define T_SEGNP                 11  // segment not present
#define T_STACK                 12  // stack exception
#define T_GPFLT                 13  // general protection fault
#define T_PGFLT                 14  // page fault
				    // #define T_RES                15  // reserved
#define T_FPERR                 16  // floating point error
#define T_ALIGN                 17  // aligment check
#define T_MCHK                  18  // machine check
#define T_SIMDERR               19  // SIMD floating point error


/* registers as pushed by pushal */
struct pushregs {
	u32 reg_edi;
	u32 reg_esi;
	u32 reg_ebp;
	u32 reg_oesp;          /* Useless */
	u32 reg_ebx;
	u32 reg_edx;
	u32 reg_ecx;
	u32 reg_eax;
};

struct trapframe {
	struct pushregs tf_regs;
	u16 tf_gs;
	u16 tf_padding0;
	u16 tf_fs;
	u16 tf_padding1;
	u16 tf_es;
	u16 tf_padding2;
	u16 tf_ds;
	u16 tf_padding3;
	u32 tf_trapno;
	/* below here defined by x86 hardware */
	u32 tf_err;
	uintptr_t tf_eip;
	u16 tf_cs;
	u16 tf_padding4;
	u32 tf_eflags;
	/* below here only when crossing rings, such as from user to kernel */
	uintptr_t tf_esp;
	u16 tf_ss;
	u16 tf_padding5;
} __attribute__((packed));

/* error_code:
 * bit 0 == 0 means no page found, 1 means protection fault
 * bit 1 == 0 means read, 1 means write
 * bit 2 == 0 means kernel, 1 means user
 * */
#define PF_P   1   //bit0, 0: the fault was caused by a not-present page, 1: by a page-level protection violation
#define PF_W   2   //bit1, 0: the access causing the fault was a read, 1: was a write
#define PF_U   4   //bit2, 0: the access causing the fault originated when the processor was executing in supervisor mode, 1: in user mode

#define PF_P0   "is a not-present page"
#define PF_P1   "is a page-level protection violation"
#define PF_RW0  "is a read"
#define PF_RW1  "is a write"
#define PF_SU0  "runing in supervisor mode"
#define PF_SU1  "runing in user mode"

#define PRINT_PGFAULT_ERR(err) do { \
	uerror("page fault reasons:\r\n"               \
			"1. address at 0x%x, "         \
			"2. code is %d, "              \
			"3. %s, "                      \
			"4. %s, "                      \
			"5. %s\r\n",                   \
			rcr2(),                        \
			(err),                         \
			(err & PF_U) ? PF_SU1 : PF_SU0,\
			(err & PF_W) ? PF_RW1 : PF_RW0,\
			(err & PF_P) ? PF_P1 : PF_P0); \
} while(0)

#define PRINT_TRAPFRAME(tf) do {\
	uerror("");print_trapframe(tf);\
}while(0)

extern void idt_init(void);
extern void print_trapframe(struct trapframe *tf);
extern void print_regs(struct trapframe *tf);
extern bool trap_in_kernel(struct trapframe *tf);
extern void print_backtrace(u32 t_ebp, u32 t_eip);

#define WARN_ON(cond) do { if (cond) {uerror("\r\n"); print_backtrace(read_ebp(), read_eip());} } while(0)

#endif  /* __TRAP_H__ */
