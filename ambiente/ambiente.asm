;============================================================================
; ambiente.asm - dimostra l'invocazione di getenv, printf e strncpy 
; ambiente.asm viene chiamato da ambiente.c (ambiente.c ha main())
; ambiente.asm non ha una main. Esporta la funzione con la
; dichiarazione: int stampaamb(const char* dateStr);
; LinuxPro Staff
; 08/12/2019
; linux x86_64
; yasm -f elf64 -o ambiente.obj -l ambiente.lst ambiente.asm
; gcc -g ambiente.c ambiente.obj -o ambiente
;============================= DEFINIZIONI DELLE COSTANTI =========================
BUFF_SIZE		equ 	128			; numero di byte nel buffer
LF        		equ		 10			; Carattere ASCII di avanzamento riga
EOL             equ		  0			; fine riga
TAB				equ 	  9			; carattere ASCII del tab
NUM_PUSH		equ 	  9			; facciamo il PUSH di 9 indirizzi per le chiamate a printf
PUSH_SIZE		equ 	  8			; ogni PUSH sottrae 8 byte da RSP
ZERO			equ		  0			; il numero 0
;============================= DEFINIZIONE DELLE MACRO =============================
%macro getSaveEnv	1				;===== la macro getSaveEnv ha 1 argomento =====
	lea		rdi, [env%1]			; env%1 = nome della variabile env ASCIIZ
	call	getenv					; getenv ritornerà usando [RAX] => ASCIIZ
	lea 	rdi, [buf%1]			; buf%1 = variabile di ambiente dest- 1° argomento di strncpy
	mov		rsi, rax				; [rsi] => ASCIIZ src - 2° argomento di strncpy
	mov		rdx, BUFF_SIZE - 1		; rdx = # massimo da copiare - 3° argomento di strncpy
	lea		rcx, [nullLine]			; [rcx] => "(null)"
	cmp		rax, ZERO				; abbiamo ottenuto un valore non valido (rax == 0)?
	cmovz	rsi, rcx				; se non valido, strncpy "(null)"
	call	strncpy					; chiamata alla funzione della libreria C per salvare la variabile
%endmacro							;======== fine della macro getSaveEnv =======
;================================ SEZIONE DEL CODICE ==============================
section		.text					;================================ SEZIONE DEL CODICE ==============================
global 		stampaamb				; dice al linker gcc che stiamo esportando stampaamb
extern 		getenv, printf, strncpy	; avvisa l'assembler/linker sulle chiamate esterne
									; questo modulo non ha ne _start ne main
;============================= FUNZIONE ESPORTATA ============================
stampaamb:							
	push	rbp						; impostiamo il frame della stack 
	mov		rbp, rsp				; impostiamo il frame della stack - stack allineata
	sub		rsp, PUSH_SIZE			; vogliamo che rsp sia allineato a 16-bit dopo 1 push
	push	rdi						; salviamo l'argomento nella stack (dateStr)

	; prendiamo e salviamo le variabili di ambienti utilizzando la macro per ognuna
	getSaveEnv HOME
	getSaveEnv HOSTNAME
	getSaveEnv HOSTTYPE
	getSaveEnv CPU
	getSaveEnv PWD
	getSaveEnv TERM
	getSaveEnv PATH
	getSaveEnv SHELL
	getSaveEnv EDITOR
	getSaveEnv MAIL
	getSaveEnv LANG
	getSaveEnv PS1
	getSaveEnv HISTFILE

	; chiamiamo printf con molti, molti argomenti
	; passiamo gli argomenti in RDI, RSI, RDX, RCX, R8 e R9; gli argomenti rimanenti sono nella stack
	lea		rdi, [formatString]		;  1° argomento a printf
	pop		rsi						;  2° argomento a printf- push rdi e pop rsi
    add     rsp, PUSH_SIZE          ;  correggiamo l'allineamento della stack
	lea		rdx, [bufHOME]			;  3° argomento a printf
	lea		rcx, [bufHOSTNAME]		;  4° argomento a printf
	lea		r8,  [bufHOSTTYPE]		;  5° argomento a printf
	lea		r9,  [bufCPU]			;  6° argomento a printf
	; abbiamo utilizzato tutti i 6 argomenti passando registri, facciamo il push di quelli rimanenti
	; Da notare: Il push viene effettuato in ordine inverso perché gli argomenti 
	;		vengono letti dall'inizio della pila! la pila cresce verso il basso!
	push	bufHISTFILE				; 15° argomento a printf
	push	bufPS1					; 14° argomento a printf
	push	bufLANG					; 13° argomento a printf
	push	bufMAIL					; 12° argomento a printf
	push	bufEDITOR				; 11° argomento a printf
	push	bufSHELL				; 10° argomento a printf
	push	bufPATH					;  9° argomento a printf
	push	bufTERM					;  8° argomento a printf
	push	bufPWD					;  7° argomento a printf

	xor		rax, rax				; nessun argomento a virgola mobile
	call	printf					; invochiamo la funzione wrapper C per stampare
	add		rsp, NUM_PUSH*PUSH_SIZE	; il chiamante deve rimuovere gli oggetti pushati
	xor		rax, rax				; ritorna EXIT_SUCCESS = 0

	leave							; annulliamo le prime due istruzioni
	ret								; ritorniamo al chiamante
;========================== SEZIONE DATI SOLA LETTURA ==========================
section		.rodata
formatString	db LF,  "Variabili di ambiente in %s:",	LF
				db TAB, "HOME     = %s",				LF
				db TAB, "HOSTNAME = %s", 				LF
				db TAB, "HOSTTYPE = %s",				LF
				db TAB, "CPU      = %s",				LF
				db TAB, "PWD      = %s",				LF
				db TAB, "TERM     = %s",				LF
				db TAB, "PATH     = %s",				LF
				db TAB, "SHELL    = %s",				LF
				db TAB, "EDITOR   = %s",				LF
				db TAB, "MAIL     = %s",				LF, 
				db TAB, "LANG     = %s",				LF,
				db TAB, "PS1      = %s",				LF,
				db TAB, "HISTFILE = %s",				LF, LF, EOL

envHOME			db "HOME", 		EOL
envHOSTNAME		db "HOSTNAME", 	EOL
envHOSTTYPE		db "HOSTTYPE", 	EOL
envCPU			db "CPU", 		EOL
envPWD			db "PWD", 		EOL
envTERM			db "TERM", 		EOL
envPATH			db "PATH", 		EOL
envSHELL		db "SHELL", 	EOL
envEDITOR		db "EDITOR",	EOL
envMAIL			db "MAIL",		EOL
envLANG			db "LANG",		EOL
envPS1			db "PS1",		EOL
envHISTFILE		db "HISTFILE",	EOL

nullLine		db "(null)",	EOL
newLine			db	LF, EOL
;========================== SEZIONE PER I DATI NON INIZIALIZZATI ======================
section		.bss
bufHOME			resb	BUFF_SIZE
bufHOSTNAME		resb	BUFF_SIZE
bufHOSTTYPE		resb	BUFF_SIZE
bufCPU			resb	BUFF_SIZE
bufPWD			resb	BUFF_SIZE
bufTERM			resb	BUFF_SIZE
bufPATH			resb	BUFF_SIZE
bufSHELL		resb	BUFF_SIZE
bufEDITOR		resb	BUFF_SIZE
bufMAIL			resb	BUFF_SIZE
bufLANG			resb	BUFF_SIZE
bufPS1			resb	BUFF_SIZE
bufHISTFILE		resb	BUFF_SIZE
;============================================================================
