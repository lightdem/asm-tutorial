;============================================================================
; rigacomando.asm - recupera le informazioni di cmdline sull'OS e le stampa
; LinuxPro Staff
; 07/12/2019
; linux x86_64
; yasm -f elf64 -g dwarf2 -o rigacomando.obj rigacomando.asm
; gcc -g rigacomando.obj -o rigacomando
;============================= DEFINIZIONI DELLE COSTANTI =========================
LF        		equ		10			; Carattere ASCII di avanzamento riga
EOL             equ		 0			; fine riga
TAB				equ		 9			; carattere ASCII del tab
ARG_SIZE		equ		 8			; dimensione del vettore argv e di un push
;================================ SEZIONE DEL CODICE ==============================
section	.text
global	main						; il linker gcc si aspetta main, e non _start
extern printf						; informa assembler e il linker sui comandi esterni

main:								; il programma inizia qui
	push	rbp						; impostiamo il frame della stack 
	mov		rbp, rsp				; impostiamo il frame della stack - stack allineata
	sub		rsp, ARG_SIZE			; vogliamo l'rsp allineato a 16 byte dopo 3 inserimenti

	push	r12						; main funziona come tutte le altre chiamate
	push	r13						; dobbiamo salvare 
	push	rbx						; i registrsi

	mov		r12, rdi				; r12 = argc 	   - salviamo argc
	mov		r13, rsi				; [r13] => argv[0] - salviamo argv addr vector
									
	call	stampaNuovaRiga
									; stampiamo argc
	lea		rdi, [formatc]			; 1° argomento a printf - stringa formatc
	mov		rsi, r12				; 2° argomento a printf - argc
	call	stampa					; stampiamo argc

	xor		rbx, rbx				; rbx = indice var i = 0
	
argvLoop:							; stampiamo ogni argv[i] - ciclo do-while
	lea		rdi, [formatv]			; 1° argomento a printf - stringa formatv
	mov		rsi, rbx				; 2° argomento a printf - l'indice i
	mov		rdx, [r13+rbx*ARG_SIZE]	; 3° argomento a printf - rdx => argv[i]
	call	stampa					; stampiamo argv[i]

	inc		rbx						; i++
	cmp		rbx, r12				; i == argc?
	jl		argvLoop				; saltiamo se no - stampiamo altri argv[]

	call	stampaNuovaRiga
	xor		rax, rax				; EXIT_SUCCESS - scendiamo alla fine

finish:								; ==== questa è la fine del programma ===
	pop		rbx						; risistemiamo i registri salvati nella chiamata
	pop		r13
	pop		r12
	add		rsp, ARG_SIZE			; annulliamo l'allineamento della stack

	leave							; annulliamo le prime due istruzioni di main
	ret								; ritorniamo dalla main con il retCode in rax
;============================== METODI LOCALI ===============================
stampaNuovaRiga:					; metodo locale (alt+invio per stampare)
	lea		rdi, [newLine]			; andiamo alla stampa

stampa:								; rdi, rsi e rdx sono argomenti di printf
	xor		rax, rax				; non mandiamo argomenti a virgola mobile a printf
	call	printf
	ret
;========================== SEZIONE DATI SOLA LETTURA ==========================
section		.rodata
formatc		db  "argc    = %d",  LF, EOL
formatv		db 	"argv[%d] = %s", LF, EOL
newLine		db	LF, EOL
;============================================================================
