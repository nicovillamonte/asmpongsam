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

goUp proc ;esta funcion tiene como objetivo desplazar a la paleta un espacio hacia arriba
          ;se incrementa en uno la coordenada de la paleta seleccionada
          ;recibiremos en DI el offset del objeto paleta
	inc [DI+01h]
	call refreshPalette  ;refrescamos la paleta para que los cambios sean visibles
	ret
goUp endp

;-----------------------------------------------------------------

goDown proc ;esta funcion tiene como objetivo desplazar a la paleta un espacio hacia abajo
            ;se decrementa en uno la coordenada de la paleta seleccionada
            ;recibiremos en DI el offset del objeto paleta
    dec [DI+01h]
	call refreshPalette  ;refrescamos la paleta para que los cambios sean visibles
	ret
goDown endp
;-----------------------------------------------------------------

isPaletteAt proc
	;Mate
isPaletteAt endp

;-----------------------------------------------------------------

end main
