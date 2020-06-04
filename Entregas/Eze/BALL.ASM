.8086
.model small
.stack 100h
.data
	BALL STRUC
		coordx		   db ?
		coordY		   db ?
		graf		     db	?
		direccion	   db	?
		sentido 	   db	2 dup (?)
		old_coordX 	 db ?
		old_coordY	 db ?
		backup_ASCII db ?
		memoryFlag   db 2 dup (?)
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
                ;en cambio, si una de las dos es distinta se cambiaran las coordenadas
                ;del objeto BALL
	cmp DH, 0FFh
	je mantener_posicion
	jmp cambio_coordenada 
	
	mantener_posicion:
	cmp DL, 0FFh
	je finalizo

	cambio_coordenada:   ;si una de las 2 coordenadas es distinta a 0FFh 
	                     ;se cambiara las coordenadas del objeto tipo BALL
	mov [DI], DH
	mov [DI+01h], DL

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
