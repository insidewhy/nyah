subdirs := teg teg/detail beard

libfiles := $(foreach d,${subdirs},$(wildcard ${d}/*.d))

mousedeer: main.d ${libfiles}
	dmd -debug -g -od.obj -of$@ $^

.PHONY: test
.obj/test: test.d ${libfiles}
	dmd -debug -g -od.obj -of$@ $^

test: .obj/test
	./$<
