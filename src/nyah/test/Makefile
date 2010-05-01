.PHONY: default

mousebear = ../.obj/mousebear/mousebear

default: $(subst .nyah,.out,$(wildcard *.nyah))

%.out: %.nyah ${mousebear}
	@${mousebear} -p $< > $@.new
	@diff $@.new $@
	@touch $@
	@echo $< succeeded 

