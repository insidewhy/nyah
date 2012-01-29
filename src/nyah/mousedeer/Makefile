.PHONY: default build clean

subdirs = . teg teg/detail teg/beard parser
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
