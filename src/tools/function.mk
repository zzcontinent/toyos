OBJPREFIX := __objs_
SLASH := /
.SECONDEXPANSION:

# 1
# list all files in some directories
# (#directories, $types)
listf = $(filter $(if $(2),$(addprefix %.,$(2)),%), \
	$(wildcard $(addsuffix $(SLASH)*,$(1))))

# 2
# get .o obj files
# (#files[, packet])
toobj = $(addprefix $(OBJDIR)$(SLASH)$(if $(2),$(2)$(SLASH)),\
	$(addsuffix .o,$(basename $(1))))

# 3
# get .d dependency files
# (#files[,packet])
todep = $(patsubst %.o,%.d,$(call toobj,$(1),$(2)))

# 4
# add $(BINDIR)/ to $(1)
totarget = $(addprefix $(BINDIR)$(SLASH),$(1))

# 5
# change $(name) to $(OBJPREFIX)$(name)
# (#names)
packetname = $(if $(1),$(addprefix $(OBJPREFIX),$(1)),$(OBJPREFIX))

# 6
# cc compile template, generate rule for dep, obj:
# (file, cc[, flags, dir])
define cc_template
ALLOBJS += $$(call toobj,$(1),$(4))
$$(call todep,$(1),$(4)): $(1) | $$$$(dir $$$$@)
	@echo + cc deps $$<
	@$(V)$(2) -I$$(dir $(1)) $(3) -MM $$< -MT "$$(patsubst %.d,%.o,$$@) $$@" > $$@
$$(call toobj,$(1),$(4)): $(1) | $$$$(dir $$$$@)
	@echo + cc $$<
	@$(V)$(2) -I$$(dir $(1)) $(3) -c $$< -o $$@
endef

# 7
# compile file
# (#files, cc[,flags,dir])
define do_cc_compile
$$(foreach f,$(1),$$(eval $$(call cc_template,$$(f),$(2),$(3),$(4))))
endef

# 8
# add files to packet
# (#files, cc[,flags, packet, dir])
define do_add_files_to_packet
__temp_packet__ := $$(call packetname,$(4))
ifeq ($$(origin $$(__temp_packet__)),undefined)
$$(__temp_packet__) :=
endif
__temp_objs__ := $$(call toobj,$(1),$(5))
$$(foreach f,$(1),$$(eval $$(call cc_template,$$(f),$(2),$(3),$(5))))
$$(__temp_packet__) += $$(__temp_objs__)
endef

# 9
# add objs to packet
# (#objs, packet)
define do_add_objs_to_packet
__temp_packet__ := $(call packetname,$(2))
ifeq ($$(origin $$(__temp_packet__)),undefined)
$$(__temp_packet__) :=
endif
$$(__temp_packet__) += $(1)
endef

# 10
# add packet and objs to target
# (target, #packets, #objs, cc, [, flags])
define do_create_target
__temp_target__ = $$(call totarget,$(1))
__temp_objs__ = $$(foreach p,$$(call packetname,$(2)),$$($$(p))) $(3)
TARGETS += $$(__temp_target__)
ifneq ($(4),)
$$(__temp_target__): $$(__temp_objs__) | $$$$(dir $$$$@)
	$(V)$(4) $(5) $$^ -o $$@
else
$$(__temp_target__): $$(__temp_objs__) | $$$$(dir $$$$@)
endif
endef

# 11
# finish all
define do_finish_all
ALLDEPS = $$(ALLOBJS:.o=.d)
$$(sort $$(dir $$(ALLOBJS)) $(BINDIR)$(SLASH) $(OBJDIR)$(SLASH)):
	@mkdir -p $$@
endef

# 12
# compile file
# (#files, cc[, flags, dir])
cc_compile = $(eval $(call do_cc_compile,$(1),$(2),$(3),$(4)))

# 13
# add files to packet
# (#files, cc[, flags, packet, dir])
add_files = $(eval $(call do_add_files_to_packet,$(1),$(2),$(3),$(4),$(5)))

# 14
# add objs to packet
# (#objs, packet)
add_objs = $(eval $(call do_add_objs_to_packet,$(1),$(2)))

# 15
# add packets and objs to target
# (target, #packets, #objs, cc, [, flags])
create_target = $(eval $(call do_create_target,$(1),$(2),$(3),$(4),$(5)))

read_packet = $(foreach p,$(call packetname,$(1)),$($(p)))

add_dependency = $(eval $(1): $(2))

finish_all = $(eval $(call do_finish_all))









