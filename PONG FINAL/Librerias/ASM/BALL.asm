.8086
.model small
.stack 100h
COORDENADA_X	EQU 	[DI+00h]
COORDENADA_Y	EQU 	[DI+01h]
DIRECMODE		EQU		[DI+03h]
SENTIDMODERL	EQU		[DI+04h]
SENTIDMODEUD	EQU		[DI+05h]
FALSE			EQU		00h
TRUE			EQU		01h
.data

.code
INCLUDE GROUND.inc
INCLUDE PALETTE.inc
PUBLIC initializateBall
PUBLIC refreshBall
PUBLIC moveBall
PUBLIC initialPosBall
PUBLIC getBallPos
PUBLIC setBallPos
PUBLIC getBallDirec
PUBLIC setBallDirec

main proc
	;NADA.
main endp


;-----------------------------------------------------------------

initializateBall proc
	;Recibimos en DI el offset del objeto BALL a inicializar
	PUSH AX
	MOV AL,[DI+00h]
	MOV BYTE PTR [DI+06h],AL
	MOV AL,[DI+01h]
	MOV BYTE PTR [DI+07h],AL
	MOV BYTE PTR [DI+08h],20h
	POP AX
	RET
initializateBall endp

;-----------------------------------------------------------------

refreshBall proc
	;Refresca la posicion de BALL en el vector SCREEN.
	;Recibe el offset de BALL en DI.
	;Utiliza AX y DX internamente, para las funciones de GROUND.
	;Es decir, utiliza dicha libreria!!!
	Pushf
    Push ax
    Push dx

	xor ax, ax
	xor dx, dx

	;Escribo el caracter en backup_ASCII en las coord(x,y) viejas.
	mov al, [di+08h]
	mov dh, [di+06h]
	mov dl, [di+07h]
	call setCoord

	;Busco caracter en las coord(x,y), donde hay que poner la pelota o nuevas.
	mov dh, [di+00h]
	mov dl, [di+01h]
	call getCoord

	;Guardo en backup_ASCII el caracter que estaba en las coord(x,y) nuevas.
	mov [di+08h], al

	;Muevo a al el graf de BALL.
	mov al, [di+02h]
	;Muevo a dx las coord(x,y) nuevas.
	mov dh, [di+00h]
	mov dl, [di+01h]
	;Muevo a las coord(x,y) viejas, las nuevas asi quedan guardadas para la proxima.
	mov [di+06h], dh
	mov [di+07h], dl
	call setCoord 

	RB_fin: 
    pop dx
    pop ax
    popf
    ret  
refreshBall endp

;-----------------------------------------------------------------

moveball proc
	;Recibimos el offset del objeto en DI
	;Dentro del objeto utilizamos [DI+00h] para COORDENADA X
	;Dentro del objeto utilizamos [DI+01h] para COORDENADA Y
	;Dentro del objeto utilizamos [DI+03h] para DIRECCION
	;Dentro del objeto utilizamos [DI+04h] para SENTIDO high (Der-Izq)
	;Dentro del objeto utilizamos [DI+05h] para SENTIDO low  (Arr-Aba)
	PUSH CX

	XOR CX,CX
	MOV CL,DIRECMODE

	CMP BYTE PTR SENTIDMODERL,TRUE
	JE 	MB_DERECHA
	JMP MB_IZQUIERDA

	MB_DERECHA:
		INC BYTE PTR COORDENADA_X
		LOOP MB_DERECHA
		JMP MB_COMP_UD

	MB_IZQUIERDA:
		DEC BYTE PTR COORDENADA_X
		LOOP MB_IZQUIERDA
	
	MB_COMP_UD:
	CMP BYTE PTR SENTIDMODEUD,TRUE
	JE MB_ARRIBA
	JMP MB_ABAJO

	MB_ARRIBA:
		DEC BYTE PTR COORDENADA_Y
		JMP MB_FIN

	MB_ABAJO:
		INC BYTE PTR COORDENADA_Y

	MB_FIN:
	CALL refreshBall
	POP CX
	RET
moveball endp

;-----------------------------------------------------------------

initialPosBall proc 		;En revision
	push ax
	push bx
	push dx
	; Recibe en di el offset de la pelota y en si recive el offset de la paleta.
	; No retorna datos, sino que sobre escribe la posicion de la pelota en el centro de
	; la paleta.
	mov cl,dl
	; Analiza el valor del largo de la paleta para averiguar el centro.
	mov al, [si+3]
	shr al,1
	jnc iPB_LargoPar
	jmp iPB_LargoImpar

	; En caso de ser par incrementa en 1 el resultado de la division y con la posicion
	; en X y en Y, setea la posicion de la pelota.
	iPB_LargoPar:
	dec al
	xchg si,di
	call getPalettePos
	xchg si,di
	mov ah, dh
	add al, dl
	cmp cl,00h
	je IPB_Izquierda
	jmp IPB_Derecha

	; En caso de ser impar deja el resultado de la division como esta y con la posicion
	; en X y en Y, setea la posicion de la pelota.
	iPB_LargoImpar:
	xchg si,di
	call getPalettePos
	xchg si,di
	mov ah, dh
	add al, dl
	cmp cl,00h
	je IPB_Izquierda
	jmp IPB_Derecha


	IPB_Derecha:
	inc ah
	jmp IPB_Mover
	IPB_Izquierda:
	dec ah
	jmp IPB_Mover

	IPB_Mover:
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
	;Esta funcion recibe en DI el offset del objeto BALL.
    ;Devuelve la posicion de la pelota, se devolvera DH con la coordenadas X 
    ;y DL con la coordenadas Y dentro de las coordenadas del objeto BALL.
	mov DH, [DI]
	mov DL, [DI+01h]
	ret
getBallPos endp

;-----------------------------------------------------------------

setBallPos proc
	;Esta funcion recibe en DI el offset del objeto pelota.
    ;En DH recibe la nueva posicion de coordenada X.
    ;En DL recibe la nueva posicion de coordenada Y.
    ;Si ambas coordenadas tienen el valor 0FFh no se cambiara su valor.
    ;En cambio, si solo DH es diferente a 0FFh solo se cambiara la coordenada X.
    ;Si solo DL es diferente a 0FFh solo se cambiara la coordenada Y del objeto BALL.
	cmp DH, 0FFh
	je SBP_miro_coordenadaY2
	jmp SBP_miro_coordenadaY1

	SBP_miro_coordenadaY1: 
	cmp DL, 0FFh
	je SBP_cambio_coordenadaX

	mov byte ptr[DI], DH   ;cambio coordenadas X
	mov byte ptr[DI+01h], DL  ;cambio coordenadas Y
        jmp SBP_finalizo
	SBP_miro_coordenadaY2:
	cmp DL, 0FFh
	je SBP_finalizo
	jmp SBP_cambio_coordenadaY

	SBP_cambio_coordenadaX:   
	mov byte ptr[DI], DH   ;cambio coordenadas X
	jmp SBP_finalizo

	SBP_cambio_coordenadaY:
	mov byte ptr[DI+01h], DL  ;cambio coordenadas Y

	SBP_finalizo:
	ret
setBallPos endp

;-----------------------------------------------------------------

getBallDirec proc
	;Recibe en DI el offset del objeto
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

setBallDirec proc
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
	je SBD_fow			 ;si es igual sigue curso sin cambiar el valor
	mov byte ptr [DI+03h],bl ;cambia el valor del modo de direcionamiento por el ingresado en el push
	SBD_fow:
	mov cx,ss:[bp+6] ;recupero dato de la pila
	cmp cx,0FFh		 ;compara con el valor maximo
	je SBD_fow1			 ;si es igual sigue curso sin cambiar el valor
	mov byte ptr [DI+04h],cl ;cambia el valor de la parte alta del modo de sentido por el ingresado en el push
	SBD_fow1:
	mov dx,ss:[bp+4] ;recupero dato de la pila
	cmp dx,0FFh		 		 ;compara con el valor maximo
	je SBD_ext			 		 ;si es igual sigue curso sin cambiar el valor
	mov byte ptr [DI+05h],dl ;cambia el valor de la parte baja del modo de sentido por el ingresado en el push
	SBD_ext:
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
