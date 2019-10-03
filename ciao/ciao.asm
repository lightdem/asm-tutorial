;============================================================================
; ciao.asm
; LinuxPro Staff
; 05/10/2019
; yasm -g dwarf2 -f elf64 ciao.asm -o ciao.obj
; ld -g -o ciao ciao.obf
;============================= DEFINIZIONI DELLE COSTANTI =========================
LF        		equ		10			; Carattere ASCII di avanzamento riga
EXIT_SUCCESS	equ  	 0			; Le app Linux di solito ritornano 0 quando non ci sono errori
STDOUT			equ  	 1			; destinazione per SYS_WRITE
SYS_WRITE		equ  	 1			; numero del servizio kernel SYS_WRITE
SYS_EXIT		equ 	60			; numero del servizio kernel SYS_EXIT
;================================ SEZIONE DEL CODICE ==============================
section	.text
global 	_start

_start:
	mov		rax, SYS_WRITE			; prepariamo alla chiamata SYS_WRITE 
	mov		rdi, STDOUT				; 1° argomento di SYS_WRITE
	lea		rsi, [msg]				; 2° argomento di SYS_WRITE - [rsi] => ASCII
	mov		rdx, msglen				; 3° argomento di SYS_WRITE - rdx = carattere numerico
	syscall							; invoca il servizio SYS_WRITE del kernel Linux
    
	mov 	rax, SYS_EXIT			; prepara la chiamata SYS_EXIT
	xor 	rdi, rdi				; 1° argomento di SYS_EXIT - rdi = EXIT_SUCCESS
	syscall							; invoca il servizio SYS_EXIT del kernel Linux
;========================== SEZIONE DATI SOLA LETTURA ==========================
section 		.rodata
    msg: 		db 		"Ciao mondo!", LF, LF
    msglen: 	equ 	$ - msg
;============================================================================
