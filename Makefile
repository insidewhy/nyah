.PHONY: backup

include mk/Makefile

BACKUP_EXCLUDE += doc/research_docs doc/internet_docs src/obj

backup: backupFiles
