.8086
.model small
.stack 100h
.data
	PALETTE STRUC
		coordx	db 	?
		coordY	db 	?
		graf	db	?
		largo 	db 	?
	ENDS
	pallete1 PALETTE <01d,00d,0DEh,03d>
	pallete2 PALETTE <78d,00d,0DDh,03d>
.code
INCLUDE GROUND.ASM		;Se pueden utilizar las funciones de GROUND.asm

main proc
	MOV AX,@DATA
	MOV DS,AX

	nop

	MOV AX,4C00h
	INT 21h
main endp


;-----------------------------------------------------------------

refreshPalette proc
	;Adrian
refreshPalette endp

;-----------------------------------------------------------------

setPalettePos proc
	;recibe en DI el offset del objeto
	push ax	;
	push bx	;	Pusheos y popeos no necesarios
	push cx	;
	push dx ;
	
	cmp dh,0FFh
	JE fow
	mov byte ptr [DI],dh
fow:	
	cmp dl,0FFh
	JE ext
	mov byte ptr [DI+01h],dl
ext:
	pop dx  ;
	pop cx	;
	pop bx	;	Pusheos y popeos no necesarios
	pop ax  ;
	ret	
setPalettePos endp

;-----------------------------------------------------------------

getPalettePos proc
	;recibe en DI el offset del objeto
	push ax	;
	push bx	;	Pusheos y popeos no necesarios
	push cx	;
	
	MOV DH,[DI]			;Recibe en dh el primer valor de la estructura palette, en este caso, la coordenada x
	MOV DL,[DI+01h]		;Recibe en dl el segundo valor de la estructura palette, en este caso, la coordenada y
	
	pop cx	;
	pop bx	;	Pusheos y popeos no necesarios
	pop ax  ;
	ret	
getPalettePos endp

;-----------------------------------------------------------------

goUp proc
	;Eze
goUp endp

;-----------------------------------------------------------------

goDown proc
	;Eze
goDown endp
;-----------------------------------------------------------------

isPaletteAt proc
	;Mate
isPaletteAt endp

;-----------------------------------------------------------------

end main 