.8086
.model small
.stack 100h
include STRUCS.inc 				;Incluimos las estructuras a utilizar en el pong (TIMER-PALETTE-BALL)
include GROUND.inc 				;Incluimos la libreria GROUND para el manejo de la pantalla.
;include TIMER.inc 				;Incluimos la libreria TIMER para el manejo del tiempo. (No puede estar incluida si se va a usar TIMER2)
include TIMER2.inc 				;Incluimos la libreria TIMER2 para el manejo del tiempo. (No puede estar incluida si se va a usar TIMER)
include KEYBOARD.inc 			;Incluimos la libreria KEYBOARD para el manejo del teclado.
include PALETTE.inc 			;Incluimos la libreria PALETTE para el manejo y creación de las paletas.
include BALL.inc 				;Incluimos la libreria BALL para el manejo y creación de la pelota.
include SCORE.inc 				;Incluimos la libreria SCORE para el manejo de la puntuación.
include SOUND.inc 				;Incluimos la libreria SOUND para el manejo del sonido del juego.
.data
 
 ;Objetos del juego.
 ball1 BALL <02h,08h,0dch,01h,01h,01h,02h,08h>
 palette1 PALETTE <01h,07h,0deh,03h,01h,07h> 
 palette2 PALETTE <4eh,07h,0ddh,03h,4eh,07h>  

 ;Banderas para teclas presionadas.
 letra_w db 01h
 letra_s db 01h
 letra_i db 01h
 letra_k db 01h

 ;Puntos de los jugadores. 
 Player_1 db 00h
 Player_2 db 00h 

 ;TIMERS
 timerPalette TIMER <> 
 timerSound TIMER <> 
 timerScore Timer <> 

.code
main proc
		mov ax, @data
		mov ds, ax
		
		;Inicializo los objetos.
 		lea di, palette1
 		call initializatePalette
 		call refreshPalette 

 		lea di, palette2
 		call initializatePalette
 		call refreshPalette

 		lea di, ball1
 		call initializateBall
 		call refreshBall 
 		call Draw

 		lea di, timerPalette
 		call TimRst
 		lea di, timerSound
 		call TimRst
		;Ciclo de juego.

Main_Enter:
		;Movimiento de paletas. 
		call getScanCode
		call SCtoASCII 
		cmp al, 20h			 ;Doy condicion de salida con bn minuscula.
		je Main_end1

Main_backGP:		
		lea di, timerPalette
		mov dx, 0004h
		call cmpMilisec
		jnz Main_Enter
								
		call Side 				;Movimiento de paletas.
		call movePalette
				
		lea di, ball1 			;Movimiento de pelotas y control de escore.
		call getBallPos
		cmp dh, 02h 
		je Main_Score1
		cmp dh, 4dh 
		je Main_Score2			

Main_backScore:
		lea di, ball1		
		lea ax, timerSound
 		call DirectionBall
 		call moveBall
 		call draw
		
		lea di, timerPalette 	;Reseteo timer.
 		call TimRst
 		jmp Main_Enter	

Main_Score1: 
		mov ah, dl 
		lea di, palette1
		call getPalettePos  	;Pongo en DX las coords y de ball1 y palette1.
		mov dh, ah  
		mov ah, 01h   			
		call CompBallPalette	
		cmp dh, 01h 			;Compruebo si alguno marco punto. 
		je Convert_Point
		lea di, ball1
		jmp Main_backScore

Main_end1: 
		cmp al, 20h 
		je Main_GP
		jmp Main_end

Main_Score2:
		mov ah, dl 
		lea di, palette2 		;Pongo en DX las coords y de ball1 y palette2.
		call getPalettePos
		mov dh, ah
		mov ah, 00h 
		call CompBallPalette	;Compruebo si alguno marco punto.
		cmp dh, 01h 
		je Convert_Point
		lea di, ball1
		jmp Main_backScore

Convert_Point: 	
		mov bx, dx 				
		lea di, timerScore		
		call TimRst
		call ShowScore

Score_time: 
		mov dx, 00bbh 
		call cmpMilisec
		jnz Score_time
		call eraseScore
		call ContinueGame2
		jmp Main_backScore

Main_GP: 
		call getScanCode
		call SCtoASCII
		cmp al, 62h     ;"b" minuscula para finalizar el programa.
		je Main_EG
		cmp al, 7ah 	;"z" minuscula para continuar el juego. 
		je Main_CG
		cmp al, 78h		;"x" minuscula para iniciar un nuevo juego. 
		je Main_NG
		jmp Main_GP

Main_EG: 
		jmp Main_end

Main_CG: 
		call ContinueGame
		jmp Main_backGP

Main_NG: 
		call NewGame
		jmp Main_Enter

Main_end:
		mov ax, 4c00h
		int 21h
main endp

;Funciones auxiliares:

Side proc
;Recibe en al la tecla presionada, devuelve en di el offset correspondiente a la paleta.
;Sino no corresponde la tecla la no retorna nada. 
;Las letras (w) y (s) corresponden a la palette1, (i) y (k) a la palette2, teclas 
;arriba y abajo respectivamente en cada caso. 
;Tambien modifica las banderas de letras presionadas para saber cuales estan y cuales no. 
	
		pushf
		;push ax
		;push bx
		;push cx
		;push dx
		;push di
		;push si

		cmp al, 77h			;Busco a que palette corresponde la tecla en AL.
		je Side_read1

v1:
		cmp al, 73h
		je Side_read2

v2:
		cmp al, 69h
		je Side_read3

v3: 
		cmp al, 6bh
		je Side_read4
		jmp Side_end 
							;Pongo en DI el ofset del palette correspondiente. 
							;Modifico la bandera correspodiente a la tecla leida. 
Side_read1:
		mov letra_w, ah 
		jmp v1

Side_read2:
		mov letra_s, ah 
		jmp v2

Side_read3:
		mov letra_i, ah 
		jmp v3 

Side_read4:
		mov letra_k, ah 

Side_end: 
		;pop si
		;pop di
		;pop dx
		;pop cx
		;pop bx
		;pop ax 
		popf
		ret 
Side endp 

movePalette proc 
;Si la tecla no corresponde a una palette, no retorna nada. 
		
		;pushf
		;push ax
		push bx
		;push cx
		;push dx
		;push di
		;push si             ;Conservo entorno.

		cmp letra_w, 00h
		je MP_up1

MP_end_up1:
		cmp letra_s, 00h
		je MP_down1

MP_end_down1:
		cmp letra_i, 00h
		je MP_up2

MP_end_up2:
		cmp letra_k, 00h
		je MP_down2
		jmp MP_end

MP_up1: 
		lea di, palette1
		mov bl, [di+01h]
		cmp bl, 00h
		je MP_end_up1
		mov bh, 01h
		mov letra_s, bh 
		call goUp
		call refreshPalette
		call Draw
		jmp MP_end_up1

MP_down1:
		lea di, palette1
		mov bl, [di+01h]
		cmp bl, 16h
		je MP_end_down1
		mov bh, 01h
		mov letra_w, bh 
		call goDown
		call refreshPalette
		call Draw
		jmp MP_end_down1

MP_up2:
		lea di, palette2
		mov bl, [di+01h]
		cmp bl, 00h
		je MP_end_up2
		mov bh, 01h
		mov letra_k, bh
		call goUp
		call refreshPalette
		call Draw
		jmp MP_end_up2

MP_down2:
		lea di, palette2
		mov bl, [di+01h]
		cmp bl, 16h
		je MP_end
		mov bh, 01h
		mov letra_i, bh
		call goDown
		call refreshPalette
		call Draw

MP_end: 
		;pop si
		;pop di
		;pop dx
		;pop cx
		pop bx
		;pop ax 
		;popf		;Recupero entorno antes de volver. 
		ret 
movePalette endp

DirectionBall proc
		pushf
		;push ax
		push bx
		;push cx
		push dx
		;push di
		;push si             ;Conservo entorno. 

		call getBallPos
		cmp dh, 02h 
		jle change1
		cmp dh, 4dh
		jge change2

back12: 
		cmp dh, 02h 
		jle DB_semend 
		cmp dh, 4dh
		jge DB_semend
		cmp dl, 00h
		jle change3
		cmp dl, 18h
		jge change4
DB_semend:
		jmp DB_end

change1: 
		call BreakBall
		push bx
		mov bx, 0001h
		push bx
		mov bx, 00ffh
		push bx
		call setBallDirec 
		push Di 			;Sonido de rebote.
		push DX 
		call StartSound
		lea di, timerSound
		call TimRst 
sound1: 
		mov dx, 0003h
		call cmpMilisec
		jnz sound1
		call StopSound
		pop dx
		pop di 
		jmp back12

change2: 
		call BreakBall
		push bx
		mov bx, 0000h
		push bx
		mov bx, 00ffh
		push bx
		call setBallDirec 
		push Di 				;Sonido de rebote.
		push DX 
		call StartSound
		lea di, timerSound
		call TimRst 
sound2: 
		mov dx, 0003h
		call cmpMilisec
		jnz sound2
		call StopSound
		pop dx
		pop di 
		jmp back12

change3:
		call BreakBall
		push bx
		mov bx, 00ffh
		push bx
		mov bx, 0000h
		push bx
		call setBallDirec
		push Di 			;Sonido de rebote.
		push DX 
		call StartSound
		lea di, timerSound
		call TimRst 
sound3: 
		mov dx, 0003h
		call cmpMilisec
		jnz sound3
		call StopSound
		pop dx
		pop di 
		jmp DB_end

change4: 
		call BreakBall
		push bx
		mov bx, 00ffh
		push bx
		mov bx, 0001h
		push bx
		call setBallDirec
		push Di 			;Sonido de rebote.
		push DX 
		call StartSound
		lea di, timerSound
		call TimRst 
sound4: 
		mov dx, 0003h
		call cmpMilisec
		jnz sound4
		call StopSound
		pop dx
		pop di 
		jmp DB_end

DB_end: 
		;pop si
		;pop di
		pop dx
		;pop cx
		pop bx
		;pop ax 
		popf		;Recupero entorno antes de volver. 
		ret 
DirectionBall endp

BreakBall proc 
		pushf
		push ax
		;push bx
		;push cx
		push dx
		;push di
		;push si             ;Conservo entorno. 
		
		call getBallDirec

		cmp al,01h
		je BB_mod1 
		cmp al,02h
		je BB_mod2 
		cmp al,03h
		je BB_mod3 

BB_mod1:
		mov bx, 0003h
		jmp BB_comp 

BB_mod2:
		mov bx, 0001h 
		jmp BB_comp

BB_mod3:
		mov bx, 0002h

BB_comp: 
		 cmp dh, 04h
		 jle BB_reduc
		 cmp dh, 4bh
		 jge BB_reduc
		 jmp BB_end

BB_reduc: 
		mov bx, 0001h 

BB_end: 
		;pop si
		;pop di
		pop dx
		;pop cx
		;pop bx
		pop ax 
		popf		;Recupero entorno antes de volver. 
		ret 
BreakBall endp

CompBallPalette proc
;Recibe en DH la coord y de ball1 y en DL la coord y de palettex
;Si en ninguno de los lugares donde está la palettex, está ball1, suma un punto
;al jugador contrario.
;Devuelve el AX los puntajes. En AH Player_1 y en AL Player_2.
;En DX condicion de juego. En DH 01h si se marcó un punto, de lo contrario
;no marco nadie y en DL devuelve: 00h si marcó Player_1 y 01h si marcó Player_2.

		pushf
		;push ax
		;push bx
		push cx
		;push dx
		;push di
		;push si             ;Conservo entorno. 

		mov cx, 03h 

CBP_again: 
		cmp dh, dl 
		je CBP_end
		inc dl 
		loop CBP_again 
		jmp CBP_point

CBP_point: 
		cmp ah, 00h 
		je CBP_p1
		cmp ah, 01h 
		je CBP_p2
		jmp CBP_end

CBP_p1: 
		xor dx, dx 
		mov dh, 01h
		mov dl, ah
		xor ax, ax
		mov ah, Player_1
		add ah, 01h 
		mov Player_1, ah 
		jmp CBP_regis 

CBP_p2: 
		xor dx, dx 
		mov dh, 01h
		mov dl, ah
		xor ax, ax
		mov ah, Player_2
		add ah, 01h 
		mov Player_2, ah 
		jmp CBP_regis

CBP_regis: 
		xor ax, ax
		mov ah, Player_1
		mov al, Player_2 

CBP_end: 
		;pop si
		;pop di
		;pop dx
		pop cx
		;pop bx
		;pop ax 
		popf		;Recupero entorno antes de volver. 
		ret 
CompBallPalette endp

ContinueGame proc
		pushf
		;push ax
		;push bx
		;push cx
		;push dx
		push di
		push si      

 		cmp dl, 00h           ;Conservo entorno.									
 		je RG_p1			  ;Si en DL tengo 01h punto Player_2.
 		cmp dl, 01h
 		je RG_p2
 		jmp RG_end 			  ;Inicializo los objetos.

 RG_p1: 
 		lea di, ball1
 		lea si, palette1
 		mov dl, 01h 
 		call initialPosBall
 		call refreshBall
 		jmp RG_PA

 RG_p2: 
 		lea di, ball1
 		lea si, palette2
 		mov dl, 00h 
 		call initialPosBall
 		call refreshBall

RG_PA: 
		call Draw 

RG_end: 
		pop si
		pop di
		;pop dx
		;pop cx
		;pop bx
		;pop ax 
		popf		;Recupero entorno antes de volver. 
		ret 
ContinueGame endp 

ContinueGame2 proc
		pushf
		;push ax
		;push bx
		;push cx
		;push dx
		push di
		push si             		;Conservo entorno.

		lea di, palette1
		mov dx,0107h
		call setPalettePos
		call refreshPalette 

		lea di, palette2
		mov dx,4e07h
		call setPalettePos
		call refreshPalette
		
		lea di, ball1
 		lea si, palette1
 		mov dl, 01h 
 		call initialPosBall
		call refreshBall
		call Draw

		pop si
		pop di
		;pop dx
		;pop cx
		;pop bx
		;pop ax 
		popf		;Recupero entorno antes de volver. 
		ret 
ContinueGame2 endp 

NewGame proc
		pushf
		;push ax
		;push bx
		;push cx
		;push dx
		push di
		push si             		;Conservo entorno.
	
		mov Player_1, 00h
		mov Player_2, 00h
		
		lea di, palette1
		mov dx,0107h
		call setPalettePos
		call refreshPalette 

		lea di, palette2
		mov dx,4e07h
		call setPalettePos
		call refreshPalette
		
		lea di, ball1
 		lea si, palette1
 		mov dl, 01h 
 		call initialPosBall
		call refreshBall
		call Draw

		pop si
		pop di
		;pop dx
		;pop cx
		;pop bx
		;pop ax 
		popf		;Recupero entorno antes de volver. 
		ret 
NewGame endp 
end main
