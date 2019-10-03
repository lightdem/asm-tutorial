#############################################################################
#
#	Makefile per invocare i make nelle sottocartelle
# 	LinuxPro Staff
# 	05/10/2019
#
#	Comandi:  make release, make debug, make clean
#			   make = make release
#
#############################################################################
SUBDIRS := $(wildcard */.)
SHELL   := /bin/bash

.PHONEY: clean debug release

define submake
	@for dir in $(SUBDIRS);					\
	do										\
		echo;								\
		$(MAKE) $(1) --directory=$$dir;		\
	done
endef

release:
	$(call submake, release)
	@echo

debug:
	$(call submake, debug)
	@echo

clean:
	$(call submake, clean)

#############################################################################
