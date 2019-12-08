#############################################################################
#
#	Makefile per rigacomando
# 	LinuxPro Staff
#	07/12/2019
#
#	Comandi:  make release, make debug, make clean
#			   make = make release
#   Richiede:  ../maketest.sh
#
#############################################################################
PROG  := rigacomando
SHELL := /bin/bash

release: $(PROG).asm Makefile
	@source ../maketest.sh && test release debug
	yasm -f elf64 -o $(PROG).obj $(PROG).asm
	gcc -m64 -no-pie $(PROG).obj -o $(PROG)
	gcc $(PROG).c

debug: $(PROG).asm Makefile
	@source ../maketest.sh && test debug release
	yasm -f elf64 -g dwarf2 -o $(PROG).obj $(PROG).asm
	gcc -m64 -g -no-pie $(PROG).obj -o $(PROG)
	gcc -g $(PROG).c

clean:
	@rm -f $(PROG) $(PROG).obj a.out debug release

#############################################################################
