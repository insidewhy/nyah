.PHONY: default force

mousebear = ../.obj/mousebear/mousebear

default: $(subst .nyah,.out,$(wildcard *.nyah))

force:

%.out: %.nyah force
	@${mousebear} -p $< > $@.new
	@diff $@.new $@
	@touch $@
	@echo $< succeeded 

