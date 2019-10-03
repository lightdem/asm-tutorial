// uname.c
// LinuxPro Staff
// 05/10/2019
// x86_64
// compilabile con: gcc uname.c or gcc -g uname.c (debug)
// per eseguire:   ./a.out

#include <stdio.h>	        // dichiarazione di printf, perror
#include <stdlib.h>         // definisce EXIT_SUCCESS, EXIT_FAILURE
#include <sys/utsname.h>    // dichiarazione di uname, utsname

int main(void)
{
    struct utsname buffer;
    
    int retValue = uname(&buffer);
 
    if (retValue != 0)
    {
        perror("uname");
        exit(EXIT_FAILURE);
    }
    
    printf("\n");
    printf("Nome OS:   %s\n",   buffer.sysname);
    printf("Nome nodo: %s\n",   buffer.nodename);
    printf("Release:   %s\n",   buffer.release);
    printf("Versione:   %s\n",   buffer.version);
    printf("Macchina:   %s\n\n", buffer.machine);
    return EXIT_SUCCESS;
}
   