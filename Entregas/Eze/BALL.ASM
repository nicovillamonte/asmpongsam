.8086
.model small
.stack 100h
.data
	BALL STRUC
		coordx		 db ?
		coordY		 db ?
		graf		 db ?
		direccion	 db ?
		sentido 	 db 2 dup (?)
		old_coordX 	 db ?
		old_coordY	 db ?
		backup_ASCII     db ?
		memoryFlag       db 2 dup (?)
	ENDS
	Pelota BALL <00d,00d,0DEh,03d>		;Esto no existira en este codigo.
.code

main proc
	MOV AX,@DATA
	MOV DS,AX

	NOP
	call getBallPos
	call setBallPos

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

getBallPos proc ;esta funcion recibe en DI el offset del objeto BALL
                ;y devuelve la posicion de la pelota, se devolvera DH con la coordenadas X 
                ;y DL con la coordenadas Y dentro de las coordenadas del objeto BALL
	mov DH, [DI]
	mov DL, [DI+01h]
	ret
getBallPos endp

;-----------------------------------------------------------------

setBallPos proc ;esta funcion recibe en DI el offset del objeto pelota
                ;en DH recibe la nueva posicion de coordenada X 
                ;en DL recibe la nueva posicion de coordenada Y
                ;si ambas coordenadas tienen el valor 0FFh no se cambiara su valor
                ;en cambio, si solo DH es diferente a 0FFh solo se cambiara la coordenada X
                ;si solo DL es diferente a 0FFh solo se cambiara la coordenada Y
                ;del objeto BALL
	cmp DH, 0FFh
	je miro_coordenadaY2
	jmp miro_coordenadaY1

	miro_coordenadaY1: 
	cmp DL, 0FFh
	je cambio_coordenadaX

	mov byte ptr[DI], DH   ;cambio coordenadas X
	mov byte ptr[DI+01h], DL  ;cambio coordenadas Y
        jmp finalizo
	miro_coordenadaY2:
	cmp DL, 0FFh
	je finalizo
	jmp cambio_coordenadaY

	cambio_coordenadaX:   
	mov byte ptr[DI], DH   ;cambio coordenadas X
	jmp finalizo

	cambio_coordenadaY:
	mov byte ptr[DI+01h], DL  ;cambio coordenadas Y

	finalizo:
	ret
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

