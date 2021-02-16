GCCPREFIX := ''
QEMU := qemu-system-i386
.SUFFIXES: .c .S .h

HOSTCC := gcc
## for mksfs program, -D_FILE_OFFSET_BITS=64 can guarantee sizeof(off_t)==8,  sizeof(ino_t) ==8
## for 64 bit gcc, to build 32-bit mksfs, you can use below line
## HOSTCFLAGS	:= -g -Wall -m32 -O2 -D_FILE_OFFSET_BITS=64
HOSTCFLAGS	:= -g -Wall -O2 -D_FILE_OFFSET_BITS=64

GDB := ${GCCPREFIX}gdb
CC := $(GCCPREFIX)gcc
CFLAGS := -fno-builtin -fno-PIC -Wall -ggdb -m32 -gstabs -nostdinc $(DEFS)
CFLAGS += $(shell $(CC) -fno-stack-protector -E -x c /dev/null >/dev/null 2>&1 && echo -fno-stack-protector)
CTYPE := c S

LD := $(GCCPREFIX)ld
LDFLAGS := -m $(shell $(LD) -V | grep elf_i386 2>/dev/null | head -n 1)
LDFLAGS += -nostdlib

OBJCOPY := $(GCCPREFIX)objcopy
OBJDUMP := $(GCCPREFIX)objdump

include tools/function.mk

