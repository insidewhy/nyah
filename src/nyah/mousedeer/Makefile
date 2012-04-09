.PHONY: default build clean

include bustin/mk/flags.mk

subdirs = . teg teg/detail teg/beard teg/beard/meta teg/beard/string_util \
		    parser bustin/capi bustin
comp_args = -I. -Iteg -debug ${llvm_link}

default: build

include teg/beard/Makefile

# gdc ?= 1
build: ${O}/mousedeer

${O}/mousedeer: main.d source_files.d code_generator.d \
				global_symbol_table.d object_module.d ${libfiles}
	${MAKE} -C bustin
	@mkdir -p ${O}
	${dmd} ${comp_args} -I.. -od${O} -of$@ $^

clean:
	rm -rf ${O} mousedeer
