.PHONY: test clean

# compile_with_gdc ?= 1
debug ?= 1
cwd ?= .
O ?= ${cwd}/.obj
subdirs ?= teg teg/detail beard
libfiles ?= $(foreach d,$(addprefix ${cwd}/,${subdirs}),$(wildcard ${d}/*.d))

# too early for anything but testing so test is first
test:
	${MAKE} -C test

mousedeer: main.d ${libfiles}
	@mkdir -p ${O}
	${dmd} ${comp_args} -od${O} -of$@ $^

clean:
	rm -rf ${O}

dmd := $(if ${compile_with_gdc},gdmd,dmd)

comp_args := $(if ${debug},-g -debug)
