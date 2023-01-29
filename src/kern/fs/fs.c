/* ********************************************************************************
 * FILE NAME   : fs.c
 * PROGRAMMER  : zhaozz
 * DESCRIPTION : filesystem for process
 * DATE        : 2023-01-29 22:28:16
 * *******************************************************************************/
#include <kern/fs/fs.h>
#include <kern/fs/vfs/vfs/h>
#include <kern/fs/devs/devs.h>
#include <kern/fs/sfs/sfs.h>

void fs_init(void)
{
	vfs_init();
	dev_init();
	sfs_init();
}

void fs_cleanup(void)
{
	vfs_cleanup();
}

