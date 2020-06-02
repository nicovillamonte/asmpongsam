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

	MOV AX,4C00h
	INT 21h
main endp


;-----------------------------------------------------------------

refreshPalette proc
		Pushf
        Push ax
        Push bx
        Push cx
        Push dx
        Push si
        ;push di

        mov ax, 00h
        mov bx, 00h
        cmp [di+2], 0deh
        je busca1
        jmp busca2


busca1: 
        mov dh, 01h
		mov dl, 00h
		call getCoord
		cmp al, 0deh
		je cambio1 
		inc dl
		jmp busca1

busca2: 
		mov dh, 78d
		mov dl, 00h
		call getCoord
		cmp al, 0ddh
		je cambio2 
		inc dl
		jmp busca2

cambio1: 
		mov al, 20h
		call setCoord
		add bh, 01h
		cmp bh, 03h
		je escribe
		jmp busca1

cambio2: 
		mov al, 20h
		call setCoord
		add bl, 01h
		cmp bl, 03h
		je escribe
		jmp busca2

escribe: 
		mov cx, [di+3]
		mov dh, [di]
		mov dl, [di+1]
sigue: 
		mov al, [di+2]
		call setCoord
		inc dl
		loop sigue
fin: 
        ;pop di
        pop si
        pop dx
        pop cx
        pop bx
        pop ax
        popf
        ret  	
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
	;Mate
isPaletteAt endp

;-----------------------------------------------------------------

end main