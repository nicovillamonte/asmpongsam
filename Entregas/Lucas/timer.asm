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
PUBLIC cmpMiliSec

main proc
	MOV AX,@DATA
	MOV DS,AX

	NOP
	
	MOV AX,4C00h
	INT 21h
main endp

;-----------------------------------------------------------------

TimRst proc
	push ax
	push cx
	push dx
	
	mov ah,01h		;resetea por default el valor del flag de medianoche		
	xor cx,cx		;pongo en 0 el valor del timer en ambas partes 
	xor dx,dx
	int 1Ah	
	
	pop dx
	pop cx
	pop ax
	ret		
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

cmpMiliSec proc 
	push ax
	push bx			
	push cx			
	push dx		
	xor bx,bx
	
	mov dl,al	;mul bx*55
	xor ax,ax
	mov al,dl
	mov dl,55
	mul dl
	mov bl,al
	
	xor ax,ax	;div bx*10
	mov ax,bx
	mov dl,10
	div dl
	mov bl,al   ;margen de error de 0.5 pulsos de clock si el numero que viene en al es impar
	
	mov ah,00h
	int 1Ah
	
	cmp bx,dx
	jg flg1
	jmp ext
flg1:
	pushf
	call setzf
	popf
	pop dx 			
	pop cx
	pop bx
	pop ax
	ret	

flg0:
	call clrzf
	
ext:
	pop dx 			
	pop cx
	pop bx
	pop ax
	ret				
cmpMiliSec endp 

setzf proc
	push ax
	push bx
	
	pushf
	pop bx
	mov al,01000000b
	or bl,al
	push bx
	popf
	
	pop bx
	pop ax
	ret
setzf endp

clrzf proc
	push ax
	push bx
	
	pushf
	pop bx
	mov al,01000000b
	xor bl,al
	push bx
	popf
	
	pop bx
	pop ax
	ret
clrzf endp

;-----------------------------------------------------------------

end main