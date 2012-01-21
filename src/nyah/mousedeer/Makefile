.PHONY: build test clean

# gdc ?= 1
debug ?= 1
cwd ?= .
O ?= ${cwd}/.obj
subdirs ?= teg teg/detail beard parser
libfiles ?= $(foreach d,$(addprefix ${cwd}/,${subdirs}),$(wildcard ${d}/*.d))

build: mousedeer

mousedeer: main.d ${libfiles}
	@mkdir -p ${O}
	${dmd} ${comp_args} -I.. -od${O} -of$@ $^

test:
	${MAKE} -C test

clean:
	rm -rf ${O} mousedeer

dmd := $(if ${gdc},gdmd,dmd)

comp_args := $(if ${debug},-g -debug,-release)
