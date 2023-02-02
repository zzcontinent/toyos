#include <libs/defs.h>
#include <libs/stdio.h>
#include <libs/string.h>
#include <libs/error.h>
#include <kern/sync/sem.h>
#include <kern/mm/kmalloc.h>
#include <kern/process/proc.h>
#include <kern/debug/kcommand.h>

#include <kern/fs/vfs/vfs.h>
#include <kern/fs/vfs/inode.h>

static semaphore_t bootfs_sem;
static struct inode *bootfs_node = NULL;


// __alloc_fs - allocate memory for fs, and set fs type
struct vfs * __alloc_fs(int type)
{
	struct vfs *fs;
	if ((fs = kmalloc(sizeof(struct vfs))) != NULL) {
		fs->fs_type = type;
	}
	return fs;
}

// vfs_init -  vfs initialize
void vfs_init(void)
{
	sem_init(&bootfs_sem, 1);
	vfs_devlist_init();
}

// lock_bootfs - lock  for bootfs
static void lock_bootfs(void)
{
	down(&bootfs_sem);
}

// ulock_bootfs - ulock for bootfs
static void unlock_bootfs(void)
{
	up(&bootfs_sem);
}

// change_bootfs - set the new fs inode
static void change_bootfs(struct inode *node)
{
	struct inode *old;
	lock_bootfs();
	{
		old = bootfs_node, bootfs_node = node;
	}
	unlock_bootfs();
	if (old != NULL) {
		vop_ref_dec(old);
	}
}

// vfs_set_bootfs - change the dir of file system
int vfs_set_bootfs(char *fsname)
{
	struct inode *node = NULL;
	if (fsname != NULL) {
		char *s;
		if ((s = strchr(fsname, ':')) == NULL || s[1] != '\0') {
			return -E_INVAL;
		}
		int ret;
		if ((ret = vfs_chdir(fsname)) != 0) {
			return ret;
		}
		if ((ret = vfs_get_curdir(&node)) != 0) {
			return ret;
		}
	}
	change_bootfs(node);
	return 0;
}

// vfs_get_bootfs - get the inode of bootfs
int vfs_get_bootfs(struct inode **node_store)
{
	struct inode *node = NULL;
	if (bootfs_node != NULL) {
		lock_bootfs();
		{
			if ((node = bootfs_node) != NULL) {
				vop_ref_inc(bootfs_node);
			}
		}
		unlock_bootfs();
	}
	if (node == NULL) {
		return -E_NOENT;
	}
	*node_store = node;
	return 0;
}


/***************************************deivce****************************************************/
static list_entry_t vdev_list;     // device info list in vfs layer
static semaphore_t vdev_list_sem;

static void lock_vdev_list(void)
{
	down(&vdev_list_sem);
}

static void unlock_vdev_list(void)
{
	up(&vdev_list_sem);
}

void vfs_devlist_init(void)
{
	list_init(&vdev_list);
	sem_init(&vdev_list_sem, 1);
}

// vfs_cleanup - finally clean (or sync) fs
void vfs_cleanup(void)
{
	if (!list_empty(&vdev_list)) {
		lock_vdev_list();
		{
			list_entry_t *list = &vdev_list, *le = list;
			while ((le = list_next(le)) != list) {
				vfs_dev_t *vdev = le2vdev(le, vdev_link);
				if (vdev->fs != NULL) {
					fsop_cleanup(vdev->fs);
				}
			}
		}
		unlock_vdev_list();
	}
}

/*
 * vfs_get_root - Given a device name (stdin, stdout, etc.), hand
 *                back an appropriate inode.
 */
int vfs_get_root(const char *devname, struct inode **node_store)
{
	assert(devname != NULL);
	int ret = -E_NO_DEV;
	if (!list_empty(&vdev_list)) {
		lock_vdev_list();
		{
			list_entry_t *list = &vdev_list, *le = list;
			while ((le = list_next(le)) != list) {
				vfs_dev_t *vdev = le2vdev(le, vdev_link);
				if (strcmp(devname, vdev->devname) == 0) {
					struct inode *found = NULL;
					if (vdev->fs != NULL) {
						found = fsop_get_root(vdev->fs);
					}
					else if (!vdev->mountable) {
						vop_ref_inc(vdev->devnode);
						found = vdev->devnode;
					}
					if (found != NULL) {
						ret = 0, *node_store = found;
					}
					else {
						ret = -E_NA_DEV;
					}
					break;
				}
			}
		}
		unlock_vdev_list();
	}
	return ret;
}

/*
 * vfs_get_devname - Given a filesystem, hand back the name of the device it's mounted on.
 */
const char * vfs_get_devname(struct vfs *fs)
{
	assert(fs != NULL);
	list_entry_t *list = &vdev_list, *le = list;
	while ((le = list_next(le)) != list) {
		vfs_dev_t *vdev = le2vdev(le, vdev_link);
		if (vdev->fs == fs) {
			return vdev->devname;
		}
	}
	return NULL;
}

void print_dev_list()
{
	list_entry_t *list = &vdev_list, *le = list;
	while ((le = list_next(le)) != list) {
		vfs_dev_t *vdev = le2vdev(le, vdev_link);
		uclean("---------------\n");
		uclean("devname:%s\n", vdev->devname);
		uclean("mountable:%d\n", vdev->mountable);
		uclean("inode:0x%x\n", vdev->devnode);
		uclean("vfs:0x%x\n", vdev->fs);
	}

}

/*
 * check_devname_confilct - Is there alreadily device which has the same name?
 */
static bool check_devname_conflict(const char *devname)
{
	list_entry_t *list = &vdev_list, *le = list;
	while ((le = list_next(le)) != list) {
		vfs_dev_t *vdev = le2vdev(le, vdev_link);
		if (strcmp(vdev->devname, devname) == 0) {
			return 0;
		}
	}
	return 1;
}


/*
 * vfs_do_add - Add a new device to the VFS layer's device table.
 *
 * If "mountable" is set, the device will be treated as one that expects
 * to have a filesystem mounted on it, and a raw device will be created
 * for direct access.
 */
static int vfs_do_add(const char *devname, struct inode *devnode, struct vfs *fs, bool mountable)
{
	assert(devname != NULL);
	assert((devnode == NULL && !mountable) || (devnode != NULL && check_inode_type(devnode, device)));
	if (strlen(devname) > FS_MAX_DNAME_LEN) {
		return -E_TOO_BIG;
	}

	int ret = -E_NO_MEM;
	char *s_devname;
	if ((s_devname = strdup(devname)) == NULL) {
		return ret;
	}

	vfs_dev_t *vdev;
	if ((vdev = kmalloc(sizeof(vfs_dev_t))) == NULL) {
		goto failed_cleanup_name;
	}

	ret = -E_EXISTS;
	DEBUG_CONSOLE;
	lock_vdev_list();
	if (!check_devname_conflict(s_devname)) {
		unlock_vdev_list();
		goto failed_cleanup_vdev;
	}
	vdev->devname = s_devname;
	vdev->devnode = devnode;
	vdev->mountable = mountable;
	vdev->fs = fs;

	list_add(&vdev_list, &(vdev->vdev_link));
	unlock_vdev_list();
	return 0;

failed_cleanup_vdev:
	kfree(vdev);
failed_cleanup_name:
	kfree(s_devname);
	return ret;
}

/*
 * vfs_add_fs - Add a new fs,  by name. See  vfs_do_add information for the description of
 *              mountable.
 */
int vfs_add_fs(const char *devname, struct vfs *fs)
{
	return vfs_do_add(devname, NULL, fs, 0);
}

/*
 * vfs_add_dev - Add a new device, by name. See  vfs_do_add information for the description of
 *               mountable.
 */
int vfs_add_dev(const char *devname, struct inode *devnode, bool mountable)
{
	return vfs_do_add(devname, devnode, NULL, mountable);
}

/*
 * find_mount - Look for a mountable device named DEVNAME.
 *              Should already hold vdev_list lock.
 */
static int find_mount(const char *devname, vfs_dev_t **vdev_store)
{
	assert(devname != NULL);
	list_entry_t *list = &vdev_list, *le = list;
	while ((le = list_next(le)) != list) {
		vfs_dev_t *vdev = le2vdev(le, vdev_link);
		if (vdev->mountable && strcmp(vdev->devname, devname) == 0) {
			*vdev_store = vdev;
			return 0;
		}
	}
	return -E_NO_DEV;
}

/*
 * vfs_mount - Mount a filesystem. Once we've found the device, call MOUNTFUNC to
 *             set up the filesystem and hand back a struct vfs.
 *
 * The DATA argument is passed through unchanged to MOUNTFUNC.
 */
int vfs_mount(const char *devname, int (*mountfunc)(struct device *dev, struct vfs **fs_store))
{
	int ret;
	lock_vdev_list();
	vfs_dev_t *vdev;
	if ((ret = find_mount(devname, &vdev)) != 0) {
		goto out;
	}
	if (vdev->fs != NULL) {
		ret = -E_BUSY;
		goto out;
	}
	assert(vdev->devname != NULL && vdev->mountable);

	struct device *dev = vop_info(vdev->devnode, device);
	if ((ret = mountfunc(dev, &(vdev->fs))) == 0) {
		assert(vdev->fs != NULL);
		cprintf("vfs: mount %s.\n", vdev->devname);
	}

out:
	unlock_vdev_list();
	return ret;
}

/*
 * vfs_unmount - Unmount a filesystem/device by name.
 *               First calls FSOP_SYNC on the filesystem; then calls FSOP_UNMOUNT.
 */
int vfs_unmount(const char *devname)
{
	int ret;
	lock_vdev_list();
	vfs_dev_t *vdev;
	if ((ret = find_mount(devname, &vdev)) != 0) {
		goto out;
	}
	if (vdev->fs == NULL) {
		ret = -E_INVAL;
		goto out;
	}
	assert(vdev->devname != NULL && vdev->mountable);

	if ((ret = fsop_sync(vdev->fs)) != 0) {
		goto out;
	}
	if ((ret = fsop_unmount(vdev->fs)) == 0) {
		vdev->fs = NULL;
		cprintf("vfs: unmount %s.\n", vdev->devname);
	}

out:
	unlock_vdev_list();
	return ret;
}

/*
 * vfs_unmount_all - Global unmount function.
 */
int vfs_unmount_all(void)
{
	if (!list_empty(&vdev_list)) {
		lock_vdev_list();
		{
			list_entry_t *list = &vdev_list, *le = list;
			while ((le = list_next(le)) != list) {
				vfs_dev_t *vdev = le2vdev(le, vdev_link);
				if (vdev->mountable && vdev->fs != NULL) {
					int ret;
					if ((ret = fsop_sync(vdev->fs)) != 0) {
						cprintf("vfs: warning: sync failed for %s: %e.\n", vdev->devname, ret);
						continue ;
					}
					if ((ret = fsop_unmount(vdev->fs)) != 0) {
						cprintf("vfs: warning: unmount failed for %s: %e.\n", vdev->devname, ret);
						continue ;
					}
					vdev->fs = NULL;
					cprintf("vfs: unmount %s.\n", vdev->devname);
				}
			}
		}
		unlock_vdev_list();
	}
	return 0;
}

/***************************************file****************************************************/
int vfs_open(char *path, uint32_t open_flags, struct inode **node_store)
{
	bool can_write = 0;
	switch (open_flags & O_ACCMODE) {
		case O_RDONLY:
			break;
		case O_WRONLY:
		case O_RDWR:
			can_write = 1;
			break;
		default:
			return -E_INVAL;
	}

	if (open_flags & O_TRUNC) {
		if (!can_write) {
			return -E_INVAL;
		}
	}

	int ret;
	struct inode *node;
	bool excl = (open_flags & O_EXCL) != 0;
	bool create = (open_flags & O_CREAT) != 0;
	ret = vfs_lookup(path, &node);

	if (ret != 0) {
		if (ret == -16 && (create)) {
			char *name;
			struct inode *dir;
			if ((ret = vfs_lookup_parent(path, &dir, &name)) != 0) {
				return ret;
			}
			ret = vop_create(dir, name, excl, &node);
		} else return ret;
	} else if (excl && create) {
		return -E_EXISTS;
	}
	assert(node != NULL);

	if ((ret = vop_open(node, open_flags)) != 0) {
		vop_ref_dec(node);
		return ret;
	}

	vop_open_inc(node);
	if (open_flags & O_TRUNC || create) {
		if ((ret = vop_truncate(node, 0)) != 0) {
			vop_open_dec(node);
			vop_ref_dec(node);
			return ret;
		}
	}
	*node_store = node;
	return 0;
}

// close file in vfs
int vfs_close(struct inode *node)
{
	vop_open_dec(node);
	vop_ref_dec(node);
	return 0;
}

// unimplement
int vfs_unlink(char *path)
{
	return -E_UNIMP;
}

// unimplement
int vfs_rename(char *old_path, char *new_path)
{
	return -E_UNIMP;
}

// unimplement
int vfs_link(char *old_path, char *new_path)
{
	return -E_UNIMP;
}

// unimplement
int vfs_symlink(char *old_path, char *new_path)
{
	return -E_UNIMP;
}

// unimplement
int vfs_readlink(char *path, struct iobuf *iob)
{
	return -E_UNIMP;
}

// unimplement
int vfs_mkdir(char *path)
{
	return -E_UNIMP;
}

/***************************************dir****************************************************/
static struct inode * get_cwd_nolock(void)
{
	return g_current->filesp->pwd;
}
/*
 * set_cwd_nolock - set current working directory.
 */
static void set_cwd_nolock(struct inode *pwd)
{
	g_current->filesp->pwd = pwd;
}

/*
 * lock_cfs - lock the fs related process on current process
 */
static void lock_cfs(void)
{
	lock_files(g_current->filesp);
}
/*
 * unlock_cfs - unlock the fs related process on current process
 */
static void unlock_cfs(void)
{
	unlock_files(g_current->filesp);
}

/*
 *  vfs_get_curdir - Get current directory as a inode.
 */
int vfs_get_curdir(struct inode **dir_store)
{
	struct inode *node;
	if ((node = get_cwd_nolock()) != NULL) {
		vop_ref_inc(node);
		*dir_store = node;
		return 0;
	}
	return -E_NOENT;
}

/*
 * vfs_set_curdir - Set current directory as a inode.
 *                  The passed inode must in fact be a directory.
 */
int vfs_set_curdir(struct inode *dir)
{
	int ret = 0;
	lock_cfs();
	struct inode *old_dir;
	if ((old_dir = get_cwd_nolock()) != dir) {
		if (dir != NULL) {
			uint32_t type;
			if ((ret = vop_gettype(dir, &type)) != 0) {
				goto out;
			}
			if (!S_ISDIR(type)) {
				ret = -E_NOTDIR;
				goto out;
			}
			vop_ref_inc(dir);
		}
		set_cwd_nolock(dir);
		if (old_dir != NULL) {
			vop_ref_dec(old_dir);
		}
	}
out:
	unlock_cfs();
	return ret;
}

/*
 * vfs_chdir - Set current directory, as a pathname. Use vfs_lookup to translate
 *             it to a inode.
 */
int vfs_chdir(char *path)
{
	int ret;
	struct inode *node;
	if ((ret = vfs_lookup(path, &node)) == 0) {
		ret = vfs_set_curdir(node);
		vop_ref_dec(node);
	}
	return ret;
}
/*
 * vfs_getcwd - retrieve current working directory(cwd).
 */
int vfs_getcwd(struct iobuf *iob)
{
	int ret;
	struct inode *node;
	if ((ret = vfs_get_curdir(&node)) != 0) {
		return ret;
	}
	assert(node->in_fs != NULL);

	const char *devname = vfs_get_devname(node->in_fs);
	if ((ret = iobuf_move(iob, (char *)devname, strlen(devname), 1, NULL)) != 0) {
		goto out;
	}
	char colon = ':';
	if ((ret = iobuf_move(iob, &colon, sizeof(colon), 1, NULL)) != 0) {
		goto out;
	}
	ret = vop_namefile(node, iob);

out:
	vop_ref_dec(node);
	return ret;
}

static int get_device(char *path, char **subpath, struct inode **node_store)
{
	int i, slash = -1, colon = -1;
	for (i = 0; path[i] != '\0'; i ++) {
		if (path[i] == ':') { colon = i; break; }
		if (path[i] == '/') { slash = i; break; }
	}
	if (colon < 0 && slash != 0) {
		/* *
		 * No colon before a slash, so no device name specified, and the slash isn't leading
		 * or is also absent, so this is a relative path or just a bare filename. Start from
		 * the current directory, and use the whole thing as the subpath.
		 * */
		*subpath = path;
		return vfs_get_curdir(node_store);
	}
	if (colon > 0) {
		/* device:path - get root of device's filesystem */
		path[colon] = '\0';

		/* device:/path - skip slash, treat as device:path */
		while (path[++ colon] == '/');
		*subpath = path + colon;
		return vfs_get_root(path, node_store);
	}

	/* *
	 * we have either /path or :path
	 * /path is a path relative to the root of the "boot filesystem"
	 * :path is a path relative to the root of the current filesystem
	 * */
	int ret;
	if (*path == '/') {
		if ((ret = vfs_get_bootfs(node_store)) != 0) {
			return ret;
		}
	}
	else {
		assert(*path == ':');
		struct inode *node;
		if ((ret = vfs_get_curdir(&node)) != 0) {
			return ret;
		}
		/* The current directory may not be a device, so it must have a fs. */
		assert(node->in_fs != NULL);
		*node_store = fsop_get_root(node->in_fs);
		vop_ref_dec(node);
	}

	/* ///... or :/... */
	while (*(++ path) == '/');
	*subpath = path;
	return 0;
}

/*
 * vfs_lookup - get the inode according to the path filename
 */
int vfs_lookup(char *path, struct inode **node_store)
{
	int ret;
	struct inode *node;
	if ((ret = get_device(path, &path, &node)) != 0) {
		return ret;
	}
	if (*path != '\0') {
		ret = vop_lookup(node, path, node_store);
		vop_ref_dec(node);
		return ret;
	}
	*node_store = node;
	return 0;
}

/*
 * vfs_lookup_parent - Name-to-vnode translation.
 *  (In BSD, both of these are subsumed by namei().)
 */
int vfs_lookup_parent(char *path, struct inode **node_store, char **endp)
{
	int ret;
	struct inode *node;
	if ((ret = get_device(path, &path, &node)) != 0) {
		return ret;
	}
	*endp = path;
	*node_store = node;
	return 0;
}


