;============================================================================
; minmax.asm - mostra l'uso delle macro per gestire variabili locali
; LinuxPro Staff
; 08/12/2019
; linux x86_64
; yasm -f elf64 -g dwarf2 -o stampaMax.obj -l stampaMax.lst stampaMax.asm
;============================= DEFINIZIONI DELLE COSTANTI =========================
LF        		equ		 10			; Carattere ASCII di avanzamento riga
EOL             equ		  0			; fine riga
VAR_SIZE		equ 	  8			; ogni variabile locale è di 8 byte
NUM_VAR			equ		  2			; numero di variabili locali
;========================== DEFINIZOINE DELLE VARIABILI LOCALI ==========================
%define		a 		qword [rsp + VAR_SIZE * (NUM_VAR - 2)]		; rsp + 0
%define		b 		qword [rsp + VAR_SIZE * (NUM_VAR - 1)]		; rsp + 8
;============================== DEFINIZIONE DI MACRO ================================
%macro prologo	0					;=== la macro prologo accetta 0 argomenti ===
	push	rbp						; impostiamo il frame della stack 
	mov		rbp, rsp				; impostiamo il frame della stack - stack allineata
	sub		rsp, VAR_SIZE * NUM_VAR	; facciamo spazio per le variabili locali nella stack
	mov		a, rdi					; rdi contiene a - 1° argomento di min o max
	mov		b, rsi					; rsi contiene b - 2° argomento di min o max
	mov		rsi, a					; 2° argomento di printf = a
	mov		rdx, b					; 3° argomento di printf = b
	mov		rcx, rsi				; 4° argomento di printf = a; assumiamo result=a
	cmp		rcx, b					; confrontiamo a e b
%endmacro							;========= fine della macro prologo ========
;============================== DEFINIZIONE DI MACRO ================================
%macro epilogo	0					;=== la macro epilogo accetta 0 argomenti ===
	xor		rax, rax				; nessun argomento a virgola mobile per printf
	push	rcx						; salviamo rcx per poi ritornarlo
	call	printf					; invochiamo la funzione C
	pop		rax						; rax = ritorno ; facciamo PUSH di rcx, ma POP di rax
	add		rsp, VAR_SIZE * NUM_VAR	; spazio libero utilizzato dalle variabili locali
	leave							; annulliamo le prime due istruzioni del prologo
	ret								; ritorna al chiamante
%endmacro							;========= fine della macro epilogo ========
;============================== DEFINIZIONE DI MACRO ================================
%macro max	0						;========= la macro max accetta 0 argomenti =======
	cmovb	rcx, b					; valore di ritorno = rcx = b (se a < b)
	lea		rdi, [formatStrMax]		; 1° argomento di printf
%endmacro							;============ fine della macro max ==========
;============================== DEFINIZIONE DI MACRO ================================
%macro min	0						;========= la macro min accetta 0 argomenti =======
	cmova	rcx, b					; valore di ritorno = rcx = b se (a > b)
	lea		rdi, [formatStrMin]		; 1° argomento di printf
%endmacro							;========== end of min macro ============
;================================ SEZIONE DEL CODICE ==============================
section		.text					
global 		stampaMax, stampaMin		; informa il linker sulle funzioni esterne
extern 		printf					; avvisa l'assembler/linker sulle chiamate esterne

stampaMax:							;=========== funzione stampaMax ==========
	prologo
	max
	epilogo						;======== fine della funzione stampaMax ======

stampaMin:							;=========== funzione stampaMin ==========
	prologo
	min
	epilogo						;======== fine della funzione stampaMin ======
;========================== SEZIONE DATI SOLA LETTURA ==========================
section		.rodata	
formatStrMax	db		"max(%ld, %ld) = %ld", LF, LF, EOL
formatStrMin	db		"min(%ld, %ld) = %ld", LF, LF, EOL
;============================================================================
