.PHONY: build test install clean

default: build

mousedeer_path = src/nyah/mousedeer
-include Makefile.local

build:
	${MAKE} -C ${mousedeer_path}

test:
	${MAKE} -C ${mousedeer_path} $@

install:
	${MAKE} -C ${mousedeer_path} $@

clean:
	${MAKE} -C ${mousedeer_path} $@

