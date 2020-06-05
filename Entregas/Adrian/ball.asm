.8086
.model small
.stack 100h
.data
	BALL STRUC
		coordx		 db ?
		coordY		 db ?
		graf		 db	?
		direccion	 db	?
		sentido 	 db	2 dup (?)
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
;Refresca la posicion de BALL en el vector SCREEN.
;Recibe el offset de BALL en DI.
;Utiliza AX y DX internamente, para las funciones de GROUND.
;Es decir, utiliza dicha libreria!!!
		Pushf
        Push ax
        ;Push bx
        ;Push cx
        Push dx
        ;Push si
        ;Push di

		xor ax, ax
    	xor dx, dx

    	;Escribo el caracter en backup_ASCII en las coord(x,y) viejas.
    	mov al, [di+07h]
    	mov dh, [di+05h]
		mov dl, [di+06h]
		call setCoord

    	;Busco caracter en las coord(x,y), donde hay que poner la pelota o nuevas.
		mov dh, [di+00h]
		mov dl, [di+01h]
		call getCoord
	
		;Guardo en backup_ASCII el caracter que estaba en las coord(x,y) nuevas.
		mov [di+07h], al

		;Muevo a al el graf de BALL.
		mov al, [di+02h]
		;Muevo a dx las coord(x,y) nuevas.
		mov dh, [di+00h]
		mov dl, [di+01h]
		;Muevo a las coord(x,y) viejas, las nuevas asi quedan guardadas para la proxima.
		mov [di+04h], dh
		mov [di+05h], dl
		call setCoord 

fin: 

        ;pop di
        ;pop si
        pop dx
        ;pop cx
        ;pop bx
        pop ax
        popf
        ret  
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