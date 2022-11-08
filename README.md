# toyos 
## quick start
```
cd src
make
make qemu-nox
make qemukill
```
if qemu blocked, press [CTRL + a] [c], qemu goes into command mode, type p $pc to print current pc reg value.
## content
```
0 tools: bootloader、kernel
1 asm i386
2 bringup
3 pmm
4 vmm
5 kernel thread
6 user process
7 scheduler
8 sync
9 file system
10 display + game
```

## wiki
- [1.segment and page managment](https://github.com/zzcontinent/toyos/tree/dev/seg_page.md)
- [2.address map](https://github.com/zzcontinent/toyos/tree/dev/address.md)
- [3.function stack](https://github.com/zzcontinent/toyos/tree/dev/stack.md)
- [4.questions](https://github.com/zzcontinent/toyos/tree/dev/ask.md)
