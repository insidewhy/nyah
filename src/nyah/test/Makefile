.PHONY: test accept

mousebear = ../.obj/mousebear/mousebear

test: $(subst .nyah,.out,$(wildcard *.nyah))

%.out: %.nyah ${mousebear}
	@${mousebear} -p $< > $@.new
	@diff $@.new $@
	@touch $@
	@rm $@.new
	@echo $< succeeded 

accept:
	@$(foreach file,$(wildcard *.out.new), \
		mv ${file} $(patsubst %.out.new,%.out,${file}))
