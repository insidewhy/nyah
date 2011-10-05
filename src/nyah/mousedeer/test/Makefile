.PHONY: default tbpeg teg variant force

outpath := output
cwd ?= ..

default: teg

-include ../Makefile

tbpeg: ${outpath}/tbpeg
teg: ${outpath}/teg
variant: ${outpath}/variant
force:

${outpath}/%: ${O}/% force
	@mkdir -p ${outpath}
	@./$< | tee $@.new
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
