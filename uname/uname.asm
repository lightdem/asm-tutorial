;============================================================================
; uname.asm - recupera le informazioni di uname dal kernel e le stampa
; LinuxPro Staff
; 05/10/2019
; linux x86_64
; yasm -f elf64 -g dwarf2 -o uname.obj uname.asm
; ld -g uname.obj -o uname
;============================= DEFINIZIONI DELLE COSTANTI =========================
STDOUT          equ      1          ; file descriptor per il terminale
SYS_EXIT        equ     60          ; numero del servizio kernel SYS_EXIT
SYS_WRITE       equ      1          ; numero del servizio kernel SYS_WRITE
SYS_UNAME       equ     63          ; numero del servizio kernel SYS_UNAME
UTSNAME_SIZE    equ     65          ; numbero di byte in ogni riga *_res
HEADER_SIZE     equ     11          ; dimensione di ogni header
WRITELINE_SIZE  equ      1          ; numero di byte da scrivere per il fine riga
LF              equ     10          ; Carattere ASCII di avanzamento riga
ZERO            equ      0          ; il numero 0
;================================ SEZIONE DEL CODICE ==============================
section     .text
global      _start                  ; ld si apsetta di trovare l'etichetta _start

_start:				    	        ; l'inizio del programma
    mov	    rax, SYS_UNAME          ; prepariamo alla chiamata SYS_UNAME
    lea 	rdi, [sysname_res]      ; RDI punta all'indirizzo della struttura
    syscall                     	; chiamiamo SYS_UNAME per popolare la sezione .bss
    mov 	rdi, rax                ; se rax ritorna -1
    cmp 	rax, ZERO               ; lo inseriamo in rdi per dire all'OS che abbiamo fallito
    jnz 	exit                    ; usciamo se otteniamo errore da SYS_UNAME

    call    scriviNuovaRiga            ; scriviamo una riga bianca in stdout
    
    lea 	rsi, [sysname]          ; scriviamo l'header di sysname
    call 	scriviHeader             ; chiamiamo il metodo locale - print senza fine riga
    lea 	rsi, [sysname_res]      ; scriviamo i dati di sysname
    call 	scriviDati               ; chiamiamo il metodo locale - print con il fine riga
    
    lea 	rsi, [nodename]         ; scriviamo l'header di nodename
    call	scriviHeader
    lea 	rsi, [nodename_res]     ; scriviamo i dati di nodename
    call 	scriviDati

    lea 	rsi, [release]          ; scriviamo l'header di release
    call 	scriviHeader
    lea 	rsi, [release_res]      ; scriviamo i dati di release
    call 	scriviDati

    lea 	rsi, [version]          ; scriviamo l'header di version
    call 	scriviHeader
    lea 	rsi, [version_res]      ; scriviamo i dati di version
    call 	scriviDati

    lea 	rsi, [domain]           ; scriviamo l'header di domain
    call 	scriviHeader
    lea 	rsi, [domain_res]       ; scriviamo i dati di domain
    call 	scriviDati

    call    scriviNuovaRiga            ; scriviamo una riga vuota in stdout
    xor 	rdi, rdi       		    ; rdi = EXIT_SUCCESS

exit:						       
    mov 	rax, SYS_EXIT		    ; usciamo dal programma - 1° argomento rdi = codice di uscita
    syscall                     	; invochiamo il kernel e abbiamo fatto

scriviHeader:    ;===== metodo locale - il chiamante imposta il secondo parametro di SYS_WRITE =====
    mov 	rax, SYS_WRITE		    ; Id del servizio Linux
    mov 	rdi, STDOUT			    ; 1° argomento di SYS_WRITE
    mov 	rdx, HEADER_SIZE        ; 3° argomento di SYS_WRITE
    syscall					        ; invoca il kernel
    ret					            ;====== fine del metodo scriviHeader =====

scriviDati:      ;===== metodo locale - il chiamante imposta il secondo parametro di SYS_WRITE =====
    mov 	rax, SYS_WRITE		    ; Linux service ID
    mov 	rdi, STDOUT             ; 1° argomento di SYS_WRITE
    mov 	rdx, UTSNAME_SIZE       ; 3° argomento di SYS_WRITE
    syscall					        ; invoca il kernel & prosegue in scriviNuovaRiga

scriviNuovaRiga:				        ;============ metodo locale ============
    mov 	rax, SYS_WRITE		    ; Linux service ID
    mov 	rdi, STDOUT             ; 1° argomento di SYS_WRITE
    lea 	rsi, [linefeed]         ; 2° argomento di SYS_WRITE
    mov 	rdx, WRITELINE_SIZE     ; 3° argomento di SYS_WRITE
    syscall                         ; invoca il kernel
    ret
;========================== SEZIONE DATI SOLA LETTURA ==========================
section     .rodata
sysname     db      "Nome OS:   "
nodename    db      "Nome nodo: "
release     db      "Release:   "
version     db      "Versione:   "
domain      db      "Macchina:   "
linefeed    db      LF              ; Carattere ASCII di avanzamento riga
;========================== SEZIONE DATI NON INIZIALIZZATI ======================
section     .bss
sysname_res     resb    UTSNAME_SIZE
nodename_res    resb    UTSNAME_SIZE
release_res     resb    UTSNAME_SIZE
version_res     resb    UTSNAME_SIZE
domain_res      resb    UTSNAME_SIZE
;============================================================================
