.PHONY: test accept

outdir = .new.output
mousedeer = ../.obj/mousedeer/mousedeer

test: nyah.out

nyah.out: nyah.nyah grammar.nyah ${mousedeer}

%.out:
	@rm -rf ${outdir}
	@mkdir -p ${outdir}
	@${mousedeer} ${mousedeer_args} -I. -p -o ${outdir} $< > ${outdir}/$@
	@for f in ${outdir}/*.out ; do diff `basename $$f` $$f || exit 1 ; done
	@touch $@
	@rm ${outdir}/*.out
	@echo $< succeeded

accept:
	mv ${outdir}/* .
