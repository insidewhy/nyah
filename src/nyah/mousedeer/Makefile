subdirs := . teg teg/detail beard

mousedeer: $(foreach d,${subdirs},$(wildcard ${d}/*.d))
	dmd -debug -g -od.obj -of$@ $^

.PHONY: test
test: mousedeer
	./mousedeer
