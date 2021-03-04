OBJPREFIX := __objs_
SLASH := /
.SECONDEXPANSION:

# list all files in some directories
# (#directories, $types)
listf = $(filter $(if $(2),$(addprefix %.,$(2)),%), \
	$(wildcard $(addsuffix $(SLASH)*,$(1))))

# get .o obj files
# (#files)
toobj = $(addprefix $(OBJDIR)$(SLASH),$(addsuffix .o,$(basename $(1))))

# get .d dependency files
# (#files)
todep = $(patsubst %.o,%.d,$(call toobj,$(1)))

# add $(BINDIR)/ to $(1)
tobin = $(addprefix $(BINDIR)$(SLASH),$(1))

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

# compile file
# (#files, cc[,flags,dir])
define cc_template_batch
$$(foreach f,$(1),$$(eval $$(call cc_template,$$(f),$(2),$(3),$(4))))
endef

# compile file
# (#files, cc[, flags, dir])
cc_compile = $(eval $(call cc_template_batch,$(1),$(2),$(3),$(4)))

# 10
# add packet and objs to bin
# (bin, #packets, #objs, cc, [, flags])
define do_create_bin
__temp_bin__ = $$(call tobin,$(1))
__temp_objs__ = $$(foreach p,$$(call packetname,$(2)),$$($$(p))) $(3)
ifneq ($(4),)
$$(__temp_bin__): $$(__temp_objs__) | $$$$(dir $$$$@)
	$(V)$(4) $(5) $$^ -o $$@
else
$$(__temp_bin__): $$(__temp_objs__) | $$$$(dir $$$$@)
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

# 14
# add objs to packet
# (#objs, packet)
add_objs = $(eval $(call do_add_objs_to_packet,$(1),$(2)))

# 15
# add packets and objs to bin
# (bin, #packets, #objs, cc, [, flags])
create_bin = $(eval $(call do_create_bin,$(1),$(2),$(3),$(4),$(5)))

read_packet = $(foreach p,$(call packetname,$(1)),$($(p)))

add_dependency = $(eval $(1): $(2))

finish_all = $(eval $(call do_finish_all))









