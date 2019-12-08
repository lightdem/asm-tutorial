// rigacomando.c
// Linux Pro staff
// 07/12/2019
// x86_64
// compilabile con: gcc rigacomando.c or gcc -g rigacomando.c (debug)
// to execute:   ./a.out

#include <stdio.h>		// dichiariamo printf
#include <stdlib.h>		// definiamo EXIT_SUCCESS

int main(int argc, char* argv[])
{
	printf("\n");		// stampa una riga bianca
	printf("argc    =  %d\n", argc);	// stampa argc
	for (int i = 0; i < argc; i++)
	{
		printf("argv[%d] = %s\n", i, argv[i]);	// stampa argv[i]
	}
	printf("\n");		// stampa una riga bianca
	return EXIT_SUCCESS;
}
