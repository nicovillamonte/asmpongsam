.8086
.model small
.stack 100h
.data

.code
PUBLIC TimRst
PUBLIC TimSet
PUBLIC TimSetC
PUBLIC getTim
PUBLIC getTimC
PUBLIC cmpMicroSec

main proc
	MOV AX,@DATA
	MOV DS,AX

	NOP
	
	MOV AX,4C00h
	INT 21h
main endp

;-----------------------------------------------------------------

TimRst proc
	;Lucas
TimRst endp

;-----------------------------------------------------------------

TimSet proc
	;Mate
TimSet endp

;-----------------------------------------------------------------

TimSetC proc
	;Adrian
TimSetC endp

;-----------------------------------------------------------------

getTim proc
	;Eze
getTim endp

;-----------------------------------------------------------------

getTimC proc      ;esta funcion tiene como objetivo devolver el tiempo actual del contador en ciclos de clock 

	mov AH, 00h   ;en CX se devolvera la parte mas significativa del contador
	int 1Ah       ;en DX se devolvera la parte menos significativa del contador

	ret
getTimC endp

;-----------------------------------------------------------------

cmpMicroSec proc
	;Lucas
cmpMicroSec endp

;-----------------------------------------------------------------

end main
