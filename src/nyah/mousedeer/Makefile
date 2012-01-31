.PHONY: default build clean

subdirs = . teg teg/detail teg/beard teg/beard/meta teg/beard/string_util \
		    parser
comp_args = -I. -Iteg

default: build

include teg/beard/Makefile

# gdc ?= 1
build: mousedeer

mousedeer: main.d ${libfiles}
	@mkdir -p ${O}
	${dmd} ${comp_args} -I.. -od${O} -of$@ $^

clean:
	rm -rf ${O} mousedeer
