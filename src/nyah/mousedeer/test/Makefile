.SECONDARY:
.PHONY: default tbpeg teg variant nyah choice joined force types llvm

update ?= ${u}
outpath := output
cwd ?= ..

ghc = ghc -odir ${O} -hidir ${O} -i../codegen -o

default: variant teg maths nyah choice joined

-include ../Makefile

tbpeg: ${outpath}/tbpeg
teg: ${outpath}/teg
maths: ${outpath}/maths
variant: ${outpath}/variant
nyah: ${outpath}/nyah
choice: ${outpath}/choice
joined: ${outpath}/joined
types: ${outpath}/types
llvm: ${outpath}/llvm
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

${O}/types: types.hs force
	@${ghc} $@ $<

${O}/llvm: llvm.hs force
	@${ghc} $@ $<
