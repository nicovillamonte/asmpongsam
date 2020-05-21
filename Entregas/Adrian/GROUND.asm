.8086
.model small
.stack 100h
.data
SCREEN 	DB 	        20h,0DEh,37 dup (20h),0BAh,37 dup (20h),20h,0DDh
		DB	0Dh,0Ah,20h,0DEh,37 dup (20h),0BAh,37 dup (20h),20h,0DDh
		DB	0Dh,0Ah,20h,0DEh,37 dup (20h),0BAh,37 dup (20h),20h,0DDh
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
main proc
	MOV AX,@DATA
	MOV DS,AX

	CALL Draw

	mov ah,08h
	int 21h

	MOV AX,4C00h
	INT 21h
main endp

;-----------------------------------------------------------------

Draw proc
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
	;Ezequiel
setCoord endp

;-----------------------------------------------------------------

getCoord proc
	;Ezequiel
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
        ;Push bx
        ;Push cx
        Push dx
        ;Push si
        
        ;Pongo coord(x1, y1) en DX.
        mov dx, ss:[bp+4]
        ;Busco valor ASCII en coord (x1,y1).
        call getCoord

        ;Muevo a DX las coord (x2,y2).
        mov dx, ss:[bp+2]

        ;Guardo en ah el valor ASCII de las coord(x1,y1)
   		mov ah, al

   		;Busco valor ASCII de las coord (x2,y2)    
   		call getCoord

   		;Pongo coord(x1, y1) en DX.
        mov dx, ss:[bp+4]

        ;Muevo valor ASCII de las coord(x2,y2) a (x1,y1).
        call setCoord

        ;Muevo valor ASCII (x1,y1) que esta en ah a al.
        mov al, ah

        ;Muevo a DX las coord (x2,y2).
        mov dx, ss:[bp+2]

        ;Muevo valor ASCII de las coord(x1,y1) a (x2,y2).
        call setCoord

		;pop di
        ;pop si
        pop dx
        ;pop cx
        ;pop bx
        pop ax
        popf
        pop bp
        ret 4  	
chgCoord endp

;-----------------------------------------------------------------

getPos proc
	;Mateo
getPos endp

;-----------------------------------------------------------------

getPosXY proc
	;Mateo
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
        mov ax, ss:[bp+2]
        ;Pongo las coordenadas (xf,yf)
        mov cx, ss:[bp+4]
        ;Pongo las coordenadas (xi,yi), repito en bx para tener como volver atras en dx.
        mov bx, ss:[bp+6]
        mov dx, ss:[bp+6] 

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
        ;pop di
        ;pop si
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