#############################################################################
#
#	Makefile per ciao
# 	LinuxPro Staff
# 	05/10/2019
#
#	Comandi:  make release, make debug, make clean
#			   make = make release
#   Richiede:  ../maketest.sh
#
#############################################################################
PROG  := ciao
SHELL := /bin/bash

release: $(PROG).asm Makefile
	@source ../maketest.sh && test release debug
	yasm -f elf64 -o $(PROG).obj $(PROG).asm	# assembla
	ld $(PROG).obj -o $(PROG)	# collega
	gcc $(PROG).c	# compila e collega la versione C (a.out)

debug: $(PROG).asm Makefile
	@source ../maketest.sh && test debug release
	yasm -f elf64 -g dwarf2 -o $(PROG).obj $(PROG).asm	# assembla
	ld -g $(PROG).obj -o $(PROG)	# collega
	gcc -g $(PROG).c	# compila e collega la versione C (a.out)

clean:
	@rm -f $(PROG) $(PROG).obj a.out debug release
#############################################################################
