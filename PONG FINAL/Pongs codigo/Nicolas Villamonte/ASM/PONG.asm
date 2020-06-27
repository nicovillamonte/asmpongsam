.8086
.model small
.stack 100h
INCLUDE STRUCS.inc 				;Incluimos las estructuras a utilizar en el pong (TIMER-PALETTE-BALL)
INCLUDE GROUND.inc 				;Incluimos la libreria GROUND para el manejo de la pantalla.
;INCLUDE TIMER.inc 				;Incluimos la libreria TIMER para el manejo del tiempo. (No puede estar incluida si se va a usar TIMER2)
INCLUDE TIMER2.inc 				;Incluimos la libreria TIMER2 para el manejo del tiempo. (No puede estar incluida si se va a usar TIMER)
INCLUDE KEYBOARD.inc 			;Incluimos la libreria KEYBOARD para el manejo del teclado.
INCLUDE PALETTE.inc 			;Incluimos la libreria PALETTE para el manejo y creación de las paletas.
INCLUDE BALL.inc 				;Incluimos la libreria BALL para el manejo y creación de la pelota.
INCLUDE SCORE.inc 				;Incluimos la libreria SCORE para el manejo de la puntuación.
INCLUDE SOUND.inc 				;Incluimos la libreria SOUND para el manejo del sonido del juego.
EXTRN MENUPONG:PROC 			;Incluimos la unica funcion de la libreria "MenuP"
.data
	;------------------EQU's------------------
	FALSE 			EQU 	00h
	TRUE			EQU		01h
	ABAJO 			EQU 	00h
	ARRIBA			EQU		01h
	IZQUIERDA		EQU 	00h
	DERECHA			EQU		01h
	LIM_ARRIBA		EQU		00h
	LIM_ABAJO		EQU 	18h
	LIM_IZQUIERDA1 	EQU		02h
	LIM_DERECHA1	EQU		4Dh
	LIM_IZQUIERDA2 	EQU		03h
	LIM_DERECHA2	EQU		4Ch
	PAL1UP			EQU		PF1[00h]
	PAL1DOWN		EQU		PF1[01h]
	PAL2UP			EQU		PF2[00h]
	PAL2DOWN		EQU		PF2[01h]
	;------------------Objetos------------------
	;Objetos PALETTE
	paleta1 	PALETTE 	<01d,12d,0DEh,03d> 		;Paleta 1, la de la izquierda
	paleta2 	PALETTE 	<78d,12d,0DDh,03d> 		;Paleta 2, la de la derecha
	;Objetos BALL
	pelota 		BALL 		<38d,12d,254d,02d>		;Esto no existira en este codigo
	;Objetos TIMER
	TIM1 		TIMER 		<> 						;Timer de las paletas
	TIM2 		TIMER 		<>						;Timer de la pelota
	TIM3 		TIMER 		<>						;Timer del sonido
	;------------------Flags------------------
	;Flags Generales
	SaqueFlag		DB 		TRUE 					;Flag del saque, si se espera que saque esta en TRUE
	SaqueSelec 		DB 		01h						;Si es 1 saca el jugador1, si es 2 saca el jugador2
	partidoEnCurso	DB 		FALSE
	;Flags PALETTE
	PF1				DB		FALSE,FALSE 			;Flag estado de la paleta1
	PF2				DB		FALSE,FALSE 			;Flag estado de la paleta2
	;Flags BALL
	DirecAux		DW 		0FFh					;Inicialmente esta en FF para mantenerse
	DirecActual 	DB 		01h 					;Guarda la direccion de la pelota en el momento
	LIM_IZQUIERDA 	DB		02h 					;Delimita la cancha para la pelota (Limite antes de la paleta1)
	LIM_DERECHA		DB		4Dh 					;Delimita la cancha para la pelota (Limite antes de la paleta2)
	condCambio1		DB 		02h 					;En que porcion de la paleta1 debe chocar para cambiar la direccion de la pelota.
	condCambio2		DB 		02h 					;En que porcion de la paleta2 debe chocar para cambiar la direccion de la pelota.
	;Flags de sonido
	SoundFlag	DB 			FALSE 					;Flag para saber si el sonido ya se esta reproduciendo
	;------------------Textos------------------
	TextoFinal  DB 			"Muchas gracias por haber jugado al Pong del GRUPONG. :D",24h 	;Mensaje de despedida cuando cierran el pong
	;------------------Variables------------------
	Punt1		DB 			00h 					;Puntuacion del jugador 1
	Punt2		DB 			00h 					;Puntuacion del jugador 2
	
.code
;----------------------------------------PONGMAIN-----------------------------------------------------------
; En el main, principalmente, mostramos el menu, para luego analizar los valores que nos da el jugador
;desde el mismo y realizar las diferentes acciones. (Cerrar pong, Continuar Partida, Nueva partida).
;La opcion de mostrar los creditos la maneja el propio menu en su interior.
;------------------------------------------------------------------------------------------------------------
main proc
	MOV AX,@DATA
	MOV DS,AX

	VOLVER_A_MENU:
	CALL MENUPONG 								;Encendemos el menu del pong (En archivo MenuP)
	;Devuelve en DL la opcion que se selecciono
	CMP DL,01h 									;Si la opcion es 1, se continua con la partida en curso.
	JE SEGUIR_PARTIDA_PONG
	CMP DL,02h 									;Si la opcion es 2, se comienza una nueva partida.
	JE NUEVA_PARTIDA_PONG
	CMP DL,04h 									;Si la opcion es 4, se sale del pong.
	JE CERRAR_PONG

	SEGUIR_PARTIDA_PONG:
	CMP BYTE PTR partidoEnCurso,FALSE 			;Vemos si existe una partida en curso.
	JE 	VOLVER_A_MENU 							;Si no existe esperamos a que seleccione otra opcion.
	CALL PONGMAIN 								;Si ya existe se abre el pong con todos los valores que quedaron intactos.
	;SI LLEGO ACA ES PORQUE APRETE ESC EN UNA PARTIDA (Pausa)
	JMP VOLVER_A_MENU 							;En la pausa ejecutamos el menu.

	NUEVA_PARTIDA_PONG:
	MOV BYTE PTR partidoEnCurso,TRUE 	;Le avisamos a nuestro flag que ya existe una partida en curso.
	CALL inicializarTodo 				;Inicializamos todos los objetos.
	MOV BYTE PTR SaqueFlag,TRUE 		;Configuramos todos los flags para el incio correcto del juego.
	MOV BYTE PTR SaqueSelec,01h
	MOV BYTE PTR PAL1UP,FALSE
	MOV BYTE PTR PAL1DOWN,FALSE
	MOV BYTE PTR PAL2UP,FALSE
	MOV BYTE PTR PAL2DOWN,FALSE
	LEA DI,pelota
	LEA SI,paleta1
	CALL initialPosBall 				;Colocamos la pelota en la paleta que va a sacar inicialmente.
	MOV BYTE PTR Punt1,00h 				;Reseteamos las puntuacion.
	MOV BYTE PTR Punt2,00h
	MOV DL,12d
	MOV DH,01d
	LEA DI,paleta1
	CALL SetPalettePos 					;Seteamos las paletas en la posicion inicial.
	MOV DH,78d
	LEA DI,paleta2
	CALL SetPalettePos 					;Seteamos las paletas en la posicion inicial.
	CALL PONGMAIN 						;Comenzamos a ejecutar el Pong.
	;SI LLEGO ACA ES PORQUE APRETE ESC EN UNA PARTIDA
	JMP VOLVER_A_MENU

	CERRAR_PONG:
	CALL despedida 						;Dejamos un cartel de despedida.
	MOV AX,4C00h 						;Devolvemos el control al DOS.
	INT 21h
main endp

;----------------------------------------PONGMAIN-----------------------------------------------------------
; Esta funcion es la que corre el pong en si, es un loop infinito cuya unica manera de cortarlo o pausarlo
;es utilizando la tecla ESC. Aca se manipulan todos los tiempos y se llama a las funciones de comparacion 
;y congiguracion para el correcto funcionamiento del juego PONG.
;------------------------------------------------------------------------------------------------------------
PONGMAIN PROC
	;CALL StartSound
	ESPERAR_TECLA:
		XOR  AX,AX
		CALL getScanCode 						;Recibimos el ScanCode en AL
			CMP AX,81h
			JE SALIR_PONG
		CALL SCtoASCII 							;Convertimos el ScanCode a ASCII

		CALL chgPaletteFlagStates 				;Cambiamos, segun el ScanCode recibido, el estado de las paletas

		;Mover paletas con TIM1
		LEA DI,TIM1
		MOV DX,01d
		CALL cmpMilisec 						;Si los milisegundos marcados pasaron se mueven las paletas y se resetear el Timer
		JNZ NO_Mover_Paleta
			CALL movPalette 					;Se mueven las paletas segun su estado
			CALL TimRst 						;Se resetea el Timer
		NO_Mover_Paleta:
			LEA DI,TIM2
			XOR DX,DX
			MOV DL,DirecActual ;DirecActual
			CALL cmpMilisec
			JNZ NO_Mover_PELOTA 				;Si los milisegundos marcados pasaron se mueve la pelota y se resetea el Timer
				CMP SaqueFlag,TRUE 				;Si esta el modo saque activado movemos la pelota con la paleta
				JE 	ActualizarSaque
			;Mover pelotas con TIM2 (Esto lo hace solo si no esta en modo Saque)
				CALL moverPelota 				;Movemos la pelota segundo direccion y sentido
				CALL TimRst 					;Reseteamos el Timer 2
				JMP NO_Mover_PELOTA
			ActualizarSaque:
			CALL UpdateSaquePos 				;Movemos pelota segun posicion de la paleta seleccionada como la que saca
			CALL TimRst 						;Reseteamos el timer 2
		NO_Mover_PELOTA:
		;Vemos el timer del sonido
		LEA DI,TIM3
		MOV DX,3d
		CALL cmpMilisec 						;Si los milisegundos marcados pasaron se mueven las paletas y se resetear el Timer
		JNZ	 NO_PARAR_SONIDO 
			;Si llega aca paramos el sonido aunque no este andando
			CALL TerminarSonido
			CALL TimRst
		NO_PARAR_SONIDO:
		CALL refrescarTodo 						;Refrescamos en la pantalla todos los objetos modificados
		CALL DRAW 								;Dibujamos en pantalla
	JMP ESPERAR_TECLA

	SALIR_PONG:
	RET
PONGMAIN ENDP

;----------------------------------------despedida-----------------------------------------------------------
; Imprime un texto con colores agradeciendo al usuario por jugar el juego antes de devolverle al DOS el
;control.
;------------------------------------------------------------------------------------------------------------
despedida proc
	MOV AX,03h 						;Limpiamos pantalla
	INT 10h

	MOV AX,0600h 					;Le damos atributos a la parte de la pantalla a utilizar.
	MOV BH,4Fh 						;Fondo Rojo -- Letras Blancas
	MOV CH,00d 						;El primer Renglon
	MOV CL,00d 						;De la columna 0 a la 55
	MOV DH,CH
	MOV DL,55d
	INT 10h

	MOV AH,09h 						;Escribimos el texto final.
	LEA DX,TextoFinal
	INT 21h

	ret
despedida endp

;----------------------------------------inicializarTodo-----------------------------------------------------
; Inicializa todos los valores de los objetos para poder comenzar una partida de cero sin errores.
;------------------------------------------------------------------------------------------------------------
inicializarTodo proc
	;Se inicializan todos los objetos.
	PUSH DI

	LEA DI,paleta1
	CALL initializatePalette 			;Inicializamos la paleta1
	LEA DI,paleta2
	CALL initializatePalette 			;Inicializamos la paleta2
	LEA DI,pelota
	CALL initializateBall 				;Inicializamos la pelota
	MOV AX,01h
	PUSH AX
	PUSH AX
	PUSH AX
	CALL SetBallDirec 					;Le configuramos la direccion inicial a la pelota
	LEA DI,TIM1
	CALL TimRst 						;Reseteamos el Timer1 por primera vez
	LEA DI,TIM2
	CALL TimRst 						;Reseteamos el Timer2 por primera vez
	LEA DI,TIM3
	CALL TimRst 						;Reseteamos el Timer3 por primera vez

	POP DI
	RET
inicializarTodo endp

;----------------------------------------refrescarTodo------------------------------------------------------
; Refresca todos los objetos que tienen la opcion de ser refrescados en pantalla para poder visualizarlos.
;------------------------------------------------------------------------------------------------------------
refrescarTodo proc
	PUSH DI
	
	LEA DI,paleta1
	CALL refreshPalette 				;Refrescamos la paleta1
	LEA DI,paleta2
	CALL refreshPalette 				;Refrescamos la paleta2
	LEA DI,pelota
	CALL refreshBall 					;Refrescamos la pelota

	POP DI
	RET
refrescarTodo endp


;----------------------------------------chgPaletteFlagStates------------------------------------------------
; Cambia los flags de estado de las paletas dependiendo de las teclas que se presionaron o soltaron para
;luego saber para donde moverlas y poder utilizar mas de una tecla a la vez en el juego. 
;------------------------------------------------------------------------------------------------------------
chgPaletteFlagStates proc
	;Recibe en AL el ASCII de la tecla y segun el mismo cambia el estado de las paletas
	;Recibe en AH si fue presionada o pulsada
	CMP AL,77h 				;Tecla W
	JE  PS_LETRA_W
	CMP AL,73h 				;Tecla S
	JE  PS_LETRA_S
	CMP AL,69h 				;Tecla I
	JE  PS_LETRA_I
	CMP AL,6Bh 				;Tecla K
	JE  PS_LETRA_K
	JMP PS_FIN 				;Ninguna tecla importante

	PS_LETRA_W:
		CMP AH,00h							;Veo si la tecla W esta presionada
		JE 	PS_PRESIONADA_W
		;Si la tecla no esta presionada:
			MOV BYTE PTR PAL1UP,FALSE 			;Apagamos el flag que recuerda si la tecla sigue presionada
			JMP PS_FIN
		PS_PRESIONADA_W:
			MOV BYTE PTR PAL1UP,TRUE 			;Encendemos el flag que recuerda si la tecla sigue presionada
			MOV BYTE PTR PAL1DOWN,FALSE 		;Apagamos el flag que recuerda si la tecla inversa sigue presionada
			JMP PS_FIN

	PS_LETRA_S:
		CMP AH,00h							;Veo si la tecla S esta presionada
		JE 	PS_PRESIONADA_S
		;Si la tecla no esta presionada:
			MOV BYTE PTR PAL1DOWN,FALSE 		;Apagamos el flag que recuerda si la tecla sigue presionada
			JMP PS_FIN
		PS_PRESIONADA_S:
			MOV BYTE PTR PAL1DOWN,TRUE 			;Encendemos el flag que recuerda si la tecla sigue presionada
			MOV BYTE PTR PAL1UP,FALSE 			;Apagamos el flag que recuerda si la tecla inversa sigue presionada
			JMP PS_FIN

	PS_LETRA_I:
		CMP AH,00h							;Veo si la tecla I esta presionada
		JE 	PS_PRESIONADA_I
		;Si la tecla no esta presionada:
			MOV BYTE PTR PAL2UP,FALSE 			;Apagamos el flag que recuerda si la tecla sigue presionada
			JMP PS_FIN
		PS_PRESIONADA_I:
			MOV BYTE PTR PAL2UP,TRUE 			;Encendemos el flag que recuerda si la tecla sigue presionada
			MOV BYTE PTR PAL2DOWN,FALSE 		;Apagamos el flag que recuerda si la tecla inversa sigue presionada
			JMP PS_FIN

	PS_LETRA_K:
		CMP AH,00h							;Veo si la tecla K esta presionada
		JE 	PS_PRESIONADA_K
		;Si la tecla no esta presionada:
			MOV BYTE PTR PAL2DOWN,FALSE 		;Apagamos el flag que recuerda si la tecla sigue presionada
			JMP PS_FIN
		PS_PRESIONADA_K:
			MOV BYTE PTR PAL2DOWN,TRUE 			;Encendemos el flag que recuerda si la tecla sigue presionada
			MOV BYTE PTR PAL2UP,FALSE 			;Apagamos el flag que recuerda si la tecla inversa sigue presionada
			JMP PS_FIN

	PS_FIN:
	RET
chgPaletteFlagStates endp


;----------------------------------------MovPalette----------------------------------------------------------
; Esta funcion se encarga de mover la paleta dependiendo de los valores de sus flags de estado cambiados
;en la funcion chgPaletteFlagStates.
;------------------------------------------------------------------------------------------------------------
movPalette proc
	PUSH DI
	;COMPARAMOS LOS ESTADOS DE LA PALETA 1
	CMP BYTE PTR PAL1DOWN,TRUE
	JE 	PAL1_ABAJO 					;Se mueve hacia abajo
	CMP BYTE PTR PAL1UP,TRUE
	JE 	PAL1_ARRIBA 				;Se mueve hacia arriba
	JMP PAL1_FINMOVER 				;No se mueve

	PAL1_ABAJO:
		LEA DI,paleta1 				;Obtenemos la posicion de la paleta
		CALL getPalettePos
		XCHG DH,DL 					;Guardamos el Y de la posicion en DH
		CALL getPaletteLarge 		;Obtenemos el largo de la paleta
		DEC DL
		ADD DH,DL
		CMP DH,LIM_ABAJO 			;Si esta en el limite de abajo no mover
		JE 	PAL1_FINMOVER
		CALL goDown 				;Movemos la paleta1 hacia abajo
		JMP PAL1_FINMOVER

	PAL1_ARRIBA:
		LEA DI,paleta1 				;Obtenemos la posicion de la paleta
		CALL getPalettePos
		CMP DL,LIM_ARRIBA 			;Si la posicion toca el limite de arriba no hace nada
		JE 	PAL1_FINMOVER
		CALL goUp 					;Movemos la paleta1 hacia arriba

	PAL1_FINMOVER:

	;COMPARAMOS LOS ESTADOS DE LA PALETA 2
	CMP BYTE PTR PAL2DOWN,TRUE
	JE 	PAL2_ABAJO 					;Se mueve hacia abajo
	CMP BYTE PTR PAL2UP,TRUE
	JE 	PAL2_ARRIBA 				;Se mueve hacia arriba
	JMP PAL2_FIN 					;No se mueve

	PAL2_ABAJO:
		LEA DI,paleta2 				;Obtenemos la posicion de la paleta
		CALL getPalettePos
		XCHG DH,DL 					;Guardamos el Y de la posicion en DH
		CALL getPaletteLarge 		;Obtenemos el largo de la paleta
		DEC DL
		ADD DH,DL
		CMP DH,LIM_ABAJO 			;Si esta en el limite de abajo no mover
		JE 	PAL2_FIN
		CALL goDown 				;Movemos la paleta2 hacia abajo
		JMP PAL2_FIN
 
	PAL2_ARRIBA:
		LEA DI,paleta2 				;Obtenemos la posicion de la paleta
		CALL getPalettePos
		CMP DL,LIM_ARRIBA 			;Si la posicion toca el limite de arriba no hace nada
		JE 	PAL2_FIN
		CALL goUp 					;Movemos la paleta2 hacia arriba

	PAL2_FIN:
	POP DI
	RET
movPalette endp


;----------------------------------------MoverPelota---------------------------------------------------------
; Esta funcion se encarga de realizar todas las verificaciones de bordes, de paletas, direccion y sentido;
;y partiendo de esto mueven la pelota para la direccion que debe hacerlo o no la mueven si se produce algun
;imprevisto como que uno de los dos pierda.
;------------------------------------------------------------------------------------------------------------
moverPelota proc
	PUSH DI
	PUSH AX
	PUSH DX

	CMP DirecActual,02h 					;Seteamos los limites de izquierda y derecha segun la direccion actual (1 y 3 los limites originales, el 2 caso especial)
	JE  CAMBIAR_LIMITE2
	MOV AL,LIM_IZQUIERDA1 					;Seteamos los limites para los casos de direcciones 1 y 3 (Que llegan siempre al lado de la paleta)
	MOV BYTE PTR LIM_IZQUIERDA,AL
	MOV AL,LIM_DERECHA1
	MOV BYTE PTR LIM_DERECHA,AL
	JMP MOVER_PELOTA_NORMAL

	CAMBIAR_LIMITE2: 						;Seteamos los limites para el caso de direccion 2 (Que se queda a dos espacios de la palete)
	MOV AL,LIM_IZQUIERDA2
	MOV BYTE PTR LIM_IZQUIERDA,AL
	MOV AL,LIM_DERECHA2
	MOV BYTE PTR LIM_DERECHA,AL
	JMP MOVER_PELOTA_NORMAL

	MOVER_PELOTA_NORMAL: 					;Mover pelota de forma normal
	;Comparar bordes superior e inferior
	LEA DI,pelota
	CALL GetBallPos 						;Obtenemos la posicion de la pelota
	CMP DL,LIM_ARRIBA 						;La comparamos con el limite superior
	JE 	IS_ON_BORDE_SUPERIOR 				;Si esta en el limite superior se realiza el cambio de direccion
	CMP DL,LIM_ABAJO 						;La comparamos con el limite inferior
	JE 	IS_ON_BORDE_INFERIOR 				;Si esta en el limite inferior se realiza el cambio de direccion
	JMP ISNT_BORDER 						;Si no esta en ningun limite sigue normalmente

	IS_ON_BORDE_SUPERIOR:
		MOV AX,0FFh 						;Cambiamos la direccion Y de la pelota hacia abajo
		PUSH AX
		PUSH AX
		MOV AX,00h
		PUSH AX
		CALL SetBallDirec
		CALL EmpezarSonido 					;Comenzamos el sonido de rebote (Que frenara solo con el timer en el PONGMAIN)
		JMP ISNT_BORDER

	IS_ON_BORDE_INFERIOR:
		MOV AX,0FFh 						;Cambiamos la direccion Y de la pelota hacia arriba
		PUSH AX
		PUSH AX
		MOV AX,01h
		PUSH AX
		CALL SetBallDirec
		CALL EmpezarSonido 					;Comenzamos el sonido de rebote (Que frenara solo con el timer en el PONGMAIN)

	ISNT_BORDER:
	;Comparar bordes izquierda y derecha (Entran en juego las paletas)
	LEA DI,pelota
	CALL GetBallPos 						;Obtenemos la posicion de la pelota
	CMP DH,LIM_IZQUIERDA 					;La comparamos con el limite izquierdo
	JLE IS_ON_BORDE_IZQUIERDA				;Si esta en el limite izquierdo se realiza el cambio de direccion
	CMP DH,LIM_DERECHA 						;La comparamos con el limite derecho
	JGE IS_ON_BORDE_DERECHA					;Si esta en el limite izquierdo se realiza el cambio de direccion
	JMP FIN_BORDE 							;Si no esta en ningun limite sigue normal

	IS_ON_BORDE_IZQUIERDA:
	CALL VerificarPaletaIzquierda 			;Realizamos un arduo proceso de comparaciones para saber si sigue normal o si el jugador 1 perdio
	CMP DL,01h 								;Si en DL se devuelve un 1 todo sigue normal
	JE FIN_BORDE
	JMP FIN_BORDE_SIN_MOVER 				;Sino quiere decir que un jugador perdio y ya se configuro todo el saque y el puntaje, solo no hay que seguir moviendo la pelota

	IS_ON_BORDE_DERECHA:
	CALL VerificarPaletaDerecha 			;Realizamos un arduo proceso de comparaciones para saber si sigue normal o si el jugador 2 perdio
	CMP DL,01h 								;Si en DL se devuelve un 1 todo sigue normal
	JE FIN_BORDE
	JMP FIN_BORDE_SIN_MOVER 				;Sino quiere decir que un jugador perdio y ya se configuro todo el saque y el puntaje, solo no hay que seguir moviendo la pelota

	FIN_BORDE:
	LEA DI,pelota 							;Hacemos un movimiento de la pelota con todos los parametros ya configurados
	CALL moveBall
	FIN_BORDE_SIN_MOVER:
	POP DX
	POP AX
	POP DI
	RET
moverPelota endp

;----------------------------------------VerificarPaletaIzquierda--------------------------------------------
; Verificamos todas las posibilidades que tiene la pelota de chocar con el lado izquierdo de la pantalla.
;Entre estas posibilidades estan las posibilidades de que rebote con la paleta o que la misma pierda.
;------------------------------------------------------------------------------------------------------------
VerificarPaletaIzquierda proc
	;Esta funcion realiza una serie de verificaciones para saber
	;si la pelota rebota o no en la paleta izquierda y realiza
	;lo que debe realizar para cada caso
	;Devuelve en DL = 00 si perdio el jugador, y 01 si reboto la pelota
	PUSH AX
	PUSH BX
	PUSH CX
	PUSH DI
	PUSHF

	XOR CX,CX 					;Vaciamos CX

	LEA DI,pelota 				;Obtenemos la direccion de la pelota
	CALL getBallDirec
	CMP DH,00h
	JE	SEGUIR_VERIFICANDO 		;Si la pelota esta yendo hacia la izquierda entonces va hacia el lado que debemos analizar.
	;Si la pelota esta yendo para el lado derecho entonces no verificar.
	MOV DL,01h 					;Devolvemos un 1 para que la pelota siga su camino con normalidad.
	POPF
	POP DI
	POP CX
	POP BX
	POP AX
	RET

	SEGUIR_VERIFICANDO:
	LEA DI,pelota 				;Obtenemos la popsicion de la pelota
	CALL getBallPos

	CMP DH,02h 					;Si la pelota esta en el X 02, se encuentra al lado de la posicion donde se desplaza la paleta.
	JE	NORMAL_COMPARATION 		;Hacer una comparacion normal.
	CMP DH,03h 					;Si la pelota esta en el X 03, se encuentra a dos espacios de la posicion donde se desplaza la paleta.
	JE	TWO_SPACE_COMPARATION 	;Se hace una comparacion especial.
	JMP FIN_PELOTA_EN_IZQUIERDA


	;----------------UN ESPACIO--------------------------------------------------------

	NORMAL_COMPARATION:
		;COMPARACION SI ESTA AL LADO LA PALETA
		DEC DH 							;Vamos a analizar uno a la izquierda, donde se desplaza la paleta
		LEA DI,paleta1
		CALL isPaletteAt 				;Preguntamos si la paleta existe en esa posicion
		MOV CL,DH
		JZ 	 REBOTAR_PALETA_1 		;Si la paleta se encuentra al lado rebota con la misma	
		;COMPARACION SI ESTA EN DIAGONAL LA PALETA Y EN EL BUEN SENTIDO
		LEA DI,pelota
		CALL getBallDirec 				;Obtenemos la direccion de la pelota
		CMP DL,00h 						;y comparamos si esta yendo para abajo
		CALL getBallPos 				;Obtenemos la posicion de la pelota
		JE 	VERIFICAR_ABAJO_IZQUIERDA 	;Si la pelota iba para abajo verificamos si hay una porcion de paleta abajo a la izquierda
			;VERIFICAR ARRIBA IZQUIERDA ;Sino verificamos si hay una porcion de paleta arriba a la izquierda
			DEC DH 							;Izquierda
			DEC DL 							;Arriba
			LEA DI,paleta1
			CALL isPaletteAt 				;Verificamos si hay una porcion de la paleta
			MOV CL,DH
			JZ	REBOTAR_PALETA_1 			;Si la hay, la pelota rebota
			JMP	PERDIO_JUGADOR_1 			;Sino pierde el jugador 1
			VERIFICAR_ABAJO_IZQUIERDA:
			DEC DH 							;Izquierda
			INC DL 							;Abajo
			LEA DI,paleta1
			CALL isPaletteAt 				;Verificamos si hay una porcion de la paleta
			MOV CL,DH
			JZ	REBOTAR_PALETA_1 			;Si la hay, la pelota rebota
			JMP PERDIO_JUGADOR_1 			;Sino pierde el jugador 1

	;----------------DOS ESPACIOS--------------------------------------------------------

	TWO_SPACE_COMPARATION:
		;MOVER LA PELOTA UNO A LA IZQUIERDA Y UNO ARRIBA
		DEC DH
		CMP BYTE PTR pelota.sentido[01h],00h 		;Dependiendo el sentido de la pelota movemos arriba o abajo, y uno a la izquierda
		JNE TSC_DEC_BALL
		INC DL 										;Uno abajo
		JMP TSC_SEGUIR_DRAWEO
		TSC_DEC_BALL:
		DEC DL 										;uno arriba
		TSC_SEGUIR_DRAWEO:
		LEA DI,pelota
		CALL setBallPos 							;Seteamos la nueva posicion de la pelota para arreglar el problema de que quede a dos espacios de la paleta.
		CALL RefreshBall 							;Actualizamos esa nueva posicion de la pelota.
		MOV DL,00h 									;Devolvemos un 0 para que no realice el movimiento habitual, ya que nosotros lo forzamos recien.
		JMP FIN_PELOTA_EN_IZQUIERDA 				;Termina la funcion para que luego entre y verifique nuevamente pero con la nueva posicion.


	REBOTAR_PALETA_1:
		CMP CL,condCambio1 							;Si se cumple la condicion de cambio de la paleta1 cambiar modo de sentido
		JE CAMBIAR_SENTIDO_PELOTA_P1
		ZETEAR_NUEVA_DIREC_P1:
		lea di,pelota
		XOR AX,AX
		MOV AL,DirecActual 							;Si anteriormente llamamos a la funcion SiguienteDireccion se cambia la misma, sino queda igual que antes
		PUSH AX
		MOV AX,01h 									;Cambiamos de sentido a la derecha por rebote
		PUSH AX
		MOV AX,0FFh 								;Mantenemos el sentido Abajo Arriba intacto
		PUSH AX
		CALL SetBallDirec 							;Seteamos la nueva direccion de la pelota
		CALL EmpezarSonido
		MOV DL,01h 									;Devolvemos un 1 asi sigue moviendo la pelota en la nueva direccion.
		JMP FIN_PELOTA_EN_IZQUIERDA

	CAMBIAR_SENTIDO_PELOTA_P1:
		CALL SiguienteDireccion 					;Cambiamos modo de sentido al siguiente
		JMP ZETEAR_NUEVA_DIREC_P1 					;Seteamos la nueva direccion modificada en la funcion

	PERDIO_JUGADOR_1:
		INC Punt2 									;Incrementamos la puntuacion del jugador contrario
		MOV AL,01h									;Mandamos como argumento que perdio el jugador 1
		CALL UnPerdedor 							;Configuramos todo para cuando un jugador pierde
		MOV DL,00h 									;Devolvemos un 0 para que no realice el movimiento habitual

	FIN_PELOTA_EN_IZQUIERDA:
	POPF
	POP DI
	POP CX
	POP BX
	POP AX
	RET
VerificarPaletaIzquierda endp

;----------------------------------------VerificarPaletaDerecha----------------------------------------------
; Verificamos todas las posibilidades que tiene la pelota de chocar con el lado derecho de la pantalla.
;Entre estas posibilidades estan las posibilidades de que rebote con la paleta o que la misma pierda.
;------------------------------------------------------------------------------------------------------------
VerificarPaletaDerecha proc
	;Esta funcion realiza una serie de verificaciones para saber
	;si la pelota rebota o no en la paleta DERECHA y realiza
	;lo que debe realizar para cada caso
	;Devuelve en DL = 00 si perdio el jugador, y 01 si reboto la pelota
	PUSH AX
	PUSH BX
	PUSH CX
	PUSH DI
	PUSHF

	XOR CX,CX

	LEA DI,pelota 						;Obtenemos la direccion de la pelota
	CALL getBallDirec
	CMP DH,01h
	JE	SEGUIR_VERIFICANDO_DERECHA 		;Si la pelota esta yendo hacia la derecha entonces va hacia el lado que debemos analizar.
	;Si la pelota esta yendo para el lado izquierdo entonces no verificar.
	MOV DL,01h 					;Devolvemos un 1 para que la pelota siga su camino con normalidad.
	POPF
	POP DI
	POP CX
	POP BX
	POP AX
	RET

	SEGUIR_VERIFICANDO_DERECHA:
	LEA DI,pelota 						;Obtenemos la popsicion de la pelota
	CALL getBallPos

	CMP DH,4Dh 							;Si la pelota esta en el X 4D, se encuentra al lado de la posicion donde se desplaza la paleta.
	JE	NORMAL_COMPARATION_DERECHA 		;Hacer una comparacion normal.
	CMP DH,4Ch 							;Si la pelota esta en el X 4C, se encuentra a dos espacios de la posicion donde se desplaza la paleta.
	JE	TWO_SPACE_COMPARATION_DERECHA 	;Se hace una comparacion especial.
	JMP FIN_PELOTA_EN_DERECHA


	;----------------UN ESPACIO--------------------------------------------------------

	NORMAL_COMPARATION_DERECHA: 				;TERMINADA
		;COMPARACION SI ESTA AL LADO LA PALETA
		INC DH 							;Vamos a analizar uno a la derecha, donde se desplaza la paleta
		LEA DI,paleta2
		CALL isPaletteAt 				;Preguntamos si la paleta existe en esa posicion
		MOV CL,DH
		JZ 	 REBOTAR_PALETA_2 			;Si la paleta se encuentra al lado rebota con la misma	
		;COMPARACION SI ESTA EN DIAGONAL LA PALETA Y EN EL BUEN SENTIDO
		LEA DI,pelota
		CALL getBallDirec 				;Obtenemos la direccion de la pelota
		CMP DL,00h 						;y comparamos si esta yendo para abajo
		CALL getBallPos 				;Obtenemos la posicion de la pelota
		JE 	VERIFICAR_ABAJO_DERECHA 	;Si la pelota iba para abajo verificamos si hay una porcion de paleta abajo a la derecha
			;VERIFICAR ARRIBA DERECHA 	;Sino verificamos si hay una porcion de paleta arriba a la derecha
			INC DH 							;Derecha
			DEC DL 							;Arriba
			LEA DI,paleta2
			CALL isPaletteAt 			;Verificamos is hay una porcion de la paleta
			MOV CL,DH
			JZ	REBOTAR_PALETA_2 		;Si la hay, la pelota rebota
			JMP	PERDIO_JUGADOR_2 		;Sino pierde el jugador 2
			VERIFICAR_ABAJO_DERECHA:
			INC DH 							;Derecha
			INC DL 							;Abajo
			LEA DI,paleta2
			CALL isPaletteAt 			;Verificamos si hay una porcion de la paleta
			MOV CL,DH
			JZ	REBOTAR_PALETA_2 		;Si la hay, la pelota rebota
			JMP PERDIO_JUGADOR_2 		;Sino pierde el jugador 2

	;----------------DOS ESPACIOS--------------------------------------------------------

	TWO_SPACE_COMPARATION_DERECHA:
	;MOVER LA PELOTA UNO A LA IZQUIERDA Y UNO ARRIBA
		INC DH
		CMP BYTE PTR pelota.sentido[01h],00h 		;Dependiendo el sentido de la pelota movemos arriba o abajo, y uno a la derecha
		JNE TSC_DEC_BALL_DERECHA
		INC DL 										;Uno abajo
		JMP TSC_SEGUIR_DRAWEO_DERECHA
		TSC_DEC_BALL_DERECHA:
		DEC DL 										;Uno arriba
		TSC_SEGUIR_DRAWEO_DERECHA:
		LEA DI,pelota
		CALL setBallPos 							;Seteamos la nueva posicion de la pelota para arreglar el problema de que quede a dos espacios de la paleta.
		CALL RefreshBall 							;Actualizamos esa nueva posicion de la pelota.
		MOV DL,00h 									;Devolvemos un 0 para que no realice el movimiento habitual, ya que nosotros lo forzamos recien.
		JMP FIN_PELOTA_EN_IZQUIERDA 				;Termina la funcion para que luego entre y verifique nuevamente pero con la nueva posicion.

	REBOTAR_PALETA_2:
		CMP CL,condCambio2 							;Si se cumple la condicion de cambio de la paleta2 cambiar modo de sentido
		JE CAMBIAR_SENTIDO_PELOTA_P2
		ZETEAR_NUEVA_DIREC_P2:
		lea di,pelota
		XOR AX,AX
		MOV AL,DirecActual 							;Si anteriormente llamamos a la funcion SiguienteDireccion se cambia la misma, sino queda igual que antes
		PUSH AX
		MOV AX,00h 									;Cambiamos de sentido a la derecha por rebote
		PUSH AX
		MOV AX,0FFh 								;Mantenemos el sentido Abajo Arriba intacto
		PUSH AX
		CALL SetBallDirec 							;Seteamos la nueva direccion de la pelota
		CALL EmpezarSonido
		MOV DL,01h 									;Devolvemos un 1 asi sigue moviendo la pelota en la nueva direccion.
		JMP FIN_PELOTA_EN_DERECHA 					;Seteamos la nueva direccion modificada en la funcion

	CAMBIAR_SENTIDO_PELOTA_P2:
		CALL SiguienteDireccion 					;Cambiamos modo de sentido al siguiente
		JMP ZETEAR_NUEVA_DIREC_P2

	PERDIO_JUGADOR_2:
		INC Punt1 									;Incrementamos la puntuacion del jugador contrario
		MOV AL,02h									;Mandamos como argumento que perdio el jugador 2
		CALL UnPerdedor 							;Configuramos todo para cuando un jugador pierde
		MOV DL,00h 									;Devolvemos un 0 para que no realice el movimiento habitual

	FIN_PELOTA_EN_DERECHA:
	POPF
	POP DI
	POP CX
	POP BX
	POP AX
	RET
VerificarPaletaDerecha endp

;----------------------------------------SiguienteDireccion--------------------------------------------------
; Pasar al siguiente modo de direccion de la pelota: 01 02 03 01 02 03 01 02 03 01 02 03
;------------------------------------------------------------------------------------------------------------
SiguienteDireccion proc
	PUSH AX
	PUSH DX
	PUSH DI
	PUSHF

	LEA DI,pelota
	PUSH DX
	CALL getBallDirec 	 							;Obtenemos la direcciona actual de la pelota
	POP DX
	XOR AH,AH
	CMP AL,03h
	JE CAMBIAR_DIREC_A1  							;Si la direccion actual esta en modo 03 entonces pasamos a la 01
	INC AL 											;Sino pasamos a la siguiente incrementando el valor del modo
	JMP CAMBIAR_DIREC_FINAL
	CAMBIAR_DIREC_A1:
	MOV AL,01h
	CAMBIAR_DIREC_FINAL:
	MOV WORD PTR DirecAux,AX 						;Guardamos en DirecAux el nuevo valor de modo de direccion y sentido
	MOV BYTE PTR DirecActual,AL 					;Guardamos en DirecActual el nuevo valor de modo de direccion y sentido

	POPF
	POP DI
	POP DX
	POP AX
	RET
SiguienteDireccion endp

;----------------------------------------UnPerdedor----------------------------------------------------------
; Cuando alguien pierde, esta funcion se encarga de realizar todas las configuraciones y animaciones de 
;mostrar la puntuacion actual por unos segundos.
;------------------------------------------------------------------------------------------------------------
UnPerdedor proc
	PUSH AX
	
	;Poner todos los flags de movimiento de la paleta nuevamente en 0
	MOV BYTE PTR PAL1UP,FALSE
	MOV BYTE PTR PAL1DOWN,FALSE
	MOV BYTE PTR PAL2UP,FALSE
	MOV BYTE PTR PAL2DOWN,FALSE

	;Avisamos que perdio con sonido y mostrando el puntaje
	CALL desactivarTeclado 					;Desactivamos el teclado para no obtener SCANCODES mientras esta en pausa
	MOV AH,Punt1 							;Le damos los argumentos para mostrar la puntuacion
	MOV AL,Punt2
	CALL ShowScore 							;Mostramos la puntuacion
		CALL EmpezarSonido					;Comenzamos a reproducir el sonido
			MOV BX,100d
			PUSH BX
			CALL DelayMilisec  				;Esperamos 1 segundo para apagar el sonido
		CALL TerminarSonido 				;Detener el sonido
		MOV BX,200d
		PUSH BX
		CALL DelayMilisec 					;Se esperan 2 segundos mas mostrando la puntuacion
	CALL EraseScore 						;Borramos la puntuacion de pantalla
	;Limpiar buffer del teclado
   	MOV AX,00h
   	MOV DX,60h
    OUT DX,AX 								;Intento de limpiar el ultimo Scancode que quedo antes de que se haya pause
	CALL activarTeclado 					;Activamos nuevamente el teclado


	POP AX
	;Recibe en AL el numero de la paleta perdedora (1 o 2)
	MOV BYTE PTR SaqueFlag,TRUE 			;Cambiamos los flags de saque
	MOV BYTE PTR SaqueSelec,AL
	;CAMBIAR DIRECCIONES
	CMP AL,01h 								;Cambiamos la direccion y sentido de la pelota segun quien haya perdido y quien saca
	JE  PERDIO_EL_JUGADOR1
	CMP AL,02h
	JE  PERDIO_EL_JUGADOR2
	JMP FIN_PERDEDOR

	PERDIO_EL_JUGADOR1:
		LEA DI,pelota
		MOV AX,01h
		PUSH AX
		PUSH AX
		MOV AX,0FFh
		PUSH AX
		CALL SetBallDirec 					;Seteamos las nuevas direcciones de la pelota
	JMP FIN_PERDEDOR

	PERDIO_EL_JUGADOR2:
		LEA DI,pelota
		MOV AX,01h
		PUSH AX
		MOV AX,00h
		PUSH AX
		MOV AX,0FFh
		PUSH AX
		CALL SetBallDirec 					;Seteamos las nuevas direcciones de la pelota

	FIN_PERDEDOR:
	MOV BYTE PTR DirecAux,01h
	MOV BYTE PTR DirecActual,01h
	RET
UnPerdedor endp

;----------------------------------------UpdateSaquePos----------------------------------------------------------
; Actualizar la posicion de la pelota segun donde el movimiento de la paleta que tiene el saque.
;----------------------------------------------------------------------------------------------------------------
UpdateSaquePos proc 	;Verificamos ScanCode (Si es Espacio saca), sino updateamos posicion de la pelota en la raqueta
	;Recibe en AL el ASCII de la tecla y segun el mismo cambia el estado de las paletas
	;Recibe en AH si fue presionada o pulsada
	PUSH DI
	PUSH SI
	PUSH DX
	PUSHF

	CMP AL,20h 					;Si hay se presiono ESPACIO entonces el jugador debe sacar
	JE 	JUGADOR_SACO
	JMP ACTUALIZAR_POS_BALL 	;Sino actualizaremos la posicion de la pelota en el centro de la paleta

	JUGADOR_SACO:
	;CALL EmpezarSonido
	MOV SaqueFlag,FALSE 				;Se cambian los flags de saque para que la pelota comience a moverse
	JMP UPDATE_FIN
	
	ACTUALIZAR_POS_BALL:
	CMP SaqueSelec,01h 					;Verificamos cual es la paleta en la que esta el saque y segun eso actualizamos
	JE  ACTUALIZAR_EN_P1
	CMP SaqueSelec,02h
	JE  ACTUALIZAR_EN_P2
	JMP UPDATE_FIN
		ACTUALIZAR_EN_P1:
			LEA SI,paleta1 				;Seleccionamos la paleta1
			MOV DL,01h 					;Seleccionamos el lado derecho de la paleta
		JMP ACTUALIZAR_ULTIMO
		ACTUALIZAR_EN_P2:
			LEA SI,paleta2 				;Seleccionamos la paleta2
			MOV DL,00h 					;Seleccionamos el lado izquierdo de la paleta
		ACTUALIZAR_ULTIMO:
		LEA DI,pelota 					;Seleccionamos la pelota
		CALL initialPosBall 			;Colocamos la pelota en la posicion central de la paleta seleccionada

	UPDATE_FIN:
	POPF
	POP DX
	POP SI
	POP DI
	RET
UpdateSaquePos endp

;----------------------------------------EmpezarSonido----------------------------------------------------------
; Activa los parlantes para comenzar a sonar el pitido a una frecuencia especifica. Maneja los flags para que
;el sonido no se superponga y se termine tildando.
;----------------------------------------------------------------------------------------------------------------
EmpezarSonido proc
	PUSH DI
	CMP BYTE PTR SoundFlag,TRUE 				;Comparar el SoundFlag, si esta encendido no hacemos nada, sino activamos el sonido
	JE NOHACERSONIDO 	
		MOV BYTE PTR SoundFlag,TRUE 			;Prendemos el flag SoundFlag
		CALL StartSound 						;Activamos el parlante
		LEA DI,TIM3
		CALL TimRst 							;Reseteamos el timer del sonido
	NOHACERSONIDO:
	POP DI
	RET
EmpezarSonido endp

;----------------------------------------TerminarSonido----------------------------------------------------------
; Desactiva los parlantes para comenzar a sonar el pitido a una frecuencia especifica. Maneja los flags para que
;el sonido no se superponga y se termine tildando.
;----------------------------------------------------------------------------------------------------------------
TerminarSonido proc
	PUSH DI
	CALL StopSound 					;Desactivar el parlante
	MOV BYTE PTR SoundFlag,FALSE 	;Apagar el flag
	POP DI
	RET
TerminarSonido endp

;----------------------------------------desactivarTeclado----------------------------------------------------------
; Desactiva el teclado utilizando el registro de mascaras del PIC.
;-------------------------------------------------------------------------------------------------------------------
desactivarTeclado proc
	PUSH AX

	MOV AL,00000010b 			;Ponemos en 1 el bit 1 del registro de mascaras del PIC
	OUT 21h,AL 					;Le Transferimos el dato en AL al puerto 21h

	POP AX
	RET
desactivarTeclado endp

;----------------------------------------activarTeclado-------------------------------------------------------------
; Activa el teclado utilizando el registro de mascaras del PIC.
;-------------------------------------------------------------------------------------------------------------------
activarTeclado proc
	PUSH AX

	MOV AL,00000000b 			;Ponemos en 0 el bit 1 del registro de mascaras del PIC
	OUT 21h,AL 					;Le Transferimos el dato en AL al puerto 21h

	POP AX
	RET
activarTeclado endp

end main