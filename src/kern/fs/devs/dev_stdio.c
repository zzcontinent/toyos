#include <libs/defs.h>
#include <libs/stdio.h>
#include <libs/iobuf.h>
#include <libs/unistd.h>
#include <libs/error.h>
#include <kern/sync/wait.h>
#include <kern/sync/sync.h>
#include <kern/process/proc.h>
#include <kern/schedule/sched.h>
#include <kern/fs/devs/dev.h>
#include <kern/fs/vfs/vfs.h>
#include <kern/fs/vfs/inode.h>
#include <kern/debug//assert.h>

#define STDIN_BUFSIZE               4096

static char stdin_buffer[STDIN_BUFSIZE];
static off_t p_rpos = 0, p_wpos = 0;
static wait_queue_t __wait_queue, *wait_queue = &__wait_queue;

void dev_stdin_write(char c)
{
	bool intr_flag;
	if (c != '\0') {
		local_intr_save(intr_flag);
		{
			stdin_buffer[p_wpos % STDIN_BUFSIZE] = c;
			if (p_wpos - p_rpos < STDIN_BUFSIZE) {
				p_wpos ++;
			}
			if (!wait_queue_empty(wait_queue)) {
				wakeup_queue(wait_queue, WT_KBD, 1);
			}
		}
		local_intr_restore(intr_flag);
	}
}

static int dev_stdin_read(char *buf, size_t len)
{
	udebug("buf:0x%x, len:%d\n", buf, len);
	int ret = 0;
	bool intr_flag;
	local_intr_save(intr_flag);
	{
		udebug("\n");
		for (; ret < len; ret ++, p_rpos ++) {
try_again:
			udebug("\n");
			if (p_rpos < p_wpos) {
				udebug("\n");
				*buf ++ = stdin_buffer[p_rpos % STDIN_BUFSIZE];
			} else {
				wait_t __wait, *wait = &__wait;
				wait_current_set(wait_queue, wait, WT_KBD);
				local_intr_restore(intr_flag);

				schedule();

				local_intr_save(intr_flag);
				wait_current_del(wait_queue, wait);
				if (wait->wakeup_flags == WT_KBD) {
					goto try_again;
				}
				break;
			}
		}
	}
	local_intr_restore(intr_flag);
	return ret;
}

static int stdin_open(struct device *dev, uint32_t open_flags)
{
	if (open_flags != O_RDONLY) {
		return -E_INVAL;
	}
	return 0;
}

static int stdin_close(struct device *dev)
{
	return 0;
}

static int stdin_io(struct device *dev, struct iobuf *iob, bool write)
{
	if (!write) {
		int ret;
		if ((ret = dev_stdin_read(iob->io_base, iob->io_resid)) > 0) {
			iob->io_resid -= ret;
		}
		return ret;
	}
	return -E_INVAL;
}

static int stdin_ioctl(struct device *dev, int op, void *data)
{
	return -E_INVAL;
}

static void stdin_device_init(struct device *dev)
{
	dev->d_blocks = 0;
	dev->d_blocksize = 1;
	dev->d_open = stdin_open;
	dev->d_close = stdin_close;
	dev->d_io = stdin_io;
	dev->d_ioctl = stdin_ioctl;

	p_rpos = p_wpos = 0;
	wait_queue_init(wait_queue);
}

void dev_init_stdin(void)
{
	struct inode *node;
	if ((node = dev_create_inode()) == NULL) {
		panic("stdin: dev_create_node.\n");
	}
	stdin_device_init(vop_info(node, device));

	int ret;
	if ((ret = vfs_add_dev("stdin", node, 0)) != 0) {
		panic("stdin: vfs_add_dev: %e.\n", ret);
	}
}

static int stdout_open(struct device *dev, uint32_t open_flags)
{
	if (open_flags != O_WRONLY) {
		return -E_INVAL;
	}
	return 0;
}

static int stdout_close(struct device *dev)
{
	return 0;
}

static int stdout_io(struct device *dev, struct iobuf *iob, bool write)
{
	if (write) {
		char *data = iob->io_base;
		for (; iob->io_resid != 0; iob->io_resid --) {
			cputchar(*data ++);
		}
		return 0;
	}
	return -E_INVAL;
}

static int stdout_ioctl(struct device *dev, int op, void *data)
{
	return -E_INVAL;
}

static void stdout_device_init(struct device *dev)
{
	dev->d_blocks = 0;
	dev->d_blocksize = 1;
	dev->d_open = stdout_open;
	dev->d_close = stdout_close;
	dev->d_io = stdout_io;
	dev->d_ioctl = stdout_ioctl;
}

void dev_init_stdout(void)
{
	struct inode *node;
	if ((node = dev_create_inode()) == NULL) {
		panic("stdout: dev_create_node.\n");
	}
	stdout_device_init(vop_info(node, device));

	int ret;
	if ((ret = vfs_add_dev("stdout", node, 0)) != 0) {
		panic("stdout: vfs_add_dev: %e.\n", ret);
	}
}

