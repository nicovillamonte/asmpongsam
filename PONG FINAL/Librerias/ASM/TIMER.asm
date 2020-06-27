.8086
.model small
.stack 100h
.data

.code
PUBLIC TimRst
PUBLIC TimSet
PUBLIC TimSetC
;PUBLIC getTim
PUBLIC getTimC
;PUBLIC cmpMiliSec

main proc
	;NADA.
main endp

;-----------------------------------------------------------------

TimRst proc
	push ax
	push cx
	push dx
	
	mov ah,01h		;resetea por default el valor del flag de medianoche		
	xor cx,cx		;pongo en 0 el valor del timer en ambas partes 
	xor dx,dx
	int 1Ah	
	
	pop dx
	pop cx
	pop ax
	ret
TimRst endp

;-----------------------------------------------------------------

TimSet proc
	push bp
	mov bp, sp
	push ax
	push bx
	push cx
	push dx
	push si

	xor cx, cx
	xor si, si
	xor dx, dx

	; Calculo de Centecimas
	xor bx, bx
	mov ax, ss:[bp+4]
	xor ah, ah
	mov bl, 0b6h
	mul bl
	mov bx, 03e8h
	div bx
	add si, ax
	jc TS_Carry1
	TS_BtL1:
	cmp dx, 1f4h
	jge TS_PulsoExtra1
	jmp TS_Segundos

	TS_Carry1:
	inc cx
	jmp TS_BtL1

	TS_PulsoExtra1:
	inc si

	; Calculo de Segundos
	TS_Segundos:
	xor bx, bx
	xor dx, dx
	mov ax, ss:[bp+4]
	mov al, ah
	xor ah, ah
	mov bl, 12h
	mul bl
	add si, ax
	jc TS_Carry2
	
	TS_BtL2:
	xor bx, bx
	xor dx, dx
	mov ax, ss:[bp+4]
	mov al, ah
	xor ah, ah
	mov bl, 15h
	mul bl
	mov bx, 64h
	div bx
	add si, ax
	jc TS_Carry3
	
	TS_BtL3:
	cmp dx, 32h
	jge TS_PulsoExtra2
	jmp TS_Minutos

	TS_Carry2:
	inc cx
	jmp TS_BtL2

	TS_Carry3:
	inc cx
	jmp TS_BtL3

	TS_PulsoExtra2:
	inc si

	; Calculo de Minutos
	TS_Minutos:
	xor bx, bx
	xor dx, dx
	mov ax, ss:[bp+6]
	xor ah, ah
	mov bx, 444h
	mul bx
	add si, ax
	jc TS_Carry4
	
	TS_BtL4:
	xor bx, bx
	xor dx, dx
	mov ax, ss:[bp+6]
	xor ah, ah
	mov bl, 26h
	mul bl
	mov bx, 64h
	div bx
	add si, ax
	jc TS_Carry5
	
	TS_BtL5:
	cmp dx, 32h
	jge TS_PulsoExtra3
	jmp TS_Horas

	TS_Carry4:
	inc cx
	jmp TS_BtL4

	TS_Carry5:
	inc cx
	jmp TS_BtL5

	TS_PulsoExtra3:
	inc si

	; Calculo de Horas
	TS_Horas:
	xor bx, bx
	xor dx, dx
	mov ax, ss:[bp+6]
	mov al, ah
	xor ah, ah
	mov bx, 8003h
	mul bx
	add dx, dx
	add ax, ax
	jc TS_Carry6
	ADD CX,DX 				;AGREGADO
	ADD SI,AX 				;AGREGADO
	jc TS_CarryAGREGADO		;AGREGADO
	
	TS_BtL6:
	xor bx, bx
	xor dx, dx
	mov ax, ss:[bp+6]
	mov al, al
	xor ah, ah
	mov bl, 21h
	mul bl
	mov bx, 64h
	div bx
	add si, ax
	jc TS_Carry7
	
	TS_BtL7:
	cmp dx, 32h
	jge TS_PulsoExtra4
	jmp TS_Fin

	TS_Carry6:
	inc dx
	add cx, dx
	ADD SI,AX 						;AGREGADO
	JC TS_CarryAGREGADO 			;AGREGADO
	jmp TS_BtL6

	TS_CarryAGREGADO: 			;AGREGADO
	INC CX 						;AGREGADO
	jmp TS_BtL6 				;AGREGADO

	TS_Carry7:
	inc cx
	jmp TS_BtL7

	TS_PulsoExtra4:
	inc si

	TS_Fin:
	mov dx, si
	mov ax, 0100h
	int 1ah

	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 4
TimSet endp

;-----------------------------------------------------------------

TimSetC proc
	;Setea el contador por cantidad de clocks.
;Recibe dos push. El primero es la parte alta del contador y el segundo la parte baja.
;Asegurarse antes de hacer el push que el registro usado para el mismo este limpio. 
;Recuerde que cada segundo son aprox. 18.2 pulsos de clock.
;
	;Guardo en la pila los registros que necesito para el poceso.
	push bp 
	mov bp, sp 
	pushf 
	push ax
	push cx
	push dx
	;Limpio los registros que voy a usar para asegurarme que no queden residuos.
	xor ax, ax
	xor cx, cx
	xor dx, dx

	;Pongo en ah la funcion que voy a usar de la int 1Ah
	mov ah, 01h
	;Pusheo desde la pila los valores pasado, en cx y dx la parte alta y baja del contador respectivamente.
	mov cx, ss:[bp+6]
	mov dx, ss:[bp+4]
	int 1Ah

	;Devuelvo los valores de los registros y limpio la pila.
	pop dx
	pop cx
	pop ax
	popf
	pop bp
	ret 4
TimSetC endp

;-----------------------------------------------------------------

getTim proc
	;Mate
getTim endp

;-----------------------------------------------------------------

getTimC proc      
	;Esta funcion tiene como objetivo devolver el tiempo actual del contador en ciclos de clock 
	PUSH AX

	mov AH, 00h   ;En CX se devolvera la parte mas significativa del contador
	int 1Ah       ;En DX se devolvera la parte menos significativa del contador

	POP AX
	ret
getTimC endp

;-----------------------------------------------------------------

cmpMiliSec proc
	;Lucas
cmpMiliSec endp

;-----------------------------------------------------------------

end main