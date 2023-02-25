#****************************************common***************************************************/
GCCPREFIX :=
QEMU := qemu-system-i386
V := @

.SUFFIXES: .c .S .h
.DELETE_ON_ERROR:

HOSTCC := gcc
## HOSTCFLAGS := -g -Wall -m32 -O2 -D_FILE_OFFSET_BITS=64
HOSTCFLAGS := -g -Wall -O2 -D_FILE_OFFSET_BITS=64

GDB := ${GCCPREFIX}gdb
CC := $(GCCPREFIX)gcc
CFLAGS := -fno-builtin -fno-PIC -Wall -ggdb -m32 -gstabs -nostdinc
CFLAGS += $(shell $(CC) -fno-stack-protector -E -x c /dev/null >/dev/null 2>&1 && echo -fno-stack-protector)
CFLAGS += -I..
CTYPE := c S

LD := $(GCCPREFIX)ld
LDFLAGS := -m $(shell $(LD) -V | grep elf_i386 2>/dev/null | head -n 1| tr -d ' ')
LDFLAGS += -nostdlib

OBJCOPY := $(GCCPREFIX)objcopy
OBJDUMP := $(GCCPREFIX)objdump

ALLOBJS =
ALLTARGETS =

OUT_DIR := out/
OUT_TARGETDIR := $(OUT_DIR)target
OUT_OBJDIR := $(OUT_DIR)obj

USER_BINS :=
USER_SRCDIR := .
USER_LIBDIR := ./libs
USER_CFLAGS := $(CFLAGS)
USER_LDFLAGS := $(LDFLAGS) 
USER_LDFLAGS += -T ../tools/user.ld

RULE_FILES_INCLUDE := user.mk
ALLTARGETS_apps =
#***************************************common function****************************************************/
include ../tools/function.mk

all: $$(ALLTARGETS_apps)
#***************************************rule user****************************************************/
$(call rule_compile_files,user,$(call listf_cc,$(USER_SRCDIR)),$(CC),$(USER_CFLAGS))
$(call rule_compile_files,user_libs,$(call listf_cc,$(USER_LIBDIR)),$(CC),$(USER_CFLAGS))
$(call rule_link_objs_same_targets,apps,$(ALLOBJS_user),$(ALLOBJS_user_libs),$(LD),$(USER_LDFLAGS))
include $(RULE_FILES_INCLUDE)

clean:
	@-rm -r $(OUT_DIR)/

log:
	make clean && make 2>&1 | less -p 'warn|err'

.PHONY: all log clean

#***************************************finish****************************************************/
$(call rule_finish_all)

