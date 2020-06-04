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
 ;recibe en DI el offset del objeto
	push bx
	push cx
	
	mov AL,[DI+03h] ;
	mov DH,[DI+04h] ; Muevo a registros los valores del struct
	mov DL,[DI+05h] ;
	
	pop cx
	pop bx
	ret
getBallDirec endp

;-----------------------------------------------------------------

setBallDirec proc ;Preguntar
	;recibe en DI el offset del objeto
	push bp		;
	mov bp,sp 	;
	push ax		;
	push bx		; Pusheos para mantener entorno
	push cx		; ya que la funcion no devuelve parametros
	push dx		;
	push di     ;  
	
	xor bx,bx ; Limpio Registros
	xor cx,cx ; (no necesario)
	xor dx,dx ;
	
	mov bx,ss:[bp+8] ;recupero dato de la pila
	cmp bx,0FFh		 ;compara con el valor maximo
	je fow			 ;si es igual sigue curso sin cambiar el valor
	mov [DI+03h],bx ;cambia el valor del modo de direcionamiento por el ingresado en el push
fow:
	mov cx,ss:[bp+6] ;recupero dato de la pila
	cmp cx,0FFh		 ;compara con el valor maximo
	je fow1			 ;si es igual sigue curso sin cambiar el valor
	mov [DI+04h],cx ;cambia el valor de la parte alta del modo de sentido por el ingresado en el push
fow1:
	mov dx,ss:[bp+4] ;recupero dato de la pila
	cmp dx,0FFh		 ;compara con el valor maximo
	je ext			 ;si es igual sigue curso sin cambiar el valor
	mov [DI+05h],dx ;cambia el valor de la parte baja del modo de sentido por el ingresado en el push
ext:
	pop di ;
	pop dx ;
	pop cx ; Retrono de todos los registros a su estado inicial
	pop bx ; ya que la funcion no devuelve parametros
	pop ax ;
	pop bp ;
	ret 6  ; Ret 6 para limpiar la pila de los pushes hechos en main
setBallDirec endp

;-----------------------------------------------------------------

end main
