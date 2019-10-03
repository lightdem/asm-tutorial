#!/bin/bash
#############################################################################
# maketest.sh
# 	LinuxPro Staff
# 	05/10/2019
#
# Uno script di supporto ai makefile per gestire debuggare e rilasciare i makefile
# usando la stessa fonte, oggetti e file eseguibili.
# Nei Makefile usare:  @source ../maketest.sh && test release debug (release)
#					@source ../maketest.sh && test debug release (debug)
# Invocare Makefile con make relase, make debug o make clean.
#
#############################################################################
function test()
{
	if [[ ! -f $1 ]]; then
		touch $1;	
		rm -f $2;
    else
        touch $1;
	fi
}
#############################################################################
