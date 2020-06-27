.8086
.model small
.stack 100h
INCLUDE STRUCS.inc 			;Incluimos las estructuras a utilizar en el pong (TIMER-PALETTE-BALL)
INCLUDE GROUND.inc 				;Incluimos la libreria GROUND para el manejo de la pantalla.
;INCLUDE TIMER.inc 				;Incluimos la libreria TIMER para el manejo del tiempo. (No puede estar incluida si se va a usar TIMER2)
INCLUDE TIMER2.inc 				;Incluimos la libreria TIMER2 para el manejo del tiempo. (No puede estar incluida si se va a usar TIMER)
INCLUDE KEYBOARD.inc 			;Incluimos la libreria KEYBOARD para el manejo del teclado.
INCLUDE PALETTE.inc 			;Incluimos la libreria PALETTE para el manejo y creación de las paletas.
INCLUDE BALL.inc 				;Incluimos la libreria BALL para el manejo y creación de la pelota.
INCLUDE SCORE.inc 				;Incluimos la libreria SCORE para el manejo de la puntuación.
INCLUDE SOUND.inc 				;Incluimos la libreria SOUND para el manejo del sonido del juego.

; -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
; Aclaracion: El PONG se cierra con la tecla ESC!!!
; -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.data

	Paleta1 Palette <03h,02h,0deh,03h>
	Paleta2 Palette <4ch,02h,0ddh,03h>
	Pelota1 Ball 	<27h,0ah,0feh,01h,00h,01h>
	Timer1  Timer 	<>
	Timer2  Timer   <>

	KeyFlag db 1, 1, 1, 1
	Puntaje db 0, 0

.code
main proc
	mov ax, @data
	mov ds, ax

Pong_Inicializacion:
	call initializateBall
	call initializatePalette

	lea di, Timer1
	call TimRst
	lea di, Timer2
	call TimRst

	jmp Pong_RstCiclo

Pong_CicloPrincipal:
	call DrawScreen

	lea di, Timer2
	mov dx, 02h
	call cmpMilisec
	jz Pong_MoverPaleta

Pong_VolverP:
	lea di, Timer1
	mov dx, 07h
	call cmpMilisec
	jz Pong_RstCiclo

	call getScanCode
	mov ah, 01h
	call SCtoASCII
	cmp al, 01bh
	je FinPong

	jmp Pong_CicloPrincipal

Pong_MoverPaleta:
	call TimRst
	call MoverPaleta
	jmp Pong_VolverP

Pong_RstCiclo:
	call RstCiclo
	jmp Pong_CicloPrincipal

FinPong:
	mov ax,4c00h
	int 21h
main endp

; -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

DrawScreen proc

	lea di, Paleta1
	call refreshPalette
	lea di,Paleta2
	call refreshPalette
	lea di, Pelota1
	call refreshBall
	call Draw

	ret

DrawScreen endp

; -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

RstCiclo proc
	pushf
	push ax
	push bx
	push cx
	push dx

	xor ax, ax
	xor cx, cx
	xor dx, dx

Rst_RstCiclo:
	call TimRst

Rst_Ejecucion:
	call PongScore
	lea di, Pelota1
	call moveBall
	call refreshBall

	call Rebote

Rst_Fin:
	pop dx
	pop cx
	pop bx
	pop ax
	popf
	ret

RstCiclo endp

; -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

RebotePaleta proc
	pushf
	push ax
	push bx
	push cx
	push dx

	xor ax, ax
	xor bx, bx
	xor cx, cx
	xor dx, dx

	lea di, Pelota1
	call getBallPos
	cmp dh, 27h
	jl RP_ReboteIzquierda
	jg RP_ReboteDerecha
	jmp RP_Fin

RP_ReboteIzquierda:
	lea di, Pelota1
	call getBallDirec
	cmp al, 02h
	je RP_ReboteIzq2
	cmp al, 03h
	je RP_ReboteIzq3
	jmp RP_Fin
RP_ReboteDerecha:
	lea di, Pelota1
	call getBallDirec
	cmp al, 02h
	je RP_ReboteDer2
	cmp al, 03h
	je RP_ReboteDer3
	jmp RP_Fin

RP_ReboteIzq2:
	call getBallPos
	cmp dh, 05h
	je RP_Izquierda1
	jmp RP_Fin
RP_ReboteIzq3:
	call getBallPos
	cmp dh, 05h
	je RP_Izquierda1
	cmp dh, 06h
	je RP_Izquierda2
	jmp RP_Fin
RP_ReboteDer2:
	call getBallPos
	cmp dh, 04ah
	je RP_Derecha1
	jmp RP_Fin
RP_ReboteDer3:
	call getBallPos
	cmp dh, 04ah
	je RP_Derecha1
	cmp dh, 049h
	je RP_Derecha2
	jmp RP_Fin

RP_Izquierda1:
	lea di, Pelota1
	mov dh, 04h
	mov dl, 0ffh
	call setBallPos
	jmp RP_Fin
RP_Izquierda2:
	lea di, Pelota1
	mov dh, 04h
	mov dl, 0ffh
	call setBallPos
	jmp RP_Fin

RP_Derecha1:
	lea di, Pelota1
	mov dh, 04bh
	mov dl, 0ffh
	call setBallPos
	jmp RP_Fin
RP_Derecha2:
	lea di, Pelota1
	mov dh, 04bh
	mov dl, 0ffh
	call setBallPos
	jmp RP_Fin

RP_Fin:
	pop dx
	pop cx
	pop bx
	pop ax
	popf
	ret

RebotePaleta endp

; -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Rebote proc
	pushf
	push ax
	push bx
	push cx
	push dx

	call RebotePaleta

Rbt_RebotePaleta:
	lea di, Pelota1
	call getBallPos
	lea di, Paleta1
	dec dh
	call isPaletteAt
	jz Rbt_ReboteIzquierda
	lea di, Pelota1
	call getBallPos
	lea di, Paleta2
	inc dh
	call isPaletteAt
	jz Rbt_ReboteDerecha
	jmp Rbt_RebotePelota

Rbt_ReboteIzquierda:
	cmp dl, 00h
	je Rbt_ReboteIzquierdaC

Rbt_ReboteIzquierdaE:
	lea di, Pelota1
	xor ax, ax
	xor cx, cx
	xor dx, dx
	call getBallDirec
	inc al
	cmp al, 03h
	jg Rbt_BajarDirecI
Rbt_RI:
	xchg dh, cl
	mov cl, 01h
	push ax
	push cx
	push dx
	call setBallDirec
	call Sonido
	jmp Rbt_RebotePelota

Rbt_BajarDirecI:
	mov al, 01h
	jmp Rbt_RI

Rbt_ReboteIzquierdaC:
	lea di, Pelota1
	xor ax, ax
	xor cx, cx
	xor dx, dx
	call getBallDirec
	xchg dh, cl
	mov cl, 01h
	push ax
	push cx
	push dx
	call setBallDirec
	call Sonido
	jmp Rbt_RebotePelota

Rbt_ReboteDerecha:
	cmp dl, 00h
	je Rbt_ReboteDerechaC

Rbt_ReboteDerechaE:
	lea di, Pelota1
	xor ax, ax
	xor cx, cx
	xor dx, dx
	call getBallDirec
	inc al
	cmp al, 03h
	jg Rbt_BajarDirecD
Rbt_RD:
	xchg dh, cl
	mov cl, 00h
	push ax
	push cx
	push dx
	call setBallDirec
	call Sonido
	jmp Rbt_RebotePelota

Rbt_BajarDirecD:
	mov al, 01h
	jmp Rbt_RD

Rbt_ReboteDerechaC:
	lea di, Pelota1
	xor ax, ax
	xor cx, cx
	xor dx, dx
	call getBallDirec
	xchg dh, cl
	mov cl, 00h
	push ax
	push cx
	push dx
	call setBallDirec
	call Sonido
	jmp Rbt_RebotePelota

Rbt_RebotePelota:
	lea di, Pelota1
	call getBallPos
	cmp dl, 00h
	je Rbt_ReboteSuperior
	cmp dl, 18h
	je Rbt_ReboteInferior
	jmp Rbt_Fin

Rbt_ReboteSuperior:
	xor ax, ax
	xor cx, cx
	xor dx, dx
	lea di, Pelota1
	call getBallDirec
	xchg dh, cl
	push ax
	push cx
	mov dl, 00h
	push dx
	call setBallDirec
	call Sonido
	jmp Rbt_Fin

Rbt_ReboteInferior:
	xor ax, ax
	xor cx, cx
	xor dx, dx
	lea di, Pelota1
	call getBallDirec
	xchg dh, cl
	mov dl, 01h
	push ax
	push cx
	push dx
	call setBallDirec
	call Sonido

Rbt_Fin:
	pop dx
	pop cx
	pop bx
	pop ax
	popf
	ret

Rebote endp

; -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

PongScore proc
	pushf
	push ax
	push bx
	push cx
	push dx

	xor ax, ax
	xor bx, bx
	xor cx, cx
	xor dx, dx

PS_Ejecucion:
	lea di, Pelota1
	call getBallPos
	cmp dh, 02h
	jl PS_PuntoIzq
	cmp dh, 4dh
	jg PS_PuntoDer
	jmp PS_Fin

PS_PuntoIzq:
	call SonidoPunto
	lea di, Puntaje
	mov ah, [di]
	mov al, [di+1]
	inc al
	mov [di], ah
	mov [di+1], al
	call ShowScore
	mov ax, 0ffh
	push ax
	call delayMilisec
	call EraseScore
	mov ax, 0fh
	push ax
	call delayMilisec
	lea di, Pelota1
	lea si, Paleta2
	mov dl, 00h
	call initialPosBall
	jmp PS_Fin

PS_PuntoDer:
	call SonidoPunto
	lea di, Puntaje
	mov ah, [di]
	mov al, [di+1]
	inc ah
	mov [di], ah
	mov [di+1], al
	call ShowScore
	mov ax, 0ffh
	push ax
	call delayMilisec
	call EraseScore
	mov ax, 0fh
	push ax
	call delayMilisec
	lea di, Pelota1
	lea si, Paleta1
	mov dl, 01h
	call initialPosBall
	jmp PS_Fin

PS_Fin:
	pop dx
	pop cx
	pop bx
	pop ax
	popf
	ret
PongScore endp

; -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

SonidoPunto proc

	push ax

	mov ax, 30h
	push ax
	call delayMilisec
	call Sonido
	mov ax, 1ah
	push ax
	call delayMilisec
	call Sonido
	mov ax, 1ah
	push ax
	call delayMilisec
	call Sonido2

	pop ax
	ret

SonidoPunto endp

; -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Sonido proc

	call startSound
	mov ax, 01h
	push ax
	call delayMilisec
	call stopSound

	ret

Sonido endp

; -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Sonido2 proc

	call startSound
	mov ax, 20h
	push ax
	call delayMilisec
	call stopSound

	ret

Sonido2 endp

; -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

MoverPaleta proc
	push ax
	push bx

MP_Comparar:
	call getScanCode
	mov ah, 01h
	call SCtoASCII
MP_Comparar1:
	cmp al, 77h
	je MP_FW
MP_Comparar2:
	cmp al, 73h
	je MP_FS
MP_Comparar3:
	cmp al, 69h
	je MP_FI
MP_Comparar4:
	cmp al, 6bh
	je MP_FK
	jmp MP_Mover1

MP_FW:
	cmp ah, 00h
	je MP_0FW
	jmp MP_1FW
MP_FS:
	cmp ah, 00h
	je MP_0FS
	jmp MP_1FS
MP_FI:
	cmp ah, 00h
	je MP_0FI
	jmp MP_1FI
MP_FK:
	cmp ah, 00h
	je MP_0FK
	jmp MP_0FK

MP_0FW:
	mov KeyFlag[0], ah
	mov KeyFlag[1], 01h
	jmp MP_Mover1
MP_0FS:
	mov KeyFlag[1], ah
	mov KeyFlag[0], 01h
	jmp MP_Mover1
MP_0FI:
	mov KeyFlag[2], ah
	mov KeyFlag[3], 01h
	jmp MP_Mover1
MP_0FK:
	mov KeyFlag[3], ah
	mov KeyFlag[2], 01h
	jmp MP_Mover1

MP_1FW:
	mov KeyFlag[0], ah
	jmp MP_Mover1
MP_1FS:
	mov KeyFlag[1], ah
	jmp MP_Mover1
MP_1FI:
	mov KeyFlag[2], ah
	jmp MP_Mover1
MP_1FK:
	mov KeyFlag[3], ah

MP_Mover1:
	lea di, Paleta1
	cmp KeyFlag[0], 00h
	je MP_MoverW
MP_Mover2:
	lea di, Paleta1
	cmp KeyFlag[1], 00h
	je MP_MoverS
MP_Mover3:
	lea di, Paleta2
	cmp KeyFlag[2], 00h
	je MP_MoverI
MP_Mover4:
	lea di, Paleta2
	cmp KeyFlag[3], 00h
	je MP_MoverK
	jmp MP_Fin

MP_MoverW:
	cmp byte ptr [di+1], 00h
	je MP_Mover2
	call goUp
	jmp MP_Mover2
MP_MoverS:
	cmp byte ptr [di+1], 16h
	je MP_Mover3
	call goDown
	jmp MP_Mover3
MP_MoverI:
	cmp byte ptr [di+1], 00h
	je MP_Mover4
	call goUp
	jmp MP_Mover4
MP_MoverK:
	cmp byte ptr [di+1], 16h
	je MP_Fin
	call goDown
	jmp MP_Fin

MP_Fin:
	pop bx
	pop ax
	ret
MoverPaleta endp

; -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

end main