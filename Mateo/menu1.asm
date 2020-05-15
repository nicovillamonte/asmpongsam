.8086
.model small
.stack 100h
.data

.code
	BloquEstructural proc						;Bloque estructural de las letras
		push bp
		mov bp, sp
		
		push ax
		push si
		push di

ArmarBloque:									;Bloque a usar
		add cx, 001d
		inc si
		int 10h
		cmp si, 14d
		je EjeY
		jmp ArmarBloque

EjeY:
		sub cx, 15d
		xor si, si
		add dx, 001d
		inc di
		cmp di, 15d
		je FinBloque
		jmp ArmarBloque

FinBloque:
		pop di
		pop si
		ret 4
		mov ax, 4c00h
		int 21h
	BloquEstructural endp

	main proc
		mov ax, @data
		mov ds, ax

		mov ax, 0003h
		int 10h
		mov ax, 0012h
		int 10h
		mov ah, 0ch

LetraP:
		mov al, 06h
		mov bh, 0
		mov cx, 050d
		mov dx, 075d

ArmarLetraP:
		add dx, 015d
		call BloquEstructural
		inc si
		cmp si, 5
		je Fin
		jmp ArmarLetraP

Fin:
		mov ah, 08
		int 21h
		mov ax, 4c00h
		int 21h
	main endp
	end main
