subdirs := . teg teg/detail

mousedeer: $(foreach d,${subdirs},$(wildcard ${d}/*.d))
	dmd -od.obj -of$@ $^
