.PHONY: test accept

outdir = .new.output
mousebear = ../.obj/mousebear/mousebear
mousebear_args = -n nyah.mousebear.grammar -o ${outdir}

test: nyah.out

%.out: %.nyah ${mousebear}
	@rm -rf ${outdir}
	@mkdir -p ${outdir}
	@${mousebear} ${mousebear_args} -p $< > ${outdir}/$@
	@for f in ${outdir}/*.out ; do diff `basename $$f` $$f || exit 1 ; done
	@touch *.out
	@rm ${outdir}/*.out
	@echo $< succeeded

accept:
	mv ${outdir}/* .
