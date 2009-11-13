.PHONY: install clean test
default:
	${MAKE} -C .obj

install:
	${MAKE} -C .obj install

reconfigure:
	rm -rf .obj.old
	mv .obj .obj.old
	./.obj.old/reconfigure
	rm -rf .obj.old

clean:
	rm -rf .obj Makefile

ifeq ($(wildcard test/Makefile),)
test:
	${MAKE} -C .obj test
else
test:
	${MAKE} -C test test
endif

uninstall:
	${MAKE} -C .obj uninstall
