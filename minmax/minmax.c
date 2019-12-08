// minmax.c
// Linux Pro staff
// 08/12/2019
// x86_64
// per esguire:  ./a.out  arg1 arg2 (programma C standalone)
//              ./minmax arg1 arg2 (C con assembly)

#include <stdlib.h>     // dichiarazione di atol; definizione di EXIT_SUCCESS, EXIT_FAILURE
#include <stdio.h>      // dichiarazione di printf

#ifdef c_version    // se è definito c_version implementiamo queste funzioni e macro

    #define max(a, b) ((a) > (b) ? (a) : (b))   // macro C
    #define min(a, b) ((a) < (b) ? (a) : (b))   // macro C
    
    long stampaMax(long a, long b)       // implementiamo la funzione c stampaMax
    {
        printf("\nmax(%ld, %ld) = %ld\n\n", a, b, max(a, b));
    }

    long stampaMin(long a, long b)       // implementiamo la funzione c stampaMin
    {
        printf("\nmin(%ld, %ld) = %ld\n\n", a, b, min(a, b));
    }

#else   // se c_version non è definito dichiariamo queste funzioni esterne

    long stampaMax(long a, long b);      // dichiariamo la funzione esterna stampaMax
    long stampaMin(long a, long b);      // dichiariamo la funzione esterna stampaMin

#endif    

int main(int argc, char* argv[])
{
    if (argc == 3)  // prendiamo gli argomenti da riga di comando e verifichiamo che siano giusti
    {
        long a = atol(argv[1]);
        long b = atol(argv[2]);
        stampaMax(a, b);
        stampaMin(a, b);
        return EXIT_SUCCESS;
    }
    else
    {
        printf("UTILIZZO: Per favore inserire 2 integer sulla riga di comando"
               " dopo il nome del programma.\n\n");
        return EXIT_FAILURE;
    }
}
   