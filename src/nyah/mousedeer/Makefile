.PHONY: test clean default

O := .obj
# compile_with_gdc := 1
debug := 1

subdirs := teg teg/detail beard
libfiles := $(foreach d,${subdirs},$(wildcard ${d}/*.d))

# too early for anything but testing
default: test
# default: mousedeer

test: ${O}/test
	./$<

clean:
	rm -rf ${O}

dmd := $(if ${compile_with_gdc},gdmd,dmd)

comp_args := $(if ${debug},-g -debug)

mousedeer: main.d ${libfiles}
	@mkdir -p ${O}
	${dmd} ${comp_args} -od${O} -of$@ $^

${O}/test: test.d ${libfiles}
	@mkdir -p ${O}
	${dmd} ${comp_args} -od${O} -of$@ $^
