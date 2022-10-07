#ifndef  __KCOMMAND_H__
#define  __KCOMMAND_H__
#include <kern/trap/trap.h>
#include <kern/mm/pmm.h>

void kcmd_loop();
int cmd_help(int argc, char **argv);
int cmd_kerninfo(int argc, char **argv);
int cmd_backtrace(int argc, char **argv);
int cmd_exit(int argc, char **argv);
int cmd_jump(int argc, char **argv);
int cmd_mem(int argc, char **argv);
int cmd_print_pg(int argc, char **argv);

#define KCMD_LOOP { \
	uinfo(""); \
	kcmd_loop(); \
}

#endif  /* __KCOMMAND_H__ */
