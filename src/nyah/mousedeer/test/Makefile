.SECONDARY:
.PHONY: default tbpeg teg variant nyah force

update ?= ${u}
outpath := output
cwd ?= ..

default: variant teg maths nyah

-include ../Makefile

tbpeg: ${outpath}/tbpeg
teg: ${outpath}/teg
maths: ${outpath}/maths
variant: ${outpath}/variant
nyah: ${outpath}/nyah
force:

${outpath}/%: ${O}/% force
	@mkdir -p ${outpath}
	@./$< | tee $@.new
	@$(if ${update},rm -f $@,true)
	@if [ ! -f $@ ] ; then \
		echo "new test $(subst ${outpath}/,,$@)"; \
		mv $@.new $@; \
	elif diff $@ $@.new ; then \
		echo "test $(subst ${outpath}/,,$@) passed"; \
		rm $@.new; \
	else \
		echo "test $(subst ${outpath}/,,$@) failed"; \
	fi

${O}/%: %.d ${libfiles}
	@mkdir -p ${O}
	${dmd} -I../.. ${comp_args} -od${O} -of$@ common.d $^
