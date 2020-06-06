.8086
.model small
.stack 100h
.data
letra db 21 dup (20h), 0dh, 0ah,'$'

.code
main proc
	mov ax,@data
	mov ds,ax
	
	mov cx, 20
	xor si, si
otro:
	mov al, byte ptr es:[82h + si]
	cmp al, 0Dh
	je noconsiderar
	mov offset [letra+si], al
noconsiderar:
	inc si
	loop otro
	
	lea dx, letra
	mov ah, 09h
	int 21h

    mov ah,4ch
    int 21H
main endp
end main
