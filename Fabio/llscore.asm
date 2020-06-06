.8086
.model small

.stack 100h
.data
pregunta1 db "Ingresar score jug1: ", '$'
pregunta2 db "Ingresar score jug2: ", '$'
salto db 0dh, 0ah, '$'

.code

extrn SCORE:proc

; solo para usar la rutina scorpongmai
main PROC
	MOV	AX,@data
	MOV	DS, AX

	lea dx, pregunta1
	mov ah, 9
	int 21h
	
uno:
	mov ah,1
	int 21h
	
	mov ah, 00h
	sub al,30h
	xor cx, cx
	mov cl, 0ah
	mul cl
	mov cx, ax
	
	mov ah,1
	int 21h

	mov ah, 00h
	sub al,30h
	add ax, cx

	shl ax, 8
	push ax
	
dos:
	lea dx, salto
	mov ah, 9
	int 21h

	lea dx, pregunta2
	mov ah, 9
	int 21h
	
	mov ah,1
	int 21h
	
	mov ah, 00h
	sub al,30h
	xor cx, cx
	mov cl, 0ah
	mul cl
	mov cx, ax
	
	mov ah,1
	int 21h

	mov ah, 00h
	sub al,30h
	add ax, cx
	
	pop bx
	add ax, bx ; paso parámetro de scores de los dos jugadores por AX. Por ejempo si hay que mostrar 9 a 8 se pasa 0908h.
						; Si hay que mostrar 31 a 42 se pasa 1F2Ah, o sea, en hexa
	CALL SCORE

	MOV AX, 4C00h
	INT 21h
main ENDP

CLS proc ; limpiar la pantalla como el CLS desde el prompt del DOS
	push ax
	push es
	push cx
	push di
	mov ax,3
	int 10h
	mov ax,0b800h
	mov es,ax
	mov cx,1000
	mov ax,7
	mov di,ax
	cld
	rep stosw
	pop di
	pop cx
	pop es
	pop ax
	ret 
CLS endp


END main