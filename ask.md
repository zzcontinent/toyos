----
# lab1
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
10. 函数堆栈
	1. 编译器
```
----
# lab2
```
1.
```
