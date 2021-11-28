#include <defs.h>
#include <stdio.h>
#include <string.h>
#include <console.h>
#include <kdebug.h>
#include <picirq.h>
#include <trap.h>
#include <clock.h>
#include <intr.h>
#include <pmm.h>
#include <vmm.h>
#include <ide.h>
#include <swap.h>
#include <proc.h>
#include <fs.h>

int kern_init(void) __attribute__((noreturn));

static void lab1_switch_test(void);

void t1()
{
	print_stackframe();
}
void t2()
{
	t1();
}
void t3()
{
	t2();
}
void t4()
{
	t2();
}

int
kern_init(void) {
	extern char edata[], end[];
	memset(edata, 0, end - edata);
	cons_init();
	const char *message = "(THU.CST) os is loading ...";
	cprintf("%s\n", message);
	cprintf("bootstack:0x%x, bootstacktop:0x%x\n", bootstack, bootstacktop);
	cprintf("edata:0x%x, end:0x%x\n", edata, end);

	print_kerninfo();
	print_stackframe();

	grade_backtrace();

	pmm_init();                 // init physical memory management

	pic_init();                 // init interrupt controller
	idt_init();                 // init interrupt descriptor table

	vmm_init();                 // init virtual memory management
	sched_init();               // init scheduler
	proc_init();                // init process table

	ide_init();                 // init ide devices
	swap_init();                // init swap
	fs_init();                  // init fs

	clock_init();               // init clock interrupt
	intr_enable();              // enable irq interrupt

	//LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
	// user/kernel mode switch test
	//lab1_switch_test();

	cpu_idle();                 // run idle process
}

void __attribute__((noinline))
	grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
		mon_backtrace(0, NULL, NULL);
	}

void __attribute__((noinline))
	grade_backtrace1(int arg0, int arg1) {
		grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
	}

void __attribute__((noinline))
	grade_backtrace0(int arg0, int arg1, int arg2) {
		grade_backtrace1(arg0, arg2);
	}

void
grade_backtrace(void) {
	grade_backtrace0(0, (int)kern_init, 0xffff0000);
}

static void
lab1_print_cur_status(void) {
	static int round = 0;
	uint16_t reg1, reg2, reg3, reg4;
	asm volatile (
			"mov %%cs, %0;"
			"mov %%ds, %1;"
			"mov %%es, %2;"
			"mov %%ss, %3;"
			: "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
	cprintf("%d: @ring %d\n", round, reg1 & 3);
	cprintf("%d:  cs = %x\n", round, reg1);
	cprintf("%d:  ds = %x\n", round, reg2);
	cprintf("%d:  es = %x\n", round, reg3);
	cprintf("%d:  ss = %x\n", round, reg4);
	round ++;
}

static void
lab1_switch_to_user(void) {
	//LAB1 CHALLENGE 1 : TODO
}

static void
lab1_switch_to_kernel(void) {
	//LAB1 CHALLENGE 1 :  TODO
}

static void
lab1_switch_test(void) {
	lab1_print_cur_status();
	cprintf("+++ switch to  user  mode +++\n");
	lab1_switch_to_user();
	lab1_print_cur_status();
	cprintf("+++ switch to kernel mode +++\n");
	lab1_switch_to_kernel();
	lab1_print_cur_status();
}

