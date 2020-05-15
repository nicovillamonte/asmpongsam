.8086
.model small
.stack 100h
.data

.code

FUNCION proc
	;PUSHEAR DOS ARGUMENTOS, QUE SERAN SUMADOS Y DEVOLVERA EL RESULTADO EN AX
	PUSH BP
	MOV BP,SP
	PUSH BX

	MOV AX,SS:[BP+04]
	MOV BX,SS:[BP+06]
	ADD AX,BX

	FIN:
	POP BP
	POP BX
	RET 4
FUNCION endp

main proc
	MOV AX,@DATA
	MOV DS,AX

	MOV AX,45d
	PUSH AX
	MOV AX,05d
	PUSH AX
	CALL FUNCION

	MOV AX,4C00h
	INT 21h
main endp
end main