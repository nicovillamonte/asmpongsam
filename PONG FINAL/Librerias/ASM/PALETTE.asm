.8086
.model small
.stack 100h
.data

.code
INCLUDE GROUND.inc		;Se pueden utilizar las funciones de GROUND.asm
PUBLIC initializatePalette
PUBLIC refreshPalette
PUBLIC setPalettePos
PUBLIC getPalettePos
PUBLIC goUp
PUBLIC goDown
PUBLIC getPaletteLarge
PUBLIC setPaletteLarge
PUBLIC isPaletteAt

main proc
	;NADA.
main endp
;-----------------------------------------------------------------

initializatePalette proc
	;Recibimos en DI el offset del objeto BALL a inicializar
	PUSH AX
	MOV AL,[DI+00h]
	MOV BYTE PTR [DI+04h],AL
	MOV AL,[DI+01h]
	MOV BYTE PTR [DI+05h],AL
	POP AX
	RET
initializatePalette endp

;-----------------------------------------------------------------

refreshPalette proc
	Pushf
    Push ax
    ;Push bx
    Push cx
    Push dx
    ;Push si
    ;push di

    mov ax, 00h
    xor cx, cx
   	mov cl, [di+03h]


	mov al, 20h
	mov dh, [di+04h]
	mov dl, [di+05h]
RP_limpia:
	call setCoord
	inc dl
	loop RP_limpia

	xor cx, cx
	mov cl, [di+03h]
	mov dh, [di+00h]
	mov dl, [di+01h]
	mov [di+04h],dh
	mov [di+05h],dl
	mov al, [di+02h]

RP_escribe: 
	call setCoord
	inc dl
	loop RP_escribe

;FINAL 
    ;pop di
    ;pop si
    pop dx
    pop cx
    ;pop bx
    pop ax
    popf
    ret  	

refreshPalette endp

;-----------------------------------------------------------------

setPalettePos proc
	;Recibe en DI el offset del objeto
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
	;Esta funcion tiene como objetivo desplazar a la paleta un espacio hacia arriba.
	;Se incrementa en uno la coordenada de la paleta seleccionada.
	;Recibiremos en DI el offset del objeto paleta.
	dec byte ptr [DI+01h]
	call refreshPalette  ;Refrescamos la paleta para que los cambios sean visibles
	ret
goUp endp

;-----------------------------------------------------------------

goDown proc
	;Esta funcion tiene como objetivo desplazar a la paleta un espacio hacia abajo.
	;Se decrementa en uno la coordenada de la paleta seleccionada.
	;Recibiremos en DI el offset del objeto paleta.
	inc byte ptr [DI+01h]
	call refreshPalette  ;Refrescamos la paleta para que los cambios sean visibles
	ret
goDown endp
;-----------------------------------------------------------------

getPaletteLarge proc
	;Devuelve la longitud en unidades de caracteres de la paleta seleccionada.
	;Recibe en DI el offset de la paleta.
	;Devuelve en DL el largo de la paleta.
	MOV DL,[DI+03h]
	RET
getPaletteLarge endp

;-----------------------------------------------------------------

setPaletteLarge proc
	;Cambia la longitud en unidades de caracteres de la paleta seleccionada.
	;Recibe en DI el offset de la paleta.
	;Recibe en DL el nuevo largo de la paleta.
	MOV byte ptr [DI+03h],DL
	RET
setPaletteLarge endp

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
	pop bx
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