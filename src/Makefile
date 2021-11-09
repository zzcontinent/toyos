
################ variables start ################
# +++ cc +++
GCCPREFIX := ''
QEMU := qemu-system-i386
#V := @

.SUFFIXES: .c .S .h
.DELETE_ON_ERROR:

HOSTCC := gcc
## for mksfs program, -D_FILE_OFFSET_BITS=64 can guarantee sizeof(off_t)==8,  sizeof(ino_t) ==8
## for 64 bit gcc, to build 32-bit mksfs, you can use below line
## HOSTCFLAGS	:= -g -Wall -m32 -O2 -D_FILE_OFFSET_BITS=64
HOSTCFLAGS	:= -g -Wall -O2 -D_FILE_OFFSET_BITS=64

GDB := ${GCCPREFIX}gdb
CC := $(GCCPREFIX)gcc
CFLAGS	:= -fno-builtin -fno-PIC -Wall -ggdb -m32 -gstabs -nostdinc $(DEFS)
CFLAGS	+= $(shell $(CC) -fno-stack-protector -E -x c /dev/null >/dev/null 2>&1 && echo -fno-stack-protector)
CTYPE := c S

KCFLAGS := $(CFLAGS)

LD := $(GCCPREFIX)ld
LDFLAGS := -m $(shell $(LD) -V | grep elf_i386 2>/dev/null | head -n 1)
LDFLAGS += -nostdlib

OBJCOPY := $(GCCPREFIX)objcopy
OBJDUMP := $(GCCPREFIX)objdump

# +++ compile out targets +++
OUT_DIR := out/
OUT_TARGETDIR := $(OUT_DIR)target
OUT_OBJDIR := $(OUT_DIR)obj
OUT_TOOLDIR := $(OUT_DIR)tools
ALLOBJS :=
ALLDEPS :=
# there are many targets with specific objs to be linked. how to classify target -> objs

# +++ user program out +++
USER_PREFIX := __user_
USER_BINS :=
# UOBJS := $(call read_packet,ulibs)

# +++ kernel include +++
INCLUDE += libs/
CFLAGS += $(addprefix -I,$(INCLUDE))
LIBDIR := libs
#KSRCDIR := $(shell find kern/* -type d)
KSRCDIR := 	kern/init \
			   kern/libs \
			   kern/debug \
			   kern/driver \
			   kern/trap \
			   kern/mm \
			   kern/sync \
			   kern/fs    \
			   kern/process \
			   kern/schedule \
			   kern/syscall  \
			   kern/fs/swap \
			   kern/fs/vfs \
			   kern/fs/devs \
			   kern/fs/sfs


KINCLUDE = $(KSRCDIR)
KCFLAGS += $(addprefix -I,$(KINCLUDE))
KCFLAGS += $(addprefix -I,libs)
target_kernel = $(call to_out_target,kernel)

# +++ user include +++
UINCLUDE += user/include/ \
	    user/libs/
USRCDIR := user
USRCDIR += user/libs
UCFLAGS += $(addprefix -I,$(UINCLUDE))

# +++ boot +++
bootfiles = $(call listf_cc,boot)
target_bootblock = $(call to_out_target,bootblock)

# +++ ucore.img +++
target_ucoreimg = $(call to_out_target,ucore.img)

# +++ sfs.img +++
SFSROOT := disk0
SFSIMG = $(call to_out_target,sfs.img)
SFSBINS =

# +++ swap.img +++
SWAPIMG = $(call to_out_target,swap.img)

# +++ qemu +++
QEMUOPTS = -hda $(target_ucoreimg) -drive file=$(SWAPIMG),media=disk,cache=writeback -drive file=$(SFSIMG),media=disk,cache=writeback -no-reboot

# +++ terminal +++
#TERMINAL := gnome-terminal
TERMINAL := terminator

################ variables end ################



################ function start ################
include tools/function.mk


# generate out files functions
swaptype = $(patsubst %.$(2),%.$(3),$(1))
asmfile = $(call swaptype,$(call to_out_obj,$(1)),o,asm)
outfile = $(call swaptype,$(call to_out_obj,$(1)),o,out)
symfile = $(call swaptype,$(call to_out_obj,$(1)),o,sym)
filename = $(basename $(notdir $(1)))
ubinfile = $(call outfile,$(addprefix $(USER_PREFIX),$(call filename,$(1))))

match = $(shell echo $(2) | awk '{for(i=1;i<NF;i++){if(match("$(1)","^"$$(i)"$$")){exit 1;}}}'; echo $$?)

define user_prog_ld
__user_bin__ := $$(call ubinfile,$(1))
USER_BINS += $$(__user_bin__)
$$(__user_bin__): tools/user.ld
$$(__user_bin__): $$(UOBJS)
$$(__user_bin__): $(1) | $$$$(dir $$$$@)
	$(V)$(LD) $(LDFLAGS) -T tools/user.ld -o $$@ $$(UOBJS) $(1)
	$(V)$(OBJDUMP) -S $$@ > $$(call swaptype,$$<,o,asm)
	$(V)$(OBJDUMP) -t $$@ | sed '1,/SYMBOL TABLE/d; s/ .* / /; /^$$$$/d' > $$(call swaptype,$$<,o,sym)
endef

# +++ sfs copy +++
define fscopy
__fs_bin__ := $(2)$(SLASH)$(patsubst $(USER_PREFIX)%,%,$(basename $(notdir $(1))))
SFSBINS += $$(__fs_bin__)
$$(__fs_bin__): $(1) | $$$$(dir $@)
	@cp $$< $$@
endef

################ function end ################



################ build rules start ################
# +++ user +++
$(call rule_compile_files,user,$(call listf_cc,$(USRCDIR)),$(CC),$(UCFLAGS))
# $(foreach p,$(call read_packet,uprog),$(eval $(call user_prog_ld,$(p))))

# +++ kernel +++
# libs/*.c
$(call rule_compile_files,kernel,$(foreach d,$(KSRCDIR),$(call listf_cc,$(d))),$(CC),$(KCFLAGS))
$(call rule_compile_files_cc,kernel,$(call listf_cc,$(LIBDIR)))

$(target_kernel): tools/kernel.ld

$(target_kernel): $(ALLOBJS_kernel)
	@echo + ld $@ : $^
	$(V)$(LD) $(LDFLAGS) -T tools/kernel.ld -o $@ $(ALLOBJS_kernel)
	$(V)$(OBJDUMP) -S $@ > $(call asmfile,kern/kernel)
	$(V)$(OBJDUMP) -t $@ | sed '1,/SYMBOL TABLE/d; s/ .* / /; /^$$/d' > $(call symfile,kern/kernel)

$(call rule_link_target,kernel)

# +++ bootblock +++
$(call rule_compile_files,bootblock,$(bootfiles),$(CC),$(CFLAGS) -Os -nostdinc)

$(target_bootblock): $(call to_out_obj,$(bootfiles)) | $(call to_out_target,sign)
	@echo + ld $@ : $^
	$(V)$(LD) $(LDFLAGS) -N -T tools/boot.ld $^ -o $(call to_out_obj,boot/bootblock)
	$(V)$(OBJDUMP) -S $(call to_out_obj,boot/bootblock) > $(call asmfile,boot/bootblock)
	$(V)$(OBJCOPY) -S -O binary $(call to_out_obj,boot/bootblock) $(call outfile,boot/bootblock)
	$(V)$(call to_out_target,sign) $(call outfile,boot/bootblock) $(target_bootblock)

$(call rule_link_target,bootblock)

# +++ sign tools +++
$(call rule_compile_files_hostcc,sign,tools/sign.c)
$(call rule_link_target_host,sign,tools/sign)

# +++ mkfs tools +++
$(call rule_compile_files_hostcc,mksfs,tools/mksfs.c)
$(call rule_link_target_host,mksfs,tools/mksfs)

# +++ create ucore.img +++
$(target_ucoreimg): $(target_kernel) $(target_bootblock)
	$(V)dd if=/dev/zero of=$@ count=10000
	$(V)dd if=$(target_bootblock) of=$@ conv=notrunc
	$(V)dd if=$(target_kernel) of=$@ seek=1 conv=notrunc

$(call rule_link_target,ucore.img)

# +++ create swap.img +++
$(SWAPIMG):
	$(V)dd if=/dev/zero of=$@ bs=1M count=128

$(call rule_link_target,swap.img)

# +++ create sfs.img +++
$(foreach p,$(USER_BINS),$(eval $(call fscopy,$(p),$(SLASH))))

$(SFSROOT):
	$(V)mkdir $@

$(SFSIMG): $(SFSROOT) $(SFSBINS) | $(call to_out_target,mksfs)
	$(V)dd if=/dev/zero of=$@ bs=1M count=128
	$(V)$(call to_out_target,mksfs) $@ $(SFSROOT)

$(call rule_link_target,sfs.img)

# +++ finish +++
$(call rule_finish_all)

# +++ qemu +++
.PHONY: qemu qemu-nox debug debug-nox monitor lines

qemu: $(target_ucoreimg) $(SWAPIMG) $(SFSIMG)
	$(V)$(QEMU) -serial stdio $(QEMUOPTS) -parallel null

qemu-nox: $(target_ucoreimg) $(SWAPIMG) $(SFSIMG)
	$(V)$(QEMU) -serial mon:stdio $(QEMUOPTS) -nographic

debug: $(target_ucoreimg) $(SWAPIMG) $(SFSIMG)
	$(V)$(QEMU) -S -s -parallel stdio $(QEMUOPTS) -serial null &
	$(V)sleep 2
	$(V)$(TERMINAL) -e "$(GDB) -q -x tools/gdbinit"

debug-bootblock: $(bootblock)
	make qemukill
	$(V)$(QEMU) -S -s -serial mon:stdio -hda out/target/bootblock -nographic &
	sleep 1
	$(TERMINAL) --new-tab -e "gdb -q -x tools/gdbinit"

debug-ucore: $(target_ucoreimg)
	make qemukill
	$(V)$(QEMU) -S -s -serial mon:stdio -hda $< -nographic &
	sleep 1
	$(TERMINAL) --new-tab -e "gdb -q -x tools/gdbinit"

debug-nox: $(target_ucoreimg) $(SWAPIMG) $(SFSIMG)
	$(V)$(QEMU) -S -s -serial mon:stdio $(QEMUOPTS) -nographic &
	$(V)sleep 1
	$(V)$(TERMINAL) -e "$(GDB) -q -x tools/gdbinit"

qemukill:
	-@ps ax | grep qemu-system-i386 | grep -v grep | awk '{print $$1}' | xargs kill -9 2>/dev/null

lines:
	@find -type f | grep -E 'c$$|h$$|S$$'| xargs wc | sort -k1 -n

clean:
	@-rm -r $(OUT_DIR)

################ build rules end ################

