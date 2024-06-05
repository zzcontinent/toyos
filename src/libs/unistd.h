#ifndef  __UNISTD_H__
#define  __UNISTD_H__

#define T_SYSCALL           0x80

/* syscall number */
#define SYS_exit            1
#define SYS_fork            2
#define SYS_read            3
#define SYS_write           4
#define SYS_open            5
#define SYS_close           6
#define SYS_wait            7
#define SYS_execve          11
#define SYS_lseek           19
#define SYS_getpid          20
#define SYS_access          33
#define SYS_kill            37
#define SYS_dup             41
#define SYS_brk             45
#define SYS_ioctl           54
#define SYS_getdirentry     89
#define SYS_mmap            90
#define SYS_munmap          91
#define SYS_fstat           108
#define SYS_fsync           118
#define SYS_mprotect        125
#define SYS_writev          146
#define SYS_sched_yield     158
#define SYS_nanosleep       162
#define SYS_pread64         180
#define SYS_getcwd          183
#define SYS_mmap2           192
#define SYS_exit_group      252
#define SYS_set_tid_address 258
#define SYS_timer_settime32 260
#define SYS_timer_gettime32 261
#define SYS_clock_settime32 264
#define SYS_clock_gettime32 265
#define SYS_openat          295
#define SYS_set_robust_list 311
#define SYS_prlimit64       340
#define SYS_getrandom       355
#define SYS_arch_prctl      384
#define SYS_rseq            386
#define SYS_clock_gettime64 403
#define SYS_clock_settime64 404
#define SYS_timer_gettime64 408
#define SYS_timer_settime64 409


/* OLNY FOR LAB6 */
#define SYS_set_priority 511
#define SYS_putc         512
#define SYS_pgdir        513

/* SYS_fork flags */
#define CLONE_VM            0x00000100  // set if VM shared between processes
#define CLONE_THREAD        0x00000200  // thread group
#define CLONE_FS            0x00000800  // set if shared between processes

/* VFS flags */
// flags for open: choose one of these
#define O_RDONLY            0           // open for reading only
#define O_WRONLY            1           // open for writing only
#define O_RDWR              2           // open for reading and writing
// then or in any of these:
#define O_CREAT             0x00000004  // create file if it does not exist
#define O_EXCL              0x00000008  // error if O_CREAT and the file exists
#define O_TRUNC             0x00000010  // truncate file upon open
#define O_APPEND            0x00000020  // append on each write
// additonal related definition
#define O_ACCMODE           3           // mask for O_RDONLY / O_WRONLY / O_RDWR

#define NO_FD               -0x9527     // invalid fd

/* lseek codes */
#define LSEEK_SET           0           // seek relative to beginning of file
#define LSEEK_CUR           1           // seek relative to current position in file
#define LSEEK_END           2           // seek relative to end of file

#define FS_MAX_DNAME_LEN    31
#define FS_MAX_FNAME_LEN    255
#define FS_MAX_FPATH_LEN    4095

#define EXEC_MAX_ARG_NUM    32
#define EXEC_MAX_ARG_LEN    4095

#endif  /* __UNISTD_H__ */
