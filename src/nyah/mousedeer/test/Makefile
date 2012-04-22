.SECONDARY:
.PHONY: default force misc function class

update ?= ${u}
outpath := output
cwd ?= ..
subdirs = teg teg/detail teg/beard teg/beard/meta teg/beard/string_util \
		  parser
comp_args := ../teg/test/common.d

default: misc function class

include ../teg/beard/Makefile

misc: ${outpath}/misc
function: ${outpath}/function
class: ${outpath}/class

${outpath}/%: %.nyah force
	@mkdir -p ${outpath}
	@${O}/mousedeer -v -das ./$< > $@.new
	@$(if ${update},rm -f $@,true)
	@if [ ! -f $@ ] ; then \
		echo "new test $(subst ${outpath}/,,$@)"; \
		mv $@.new $@; \
	elif diff $@ $@.new ; then \
		echo "test $(subst ${outpath}/,,$@) passed"; \
		rm $@.new; \
		touch $@; \
	else \
		echo "test $(subst ${outpath}/,,$@) failed"; \
	fi

force:
