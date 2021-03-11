
################ variables start ################
# +++ cc +++
GCCPREFIX := ''
QEMU := qemu-system-i386

.SUFFIXES: .c .S .h
.DELETE_ON_ERROR:

HOSTCC := gcc
## for mksfs program, -D_FILE_OFFSET_BITS=64 can guarantee sizeof(off_t)==8,  sizeof(ino_t) ==8
## for 64 bit gcc, to build 32-bit mksfs, you can use below line
## HOSTCFLAGS	:= -g -Wall -m32 -O2 -D_FILE_OFFSET_BITS=64
HOSTCFLAGS	:= -g -Wall -O2 -D_FILE_OFFSET_BITS=64

GDB := ${GCCPREFIX}gdb
CC := $(GCCPREFIX)gcc
CFLAGS := -fno-builtin -fno-PIC -Wall -ggdb -m32 -gstabs -nostdinc
CFLAGS += $(shell $(CC) -fno-stack-protector -E -x c /dev/null >/dev/null 2>&1 && echo -fno-stack-protector)
KCFLAGS := $(CFLAGS)
CTYPE := c S

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

# +++ user program out +++
USER_PREFIX := __user_
USER_BINS :=
# UOBJS := $(call read_packet,ulibs)

# +++ kernel include +++
INCLUDE += libs/
CFLAGS += $(addprefix -I,$(INCLUDE))
LIBDIR := libs
KSRCDIR := $(shell find kern/* -type d)
KINCLUDE = $(KSRCDIR)
KCFLAGS += $(addprefix -I,$(KINCLUDE))
KCFLAGS += $(addprefix -I,libs)
kernel = $(call to_out_target,kernel)
# KOBJS = $(call read_packet,kernel libs)


# +++ user include +++
UINCLUDE += user/include/ \
	    user/libs/
USRCDIR := user
USRCDIR += user/libs
UCFLAGS += $(addprefix -I,$(UINCLUDE))

# +++ boot +++
bootfiles = $(call listf_cc,boot)
bootblock = $(call to_out_target,bootblock)

# +++ ucore.img +++
UCOREIMG := $(call to_out_target,ucore.img)

# +++ sfs.img +++
SFSROOT := disk0
SFSIMG := $(call to_out_target,sfs.img)
SFSBINS :=
SFSIMG := $(call to_out_target,sfs.img)

# +++ swap.img +++
SWAPIMG := $(call to_out_target,swap.img)

# +++ qemu +++
QEMUOPTS = -hda $(UCOREIMG) -drive file=$(SWAPIMG),media=disk,cache=writeback -drive file=$(SFSIMG),media=disk,cache=writeback

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
	@$(OBJDUMP) -S $$@ > $$(call swaptype,$$<,o,asm)
	@$(OBJDUMP) -t $$@ | sed '1,/SYMBOL TABLE/d; s/ .* / /; /^$$$$/d' > $$(call swaptype,$$<,o,sym)
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
$(call rule_compile_files,$(call listf_cc,$(USRCDIR)),$(CC),$(UCFLAGS))
# $(foreach p,$(call read_packet,uprog),$(eval $(call user_prog_ld,$(p))))

# +++ kernel +++
# libs/*.c
$(call rule_compile_files_cc,$(call listf_cc,$(LIBDIR)))
$(call rule_compile_files,$(foreach d,$(KSRCDIR),$(call listf_cc,$(d))),$(CC),$(KCFLAGS))

$(kernel): tools/kernel.ld

$(kernel): $(KOBJS)
	@echo +ld $@
	$(V)$(LD) $(LDFLAGS) -T tools/kernel.ld -o $@ $(KOBJS)
	@$(OBJDUMP) -S $@ > $(call asmfile,kernel)
	@$(OBJDUMP) -t $@ | sed '1,/SYMBOL TABLE/d; s/ .* / /; /^$$/d' > $(call symfile,kernel)

$(call rule_create_target,kernel)

# +++ bootblock +++
$(call rule_compile_files,$(bootfiles),$(CC),$(CFLAGS) -Os -nostdinc)

$(bootblock): $(call to_out_obj,$(bootfiles)) | $(call to_out_target,sign)
	@echo + ld $@ : $^
	$(V)$(LD) $(LDFLAGS) -N -T tools/boot.ld $^ -o $(call to_out_obj,bootblock)
	@$(OBJDUMP) -S $(call to_out_obj,bootblock) > $(call asmfile,bootblock)
	@$(OBJCOPY) -S -O binary $(call to_out_obj,bootblock) $(call outfile,bootblock)
	$(call to_out_target,sign) $(call outfile,bootblock) $(bootblock)

$(call rule_create_target,bootblock)

# +++ sign tools +++
$(call rule_compile_files_hostcc,tools/sign.c)
$(call rule_create_target_host,sign,tools/sign)

# +++ mkfs tools +++
$(call rule_compile_files_hostcc,tools/mksfs.c,mksfs,mksfs)
$(call rule_create_target_host,mksfs,mksfs)

# +++ create ucore.img +++
$(UCOREIMG): $(kernel) $(bootblock)
	$(V)dd if=/dev/zero of=$@ count=10000 bs=512
	$(V)dd if=$(bootblock) of=$@ conv=notrunc
	$(V)dd if=$(kernel) of=$@ seek=1 conv=notrunc

$(call rule_create_target,ucore.img)

# +++ create swap.img +++
$(SWAPIMG):
	$(V)dd if=/dev/zero of=$@ bs=1M count=128

$(call rule_create_target,swap.img)

# +++ create sfs.img +++
$(foreach p,$(USER_BINS),$(eval $(call fscopy,$(p),$(SLASH))))

$(SFSROOT):
	$(V)mkdir $@

$(SFSIMG): $(SFSROOT) $(SFSBINS) | $(call to_out_target,mksfs)
	$(V)dd if=/dev/zero os=$@ bs=1M count=128
	@$(call to_out_target,mksfs) $@ $(SFSROOT)

$(call rule_create_target,sfs.img)

# +++ finish +++
$(call rule_finish_all)

# +++ qemu +++
.PHONY: qemu qemu-nox debug debug-nox monitor lines

qemu: $(UCOREIMG) $(SWAPIMG) $(SFSIMG)
	$(V)$(QEMU) -serial stdio $(QEMUOPTS) -serial null

qemu-nox: $(UCOREIMG) $(SWAPIMG) $(SFSIMG)
	$(V)$(QEMU) -serial mon:stdio $(QEMUOPTS) -nographic

debug: $(UCOREIMG) $(SWAPIMG) $(SFSIMG)
	$(V)$(QEMU) -S -s -parallel stdio $(QEMUOPTS) -serial null &
	$(V)sleep 2
	$(V)$(TERMINAL) -e "$(GDB) -q -x tools/gdbinit"

debug-bootblock: $(bootblock)
	$(V)$(QEMU) -S -s -serial mon:stdio -hda out/bin/bootblock -nographic &
	sleep 1
	$(TERMINAL) -e "gdb -q -x tools/gdbinit"

debug-nox: $(UCOREIMG) $(SWAPIMG) $(SFSIMG)
	$(V)$(QEMU) -S -s -parallel stdio $(QEMUOPTS) -nographic &
	$(V)sleep 2
	$(V)$(TERMINAL) -e "$(GDB) -q -x tools/gdbinit"

lines:
	@find -type f | grep -E 'c$$|h$$|S$$'| xargs wc | sort -k1 -n

clean:
	@-rm -r $(OUT_DIR)

################ build rules end ################

