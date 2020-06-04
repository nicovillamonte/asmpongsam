.8086
.model small
.stack 100h
.data
	BALL STRUC
		coordx			db 	?
		coordY			db 	?
		graf			db	?
		direccion		db	?
		sentido 		db	2 dup (?)
		old_coordX 		db 	?
		old_coordY		db 	?
		backup_ASCII	db  ?
		memoryFlag		db  2 dup (?)
	ENDS
	Pelota BALL <00d,00d,0DEh,03d>		;Esto no existira en este codigo.
.code

main proc
	MOV AX,@DATA
	MOV DS,AX

	NOP

	MOV AX,4C00h
	INT 21h
main endp

;-----------------------------------------------------------------

refreshBall proc
	;Adrian
refreshBall endp

;-----------------------------------------------------------------

moveBall proc
; Recive en di el offset de la pelota, y no retorna datos.
; Segun los datos de direccion y sentido, cambia las posiciones de X e Y, segun el movimiento de la pelota.

; Toma el valor del sentido para incrementar los valores de las coordenadas segun corresponda.
mB_Sentido:
	cmp byte ptr [di+4], 00h
	je mB_Izquierda
	jmp mB_Derecha

mB_Izquierda:
	cmp byte ptr [di+5], 00h
	je mB_IzqAbajo
	jmp mB_IzqArriba
mB_Derecha:
	cmp byte ptr [di+5], 00h
	je mB_DerAbajo
	jmp mB_DerArriba

; Incrementa las coordenadas.
mB_IzqArriba:
	inc byte ptr [di]
	cmp byte ptr [di+3], 01h	;
	je mB_IAR_Sent15			; Analiza el angulo con el que se mueve la pelota.
	cmp byte ptr [di+2], 02h	;
	je mB_IAR_Sent30
mB_SeMueve_IAR:
	mov byte ptr [di+9], 00h			;
	inc byte ptr [di+1]					; Movimiento en la coordenada Y.
	jmp mB_Fin							;
mB_IzqAbajo:
	inc byte ptr [di]
	cmp byte ptr [di+3], 01h
	je mB_IAB_Sent15
	cmp byte ptr [di+2], 02h
	je mB_IAB_Sent30
mB_SeMueve_IAB:
	mov byte ptr [di+9], 00h
	dec byte ptr [di+1]
	jmp mB_Fin
mB_DerArriba:
	dec byte ptr [di]
	cmp byte ptr [di+3], 01h
	je mB_DAR_Sent15
	cmp byte ptr [di+2], 02h
	je mB_DAR_Sent30
mB_SeMueve_DAR:
	mov byte ptr [di+9], 00h
	inc byte ptr [di+1]
	jmp mB_Fin
mB_DerAbajo:
	dec byte ptr [di]
	cmp byte ptr [di+3], 01h
	je mB_DAB_Sent15
	cmp byte ptr [di+2], 02h
	je mB_DAB_Sent30
mB_SeMueve_DAB:
	mov byte ptr [di+9], 00h
	dec byte ptr [di+1]
	jmp mB_Fin

; Analiza si la pelota se mueve en la coordenada Y o no.
mB_IAR_Sent15:
	cmp byte ptr [di+9], 02h			;
	je mB_SeMueve_IAR					; Analiza si la pelota se mueve o no.
	inc byte ptr [di+9]					;
	jmp mB_Fin
mB_IAR_Sent30:
	cmp byte ptr [di+9], 01h			;
	je mB_SeMueve_IAR					; Analiza si la pelota se mueve o no.
	inc byte ptr [di+9]					;
	jmp mB_Fin

mB_IAB_Sent15:
	cmp byte ptr [di+9], 02h
	je mB_SeMueve_IAB
	inc byte ptr [di+9]
	jmp mB_Fin
mB_IAB_Sent30:
	cmp byte ptr [di+9], 01h
	je mB_SeMueve_IAB
	inc byte ptr [di+9]
	jmp mB_Fin

mB_DAR_Sent15:
	cmp byte ptr [di+9], 02h
	je mB_SeMueve_DAR
	inc byte ptr [di+9]
	jmp mB_Fin
mB_DAR_Sent30:
	cmp byte ptr [di+9], 01h
	je mB_SeMueve_DAR
	inc byte ptr [di+9]
	jmp mB_Fin

mB_DAB_Sent15:
	cmp byte ptr [di+9], 02h
	je mB_SeMueve_DAB
	inc byte ptr [di+9]
	jmp mB_Fin
mB_DAB_Sent30:
	cmp byte ptr [di+9], 01h
	je mB_SeMueve_DAB
	inc byte ptr [di+9]
	jmp mB_Fin

; No nesecite pushear ni popear nada.
mB_Fin:
	ret
moveBall endp

;-----------------------------------------------------------------

initialPosBall proc
	push ax
	push bx
	push dx
; Recive en di recive el offset de la pelota y en si recive el offset de la paleta.
; No retorna datos, sino que sobre escribe la posicion de la pelota en el centro de
; la paleta.

; Analiza el valor del largo de la paleta para averiguar el centro.
	mov al, [si+3]
	mov bl, 02h
	div bl
	cmp ah, 00h
	je iPB_LargoPar
	jmp iPB_LargoImpar

; En caso de ser par incrementa en 1 el resultado de la division y con la posicion
; en X y en Y, setea la posicion de la pelota.
iPB_LargoPar:
	inc al
	call getPalettePos
	mov ah, dh
	add al, dl
	mov [di], ah
	mov [di+1], al
	jmp iPB_Fin

; En caso de ser impar deja el resultado de la division como esta y con la posicion
; en X y en Y, setea la posicion de la pelota.
iPB_LargoImpar:
	call getPalettePos
	mov ah, dh
	mov al, dl
	mov [di], ah
	mov [di+1], al
	jmp iPB_Fin

iPB_Fin:
	pop dx
	pop bx
	pop ax
	ret
initialPosBall endp

;-----------------------------------------------------------------

getBallPos proc
	;Ezequiel
getBallPos endp

;-----------------------------------------------------------------

setBallPos proc
	;Ezequiel
setBallPos endp

;-----------------------------------------------------------------

getBallDirec proc
	;Lucas
getBallDirec endp

;-----------------------------------------------------------------

setBallDirec proc
	;Lucas
setBallDirec endp

;-----------------------------------------------------------------

end main
