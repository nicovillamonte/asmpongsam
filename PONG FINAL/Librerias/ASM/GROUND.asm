.8086
.model small
.stack 100h
BytesPL		EQU		78d
.data
SCREEN 	DB 	        20h,020h,37 dup (20h),0BAh,37 dup (20h),20h,020h
		DB	0Dh,0Ah,20h,020h,37 dup (20h),0BAh,37 dup (20h),20h,020h
		DB	0Dh,0Ah,20h,020h,37 dup (20h),0BAh,37 dup (20h),20h,020h
		DB	0Dh,0Ah,20h, 20h,37 dup (20h),0BAh,37 dup (20h),20h,020h
		DB	0Dh,0Ah,20h, 20h,37 dup (20h),0BAh,37 dup (20h),20h,020h
		DB	0Dh,0Ah,20h, 20h,37 dup (20h),0BAh,37 dup (20h),20h,020h
		DB	0Dh,0Ah,20h, 20h,37 dup (20h),0BAh,37 dup (20h),20h,020h
		DB	0Dh,0Ah,20h, 20h,37 dup (20h),0BAh,37 dup (20h),20h,020h
		DB	0Dh,0Ah,20h, 20h,37 dup (20h),0BAh,37 dup (20h),20h,020h
		DB	0Dh,0Ah,20h, 20h,37 dup (20h),0BAh,37 dup (20h),20h,020h
		DB	0Dh,0Ah,20h, 20h,37 dup (20h),0BAh,37 dup (20h),20h,020h
		DB	0Dh,0Ah,20h, 20h,37 dup (20h),0BAh,37 dup (20h),20h,020h
		DB	0Dh,0Ah,20h, 20h,37 dup (20h),0BAh,37 dup (20h),20h,020h
		DB	0Dh,0Ah,20h, 20h,37 dup (20h),0BAh,37 dup (20h),20h,020h
		DB	0Dh,0Ah,20h, 20h,37 dup (20h),0BAh,37 dup (20h),20h,020h
		DB	0Dh,0Ah,20h, 20h,37 dup (20h),0BAh,37 dup (20h),20h,020h
		DB	0Dh,0Ah,20h, 20h,37 dup (20h),0BAh,37 dup (20h),20h,020h
		DB	0Dh,0Ah,20h, 20h,37 dup (20h),0BAh,37 dup (20h),20h,020h
		DB	0Dh,0Ah,20h, 20h,37 dup (20h),0BAh,37 dup (20h),20h,020h
		DB	0Dh,0Ah,20h, 20h,37 dup (20h),0BAh,37 dup (20h),20h,020h
		DB	0Dh,0Ah,20h, 20h,37 dup (20h),0BAh,37 dup (20h),20h,020h
		DB	0Dh,0Ah,20h, 20h,37 dup (20h),0BAh,37 dup (20h),20h,020h
		DB	0Dh,0Ah,20h, 20h,37 dup (20h),0BAh,37 dup (20h),20h,020h
		DB	0Dh,0Ah,20h, 20h,37 dup (20h),0BAh,37 dup (20h),20h,020h
		DB	0Dh,0Ah,20h, 20h,37 dup (20h),0BAh,37 dup (20h),20h,020h,24h
.code
PUBLIC Draw
PUBLIC setCoord
PUBLIC getCoord
PUBLIC chgCoord
PUBLIC getPos
PUBLIC getPosXY
PUBLIC FillSq

main proc
	;NADA.
main endp

;-----------------------------------------------------------------

Draw proc
	;  Se dibuja en pantalla el contenido del vector SCREEN,
	;el mismo ocupara todo el espacio de la pantalla.
	;Antes de dibujar, se limpia la pantalla.

	PUSH AX 					;Push de los registros
	PUSH DX

	MOV AX,03h 					;Borramos pantalla
	INT 10h

	MOV AH,09h 					;Imprimimos el vector SCREEN
	LEA DX,SCREEN
	INT 21h

	POP DX 						;Pop de los registros
	POP AX
	RET
Draw endp

;-----------------------------------------------------------------

setCoord proc
	;Esta funcion recibira el valor ASCII a posicionar en SCREEN en AL
 	;Recibira las coordenadas (x,y) en DH y DL en su respectivo orden 
 	;Estas coordenadas las enviara a la funcion getPos para recibir la posicion en DX
 	;Con la posicion en DX y el valor ASCII en AL, modificamos el vector SCREEN 

	push ax
	push bx
	push dx

	call getPos  			;Envio DH y DL a getPos y recibo DX

	mov bx, dx
	mov SCREEN[bx], al      ;Modifico el vector SCREEN ingresando el ASCII obtenido en AL

	pop dx
	pop bx
	pop ax
	ret
setCoord endp

;-----------------------------------------------------------------

getCoord proc
	;Esta funcion recibira las coordenadas (x,y) en DH y DL en su respectivo orden 
   	;y devuelve el valor ASCII de esa posicion en AL
   
   	push bx
  	push dx

  	call getPos  		;Envio DH y DL a getPos y recibo DX

   	mov bx, dx
   	mov al, SCREEN[bx]  ;devuelvo el valor ASCII

   	pop dx
   	pop bx
   	ret
getCoord endp

;-----------------------------------------------------------------

chgCoord proc
;Intercambia dos valores ASCII.
;Recibe las coordenadas (x1,y1), (x2,y2).
;Las coord x o y no pueden ser de mas de 8 bits de longitud
;Deben pushearse de tal forma, que al extraerlas del stack
;la coordenada x quede en la parte alta y la coordenada y
;quede en la parte baja del registro.
    push bp 
    mov bp, sp
    Pushf
    Push ax
    Push dx
    
    ;Pongo coord(x1, y1) en DX.
    mov dx, ss:[bp+6]
    ;Busco valor ASCII en coord (x1,y1).
    call getCoord

    ;Muevo a DX las coord (x2,y2).
    mov dx, ss:[bp+4]

    ;Guardo en ah el valor ASCII de las coord(x1,y1)
	mov ah, al

	;Busco valor ASCII de las coord (x2,y2)    
	call getCoord

	;Pongo coord(x1, y1) en DX.
    mov dx, ss:[bp+6]

    ;Muevo valor ASCII de las coord(x2,y2) a (x1,y1).
    call setCoord

    ;Muevo valor ASCII (x1,y1) que esta en ah a al.
    mov al, ah

    ;Muevo a DX las coord (x2,y2).
    mov dx, ss:[bp+4]

    ;Muevo valor ASCII de las coord(x1,y1) a (x2,y2).
    call setCoord

    pop dx
    pop ax
    popf
    pop bp
    ret 4
chgCoord endp

;-----------------------------------------------------------------

getPos proc
	push ax
	push bx

	xor ax, ax
	mov al, dl
	mov bl, BytesPL
	add bl, 3
	mul bl
	xchg dh, dl
	xor dh, dh
	add ax, dx
	mov dx, ax

	pop bx
	pop ax
	ret
getPos endp

;-----------------------------------------------------------------

getPosXY proc
	push ax
	push bx
	push cx
	push dx
	xor cx, cx

	;PosY
	mov ax, dx
	mov bl, BytesPL
	div bl
	mov bh, 3
	mul bh
	sub dx, ax
	mov ax, dx
	div bl
	mov cl, al
		
	;PosX
	pop dx
	mov ax, dx
	mov bl, BytesPL
	div bl
	mov bh, 3
	mul bh
	sub dx, ax
	mov ax, dx
	div bl
	mov ch, ah

	;FinPosXY
	mov dx, cx		
	pop cx
	pop bx
	pop ax
	ret
getPosXY endp

;-----------------------------------------------------------------

FillSq proc
;Sobreescribe dos valores ASCII correspondiente a (x1,y1) y (x2,y2).
;Recibe las coordenadas (x1,y1), (x2,y2).
;Deben pushearse de tal forma, que al extraerlas del stack
;la coordenada x quede en la parte alta y la coordenada y
;quede en la parte baja del registro.
;El valor ASCII pusheado debe quedar en la parte baja del registro. 
	push bp 
    mov bp, sp
    Pushf
    Push ax
    Push bx
    Push cx
    Push dx
    ;Push si
    ;Push di
    ;Pongo valor ASCII en ax(al)
    mov ax, ss:[bp+4]
    ;Pongo las coordenadas (xf,yf)
    mov cx, ss:[bp+6]
    ;Pongo las coordenadas (xi,yi), repito en bx para tener como volver atras en dx.
    mov bx, ss:[bp+8]
    mov dx, ss:[bp+8] 

	columna: 
		;Reescribo un caracter ASCIi
        call setCoord
        ;Incremento la columna(dh) y comparo con fila(dl) para ver si tengo que correrla.
        inc dh        
        cmp dh, ch
        jg fila
        jmp columna

	fila:   
		;Vulevo al valor inicial la columna(dh)
        mov dh, bh 
        ;incremento la fila(dl). Comparo para ver si termine o si no,
        ;salto a columna para cambiar las filas restantes.
        inc dl
        cmp dl, cl
        jg fin 
        jmp columna

	fin:
    pop dx
    pop cx
    pop bx
    pop ax
    popf
    pop bp
    ret 6 
FillSq endp

;-----------------------------------------------------------------

end main			