.PHONY: test clean default

O := .obj
compile_with_gdc := 1
debug := 1

subdirs := teg teg/detail beard
libfiles := $(foreach d,${subdirs},$(wildcard ${d}/*.d))

default: mousedeer

test: ${O}/test
	./$<

clean:
	rm -rf ${O}

ifeq (${compile_with_gdc}, 1)

##############################################################################
# gdc build
comp_args := $(if debug,-g2)
objdirs := $(addprefix ${O}/,${libdirs})
objfiles := $(addprefix ${O}/,$(patsubst %.d,%.o,${libfiles}))

mousedeer: ${O}/main.o ${objfiles}
	gdc ${comp_args} $< ${objfiles} -o $@

${O}/test: ${O}/test.o ${objfiles}
	gdc ${comp_args} $< ${objfiles} -o $@

${O}/%.o: %.d
	@mkdir -p $(dir $@)
	gdc ${comp_args} -c -o $@ $<

else
##############################################################################
# dmd build
comp_args := $(if ${debug},-g -debug)

mousedeer: main.d ${libfiles}
	@mkdir -p ${O}
	dmd ${comp_args} -od${O} -of$@ $^

${O}/test: test.d ${libfiles}
	@mkdir -p ${O}
	dmd ${comp_args} -od${O} -of$@ $^

endif
