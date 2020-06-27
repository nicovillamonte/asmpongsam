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
.data
	pal1	PALETTE 	<01h,03h,0DEh,03h>
	pal2	PALETTE 	<4Eh,03h,0DEh,03h>
	pelota	BALL 		<26h,0Ch,0DFh,01h>
	temp	TIMER		<>
	flagD db 1 dup (0)
	flagC db 1 dup (0)
	flagK db 1 dup (0)
	flagM db 1 dup (0)
	punt1 db (0),0dh,0ah,24h
	punt2 db (0),0dh,0ah,24h
	pres db 0dh,0ah,"Bienvenido al pong:",0dh,0ah
		 db "Esc = Salir",0dh,0ah
		 db "Enter = jugar",0dh,0ah
		 db "'A' o 'a' = Agradecimientos",0dh,0ah,24h
	agra db 0dh,0ah,"Quiero agradecer a todos los integrantes del pong",0dh,0ah
		 db "Por la paciencia y la buena onda que hubo",3,0dh,0ah,24h
	Salida db 0dh,0ah,"Gracias por jugar al pong, por favor, no vuelva",24h
	letraP	db	"P",24h
	letraO	db	"O",24h
	letraN	db	"N",24h
	letraG	db	"G",24h
.code
main proc
	MOV AX,@DATA
	MOV DS,AX
	
	call Menu
	
	mov ah,9
	lea dx,pres
	int 21h
inicio:	
	mov ah,1
	int 21h
	cmp al,1Bh
	je M_exit
	cmp al,0Dh
	je CTG
	cmp al,61h
	je cuqui
	cmp al,41h
	je cuqui
	jmp inicio
	
cuqui:
	mov ah,9
	lea dx,agra
	int 21h
leer2:	
	mov ah,1
	int 21h
	cmp al,1Bh
	je M_exit
	cmp al,0Dh
	je CTG
	cmp al,61h
	je cuqui
	cmp al,41h
	je cuqui
	jmp leer2
	
CTG:	
	lea di, pal1			
	call initializatePalette
	lea di, pal2			
	call initializatePalette
	lea di, pelota		
	call initializateBall

	mov bx,01h
	mov cx,01h
	mov dx,00h
	push bx
	push cx
	push dx
	call setBallDirec
	call game

M_exit:
		;añadir cls y texto
	mov ah,0
	mov al,3
	int 10h
	
	mov ah,9
	lea dx,Salida
	int 21h
	
	MOV AX,4C00h
	INT 21h
main endp

Menu proc
mov ah,0
	mov al,3
	int 10h
	
	mov ah,9
	lea dx,letraP
	int 21h
	call StartSound		;sonido
	mov bx,01h			;duracion
	push bx
	call delayMilisec
	call StopSound		;fin sonido
	mov bx,0AAh			;duracion
	push bx
	call delayMilisec
	mov ah,9
	lea dx,letraO
	int 21h
	call StartSound		;sonido
	mov bx,01h			;duracion
	push bx
	call delayMilisec
	call StopSound		;fin sonido
	mov bx,0AAh			;duracion
	push bx
	call delayMilisec
	mov ah,9
	lea dx,letraN
	int 21h
	call StartSound		;sonido
	mov bx,01h			;duracion
	push bx
	call delayMilisec
	call StopSound		;fin sonido
	mov bx,036h			;duracion
	push bx
	call delayMilisec
	mov ah,9
	lea dx,letraG
	int 21h
	call StartSound		;sonido
	mov bx,01h			;duracion
	push bx
	call delayMilisec
	call StopSound		;fin sonido
	mov bx,0FFh			;duracion
	push bx
	call delayMilisec
	
	mov ah,0
	mov al,3
	int 10h
	
	ret
Menu endp

game proc
gam:
;--------------------------------------------------------------------------------------
pale:
	lea di, pal1				
	call refreshPalette	
	lea di, pal2				
	call refreshPalette		
	call getScanCode
	call SCtoASCII
CMP_esc:
	cmp al,1Bh ;Esc
	je T_sali
	call Set_flags
	call CMP_flags
	jmp bola
T_sali:
	jmp sali
bola:
	call peloMov
	jmp dib
dib:
	call draw	;print
tiem:
	cmp punt1,5
	je sali
	cmp punt2,5
	je sali
	jmp gam
sali:
	ret
game endp
;--------------------------------------------------------------------------------------
rebotepaleta proc
paleta1:
	lea di,pelota
	call getBallPos
	lea di,pal1
	dec dh
	call isPaletteAt
	cmp dh,00h
	jne rebote
	cmp dl,01h
	je rebote
paleta2:
	lea di,pelota
	call getBallPos
	lea di,pal2
	inc dh
	call isPaletteAt
	cmp dh,00h
	jne rebote
	cmp dl,01h
	je rebote
	jmp salir
rebote:
	lea di,pelota
	call getBallDirec
	cmp dh,01h
	je RPI_derecha
	cmp dl,01h
	je RPI_arriba
	mov bx,01h
	mov cx,01h
	mov dx,00h
	push bx
	push cx
	push dx
	call setBallDirec
	jmp salir
RPI_derecha:
	cmp dl,01
	je RPI_abajo
	mov bx,01h
	mov cx,00h
	mov dx,00h
	push bx
	push cx
	push dx
	call setBallDirec
	jmp salir
RPI_abajo:
	mov bx,01h
	mov cx,00h
	mov dx,01h
	push bx
	push cx
	push dx
	call setBallDirec
	jmp salir
RPI_arriba:
	mov bx,01h
	mov cx,01h
	mov dx,01h
	push bx
	push cx
	push dx
	call setBallDirec
	jmp salir
salir:
	ret
rebotepaleta endp
;--------------------------------------------------------------------------------------
Set_flags proc
	cmp al,63h	;C
	je CMP_ahC
Sig_flag:
	cmp al,64h	;D
	je CMP_ahD
Sig_flag1:
	cmp al,6Dh	;M
	je CMP_ahM
Sig_flag2:
	cmp al,6Bh	;k
	je CMP_ahK
	jmp MVP_exit
	
CMP_ahC:
	cmp ah,00h
	je INC_flagC
	mov flagC,00h
	jmp Sig_flag
INC_flagC:
	mov flagC,01h
	jmp Sig_flag
	
CMP_ahD:
	cmp ah,00h
	je INC_flagD
	mov flagD,00h
	jmp Sig_flag1
INC_flagD:
	mov flagD,01h
	jmp Sig_flag1
	
CMP_ahM:
	cmp ah,00h
	je INC_flagM
	mov flagM,00h
	jmp Sig_flag2
INC_flagM:
	mov flagM,01h
	jmp Sig_flag2
	
CMP_ahK:
	cmp ah,00h
	je INC_flagK
	mov flagK,00h
	jmp MVP_exit
INC_flagK:
	mov flagK,01h
MVP_exit:
	ret
Set_flags endp
;--------------------------------------------------------------------------------------
CMP_flags proc
	call Set_flags	
	cmp flagC,01h	
	je down		
SC_flag:
	cmp flagD,01h	
	je up
TC_flag:
	cmp flagM,01h
	je down1
CC_flag:
	cmp flagK,01h
	je up1
	jmp CF_exit
	
down:
	lea di, pal1
	call getPalettePos
	cmp dl,16h
	je SC_flag
	lea di, pal1
	call goDown
	jmp SC_flag
up:
	lea di, pal1
	call getPalettePos
	cmp dl,00h
	je TC_flag
	lea di, pal1
	call goUp
	jmp TC_flag	
down1:
	lea di, pal2
	call getPalettePos
	cmp dl,16h
	je CC_flag
	lea di, pal2
	call goDown
	jmp CC_flag
up1:
	lea di, pal2
	call getPalettePos
	cmp dl,00h
	je CF_exit
	lea di, pal2
	call goUp
	jmp CF_exit
CF_exit:
	ret
CMP_flags endp
;--------------------------------------------------------------------------------------
peloMov proc
lea di, pelota				
	call refreshball			; Pelota
	call moveBall
	mov bx,05h
	push bx
	call delayMilisec
	lea di, pelota
	call getBallPos
	cmp dl,18h
	je chng
	cmp dl,00h
	je chng
	cmp dh,4Fh
	je rein1
	cmp dh,00h
	je rein1
	call rebotepaleta
	jmp Ball_exit
chng:
	lea di,pelota
	call getBallDirec
	cmp dh,01h
	je cam1
	jmp chng2
rein1:
	jmp rein2
cam1:
	cmp dl,01h
	je cam2
	mov bx,01h
	mov cx,01h
	mov dx,01h
	push bx
	push cx
	push dx
	call setBallDirec
	call StartSound		;sonido
	mov bx,02h			;duracion
	push bx
	call delayMilisec
	call StopSound		;fin sonido
	jmp Ball_exit
cam2:
	mov bx,01h
	mov cx,01h
	mov dx,00h
	push bx
	push cx
	push dx
	call setBallDirec
	call StartSound		;sonido
	mov bx,02h			;duracion
	push bx
	call delayMilisec
	call StopSound		;fin sonido
	jmp Ball_exit
rein2:
	jmp rein
chng2:
	cmp dl,01h
	je cam3
	mov bx,01h
	mov cx,00h
	mov dx,01h
	push bx
	push cx
	push dx
	call setBallDirec
	call StartSound		;sonido
	mov bx,02h			;duracion
	push bx
	call delayMilisec
	call StopSound		;fin sonido
	jmp Ball_exit
cam3:
	mov bx,01h
	mov cx,00h
	mov dx,00h
	push bx
	push cx
	push dx
	call setBallDirec
	call StartSound		;sonido
	mov bx,02h			;duracion
	push bx
	call delayMilisec
	call StopSound		;fin sonido
	jmp Ball_exit
rein:
	call puntos
	cmp punt1,5
	je Ball_exit
	cmp punt2,5
	je Ball_exit
	lea di,pelota
	mov dh,26h
	mov dl,0Ch
	call setBallPos
	mov bx,01h
	mov cx,01h
	mov dx,00h
	push bx
	push cx
	push dx
	call setBallDirec
	jmp Ball_exit
Ball_exit:
	ret
peloMov endp

puntos proc
	cmp dh,4Fh
	je Inc_Ah
	inc punt2
	mov ah,punt1
	mov al,punt2
	call ShowScore
	mov bx,0AAh			;duracion
	push bx
	call delayMilisec
	call EraseScore
	jmp PNT_exit
Inc_Ah:
	inc punt1
	mov ah,punt1
	mov al,punt2
	call ShowScore
	mov bx,0AAh			;duracion
	push bx
	call delayMilisec
	call EraseScore
PNT_exit:	
	ret
puntos endp
;--------------------------------------------------------------------------------------
end main