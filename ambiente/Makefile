#############################################################################
#
#	Makefile per rigacomando
# 	LinuxPro Staff
#	08/12/2019
#
#	Comandi:  make release, make debug, make clean
#			   make = make release
#   Richiede:  ../maketest.sh
#
#############################################################################
PROG  := ambiente
SHELL := /bin/bash

release: $(PROG).asm Makefile
	@source ../maketest.sh && test release debug
	yasm -f elf64 -o $(PROG).obj -l $(PROG).lst $(PROG).asm
	gcc -no-pie $(PROG).c $(PROG).obj -o $(PROG)

debug: $(PROG).asm Makefile
	@source ../maketest.sh && test debug release
	yasm -f elf64 -g dwarf2 -o $(PROG).obj -l $(PROG).lst $(PROG).asm
	gcc -g -no-pie $(PROG).c $(PROG).obj -o $(PROG)

clean:
	@rm -f $(PROG) $(PROG).obj $(PROG).lst a.out debug release
#############################################################################
