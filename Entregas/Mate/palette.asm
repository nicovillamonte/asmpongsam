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
	;Lucas
setPalettePos endp

;-----------------------------------------------------------------

getPalettePos proc
	;Lucas
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
	; Ingresa el offset del objeto pallete y las coordenadas,
	; y retorna si la paleta se encuantra ahi, la posicion de la misma
	; y si es una esquina de la paleta o no.
	push ax
	push bx
	push cx
	pushf

iPA_QuePaleta:						;
	cmp [di], 01d					; Pregunta que paleta esta analizando.
	je iPA_PaletaIzquierda			;
	cmp [di], 78d					;
	je iPA_PaletaDerecha			;
	jmp iPA_QuePaleta				;

iPA_PaletaIzquierda:				;
	dec dh							;
	pop bx							;
	cmp [di], dh					;
	je iPA_NoExiste					;
	cmp [di+1], dl					;
	je iPA_EsquinaSuperior			; Analiza si la paleta se encuentra el la coordenada Y
	inc dl							; ingresada y, si se encuentra, en que posicion de la
	cmp [di+1], dl					; paleta esta.
	je iPA_Centro					;
	inc dl							;
	cmp [di+1], dl					;
	je iPA_EsquinaInferior			;
	sub dl, 2						;
	jmp iPA_NoExiste				;

iPA_PaletaDerecha:					;
	inc dh							;
	pop bx							;
	cmp [di], dh					;
	je iPA_NoExiste					;
	cmp [di+1], dl					;
	je iPA_EsquinaSuperior			; Analiza si la paleta se encuentra el la coordenada Y
	inc dl							; ingresada y, si se encuentra, en que posicion de la
	cmp [di+1], dl					; paleta esta.
	je iPA_Centro					;
	inc dl							;
	cmp [di+1], dl					;
	je iPA_EsquinaInferior			;
	sub dl, 2						;
	jmp iPA_NoExiste				;

iPA_EsquinaSuperior:
	mov dl, 1
	mov dh, 1
	mov al, 01000000
	or bl, al
	push bx
	jmp iPA_Fin

iPA_Centro:
	mov dl, 0
	mov dh, 2
	mov al, 01000000
	or bl, al
	push bx
	jmp iPA_Fin

iPA_EsquinaInferior:
	mov dl, 1
	mov dh, 3
	mov al, 01000000
	or bl, al
	push bx
	jmp iPA_Fin

iPA_NoExiste:
	mov dl, 0
	mov dh, 0
	mov al, 10111111
	and bl, al
	push bx
	jmp iPA_Fin

iPA_Fin:
	popf
	pop cx
	pop bx
	pop ax
	ret
isPaletteAt endp

;-----------------------------------------------------------------

end main
