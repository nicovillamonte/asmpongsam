.8086
.model small
.stack 100h
.data
	GTim db 0, 0, 0, 0
.code
PUBLIC TimRst
PUBLIC TimSet
PUBLIC TimSetC
PUBLIC getTim
PUBLIC getTimC
PUBLIC cmpMicroSec

main proc
	MOV AX,@DATA
	MOV DS,AX

	mov ax, 173bh
	push ax
	mov ax, 3b63h
	push ax
	call TimSet
	
	MOV AX,4C00h
	INT 21h
main endp

;-----------------------------------------------------------------

TimRst proc
	;Lucas
TimRst endp

;-----------------------------------------------------------------

; Esta funcion recibe datos(Horas, minutos, segundos y centecimas) por stack que transformara aplicando unos calculos para pasarlos
; a los pulsos de clock equivalentes al tiempo transcurrido desde el 00:00:00:00, para setear el timer o contador de tiempo del
; programa.
;
; Esta funcion recive datos pero no retorna, y borra los datos del stack referentes al uso que la funcion le da.
;

TimSet proc
	push bp
	mov bp, sp
	push ax
	push bx
	push si

	xor cx, cx
	xor si, si

; Calculo de Centecimas
	xor bx, bx			; 
	mov ax, ss:[bp+4]		; Calculo para Transformar las centecimas entregadas por stack en pulsos de clock.
	xor ah, ah			; De los dos valores en el stack agarramos el valor de lower-order del primero.
	mov bl, 0b6h			; Aplicamos una multiplicacion de un numero con coma, que se realiza multiplicando ese numero
	mul bl				; por 10d/100d/1000d en hexa, y despues dividiendo por 10d/100d/1000d segun corresponda
	mov bx, 03e8h			; (En Hexa).
	div bx				;
	add si, ax
	jc TS_Carry1
TS_BtL1:				; Etiqueta para volver a la linea
	cmp dx, 1f4h
	jge PulsoExtra1
	jmp Segundos

TS_Carry1:				;
	inc cx				; Calculo adicional en caso de que exista carry.
	jmp TS_BtL1			;

PulsoExtra1:				; Calculo adicional en caso de que haya que redondear el resto de la division siendo que el
	inc si				; resultado sea < 499d.

; Calculo de Segundos
Segundos:
	xor bx, bx			;
	xor dx, dx			; Calculo para Transformar los segundos entregados por stack en pulsos de clock.
	mov ax, ss:[bp+4]		;
	mov al, ah
	xor ah, ah
	mov bl, 12h
	mul bl
	add si, ax
	jc TS_Carry2
BtL2:
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
BtL3:
	cmp dx, 32h
	jge PulsoExtra2
	jmp Minutos

TS_Carry2:
	inc cx
	jmp BtL2

TS_Carry3:
	inc cx
	jmp BtL3

PulsoExtra2:
	inc si

; Calculo de Minutos
Minutos:
	xor bx, bx			;
	xor dx, dx			; Calculo para Transformar los minutos entregados por stack en pulsos de clock.
	mov ax, ss:[bp+6]		;
	xor ah, ah
	mov bx, 444h
	mul bx
	add si, ax
	jc TS_Carry4
BtL4:
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
BtL5:
	cmp dx, 32h
	jge PulsoExtra3
	jmp Horas

TS_Carry4:
	inc cx
	jmp BtL4

TS_Carry5:
	inc cx
	jmp BtL5

PulsoExtra3:
	inc si

; Calculo de Horas
Horas:
	xor bx, bx			;
	xor dx, dx			; Calculo para Transformar las horas entregadas por stack en pulsos de clock.
	mov ax, ss:[bp+6]		;
	mov al, ah
	xor ah, ah
	mov bx, 8003h
	mul bx
	add dx, dx
	add ax, ax
	jc TS_Carry6
	add cx, dx
	add si, ax
BtL6:
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
BtL7:
	cmp dx, 32h
	jge PulsoExtra4
	jmp Fin

TS_Carry6:
	inc dx
	add cx, dx
	add si, cx
	jc TS_CarryAgregado
	jmp BtL6

TS_CarryAgregado:
	inc cx
	jmp TS_BtL6

TS_Carry7:
	inc cx
	jmp BtL7

PulsoExtra4:
	inc si

Fin:
	mov dx, si
	mov ax, 0100h
	int 1ah

	pop si
	pop bx
	pop ax
	pop bp
	ret 4
TimSet endp

;-----------------------------------------------------------------

TimSetC proc
	;Adrian
TimSetC endp

;-----------------------------------------------------------------

; >> Incompleto <<

getTim proc
	push ax
	push bx

	;xor ax, ax
	;int 1ah
	mov cx, 0001h
	mov dx, 411ch

	xchg cx, dx
	mov ax, cx
	mov bx, 8003h
	div bx
	shr ax, 1
	sub dx, ax
	mov GTim[0], al
	xor ax, ax
	xchg ax, dx
	xor bx, bx
	mov bx, 444h
	div bx
	mov GTim[1], al
	xor ax, ax
	xchg ax, dx
	xor bx, bx
	mov bl, 12h
	div bl
	mov GTim[2], al
	xchg ah, al
	xor ah, ah
	xor bx, bx
	mov bl, 37h
	mul bl
	mov bl, 0ah
	div bl
	add GTim[3], al

	mov ch, GTim[0]
	mov cl, GTim[1]
	mov dh, GTim[2]
	mov dl, GTim[3]

	pop bx
	pop ax
	ret
getTim endp

;-----------------------------------------------------------------

getTimC proc
	;Adrian
getTimC endp

;-----------------------------------------------------------------

cmpMicroSec proc
	;Lucas
cmpMicroSec endp

;-----------------------------------------------------------------

end main
