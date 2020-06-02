.8086
.model small
.stack 100h
.data
	PALETTE STRUC
		coordx	db 	?
		coordY	db 	?
		graf	db	?
		largo 	db 	?
		old_Coordx db ?
		old_Coordy db ? 
	ENDS
	pallete1 PALETTE <01d,00d,0DEh,03d,01d,00d>
	pallete2 PALETTE <78d,00d,0DDh,03d,78d,00d>
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
        ;Push bx
        Push cx
        Push dx
        ;Push si
        ;push di

        mov ax, 00h
       	mov cx, [di+03h]

limpia:
		mov al, 20h
		mov dh, [di+04h]
		mov dl, [di+05h]
		call setCoord
		inc dl
		loop limpia

		mov cx, [di+03h]
		mov dh, [di+00h]
		mov dl, [di+01h]
		mov al, [di+02h]

escribe: 
		call setCoord
		inc dl
		loop sigue
fin: 
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