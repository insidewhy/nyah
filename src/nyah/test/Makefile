.PHONY: test accept

mousebear = ../.obj/mousebear/mousebear
outdir = .new.output

test: $(subst .nyah,.out,$(wildcard *.nyah))

%.out: %.nyah ${mousebear}
	@mkdir -p ${outdir}
	@${mousebear} -o ${outdir} -p $< > ${outdir}/$@
	@diff $@ ${outdir}/$@
	@touch $@
	@rm ${outdir}/$@
	@echo $< succeeded

accept:
	mv ${outdir}/* .
