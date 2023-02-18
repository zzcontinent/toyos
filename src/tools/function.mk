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
# (#files)
to_out_obj = $(addprefix $(OUT_OBJDIR)$(SLASH),$(addsuffix .o,$(basename $(1))))

# -------------------------------------------------------------------------
# (#files)
to_out_dep = $(patsubst %.o,%.d,$(call to_out_obj,$(1)))

# -------------------------------------------------------------------------
# (filename, prefix_dir) -> $(OUT_TARGETDIR)/prefix_dir/filename
to_out_target = $(addprefix $(OUT_TARGETDIR)$(SLASH)$(2),$(1))

# -------------------------------------------------------------------------
# (out_objs) -> only file basename
basename_clean = $(basename $(notdir $(1)))
basenames_clean = $(foreach obj,$(1),$(call basename_clean,$(obj)))

# -------------------------------------------------------------------------
# cc compile template, generate rule for dep, obj:
# (group, file, cc[, flags])
define template_complie_file
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
# (group, #files, cc[,flags])
define template_compile_files
$$(foreach f,$(2),$$(eval $$(call template_complie_file,$(1),$$(f),$(3),$(4))))
endef

# -------------------------------------------------------------------------
# compile file
# (group, #files, cc[, flags])
rule_compile_files = $(eval $(call template_compile_files,$(1),$(2),$(3),$(4)))
# (group, #files)
rule_compile_files_cc = $(call rule_compile_files,$(1),$(2),$(CC),$(CFLAGS))
# (group, #files)
rule_compile_files_hostcc = $(call rule_compile_files,$(1),$(2),$(HOSTCC),$(HOSTCFLAGS))
# -------------------------------------------------------------------------
# (group, target, #obj, cc, [, flags])
define template_link_objs
ALLTARGETS += $$(call to_out_target,$(2))
ALLTARGETS_$(1) += $$(call to_out_target,$(2))
$$(call to_out_target,$(2)): $(3) | $$$$(dir $$$$@)
	@echo "[LD] [$$@] : $$^"
	$(V)$(4) $(5) $$^ -o $$@
endef

# (group, #objs, #common_libs, cc, [, flags])
define template_link_objs_same_targets
$$(foreach obj,$(2),$$(eval $$(call template_link_objs,$(1),$$(call basename_clean,$$(obj)),$$(obj) $(3),$(4),$(5))))
endef

# (group, target, #objs, cc, [, flags])
rule_link_objs = $(eval $(call template_link_objs,$(1),$(2),$(3),$(4),$(5)))
# (group, #objs, #common_libs, cc, [, flags])
rule_link_objs_same_targets = $(eval $(call template_link_objs_same_targets,$(1),$(2),$(3),$(4),$(5)))
# (group, target, #objs)
rule_link_objs_cc = $(call rule_link_objs,$(1),$(2),$(CC),$(CFLAGS))
# (group, target, #objs)
rule_link_objs_hostcc = $(call rule_link_objs,$(1),$(2),$(3),$(HOSTCC),$(HOSTCFLAGS))

# -------------------------------------------------------------------------
# finish all
define tempalte_do_finish_all
$$(sort $$(dir $$(ALLTARGETS)) $$(dir $$(ALLOBJS)) $(OUT_TARGETDIR)$(SLASH) $(OUT_OBJDIR)$(SLASH)):
	@mkdir -p $$@
endef

rule_finish_all = $(eval $(call tempalte_do_finish_all))

# -------------------------------------------------------------------------
