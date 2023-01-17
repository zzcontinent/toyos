#include <libs/stdio.h>
#include <libs/defs.h>
#include <libs/string.h>
#include <kern/mm/mmu.h>
#include <kern/mm/default_pmm.h>
#include <kern/trap/trap.h>
#include <kern/debug/kcommand.h>
#include <kern/debug/kdebug.h>

bool is_kernel_panic(void);

#define COMMAND_MAX    200
#define MAXARGS         16
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
static int cmd_cur_index = 0;

static struct command commands[COMMAND_MAX] = {
	{"help", "print this list of commands", 1, cmd_help},
	{"kinfo", "print kernel information", 1, cmd_kerninfo},
	{"bt", "print backtrace of stack frame", 1, cmd_backtrace},
	{"exit", "exit console", 1, cmd_exit},
	{"jump", "jump addr", 2, cmd_jump},
	{"call", "call addr", 2, cmd_call},
	{"mem", "print memory", 1, cmd_mem},
	{"page", "print page table", 1, cmd_print_pg},
	{"printfree", "printfree (pages)", 1, cmd_print_free_pages},
	{"alloc", "alloc (one page)", 1, cmd_alloc_page},
	{"free", "free page", 2, cmd_free_page},
	{"hi", "hi [index](print history or run history of index)", -1, cmd_history},
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
	cprintf("type 'help' for a list of commands\n");
	char *buf;
	static int index = 0;
	char promt_buf[64] = {0};
	while (1) {
		snprintf(promt_buf, 64, "[sh:%d]$ ", ++index);
		if ((buf = readline(promt_buf, 1)) != NULL) {
			//append history
			append_cmd_history(buf);

			enum CMD_RETURN_CODE ret_code = runcmd(buf);
			if (ret_code == CMD_EXIT)
			{
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
	print_stackframe();
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

int cmd_print_free_pages(int argc, char **argv)
{
	print_free_pages();
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
	u32 addr = str2n(argv[1]);
	free_page((struct page*)addr);
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

	if (cmd_cur_index >= CMD_HISTORY_MAX)
		cmd_cur_index = 0;
	strcpy(cmd_history_buf[cmd_cur_index], cmd);
	++cmd_cur_index;
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
		return  runcmd(get_cmd_history(index));
	} else {
		return CMD_NOT_SUPPORT;
	}
}

