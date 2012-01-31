.SECONDARY:
.PHONY: default nyah types llvm

update ?= ${u}
outpath := output
cwd ?= ..
subdirs = teg teg/detail teg/beard teg/beard/meta teg/beard/string_util \
		  parser
comp_args := ../teg/test/common.d

default: nyah

include ../teg/beard/Makefile
include ../teg/beard/Makefile.test

nyah: ${outpath}/nyah

${O}/types: types.hs force
	@${ghc} $@ $<

${O}/llvm: llvm.hs force
	@${ghc} $@ $<
