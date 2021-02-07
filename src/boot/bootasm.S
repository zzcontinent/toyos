#include <asm.h>

.set PROT_MODE_CSEG, 0x8        #kernel code segment selector
.set PROT_MODE_DSEG, 0x10        #kernel data segment selector
.set CR0_PE_ON, 0x1            #protected mode enable flag

.global start
start:
.code16                    #Assemble for 16-bit mode
    cli                    #Disable interrupts
    cld                    #String operations increment

    # Set up the important data segment registers (DS ES SS)
    xorw %ax, %ax
    movw %ax, %ds

#enable A20:
seta20.1:
    inb $0x64, %al
    testb $0x2, %al
    jnz seta20.1

    movb $0xd1, %al
    outb %al, $0x64

seta20.2:
    inb $0x64, %al
    testb $0x2, %al
    jnz seta20.2

    mov $0xdf, %al
    outb %al, $0x60

    #switch from real to protected mode, using a bootstrap GDT
    # and segment translation that makes virtual addresses
    # identical to physical addresses, so that the
    # effective memory map does not change during the switch.
    lgdt gdtdesc
    movl %cr0, %eax
    orl %CR0_PE_ON, %eax
    movl $eax, $cr0

    #jump to next instruction, but in 32-bit code segment.
    # switches processor into 32-bit mode.
    ljmp $PROT_MODE_CSEG, $protcseg

.code32
protcseg:
    #set up the protedted-mode data segment registers
    movw $PROT_MODE_DSEG, %ax
    movw %ax,%ds
    movw %ax,%es
    movw %ax,%fs
    movw %ax,%gs
    movw %ax,%ss

    # set up the stack pointer and call into C.
    # the stack region is from 0-start(0x7c00)
    movl $0x0, %ebp
    movl $start %esp
    call bootmain

    if bootmain returns(it shouldn't) , loop
spin:
    jmp spin


# bootstrap GDT
.p2align 2
gdt:
    SEG_NULLASM
    SEG_ASM(STA_X|STA_R, 0x0, 0xffffffff)    #code seg for bootloader and kernel
    SEG_ASM(STA_W, 0x0, 0xffffffff)    #data seg for bootloader and kernel

# pdf 330: GDTR.Limit:Base <- m16:32
gdtdesc:
    .word 0x17        # sizeof(gdt) - 1
    .long gdt        #address gdt
