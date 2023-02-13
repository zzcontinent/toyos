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
CFLAGS += -I.
CTYPE := c S

LD := $(GCCPREFIX)ld
LDFLAGS := -m $(shell $(LD) -V | grep elf_i386 2>/dev/null | head -n 1| tr -d ' ')
LDFLAGS += -nostdlib

OBJCOPY := $(GCCPREFIX)objcopy
OBJDUMP := $(GCCPREFIX)objdump

#TERMINAL := gnome-terminal
TERMINAL := terminator

OUT_DIR := out/
OUT_TARGETDIR := $(OUT_DIR)target
OUT_OBJDIR := $(OUT_DIR)obj
OUT_TOOLDIR := $(OUT_DIR)tools

LIBDIR := libs
KSRCDIR := $(shell find kern/* -type d)

BOOT_OPTIMIZE := -Os
KERNEL_OPTIMIZE := -O0
BOOT_CFLAGS = $(CFLAGS) $(BOOT_OPTIMIZE)
KERNEL_CFLAGS = $(CFLAGS) $(KERNEL_OPTIMIZE)

bootfiles = $(call listf_cc,boot)
rootfs_path = $(call to_out_target,disk0)
rootfs_bins =

target_bootblock = $(call to_out_target,bootblock)
target_kernel = $(call to_out_target,kernel)
target_os_img = $(call to_out_target,os.img)
target_rootfsimg = $(call to_out_target,rootfs.img)
target_swapimg = $(call to_out_target,swap.img)

USER_BINS :=
USER_SRCDIR := user
USER_LIBDIR := user/libs
USER_CFLAGS := $(CFLAGS)

QEMUOPTS = -hda $(target_os_img) -drive file=$(target_swapimg),media=disk,cache=writeback -drive file=$(target_rootfsimg),media=disk,cache=writeback -no-reboot

#***************************************common function****************************************************/
include tools/function.mk

# generate out files functions
swaptype = $(patsubst %.$(2),%.$(3),$(1))
asmfile = $(call swaptype,$(call to_out_obj,$(1)),o,asm)
symfile = $(call swaptype,$(call to_out_obj,$(1)),o,sym)
filename = $(basename $(notdir $(1)))

#***************************************rule default****************************************************/
all: $(target_bootblock) $(target_kernel)

#***************************************rule bootblock****************************************************/
$(call rule_compile_files,bootblock,$(bootfiles),$(CC),$(BOOT_CFLAGS) -nostdinc)

$(target_bootblock): $(ALLOBJS_bootblock) | $(call to_out_target,sign)
	@echo "[LD] [$@] : $^"
	$(V)$(LD) $(LDFLAGS) -N -T tools/boot.ld $^ -o $(call to_out_target,boot)
	$(V)$(OBJCOPY) -S -O binary $(call to_out_target,boot) $(target_bootblock)
	$(V)$(call to_out_target,sign) $(target_bootblock) $(target_bootblock)


#***************************************rule kernel****************************************************/
$(call rule_compile_files,kernel,$(foreach d,$(KSRCDIR),$(call listf_cc,$(d))),$(CC),$(KERNEL_CFLAGS))
$(call rule_compile_files,kernel,$(call listf_cc,$(LIBDIR)),$(CC),$(KERNEL_CFLAGS))

$(target_kernel): $(call to_out_obj,kern/init/entry) $(ALLOBJS_kernel)
	@echo "[LD] [$@] : $^"
	$(V)$(LD) $(LDFLAGS) -T tools/kernel.ld -o $@ $^

#***************************************rule images****************************************************/
$(target_os_img): $(target_kernel) $(target_bootblock)
	$(V)dd if=/dev/zero of=$@ count=10000
	$(V)dd if=$(target_bootblock) of=$@ conv=notrunc
	$(V)dd if=$(target_kernel) of=$@ seek=1 conv=notrunc

$(target_rootfsimg): $(rootfs_path) $(rootfs_bins) | $(call to_out_target,mksfs)
	$(V)dd if=/dev/zero of=$@ bs=1M count=128
	$(V)$(call to_out_target,mksfs) $@ $(rootfs_path)

$(target_swapimg):
	$(V)dd if=/dev/zero of=$@ bs=1M count=128

$(rootfs_path):
	$(V)mkdir -p $@

#***************************************rule user****************************************************/

define user_prog_ld
USER_BINS += $(1)
$$(__user_bin__): tools/user.ld
$$(__user_bin__): $$(UOBJS)
$$(__user_bin__): $(1) | $$$$(dir $$$$@)
	$(V)$(LD) $(LDFLAGS) -T tools/user.ld -o $$@ $$(UOBJS) $(1)
	$(V)$(OBJDUMP) -S $$@ > $$(call swaptype,$$<,o,asm)
	$(V)$(OBJDUMP) -t $$@ | sed '1,/SYMBOL TABLE/d; s/ .* / /; /^$$$$/d' > $$(call swaptype,$$<,o,sym)
endef

# +++ rootfs copy +++
define fscopy
__fs_bin__ := $(2)$(SLASH)$(patsubst %,%,$(basename $(notdir $(1))))
rootfs_bins += $$(__fs_bin__)
$$(__fs_bin__): $(1) | $$$$(dir $@)
	@cp $$< $$@
endef


# +++ create rootfs.img +++
$(foreach p,$(user_bins),$(eval $(call fscopy,$(p),$(SLASH))))

# UOBJS := $(call read_packet,ulibs)
$(call rule_compile_files,user,$(call listf_cc,$(USER_SRCDIR)),$(CC),$(USER_CFLAGS))

#***************************************rule tools****************************************************/
# +++ sign tools +++
$(call rule_compile_files_hostcc,sign,tools/sign.c)
$(call rule_link_objs_hostcc,sign,$(call to_out_obj,tools/sign))

# +++ mkfs tools +++
$(call rule_compile_files_hostcc,mksfs,tools/mksfs.c)
$(call rule_link_objs_hostcc,mksfs,$(call to_out_obj,tools/mksfs))

objdump:
	@-for f in `ls out/target`;\
	do\
		$(OBJDUMP) -S out/target/$${f} 2>/dev/null > out/target/$${f}.asm;\
		[ `cat out/target/$${f}.asm|wc -c` -eq 0 ] && rm out/target/$${f}.asm;\
		$(OBJDUMP) -t out/target/$${f} 2>/dev/null | sed '1,/SYMBOL TABLE/d; s/ .* / /; /^$$$$/d' > out/target/$${f}.sym;\
		[ `cat out/target/$${f}.sym|wc -c` -eq 0 ] && rm out/target/$${f}.sym;\
	done


qemu: $(target_os_img) $(target_swapimg) $(target_rootfsimg)
	$(V)$(QEMU) -serial stdio $(QEMUOPTS) -parallel null

qemu-nox: $(target_os_img) $(target_swapimg) $(target_rootfsimg)
	make qemukill
	$(V)$(QEMU) -serial mon:stdio $(QEMUOPTS) -nographic

debug: $(target_os_img) $(target_swapimg) $(target_rootfsimg)
	$(V)$(QEMU) -S -s -parallel stdio $(QEMUOPTS) -serial null &
	$(V)sleep 2
	$(V)$(TERMINAL) -e "$(GDB) -q -x tools/gdbinit"

debug-nox: $(target_os_img) $(target_swapimg) $(target_rootfsimg)
	make qemukill
	$(V)$(QEMU) -S -s -serial mon:stdio $(QEMUOPTS) -nographic > /dev/null &
	$(V)sleep 1
	$(V)$(TERMINAL) -e "$(GDB) -q -x tools/gdbinit"

debug-nox-bash: $(target_os_img) $(target_swapimg) $(target_rootfsimg)
	make qemukill
	$(V)$(QEMU) -S -s -serial mon:stdio $(QEMUOPTS) -nographic >/dev/null &
	$(V)sleep 1
	$(V)$(GDB) -q -x tools/gdbinit

qemukill:
	-@ps ax | grep qemu-system-i386 | grep -v grep | awk '{print $$1}' | xargs kill -9 2>/dev/null

lines:
	@find -type f | grep -E 'c$$|h$$|S$$'| xargs wc | sort -k1 -n

clean:
	@-rm -r $(OUT_DIR)/

log:
	make clean && make 2>&1 | less -p 'warn|err'

.PHONY: all qemu qemu-nox debug debug-nox monitor lines objdump

#***************************************finish****************************************************/
$(call rule_finish_all)

