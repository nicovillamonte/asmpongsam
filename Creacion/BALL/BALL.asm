.8086
.model small
.stack 100h
.data
	BALL STRUC
		coordx		db 	?
		coordY		db 	?
		graf		db	?
		direccion	db	?
		sentido 	db	2 dup (?)
		old_coordX 	db 	?
		old_coordY	db 	?
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
	;Mateo
moveBall endp

;-----------------------------------------------------------------

initialPosBall proc
	;Mateo
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