default: backup
proj := $(shell basename $(shell dirname $(shell pwd)))

backup: 
	tar czf ${proj}.tar.gz --exclude ${proj}.tar.gz --exclude doc/internet_docs --exclude src/obj -C .. trunk
