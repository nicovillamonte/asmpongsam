.8086
.model small 
.stack 100h
.data 
 mjs db "Holas",24h
.code
public SetTimC
main proc
.startup
		;No hace nada
		mov ax, @data 
		mov ds, ax

		mov cx, 00h
		push cx
		mov cx, 0ffh
		push cx

		call SetTimC

		mov ah, 09h
		mov dx, offset mjs
		int 21h

.exit
main endp

SetTimC proc
	push bp 
	mov bp, sp 
	pushf 
	push ax
	;push bx
	push cx
	push dx
	;push si
	;push di

	xor ax, ax
	xor cx, cx
	xor dx, dx

	mov ah, 01h
	mov cx, ss:[bp+6]
	mov dx, ss:[bp+4]
	int 1Ah

	;pop di
	;pop si
	pop dx
	pop cx
	;pop bx
	pop ax
	pushf
	pop bp
	ret 4
SetTimC endp
end main 
