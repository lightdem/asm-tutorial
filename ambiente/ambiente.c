// ambiente.c
// Linux Pro staff
// 07/12/2019
// x86_64
// assemblato da: yasm -f elf64 -g dwarf2 -o ambiente.obj ambiente.asm
// compilato e linkato con: gcc -g ambiente.c ambiente.obj -o ambiente
// per eseguire: ./ambiente

#include <time.h>       // dichiarazione di time; definizione di time_t
#include <string.h>     // dichiarazione di strtok

int stampaamb(const char* timestr);   // dichiarazione della fuznione asm

int main(void)
{
    time_t  now;

    time(&now);
    char* strTempo = strtok(ctime(&now), "\n");  // toglie il carattere di inizioriga da ctime
    return stampaamb(strTempo);   // chiama la funzione stampaamb con l'argomento strTempo
}
   