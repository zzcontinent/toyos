################ variables start ################
# +++ cc +++
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

# +++ compile out targets +++
BINDIR := bin
OBJDIR := obj
ALLOBJS :=
ALLDEPS :=
TARGETS :=

# +++ user program out +++
USER_PREFIX := __user_
USER_BINS :=
UOBJS := $(call read_packet,ulibs)

# +++ kernel include +++
INCLUDE += libs/
CFLAGS += $(addprefix -I,$(INCLUDE))
LIBDIR += libs
KSRCDIR += $(shell find kern * -type d)
KINCLUDE = $(KSRCDIR)
KCFLAGS += $(addprefix -I,$(KINCLUDE))
kernel = $(call totarget,kernel)
KOBJS = $(call read_packet,kernel libs)


# +++ user include +++
UINCLUDE += user/include/ \
	    user/libs/
USRCDIR += user
ULIBDIR += user/libs
UCFLAGS += $(addprefix -I,$(UINCLUDE))

# +++ boot +++
bootfiles = $(call listf_cc,boot)
bootblock = $(call totarget,bootblock)
################ variables end ################

################ function start ################
include tools/function.mk

# for cc
listf_cc = $(call listf,$(1),$(CTYPE))
add_files_cc = $(call add_files,$(1),$(CC),$(CFLAGS),$(3),$(2),$(4))
create_target_cc = $(call create_target,$(1),$(2),$(3),$(CC),$(CFLAGS))

# for hostcc
add_files_host = $(call add_files,$(1),$(HOSTCC),$(HOSTCFLAGS),$(2),$(3))
create_target_host = $(call create_target,$(1),$(2),$(3),$(HOSTCC),$(HOSTCFLAGS)))

# generate out files functions
swaptype = $(patsubst %.$(2),%.$(3),$(1))
objfile = $(call toobj,$(1))
asmfile = $(call swaptype,$(call objfile,$(1)),o,asm)
outfile = $(call swaptype,$(call objfile,$(1)),o,out)
symfile = $(call swaptype,$(call objfile,$(1)),o,sym)
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

################ function end ################

################ build rules start ################
# +++ user +++
$(call add_files_cc,$(call listf_cc,$(ULIBDIR)),ulibs,$(UCFLAGS))
$(call add_files_cc,$(call listf_cc,$(USRCDIR)),uprog,$(UCFLAGS))
$(foreach p,$(call read_packet,uprog),$(eval $(call user_prog_ld,$(p))))

# +++ kernel +++
$(call add_files_cc,$(call listf_cc,$(LIBDIR)),libs)
$(kernel): tools/kernel.ld

$(kernel): $(KOBJS)
	@echo +ld $@
	$(V)$(LD) $(LDFLAGS) -T tools/kernel.ld -o $@ $(KOBJS)
	@$(OBJDUMP) -S $@ > $(call asmfile,kernel)
	@$(OBJDUMP) -t $@ | sed '1,/SYMBOL TABLE/d; s/ .* / /; /^$$/d' > $(call symfile,kernel)

$(call create_target,kernel)

# +++ bootblock +++
$(foreach f,$(bootfiles),$(call cc_compile,$(f),$(CC),$(CFLAGS),-Os -nostdinc))

$(bootblock): $(call toobj,boot/bootasm.S) $(call toobj,$(bootfiles)) | $(call totarget,sign)
	@echo + ld @
	$(V)$(LD) $(LDFLAGS) -N -T tools/boot.ld $^ -o$(call toobj,bootblock)
	@$(OBJDUMP) -S $(call objfile,bootblock) > $(call asmfile,bootblock)
	@$(OBJCOPY) -S -O binary $(call objfile,bootblock) $(call outfile,bootblock)
	$(call totarget,sign) $(call outfile,bootblock) $(bootblock)


################ build rules end ################






