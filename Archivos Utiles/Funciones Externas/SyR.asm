.8086
.model small
.stack 100h
.data

.code
PUBLIC SUMA
PUBLIC RESTA

main proc
	;No hago nada
main endp

SUMA proc
	;INGRESA EN AX Y BX, SALE EN AX EL RES
	ADD AX,BX
	RET
SUMA endp

RESTA proc
	;INGRESA EN AX Y BX, SALE EN AX EL RES
	SUB AX,BX
	RET
RESTA endp
end main