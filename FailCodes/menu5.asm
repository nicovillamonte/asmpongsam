.8086
.model small
.stack 100h
.data
	;Vectores que contienen los datos para escribir los pixeles.
	;El programa opera bien, pero utiliza vectores muy grandes en casos que no hacen falta. - Largo / Direc -
	ValorDeX dw 101d, 116d, 162d, 117d, 192d, 267d, 207d, 207d, 297d, 387d, 312d, 417d, 432d, 432d, 507d, 462d, 24h
	ValorDeY dw 075d, 075d,091d, 121d, 091d, 091d, 075d, 166d, 075d, 075d, 091d, 091d, 075d, 165d, 120d, 120d, 24h
	Largo dw 7, 3, 3, 3, 5, 5, 4, 4, 7, 7, 5, 5, 5, 5, 3, 3, 24h
	Direc dw 0, 1, 0, 1, 0, 0, 1, 1, 0, 0, 2, 0, 1, 1, 0, 1, 24h
	
	BackUp dw 0, 24h											;Vector de guia para el loop.
.code

	BloquEstructural proc										;Funcion que arma el bloque basico estructural.
		push di
		xor di, di
		xchg BackUp[0], cx
		mov cx, 15d

ArmarBloque:
		xchg BackUp[0], cx
		int 10h
		inc cx
		xchg BackUp[0], cx
		loop ArmarBloque
		xchg BackUp[0], cx

EjeY:
		sub cx, 15d
		inc dx
		inc di
		cmp di, 15d
		je FinBloque
		xchg BackUp[0], cx
		mov cx, 15d
		jmp ArmarBloque

FinBloque:
		pop di
		ret

	BloquEstructural endp

;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	EstructuraLetra proc										;Funcion que arma las letras.
		mov al, 02h
		xor di, di

		cmp Direc[si], 1
		je Derecha
		cmp Direc[si], 2
		je Diagonal
		
Abajo:
		call BloquEstructural
		inc di
		cmp di, Largo[si]
		je FinEstructura
		jmp Abajo

Derecha:
		call BloquEstructural
		add cx, 15d
		sub dx, 15d
		inc di
		cmp di, Largo[si]
		je FinEstructura
		jmp Derecha

Diagonal:
		call BloquEstructural
		add cx, 15d
		inc di
		cmp di, Largo[si]
		je FinEstructura
		jmp Diagonal

FinEstructura:
		ret

	EstructuraLetra endp

;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	main proc

Inicio:
		mov ax, @data
		mov ds, ax

		mov ax, 0003h
		int 10h
		mov ax, 0012h
		int 10h
		mov ah, 0ch
		
		xor bx, bx
		xor si, si

AwanteFabio:													;Bloque de lectura de datos.
		mov cx, ValorDeX[si]
		mov dx, ValorDeY[si]
		call EstructuraLetra
		add si, 2
		cmp Direc[si], 24h
		je FinMain
		jmp AwanteFabio

FinMain:
		mov ah, 08
		int 21h
		mov ax, 4c00h
		int 21h
	main endp
end main
