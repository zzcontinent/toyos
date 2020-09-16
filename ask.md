----

# lab1 系统软件启动过程

```
1. make生成文件过程:
	1.1 生成ucore.img
	1.2 硬盘主引导山区的特征
2. qemu执行与调试
	2.1 0x7c00实地址设置断点
	2.2 gdb反汇编 vs. bootasm.S vs. bootblock.asm
3. bootloader设置进入保护模式
	3.1 开启A20
	3.2 初始化GDT表
4. bootloader加载ELF格式的OS过程
	4.1 读取硬盘扇区
	4.2 加载ELF格式的OS
5. 函数调用堆栈跟踪
	5.1 print_stackframe
	5.2 eip esp ss[eip + 4] ...
6. 中断初始化和中断处理
	6.1 中断描述符表(保护模式下的中断向量表)
		一个表项多少字节？其中哪几位代表中断处理代码的入口？
	6.2 idt_init()中对中断入口进行初始化
		mmu.h -> SETGATE -> idt vector
		tools/vectors.c -> idt entry (trap.c)
	6.3 trap()
		timer interrupt -> print_ticks() -> 100 ticks
	6.4 系统调用T_SYSCALL中断的陷阱 门描述符权限DPL=3 
7. BIOS启动流程
	->Intel 80386 CPU -> 0xFFFFFFF0(CS:EIP 0xF000:0xFFF0) -> jump to BIOS 例行程序起始点(硬件自建和初始化)
	-> 选择一个启动设备(软盘、硬盘、光盘) 
	-> 读取该设备第一扇区到0x7c00
	->主引导(MBR:Master Boot Record)扇区或启动扇区: 引导程序(440Bytes) -> widnows磁盘签名(4Bytes) -> 分区表(64Bytes) -> 结束标志(0x55AA)
	-> 8086(16bit) : EPROM被编址在1MB内存空间的最高64KB中.PC加点后,CS=0xF000,IP=0xFFF0 -> JMP F000:E05B ->开启BIOS执行过程
	-> 80386(32bit): BIOS ROM被编址在4GB地址的最后64KB中 -> CS=0xF000,shadhow register base=0xFFFF0000,EIP=0xF000 -> 0xFFFFFFF0执行JMP F000:E05B -> BIOS ROM被映射到RAM的1MB以内空间里
8. ELF格式(一种目标文件object file)
	1. 类型：可执行文件(executable file) + 可重定位文件(relocatable file) + 共享目标文件(shared object file)
	2. ELF header (program header)
9. Link Address & Load Address
	1. Link Address: 编译器指定代码和数据所需要放置的内存地址
	2. Load Address: 程序加载器ld配置的实际被加载内存的位置
	3. Link Address 和Load Address不同会导致?
		-> 直接跳转位置错误
		-> 直接内存访问(只读数据区或者bss等直接地址访问)错误
		-> 堆和栈的使用不受影响,但是可能会覆盖程序、数据区域
		-> 动态链接库：可以存在Link地址和Load地址不一样
10. 函数堆栈(CDECL为例)
	1. CALL指令：压入入参+return address
	2. 编译器加入：
		push1 %ebp
		movl %esp %ebp
11. 中断和异常
	1. 中断(interrupt) == 异步中断(asynchronous interrupt) == 外部中断
		CPU外部设备引起的事件：I/O中断、时钟中断
	2. 异常(exception) == 同步中断(synchronous interrupt)  == 内部中断
		CPU执行指令周期检测到的不正常或非法的条件(除零错误、地址访问越界)引起的内部事件
	3. 中断描述符表
		3.1 与GDT同样是8字节的描述符数组，但IDT的第一项可以包含一个描述符
		3.2 CPU把中断(异常)乘以8作为IDT的索引
		3.3 加载IDT:LIDT(Load,ring0) & 存储IDT:SIDT(store,ring0-3)
		3.4 最多256个 interrupt/exception vectors. [0,31]被exception & NMI使用
		3.5 Task-gate descriptor + interrupt-gate descriptor + trap-gate descriptor
```

----

# lab2 物理内存管理
```
1.自映射解决什么问题?
	0. 定义:把页目录表(1024*4Bytes)+页表(1024*1024*4Bytes)放到一个连续的4MB虚拟地址空间中,address_cnt=1024*1024
		map: virtual addr(KERNBASE ~ KERNBASE+KMEMSIZE) = physical_addr(0 ~ KMEMSIZE)
	1. vpt=0xFAC00000(10:1003,0,0); vpd=0xFAFEB000=PGADDR(PDX(VPT),PDX(VPT),0) (10:1003,1003,0)
	2. KERNBASE=0xC0000000; KMEMSIZE=0x38000000(896MB); KERNTOP=KERNBASE+KMEMSIZE=0xF8000000; 
	3. KERNTOP的页目录虚地址: vpd + KERNTOP/4M*4 = vpd + 0xF8000000/0x400000*4 = 0xFAFEB000 + 0xF80 = 0xFAFEBF80 
	4. KERNTOP的页表项虚地址: vpt + KERNTOP/4K*4 = vpt + 0xF8000000/0x1000*4 = 0xFAC00000 + 0x3E0000 = 0xFAFE0000
		KERNTOP/4M*4中x4是因为页表的位宽32bits, 所以offset 转换为地址 offset*4
	5. 页表的虚拟地址空间为0xFAC00000 - 0xFB000000, size=4MB, address_cnt=1024*1024 (10bits * 10bits)
2. 实现用户空间的自映射(之前在内核空间)
	1. pmm_init: boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir}| PTE_P | PTE_W
	2. pgdir[UVPT] = PADDR(pgdir)| PTE_P | PTE_U (不能给写权限,pgdir是每个进程的page table)
	3. print_pgdir: 遍历自己的页表结构
```

----

# lab3 虚拟内存管理
```
1. 给未被映射的地址映射上物理页
	1. do_pgfault考虑: 访问权限(页面所在VMA的权限 + 内存控制结构所指定的也表,不是内核的也表)
	2. 页目录项PDE和页表项PTE对实现页替换算法的潜在作用
	3. 如果且页服务例程在执行过程中访问内存,发生了页访问异常,此时硬件要做哪些事情?
2. FIFO页替换算法
	1. swap_manager的作用
	2. swap_fifo.c -> map_swappable + swap_out_victim
	3. 被换出的页有什么特征,如何判断,何时换入和换出
3. 识别dirty bit的extended clock页替换算法
4. LRU页替换算法
```

----

# lab4 内核线程管理
```
1.
```

----

# lab5 用户进程管理
```
1.
```

----

# lab6 调度器
```
1.
```

----

# lab7 同步互斥
```
1.
```

----

# lab8 文件系统
```
1.
```

