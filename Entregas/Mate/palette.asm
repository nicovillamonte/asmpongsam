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

;INCLUDE GROUND.ASM		;Se pueden utilizar las funciones de GROUND.asm

main proc
	MOV AX,@DATA
	MOV DS,AX

	nop

	mov ax, 4c00h
	int 21h
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

iPA_Largo:
	xor cx, cx
	mov cl, [di+3]

iPA_Coordenadas:
	cmp [di], dh					;
	jne iPA_NoExiste				; Analiza las coordenadas dadas en el registro dx
	cmp [di+1], dl					; y las compara a las del objeto para saber si la
	je iPA_Esquina					; paleta esta en las coordenadas dadas.
	dec dl							;
	loop iPA_Coordenadas			;
	jmp iPA_NoExiste				;

iPA_Esquina:
	pop bx
	mov ch, [di+3]
	dec cl
	sub ch, cl
	cmp [di+3], ch					;
	je iPA_EsquinaInferior			; Analiza el registro cx para saber si se
	cmp ch, 01d						; encuentra en una esquina de la paleta o en el
	je iPA_EsquinaSuperior			; centro de la misma.
	jmp iPA_Centro					;

iPA_EsquinaSuperior:
	mov dl, 1
	mov dh, ch
	mov al, 01000000b
	or bl, al
	push bx
	jmp iPA_Fin

iPA_Centro:
	mov dl, 0
	mov dh, ch
	mov al, 01000000b
	or bl, al
	push bx
	jmp iPA_Fin

iPA_EsquinaInferior:
	mov dl, 1
	mov dh, ch
	mov al, 01000000b
	or bl, al
	push bx
	jmp iPA_Fin

iPA_NoExiste:
	mov dl, 0
	mov dh, 0
	mov al, 10111111b
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
