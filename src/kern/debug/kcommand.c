#include <libs/stdio.h>
#include <libs/defs.h>
#include <libs/string.h>
#include <kern/mm/mmu.h>
#include <kern/mm/default_pmm.h>
#include <kern/trap/trap.h>
#include <kern/debug/kcommand.h>
#include <kern/debug/kdebug.h>
#include <kern/driver/console.h>
#include <kern/process/proc.h>
#include <libs/ringbuf.h>

bool is_kernel_panic(void);

#define COMMAND_MAX    256
#define MAXARGS         256
#define WHITESPACE      " \t\n\r"
#define CMD_HISTORY_MAX    20
#define CMD_HISTORY_BUF_LEN    256

enum CMD_RETURN_CODE {
	CMD_EXIT = -1,
	CMD_SUCCEED = 0,
	CMD_NOT_SUPPORT,
	CMD_BAD_ARGS,
	CMD_NULL,
};

struct command {
	const char *name;
	const char *desc;
	int argc;  //-1: not check; other: must equal to argc
	int(*func)(int argc, char **argv);
};

static char cmd_history_buf[CMD_HISTORY_MAX][CMD_HISTORY_BUF_LEN] = {0};
static char cmd_history_buf_for_run[CMD_HISTORY_BUF_LEN] = {0};
static int cmd_cur_index = 0;

static struct command commands[COMMAND_MAX] = {
	{"help", "print this list of commands", 1, cmd_help},
	{"kinfo", "print kernel information", 1, cmd_kerninfo},
	{"bt", "print backtrace of stack frame", 1, cmd_backtrace},
	{"exit", "exit console", 1, cmd_exit},
	{"jump", "jump addr", 2, cmd_jump},
	{"call", "call addr", 2, cmd_call},
	{"fp4", "fp(format print 4byte) addr len break", 4, cmd_format_print4},
	{"fp2", "fp(format print 2byte) addr len break", 4, cmd_format_print2},
	{"fp", "fp(format print 1byte) addr len break", 4, cmd_format_print1},
	{"mem", "print memory", 1, cmd_mem},
	{"mmap", "print memory", 1, cmd_mem},
	{"page", "print page table", 1, cmd_print_pg},
	{"alloc", "alloc one page", 1, cmd_alloc_page},
	{"free", "free [page]", -1, cmd_free_page},
	{"devs", "print vfs_dev_list", 1, cmd_print_dev_list},
	{"hi", "hi [index](print history or run history of index)", -1, cmd_history},
	{"kexec", "kexec(kernel execve) name path args...", -1, cmd_kernel_execv},
	{"sfs_ls", "sfs_ls path", -1, cmd_sfs_ls},
	{"sfs_read", "sfs_read file rbuf len", 3, cmd_sfs_read},
	{"sfs_write", "sfs_write file wbuf len", 3, cmd_sfs_write},
	{0, 0, 0, 0},
};

int get_commands_len()
{
	int i=0;
	while(commands[i].name != 0) ++i;
	return i;
}

void append_command(struct command cmdone)
{
	int len = get_commands_len();
	commands[len] = cmdone;
	commands[len+1].name = 0;
	commands[len+1].argc = 0;
	commands[len+1].desc = 0;
	commands[len+1].func = 0;
}

static int parse(char *buf, char **argv)
{
	int argc = 0;
	if (buf == NULL)
		return -1;

	while (1) {
		// find global whitespace
		while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
			*buf ++ = '\0';
		}
		if (*buf == '\0') {
			break;
		}

		// save and scan past next arg
		if (argc == MAXARGS - 1) {
			cprintf("Too many arguments (max %d).\n", MAXARGS);
		}
		argv[argc ++] = buf;
		while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
			buf ++;
		}
	}
	return argc;
}

static int runcmd(char *buf)
{
	char *argv[MAXARGS];
	int argc = parse(buf, argv);
	if (argc <= 0) {
		return CMD_NULL;
	}

	int i;
	for (i = 0; i < get_commands_len(); i ++) {
		if (strcmp(commands[i].name, argv[0]) == 0) {
			if (argc != commands[i].argc && commands[i].argc != -1)
			{
				return CMD_BAD_ARGS;
			}
			return commands[i].func(argc, argv);
		}
	}
	return CMD_NOT_SUPPORT;
}

void kcmd_loop()
{
	char *buf;
	static int index = 0;
	char promt_buf[64] = {0};
	while (1) {
		snprintf(promt_buf, 64, "[sh:%d]$ ", ++index);
		if ((buf = readline(promt_buf, 1)) != NULL) {
			//append history
			append_cmd_history(buf);

			enum CMD_RETURN_CODE ret_code = runcmd(buf);
			if (ret_code == CMD_EXIT) {
				cprintf("exit!\n");
				return;
			} else if (ret_code == CMD_NOT_SUPPORT) {
				cprintf("not support!\n");
			} else if (ret_code == CMD_BAD_ARGS) {
				cprintf("bad args!\n");
			} else {
				continue;
			}
		}
	}
}

/* mon_help - print the information about mon_* functions */
int cmd_help(int argc, char **argv)
{
	int i;
	for (i = 0; i < get_commands_len(); i ++) {
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
	}
	return CMD_SUCCEED;
}

int cmd_kerninfo(int argc, char **argv)
{
	print_kerninfo();
	return CMD_SUCCEED;
}

/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int cmd_backtrace(int argc, char **argv)
{
	WARN_ON(1);
	return CMD_SUCCEED;
}

int cmd_exit(int argc, char **argv)
{
	return CMD_EXIT;
}

int cmd_jump(int argc, char **argv)
{
	cprintf("jump to %s\n", argv[1]);
	u32 addr = str2n(argv[1]);
	asm volatile("jmp *%0\n" ::"r"(addr));
	return CMD_SUCCEED;
}

//{"fp", "fp(format print 1byte) addr len break", 4, cmd_format_print1},
int cmd_format_print1(int argc, char **argv)
{
	u8* addr = (u8*)(u32)str2n(argv[1]);
	int len = str2n(argv[2]);
	int line_break = str2n(argv[3]);
	int i = 0;
	for (i=0; i<len; i++)
	{
		if (i%line_break == 0) {
			uclean("0x%x: ", i);
		}

		uclean("%2x ", addr[i]);
		if (i%line_break == line_break-1) {
			uclean("\n");
		}
	}
	return CMD_SUCCEED;
}

void lib_format_print4(uintptr_t src, int len, int line_break)
{
	int i = 0;
	u32 *addr = (u32*)src;
	uclean("addr:%x, len:%d\n", src, len);
	for (i=0; i<len/4; i++)
	{
		if (i%line_break == 0) {
			uclean("0x%04x: ", i*4);
		}

		uclean("%08x ", addr[i]);
		if (i%line_break == line_break-1) {
			uclean("\n");
		}
	}
}

int cmd_format_print2(int argc, char **argv)
{
	u16* addr = (u16*)(u32)str2n(argv[1]);
	int len = str2n(argv[2]);
	int line_break = str2n(argv[3]);
	int i = 0;
	for (i=0; i<len; i+=2)
	{
		if ((i/2)%line_break == 0) {
			uclean("0x%x: ", i);
		}

		uclean("%4x ", addr[i/2]);
		if ((i/2)%line_break == line_break-1) {
			uclean("\n");
		}
	}
	return CMD_SUCCEED;
}

int cmd_format_print4(int argc, char **argv)
{
	u32* addr = (u32*)(u32)str2n(argv[1]);
	int len = str2n(argv[2]);
	int line_break = str2n(argv[3]);
	int i = 0;
	for (i=0; i<len; i+=4)
	{
		if ((i/4)%line_break == 0) {
			uclean("0x%x: ", i);
		}

		uclean("%8x ", addr[i/4]);
		if ((i/4)%line_break == line_break-1) {
			uclean("\n");
		}
	}
	return CMD_SUCCEED;
}

int cmd_call(int argc, char **argv)
{
	cprintf("call to %s\n", argv[1]);
	u32 addr = str2n(argv[1]);
	asm volatile("call *%0\n" ::"r"(addr));
	return CMD_SUCCEED;
}

int cmd_mem(int argc, char **argv)
{
	print_mem();
	return CMD_SUCCEED;
}

int cmd_print_pg(int argc, char **argv)
{
	print_pg();
	return CMD_SUCCEED;
}

int cmd_alloc_page(int argc, char **argv)
{
	struct page *page = alloc_page();
	uclean("page=0x%x\r\n", page);
	return CMD_SUCCEED;
}

int cmd_free_page(int argc, char **argv)
{
	if (argc == 2)
	{
		u32 addr = str2n(argv[1]);
		free_page((struct page*)addr);
	} else if (argc == 1) {
		print_free_pages();
	}
	return CMD_SUCCEED;
}

int get_cmd_index_relative(int offset)
{
	return ((cmd_cur_index+offset)%CMD_HISTORY_MAX + CMD_HISTORY_MAX)%CMD_HISTORY_MAX;
}

void append_cmd_history(char* cmd)
{
	int i = 0;
	for (i=0; i<CMD_HISTORY_MAX; i++)
	{
		if (0 == strcmp(cmd, cmd_history_buf[i]))
			return;
	}

	strcpy(cmd_history_buf[cmd_cur_index], cmd);
	++cmd_cur_index;
	if (cmd_cur_index >= CMD_HISTORY_MAX)
		cmd_cur_index = 0;
}

void print_cmd_history()
{
	int i = 0;
	while(i < CMD_HISTORY_MAX)
	{
		if (cmd_history_buf[i][0] != 0)
			uclean("%d : %s\r\n", i, cmd_history_buf[i]);
		++i;
	}
}


char *get_cmd_history(int index)
{
	if (index >= 0  && index < CMD_HISTORY_MAX)
		return cmd_history_buf[index];
	else
		return NULL;
}

int cmd_history(int argc, char **argv)
{
	if (argc == 1)
	{
		print_cmd_history();
		return CMD_SUCCEED;
	} else if (argc == 2) {
		int index = str2n(argv[1]);
		strcpy(cmd_history_buf_for_run, get_cmd_history(index));
		return  runcmd(cmd_history_buf_for_run);
	} else {
		return CMD_NOT_SUPPORT;
	}
}

int cmd_kernel_execv(int argc, char **argv)
{
	set_cons_type(CONS_TYPE_SERIAL_ISR_DEV_STDIN);
	const char ** tmp_argv = (const char **)argv;
	kernel_sys_execve(tmp_argv[1], tmp_argv+1);
	return CMD_SUCCEED;
}

int cmd_sfs_ls(int argc, char **argv)
{
	set_cons_type(CONS_TYPE_SERIAL_ISR_DEV_STDIN);
	const char ** tmp_argv = (const char **)argv;
	kernel_sys_execve(tmp_argv[1], tmp_argv+1);
	return CMD_SUCCEED;
}

int cmd_sfs_read(int argc, char **argv)
{
	set_cons_type(CONS_TYPE_SERIAL_ISR_DEV_STDIN);
	const char ** tmp_argv = (const char **)argv;
	kernel_sys_execve(tmp_argv[1], tmp_argv+1);
	return CMD_SUCCEED;
}

int cmd_sfs_write(int argc, char **argv)
{
	set_cons_type(CONS_TYPE_SERIAL_ISR_DEV_STDIN);
	const char ** tmp_argv = (const char **)argv;
	kernel_sys_execve(tmp_argv[1], tmp_argv+1);
	return CMD_SUCCEED;
}

int cmd_print_dev_list(int argc, char **argv)
{
	extern void print_dev_list();
	print_dev_list();
	return CMD_SUCCEED;
}

