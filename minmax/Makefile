#############################################################################
#
#	Makefile per minmax
# 	LinuxPro Staff
#	08/12/2019
#
#	Comandi:  make release, make debug, make clean
#			   make = make release
#   Richiede:  ../maketest.sh
#
#	Fa il build in due versioni di minmax.c:  a.out  - solo c
#									   minmax - c e assembly
#############################################################################
PROG  := minmax
SHELL := /bin/bash

release: $(PROG).asm Makefile
	@source ../maketest.sh && test release debug
	yasm -f elf64 -o $(PROG).obj -l $(PROG).lst $(PROG).asm
	gcc -m64 -no-pie $(PROG).c $(PROG).obj -o $(PROG)
	gcc -D c_version $(PROG).c

debug: $(PROG).asm $(PROG).c Makefile
	@source ../maketest.sh && test debug release
	yasm -f elf64 -g dwarf2 -o $(PROG).obj -l $(PROG).lst $(PROG).asm
	gcc -m64 -g -no-pie $(PROG).c $(PROG).obj -o $(PROG)
	gcc -g -D c_version $(PROG).c

clean:
	@rm -f $(PROG) $(PROG).obj $(PROG).lst a.out debug release
#############################################################################
