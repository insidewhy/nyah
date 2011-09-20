subdirs := . teg teg/detail beard

mousedeer: $(foreach d,${subdirs},$(wildcard ${d}/*.d))
	dmd -od.obj -of$@ $^
