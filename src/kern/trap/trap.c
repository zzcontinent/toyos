#include <libs/libs_all.h>
#include <kern/debug/assert.h>
#include <kern/driver/clock.h>
#include <kern/driver/console.h>
#include <kern/debug/kdebug.h>
#include <kern/mm/memlayout.h>
#include <kern/mm/mmu.h>
#include <kern/process/proc.h>
#include <kern/schedule/sched.h>
#include <kern/mm/swap.h>
#include <kern/sync/sync.h>
#include <kern/syscall/syscall.h>
#include <kern/trap/trap.h>
#include <kern/mm/vmm.h>
#include <kern/fs/devs/dev.h>
#include <kern/debug/kcommand.h>

#define TICK_NUM 100

static const char* IA32flags[] = {
	"CF",
	NULL,
	"PF",
	NULL,
	"AF",
	NULL,
	"ZF",
	"SF",
	"TF",
	"IF",
	"DF",
	"OF",
	NULL,
	NULL,
	"NT",
	NULL,
	"RF",
	"VM",
	"AC",
	"VIF",
	"VIP",
	"ID",
	NULL,
	NULL,
};

static const char* const excnames[] = {
	"Divide error",
	"Debug",
	"Non-Maskable Interrupt",
	"Breakpoint",
	"Overflow",
	"BOUND Range Exceeded",
	"Invalid Opcode",
	"Device Not Available",
	"Double Fault",
	"Coprocessor Segment Overrun",
	"Invalid TSS",
	"Segment Not Present",
	"Stack Fault",
	"General Protection",
	"Page Fault",
	"(unknown trap)",
	"x87 FPU Floating-Point Error",
	"Alignment Check",
	"Machine-Check",
	"SIMD Floating-Point Exception"
};

/* *
 * Interrupt descriptor table:
 *
 * Must be built at run time because shifted function addresses can't
 * be represented in relocation records.
 * */
static struct gatedesc idt[256] = { { 0 } };

static struct pseudodesc idt_pd = {
	sizeof(idt) - 1, (uintptr_t)idt
};

static volatile int in_swap_tick_event = 0;
extern struct mm_struct* g_check_mm_struct;

void print_ticks()
{
	cprintf("%d ticks\n", TICK_NUM);
}

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void idt_init(void)
{
	extern uintptr_t __vectors[];
	int i;
	for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i++)
	{
		SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
	}
	SETGATE(idt[T_SYSCALL], 1, GD_KTEXT, __vectors[T_SYSCALL], DPL_USER);
	lidt(&idt_pd);
}

static const char* trapname(int trapno)
{
	if (trapno < sizeof(excnames) / sizeof(const char* const)) {
		return excnames[trapno];
	}
	if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
		return "Hardware Interrupt";
	}
	return "(unknown trap)";
}

/* trap_in_kernel - test if trap happened in kernel */
bool trap_in_kernel(struct trapframe* tf)
{
	return (tf->tf_cs == (u16)KERNEL_CS);
}

void print_trapframe(struct trapframe* tf)
{
	cprintf("trapframe at %p\n", tf);
	print_regs(tf);
	cprintf("|-ds        0x04x\n", tf->tf_ds);
	cprintf("|-es        0x04x\n", tf->tf_es);
	cprintf("|-fs        0x04x\n", tf->tf_fs);
	cprintf("|-gs        0x04x\n", tf->tf_gs);
	cprintf("|-trap      0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
	cprintf("|-err       0x%08x\n", tf->tf_err);
	cprintf("|-eip       0x%08x\n", tf->tf_eip);
	cprintf("|-cs        0x04x\n", tf->tf_cs);
	cprintf("|-flag      0x%08x ", tf->tf_eflags);

	int i, j;
	for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i++, j <<= 1) {
		if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
			cprintf("%s,", IA32flags[i]);
		}
	}
	cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
	cprintf("|-tf_kernel %d\n", trap_in_kernel(tf));
	cprintf("|-esp       0x%08x\n", tf->tf_esp);
	cprintf("|-ss        0x----%04x\n", tf->tf_ss);
}

void print_regs(struct trapframe* tf)
{
	cprintf("|-edi  0x%08x\n", tf->tf_regs.reg_edi);
	cprintf("|-esi  0x%08x\n", tf->tf_regs.reg_esi);
	cprintf("|-ebp  0x%08x\n", tf->tf_regs.reg_ebp);
	cprintf("|-oesp 0x%08x\n", tf->tf_regs.reg_oesp);
	cprintf("|-ebx  0x%08x\n", tf->tf_regs.reg_ebx);
	cprintf("|-edx  0x%08x\n", tf->tf_regs.reg_edx);
	cprintf("|-ecx  0x%08x\n", tf->tf_regs.reg_ecx);
	cprintf("|-eax  0x%08x\n", tf->tf_regs.reg_eax);
}


int pgfault_handler(struct trapframe* tf)
{
	if (g_check_mm_struct != NULL) { //used for test check_swap
		print_pgfault(tf);
	}
	struct mm_struct* mm = NULL;
	if (g_check_mm_struct != NULL) {
		assert(g_current == g_idleproc);
		mm = g_check_mm_struct;
	} else {
		if (g_current == NULL) {
			print_trapframe(tf);
			print_pgfault(tf);
			panic("unhandled page fault.\n");
		}
		mm = g_current->mm;
	}
	return do_pgfault(mm, tf->tf_err, rcr2());
}


void trap_dispatch(struct trapframe* tf)
{
	int ret = 0;
	switch (tf->tf_trapno) {
		case T_PGFLT: //page fault
			if ((ret = pgfault_handler(tf)) != 0) {
				if (g_current == NULL) {
					panic("handle pgfault failed. ret=%d\n", ret);
				} else {
					if (trap_in_kernel(tf)) {
						panic("handle pgfault failed in kernel mode. ret=%d\n", ret);
					}
					cprintf("killed by kernel.\n");
					cprintf("handle user mode pgfault failed. ret=%d\n", ret);
					do_exit(-E_KILLED);
				}
			}
			break;
		case T_SYSCALL:
			syscall();
			break;
		case IRQ_OFFSET + IRQ_TIMER:
			assert(g_current != NULL);
			g_ticks++;
			run_timer_list();
			break;
		case IRQ_OFFSET + IRQ_COM1:
			//udebug("IRQ_COM1:%d\n", tf->tf_trapno);
			//serial_intr();
			//break;
		case IRQ_OFFSET + IRQ_KBD:
			//udebug("IRQ_KBS:%d\n", tf->tf_trapno);
			//kbd_intr();
			serial_intr();
			break;
		case IRQ_OFFSET + IRQ_IDE1:
		case IRQ_OFFSET + IRQ_IDE2:
			/* do nothing */
			break;
		default:
			print_trapframe(tf);
			if (g_current != NULL) {
				cprintf("unhandled trap.\n");
				do_exit(-E_KILLED);
			}
			// in kernel, it must be a mistake
			panic("unexpected trap in kernel.\n");
	}
}

/* *
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void trap(struct trapframe* tf)
{
	// dispatch based on what type of trap occurred
	// used for previous projects
	if (g_current == NULL) {
		trap_dispatch(tf);
	} else {
		// keep a trapframe chain in stack
		struct trapframe* otf = g_current->tf;
		g_current->tf = tf;

		bool in_kernel = trap_in_kernel(tf);

		trap_dispatch(tf);

		g_current->tf = otf;
		if (!in_kernel) {
			if (g_current->flags & PF_EXITING) {
				do_exit(-E_KILLED);
			}
			if (g_current->need_resched) {
				schedule();
			}
		}
	}
	//udebug("trap exit\n");
}
