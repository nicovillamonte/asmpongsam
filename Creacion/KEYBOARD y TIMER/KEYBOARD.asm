.8086
.model small
.stack 100h
PUERTO_TECLADO		EQU		60h
.data

.code
PUBLIC getScanCode
PUBLIC SCtoASCII

main proc
	MOV AX,@DATA
	MOV DS,AX

	NOP

	MOV AX,4C00h
	INT 21h
main endp

;-----------------------------------------------------------------

getScanCode proc
	;Eze
getScanCode endp

;-----------------------------------------------------------------

SCtoASCII proc
	;Eze
SCtoASCII endp

;-----------------------------------------------------------------
end main