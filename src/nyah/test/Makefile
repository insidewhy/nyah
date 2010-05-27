.PHONY: test accept

outdir = .new.output
mousebear = ../.obj/mousebear/mousebear
mousebear_args = -n nyah.mousebear.grammar -o ${outdir}

test: $(subst .nyah,.out,$(wildcard *.nyah))

%.out: %.nyah ${mousebear}
	@mkdir -p ${outdir}
	@${mousebear} ${mousebear_args} -p $< > ${outdir}/$@
	@diff $@ ${outdir}/$@
	@touch $@
	@rm ${outdir}/$@
	@echo $< succeeded

accept:
	mv ${outdir}/* .
