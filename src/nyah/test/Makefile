.PHONY: test accept

outdir = .new.output
mousedeer = ../.obj/mousedeer/mousedeer
mousedeer_args = -n nyah.mousedeer.grammar -o ${outdir}

test: nyah.out

%.out: %.nyah ${mousedeer}
	@rm -rf ${outdir}
	@mkdir -p ${outdir}
	@${mousedeer} ${mousedeer_args} -p $< > ${outdir}/$@
	@for f in ${outdir}/*.out ; do diff `basename $$f` $$f || exit 1 ; done
	@touch *.out
	@rm ${outdir}/*.out
	@echo $< succeeded

accept:
	mv ${outdir}/* .
