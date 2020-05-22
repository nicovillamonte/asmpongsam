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

getTimC proc
	;Adrian
getTimC endp

;-----------------------------------------------------------------

cmpMicroSec proc
	;Lucas
cmpMicroSec endp

;-----------------------------------------------------------------

end main