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
# $(OUT_TARGETDIR)/ to $(1)
# (filename, prefix_dir) -> $(OUT_TARGETDIR)/prefix_dir/filename
to_out_target = $(addprefix $(OUT_TARGETDIR)$(SLASH)$(2),$(1))

# -------------------------------------------------------------------------
# cc compile template, generate rule for dep, obj:
# (target, file, cc[, flags])
define template_cc_file
ALLOBJS_$(1) += $$(call to_out_obj,$(2))
ALLOBJS += $$(call to_out_obj,$(2))
$$(call to_out_dep,$(2)): $(2) | $$$$(dir $$$$@)
	@echo "[CC] [$$@] : $$^"
	$(V)$(3) -I$$(dir $(2)) $(4) -MM $$< -MT "$$(patsubst %.d,%.o,$$@) $$@" > $$@
$$(call to_out_obj,$(2)): $(2) | $$$$(dir $$$$@)
	@echo "[CC] [$$@] : $$^"
	$(V)$(3) -I$$(dir $(2)) $(4) -c $$< -o $$@
endef

# -------------------------------------------------------------------------
# compile file
# (target, #files, cc[,flags])
define template_cc_files
$$(foreach f,$(2),$$(eval $$(call template_cc_file,$(1),$$(f),$(3),$(4))))
endef

# -------------------------------------------------------------------------
# compile file
# (target, #files, cc[, flags])
rule_compile_files = $(eval $(call template_cc_files,$(1),$(2),$(3),$(4)))
# (target, #files)
rule_compile_files_cc = $(call rule_compile_files,$(1),$(2),$(CC),$(CFLAGS))
# (target, #files)
rule_compile_files_hostcc = $(call rule_compile_files,$(1),$(2),$(HOSTCC),$(HOSTCFLAGS))
# -------------------------------------------------------------------------
# add packet and objs to target
# (target, #obj, cc, [, flags])
define template_link_objs
$$(call to_out_target,$(1)): $(2) | $$$$(dir $$$$@)
	@echo "[LD] [$$@] : $$^"
	$(V)$(3) $(4) $$^ -o $$@
endef

# (target, #obj, cc, [, flags])
rule_link_objs = $(eval $(call template_link_objs,$(1),$(2),$(3),$(4)))
# (target, #objs)
rule_link_objs_cc = $(call rule_link_objs,$(1),$(2),$(CC),$(CFLAGS))
# (target, #objs)
rule_link_objs_hostcc = $(call rule_link_objs,$(1),$(2),$(HOSTCC),$(HOSTCFLAGS))
# (#obj_targets, #obj_libs, cc, [, flags])
rule_link_objs_to_targets = $(foreach  obj,$(1),$(call rule_link_objs,$(basename $(notdir $(obj))),$(obj) $(2),$(3),$(4)))

# -------------------------------------------------------------------------
# finish all
define tempalte_do_finish_all
$$(sort $$(dir $$(ALLOBJS)) $(OUT_TARGETDIR)$(SLASH) $(OUT_OBJDIR)$(SLASH)):
	@mkdir -p $$@
endef

rule_finish_all = $(eval $(call tempalte_do_finish_all))

# -------------------------------------------------------------------------
