#ifndef  __KCOMMAND_H__
#define  __KCOMMAND_H__
#include <kern/trap/trap.h>
#include <kern/mm/pmm.h>
#include <kern/driver/console.h>

extern void kcmd_loop();
extern int cmd_help(int argc, char **argv);
extern int cmd_kerninfo(int argc, char **argv);
extern int cmd_backtrace(int argc, char **argv);
extern int cmd_exit(int argc, char **argv);
extern int cmd_jump(int argc, char **argv);
extern int cmd_mem(int argc, char **argv);
extern int cmd_print_pg(int argc, char **argv);
extern int cmd_print_free_pages(int argc, char **argv);
extern int cmd_call(int argc, char **argv);
extern int cmd_alloc_page(int argc, char **argv);
extern int cmd_free_page(int argc, char **argv);
extern int cmd_history(int argc, char **argv);
extern void append_cmd_history(char* cmd);
extern int cmd_format_print1(int argc, char **argv);
extern int cmd_format_print4(int argc, char **argv);
extern int cmd_format_print2(int argc, char **argv);
extern int cmd_print_dev_list(int argc, char **argv);
extern int cmd_kernel_execv(int argc, char **argv);
extern int cmd_sfs_ls(int argc, char **argv);
extern int cmd_sfs_read(int argc, char **argv);
extern int cmd_sfs_write(int argc, char **argv);
extern void lib_format_print4(uintptr_t src, int len, int line_break);

#define DEBUG_CONSOLE { \
	set_cons_type(CONS_TYPE_SERIAL_POLL); \
	uinfo(""); \
	kcmd_loop(); \
	set_cons_type(CONS_TYPE_SERIAL_ISR_DEV_STDIN); \
}

#endif  /* __KCOMMAND_H__ */
