OBJPREFIX := __objs_
SLASH := /
.SECONDEXPANSION:

# -------------------------------------------------------------------------
# list all files in some directories
# (#directories, $types)
listf = $(filter $(if $(2),$(addprefix %.,$(2)),%), \
	$(wildcard $(addsuffix $(SLASH)*,$(1))))

# (#directories, $types)
listf_cc = $(call listf,$(1),$(CTYPE))

# -------------------------------------------------------------------------
# get .o obj files
# (#files)
to_out_obj = $(addprefix $(OUT_OBJDIR)$(SLASH),$(addsuffix .o,$(basename $(1))))

# -------------------------------------------------------------------------
# get .d dependency files
# (#files)
to_out_dep = $(patsubst %.o,%.d,$(call to_out_obj,$(1)))

# -------------------------------------------------------------------------
# add $(OUT_TARGETDIR)/ to $(1)
to_out_target = $(addprefix $(OUT_TARGETDIR)$(SLASH),$(1))

# -------------------------------------------------------------------------
# cc compile template, generate rule for dep, obj:
# (file, cc[, flags])
define template_cc
ALLOBJS += $$(call to_out_obj,$(1))
ALLDEPS += $$(call to_out_dep,$(1))
$$(call to_out_dep,$(1)): $(1) | $$$$(dir $$$$@)
	@echo + cc deps $$<
	@$(V)$(2) -I$$(dir $(1)) $(3) -MM $$< -MT "$$(patsubst %.d,%.o,$$@) $$@" > $$@
$$(call to_out_obj,$(1)): $(1) | $$$$(dir $$$$@)
	@echo + cc $$<
	@$(V)$(2) -I$$(dir $(1)) $(3) -c $$< -o $$@
endef

# -------------------------------------------------------------------------
# compile file
# (#files, cc[,flags])
define template_cc_batch
$$(foreach f,$(1),$$(eval $$(call template_cc,$$(f),$(2),$(3))))
endef

# -------------------------------------------------------------------------
# compile file
# (#files, cc[, flags])
rule_compile_files = $(eval $(call template_cc_batch,$(1),$(2),$(3)))
# (#files)
rule_compile_files_cc = $(call rule_compile_files,$(1),$(CC),$(CFLAGS))
# (#files)
rule_compile_files_hostcc = $(call rule_compile_files,$(1),$(HOSTCC),$(HOSTCFLAGS))
# -------------------------------------------------------------------------
# add packet and objs to target
# (target, #objs, cc, [, flags])
define template_do_create_target
ifneq ($(3),)
$$(call to_out_target,$(1)): $$(call to_out_obj,$(2)) | $$$$(dir $$$$@)
	$(V)$(3) $(4) $$^ -o $$@
else
$$(call to_out_target,$(1)): $$(call to_out_obj,$(2)) | $$$$(dir $$$$@)
endif
endef

# (target, #objs, cc, [, flags])
rule_create_target = $(eval $(call template_do_create_target,$(1),$(2),$(3),$(4)))
# (target, #objs)
rule_create_target_cc = $(call rule_create_target,$(1),$(2),$(CC),$(CFLAGS))
# (target, #objs)
rule_create_target_host = $(call rule_create_target,$(1),$(2),$(HOSTCC),$(HOSTCFLAGS))
# -------------------------------------------------------------------------
# finish all
define tempalte_do_finish_all
$$(sort $$(dir $$(ALLOBJS)) $(OUT_TARGETDIR)$(SLASH) $(OUT_OBJDIR)$(SLASH)):
	@mkdir -p $$@
endef

rule_finish_all = $(eval $(call tempalte_do_finish_all))

# -------------------------------------------------------------------------
