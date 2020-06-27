.8086
.model small
.stack 100h
.data
	SELECT  DB 01h
	FilSeli DB ?
	ColSeli DB ?
	FilSelf DB ?
	ColSelf DB ?
	Menu   db 0Dh,0Ah,0Dh,0Ah,0Dh,0Ah,0Dh,0Ah,0Dh,0Ah
       db         20h, 20h, "                        _____                                               ",20h
       db 0Dh,0Ah,20h, 20h, "                       |  __ \                                              ",20h
       db 0Dh,0Ah,20h, 20h, "                       | |__) |___   _ __    __ _                           ","I"
       db 0Dh,0Ah,20h, 20h, "                       |  ___// _ \ | '_ \  / _` |                          ",20h
       db 0Dh,0Ah,20h, "W", "                       | |   | (_) || | | || (_| |                          ",0DDh
       db 0Dh,0Ah,20h, 20h, "                       |_|    \___/ |_| |_| \__, |                          ",0DDh
       db 0Dh,0Ah,20h,0DEh, "                                             __/ |                          ",0DDh
       db 0Dh,0Ah,20h,0DEh, "                                            |___/                           ",20h
       db 0Dh,0Ah,20h,0DEh, "  ",0FEh,"                                                                         ","K"
       db 0Dh,0Ah,20h, 20h, "                           CONTINUE GAME                                    ",20h
       db 0Dh,0Ah,20h, "S", "                           START GAME                                       ",20h
       db 0Dh,0Ah,20h, 20h, "                           CREDITS                                          ",20h
       db 0Dh,0Ah,20h, 20h, "                           EXIT GAME                                        ",20h
       db 0Dh,0Ah,20h, 20h, "                                                                            ",20h
       db 0Dh,0Ah,20h, 20h, "                                                                            ",20h
       db 0Dh,0Ah,20h, 20h, "                                                                            ",20h
       db 0Dh,0Ah,20h, 20h, "                                                                            ",20h
       db 0Dh,0Ah,20h, 20h, "                                                                            ",20h
       db 0Dh,0Ah,20h, 20h, "                                                                            ",20h
       db 0Dh,0Ah,20h, 20h, "                                                     by GRUPONG CORPORATION $"

Credits   db 0Dh,0Ah
       db         20h, 20h, "                                                                            ",20h
       db 0Dh,0Ah,20h, 20h, "                           PONG by GRUPONG                                  ",20h
       db 0Dh,0Ah,20h, 20h, "                                UNSAM                                       ","I"
       db 0Dh,0Ah,20h, 20h, "                                                                            ",20h
       db 0Dh,0Ah,20h, "W", "                            CREATOR's                                       ",0DDh
       db 0Dh,0Ah,20h, 20h, "                         Fabio Bruschetti                                   ",0DDh
       db 0Dh,0Ah,20h,0DEh, "                         Pedro Iriso                                        ",0DDh
       db 0Dh,0Ah,20h,0DEh, "                                                                            ",20h
       db 0Dh,0Ah,20h,0DEh, "  ",0FEh,"                      PROJECT ORGANIZER                                  ","K"
       db 0Dh,0Ah,20h, 20h, "                         Nicolas Villamonte                                 ",20h
       db 0Dh,0Ah,20h, "S", "                                                                            ",20h
       db 0Dh,0Ah,20h, 20h, "                           PROGRAMMERS                                      ",20h
       db 0Dh,0Ah,20h, 20h, "                         Adrian Ibarra                                      ",20h
       db 0Dh,0Ah,20h, 20h, "                         Ezequiel Oyola                                     ",20h
       db 0Dh,0Ah,20h, 20h, "                         Fabio Bruschetti                                   ",20h
       db 0Dh,0Ah,20h, 20h, "                         Lucas Frechou                                      ",20h
       db 0Dh,0Ah,20h, 20h, "                         Mateo Pastorini                                    ",20h
       db 0Dh,0Ah,20h, 20h, "                         Nicolas Villamonte                                 ",20h
       db 0Dh,0Ah,20h, 20h, "                                                                            ",20h
       db 0Dh,0Ah,20h, 20h, "                                                                            ",20h
       db 0Dh,0Ah,20h, 20h, "                                                                            ",20h
       db 0Dh,0Ah,20h, 20h, "                                                                            ",20h
       db 0Dh,0Ah,20h, 20h, "                                                                            ",20h
       db 0Dh,0Ah,20h, 20h, "                                                     by GRUPONG CORPORATION $"

Credits2   db 0Dh,0Ah
       db         20h, 20h, "                                                                            ",20h
       db 0Dh,0Ah,20h, 20h, "                           PONG by GRUPONG                                  ",20h
       db 0Dh,0Ah,20h, 20h, "                                UNSAM                                       ","I"
       db 0Dh,0Ah,20h, 20h, "                                  ",0BAh,"                                         ",20h
       db 0Dh,0Ah,20h, "W", "                                  ",0BAh,"                                         ",0DDh
       db 0Dh,0Ah,20h, 20h, "                                  ",0BAh,"                                         ",0DDh
       db 0Dh,0Ah,20h,0DEh, "          CREATOR's               ",0BAh,"           PROGRAMMERS                   ",0DDh
       db 0Dh,0Ah,20h,0DEh, "       Fabio Bruschetti           ",0BAh,"         Adrian Ibarra                   ",20h
       db 0Dh,0Ah,20h,0DEh, "       Pedro Iriso                ",0BAh,"         Ezequiel Oyola                  ","K"
       db 0Dh,0Ah,20h, 20h, "                                  ",0BAh,"         Fabio Bruschetti                ",20h
       db 0Dh,0Ah,20h, "S", "                                  ",0BAh,"         Lucas Frechou                   ",20h
       db 0Dh,0Ah,20h, 20h, "       PROJECT ORGANIZER          ",0BAh,"         Mateo Pastorini                 ",20h
       db 0Dh,0Ah,20h, 20h, "       Nicolas Villamonte         ",0BAh,"         Nicolas Villamonte              ",20h
       db 0Dh,0Ah,20h, 20h, "                                  ",0BAh,"                                         ",20h
       db 0Dh,0Ah,20h, 20h, "                                  ",0BAh,"                                         ",20h
       db 0Dh,0Ah,20h, 20h, "                                  ",0BAh,"                                         ",20h
       db 0Dh,0Ah,20h, 20h, "                                  ",0BAh,"                                         ",20h
       db 0Dh,0Ah,20h, 20h, "                                  ",0BAh,"                                         ",20h
       db 0Dh,0Ah,20h, 20h, "                                  ",0BAh,"         ",0FEh,"                               ",20h
       db 0Dh,0Ah,20h, 20h, "                                  ",0BAh,"                                         ",20h
       db 0Dh,0Ah,20h, 20h, "                                  ",0BAh,"                                         ",20h
       db 0Dh,0Ah,20h, 20h, "                                  ",0BAh,"                                         ",20h
       db 0Dh,0Ah,20h, 20h, "                                  ",0BAh,"                                         ",20h
       db 0Dh,0Ah,20h, 20h, "                                  ",0BAh,"                  by GRUPONG CORPORATION $"
.code
PUBLIC MENUPONG

main proc
	;NADA
main endp

MENUPONG proc
	PUSH AX
	PUSH BX
	PUSH CX
	PUSHF

	CALL drawMenu

	MENU_VOLVER:
	;Esperamos a que el usuario presione una tecla
	MOV AH,08h
	INT 21h
	MENU_VOLVER_NO_LEER:
	;COMPARAR QUE TECLA ES
	CMP AL,00h 				;Si es tecla especial
	JE 	MENU_TECLA_ESPECIAL
	CMP AL,0Dh 				;ENTER
	JE 	MENU_ENTER
	CMP AL,67h
	JE 	MENU_VER_SECRETO
	JMP MENU_VOLVER
	MENU_SEGUIR:
    MOV AX,0C00h            ;Limpia el Buffer
    INT 21h
    CALL drawMenu			;Dibujar el menu
    JMP MENU_VOLVER 		;Volver a esperar una tecla

    MENU_VER_SECRETO:
    CALL verificarSecreto 		;DEVUELVE EN DL 1 SI SE DESBLOQUEO
    CMP DL,01h
    JNE MENU_VOLVER_NO_LEER
    	CALL drawCredits2
    	MOV AH,08h
		INT 21h
		CALL drawMenu			;Dibujar el menu
		jmp MENU_VOLVER


    MENU_TECLA_ESPECIAL:
    MOV AL,08h
    INT 21h
    CMP AL,50h
    JE  MENU_FLECHA_ABAJO
    CMP AL,48h
    JE  MENU_FLECHA_ARRIBA
    JMP MENU_VOLVER

    MENU_FLECHA_ABAJO:
	    CMP BYTE PTR SELECT,04h
	    JE	MN_VOLVER_A_1
	    INC BYTE PTR SELECT
	    JMP MENU_SEGUIR
	    MN_VOLVER_A_1:
	    MOV BYTE PTR SELECT,01h
	    JMP MENU_SEGUIR

    MENU_FLECHA_ARRIBA:
    	CMP BYTE PTR SELECT,01h
	    JE	MN_VOLVER_A_4
	    DEC BYTE PTR SELECT
	    JMP MENU_SEGUIR
	    MN_VOLVER_A_4:
	    MOV BYTE PTR SELECT,04h
	    JMP MENU_SEGUIR

	MENU_MOSTRAR_CREDITOS:
	CALL drawCredits
	MOV AH,08h
	INT 21h
	CALL drawMenu			;Dibujar el menu
	jmp MENU_VOLVER

    MENU_ENTER:
    	CMP BYTE PTR SELECT,03h
    	JE 	MENU_MOSTRAR_CREDITOS 
    	MOV DL,BYTE PTR SELECT

    FIN_MENU:
    POPF
    POP CX
    POP BX
    POP AX
    RET
MENUPONG endp

drawMenu proc
	PUSH AX
	PUSH DX
	PUSHF

	MOV AX,03
	INT 10h

	CALL Seleccionar

	MOV AX,0600h
	MOV BH,0Eh
	MOV CH,FilSeli
	MOV CL,ColSeli
	MOV DH,FilSelf
	MOV DL,ColSelf
	INT 10h

	MOV AH,09h
	LEA DX,Menu
	INT 21h

	POPF
	POP DX
	POP AX
	RET
drawMenu endp


Seleccionar proc
	CMP BYTE PTR SELECT,01h
	JE 	SELEC_FILA_1
	CMP BYTE PTR SELECT,02h
	JE 	SELEC_FILA_2
	CMP BYTE PTR SELECT,03h
	JE 	SELEC_FILA_3
	CMP BYTE PTR SELECT,04h
	JE 	SELEC_FILA_4

	SELEC_FILA_1:
	MOV BYTE PTR FilSeli,14d
	MOV BYTE PTR ColSeli,04d
	MOV BYTE PTR FilSelf,14d
	MOV BYTE PTR ColSelf,70d
	JMP FIN_SELECCIONAR

	SELEC_FILA_2:
	MOV BYTE PTR FilSeli,15d
	MOV BYTE PTR ColSeli,04d
	MOV BYTE PTR FilSelf,15d
	MOV BYTE PTR ColSelf,70d
	JMP FIN_SELECCIONAR

	SELEC_FILA_3:
	MOV BYTE PTR FilSeli,16d
	MOV BYTE PTR ColSeli,04d
	MOV BYTE PTR FilSelf,16d
	MOV BYTE PTR ColSelf,70d
	JMP FIN_SELECCIONAR

	SELEC_FILA_4:
	MOV BYTE PTR FilSeli,17d
	MOV BYTE PTR ColSeli,04d
	MOV BYTE PTR FilSelf,17d
	MOV BYTE PTR ColSelf,70d
	JMP FIN_SELECCIONAR

	FIN_SELECCIONAR:
	RET	
Seleccionar endp


drawCredits proc
	PUSH AX
	PUSH DX
	PUSHF

	MOV AX,03h
	INT 10h

	MOV AH,09h
	LEA DX,Credits
	INT 21h

	POPF
	POP DX
	POP AX
	RET
drawCredits endp

drawCredits2 proc
	PUSH AX
	PUSH DX
	PUSHF

	MOV AX,03h
	INT 10h

	MOV AH,09h
	LEA DX,Credits2
	INT 21h

	POPF
	POP DX
	POP AX
	RET
drawCredits2 endp

verificarSecreto proc
	MOV DL,01h

	MOV AH,08h
	INT 21h
	CMP AL,72h
	JNE FIN_NO_SECRETO
	INT 21h
	CMP AL,75h
	JNE FIN_NO_SECRETO
	INT 21h
	CMP AL,70h
	JNE FIN_NO_SECRETO
	INT 21h
	CMP AL,6Fh
	JNE FIN_NO_SECRETO
	INT 21h
	CMP AL,6Eh
	JNE FIN_NO_SECRETO
	INT 21h
	CMP AL,67h
	JNE FIN_NO_SECRETO
	JMP FIN_SECRETO

	FIN_NO_SECRETO:
	MOV DL,00h
	FIN_SECRETO:
	RET
verificarSecreto endp

end main