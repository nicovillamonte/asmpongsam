.8086
.model small
.stack 100h
FALSE 	EQU 	00h
TRUE	EQU		01h
.data
INCLUDE STRUCS.inc
	INTERN_TIMER 	TIMER 		<>
	TimCarry 		DB 			FALSE
	AuxMilCont		DW 			?,?
.code
;Timers
PUBLIC TimRst
PUBLIC refreshPassedTim
;Milisegundos
PUBLIC getPassedMiliSec
PUBLIC cmpMiliSec
PUBLIC delayMilisec
;Segundos
PUBLIC getPassedSeconds
PUBLIC cmpSeconds
PUBLIC delaySeconds
;Minutos
PUBLIC getPassedMinutes
PUBLIC cmpMinutes
PUBLIC delayMinutes

main proc
	;NADA.
main endp

;-----------------------TIMRST--------------------------------------
;Recibe:                                                           |
;		DI = Offset TIMER                                          |
;	Devuelve:                                                      |
;		Nada.                                                      |
;	Efecto:                                                        |
;		Setea en 0 el valor inicial del TIMER seleccionado.        |
;		Setea el timer en el tiempo actual.                        |
;-------------------------------------------------------------------
TimRst proc
	PUSH AX
	PUSH BX
	PUSH CX
	PUSH DX
	PUSHF

	MOV BX,DI
	MOV AH,2Ch
	INT 21h
	MOV BYTE PTR [BX+00h],CH
	MOV BYTE PTR [BX+01h],CL
	MOV BYTE PTR [BX+02h],DH
	MOV BYTE PTR [BX+03h],DL
	MOV AH,2Ah
	INT 21h
	MOV BYTE PTR [BX+04h],DL
	
	POPF
	POP DX
	POP CX
	POP BX
	POP AX
	RET
TimRst endp

;-----------------------refreshPassedTim--------------------------
;Recibe:														 |
;	DI = Offset TIMER 										  	 |
;Devuelve: 													  	 |
;	Nada. 													   	 |
;Efecto: 													  	 |
;	Refresca el tiempo actual del timer teniendo en cuenta 	 	 |
;	los valores iniciales. 									  	 |
;-----------------------------------------------------------------
refreshPassedTim proc
	PUSH AX
	PUSH BX
	PUSH CX
	PUSH DX
	PUSH SI

	XOR SI,SI
	MOV BX,DI
	;PARTE QUE REFRESCA LAS HORAS, MINUTOS, SEGUNDOS y CENTESIMAS PASADAS
	;0.Comparar Fechas
	MOV AH,2Ah
	INT 21h
	CMP DL,[BX+04h]
	JNE	RPT_OTRODIA
	;Obtener Tiempo del sistema en Sexagesimal
	MOV AH,2Ch
	INT 21h
	JMP RPT_CALCULAR
	
	RPT_OTRODIA:
	MOV CX,173Bh
	MOV DX,3B64h
	MOV SI,01h

	RPT_CALCULAR:
	;1.Restar milisec
	SUB DL,[BX+03h]
	CMP DL,00h
	JL	RPT_NEG_MILISEC
		MOV TimCarry,FALSE
		JMP RPT_SAVE_MILISEC
	RPT_NEG_MILISEC:
		ADD DL,64h
		MOV TimCarry,TRUE
	RPT_SAVE_MILISEC:
	MOV BYTE PTR [BX+08h],DL
	;2.Restar Sec
	SUB DH,[BX+02h]
	SUB DH,TimCarry
	CMP DH,00h
	JL	RPT_NEG_SEC
		MOV TimCarry,FALSE
		JMP RPT_SAVE_SEC
	RPT_NEG_SEC:
		ADD DH,3Ch
		MOV TimCarry,TRUE
	RPT_SAVE_SEC:
	MOV BYTE PTR [BX+07h],DH
	;3.Restar Min
	SUB CL,[BX+01h]
	SUB CL,TimCarry
	CMP CL,00h
	JL	RPT_NEG_MIN
		MOV TimCarry,FALSE
		JMP RPT_SAVE_MIN
	RPT_NEG_MIN:
		ADD CL,3Ch
		MOV TimCarry,TRUE
	RPT_SAVE_MIN:
	MOV BYTE PTR [BX+06h],CL
	;4.Restar Horas
	SUB CH,[BX+00h]
	SUB CH,TimCarry
	MOV BYTE PTR [BX+05h],CH

	;Si el dia es otro entonces debemos sumar lo pasado.
	CMP SI,01h
	JNE RPT_FIN
	MOV AH,2Ch
	INT 21h
	call otroDia


	RPT_FIN:
	POP SI
	POP DX
	POP CX
	POP BX
	POP AX
	RET
refreshPassedTim endp

otroDia proc
	PUSH AX

	;1.Sumar Milisec
	ADD BYTE PTR [BX+08h],DL
	CMP BYTE PTR [BX+08h],64h
	JGE RPT_MAY_MILISEC
	MOV TimCarry,FALSE
	JMP TERMINAR_MILISEC
	RPT_MAY_MILISEC:
		SUB BYTE PTR [BX+08h],64h
		MOV TimCarry,TRUE
	TERMINAR_MILISEC:
	;2.Sumar Sec
	ADD BYTE PTR [BX+07h],DH
	MOV AL,TimCarry
	ADD BYTE PTR [BX+07h],AL
	CMP BYTE PTR [BX+07h],3Ch
	JGE RPT_MAY_SEC
	MOV TimCarry,FALSE
	JMP TERMINAR_SEC
	RPT_MAY_SEC:
		SUB BYTE PTR [BX+07h],3Ch
		MOV TimCarry,TRUE
	TERMINAR_SEC:
	;3.Sumar Min
	ADD BYTE PTR [BX+06h],CL
	MOV AL,TimCarry
	ADD BYTE PTR [BX+06h],AL
	CMP BYTE PTR [BX+06h],3Ch
	JGE RPT_MAY_MIN
	MOV TimCarry,FALSE
	JMP TERMINAR_MIN
	RPT_MAY_MIN:
		SUB BYTE PTR [BX+06h],3Ch
		MOV TimCarry,TRUE
	TERMINAR_MIN:
	;4.Sumar Horas
	ADD BYTE PTR [BX+05h],CH
	MOV AL,TimCarry
	ADD BYTE PTR [BX+05h],AL
	CMP BYTE PTR [BX+06h],17h
	JL	OD_FIN
	;Si sigue aca hubo un error de overflow de horario
	MOV BYTE PTR [BX+05h],0FFh
	MOV BYTE PTR [BX+06h],0FFh
	MOV BYTE PTR [BX+07h],0FFh
	MOV BYTE PTR [BX+08h],0FFh

OD_FIN:
	POP AX
	RET
otroDia endp

;-----------------------getPassedMiliSec--------------------------
;Recibe: 														 |
;	DI = Offset TIMER. 										 	 |
;Devuelve: 													  	 |
;	CX = Parte ALTA de los milisegundos. 					 	 |
;	DX = Parte BAJA de los milisegundos. 					  	 |
;Efecto: 													 	 |
;	Devuelve en milisegundos el tiempo pasado desde su Reset.	 |
;-----------------------------------------------------------------
getPassedMiliSec proc
	
	PUSH AX
	PUSH BX
	PUSHF

	MOV BX,DI
	CALL refreshPassedTim

	
	MOV WORD PTR [BX+09h],00h
	MOV WORD PTR [BX+0Bh],00h

	XOR AX,AX

	CMP BYTE PTR [BX+05h],00h
	JNE GPM_CALC_HORAS
	JMP GPM_TERM_HORAS
	GPM_CALC_HORAS:
	;Pasamos las Horas a milisegundos
		;Horasx3600 = Segundos
			MOV AL,[BX+05h]
			MOV CX,0E10h
			MUL CX
			ADD [BX+09h],DX
			ADD [BX+0Bh],AX
		;Segundosx100 = milisegundos
			MOV CX,0064h
			MUL CX
			MOV AuxMilCont[00h],DX
			MOV AuxMilCont[02h],AX
			;
			MOV AX,[BX+09h]
			MUL CL
			;ADD AX,AuxMilCont[00h]
			;;MOV [BX+09h],AX
			ADD AuxMilCont[00h],AX
			;Guardamos el resultado
			MOV AX,AuxMilCont[02h]
			MOV DX,AuxMilCont[00h]
			MOV [BX+09h],DX
			MOV [BX+0Bh],AX
	GPM_TERM_HORAS:
	CMP BYTE PTR [BX+06h],00h
	JNE GPM_CALC_MIN
	JMP GPM_TERM_MIN
	GPM_CALC_MIN:
	;Pasamos los minutos a milisegundos
		XOR AX,AX
		MOV AL,[BX+06h] 		;Obtenemos los minutos pasados
		MOV CX,1770h
		MUL CX
		ADD [BX+0Bh],AX
		JC  GPM_HAYCARRY_MIN
		ADD [BX+09h],DX
		JMP GPM_TERM_MIN
		GPM_HAYCARRY_MIN:
		INC DX
		ADD [BX+09h],DX
	GPM_TERM_MIN:
	CMP BYTE PTR [BX+07h],00h
	JNE GPM_CALC_SEG
	JMP GPM_TERM_SEG
	GPM_CALC_SEG:
		;Pasamos los segundos a milisegundos
		XOR AX,AX
		XOR CX,CX
		MOV AL,[BX+07h] 		;Obtenemos los segundos pasados
		MOV CL,64h
		MUL CL
		ADD [BX+0Bh],AX
		JC  GPM_HAYCARRY_SEG
		JMP GPM_TERM_SEG
		GPM_HAYCARRY_SEG:
		INC WORD PTR [BX+09h]
	GPM_TERM_SEG:
	CMP BYTE PTR [BX+08h],00h
	JNE GPM_CALC_CENT
	JMP GPM_TERM_CENT
	GPM_CALC_CENT:
		;Sumamos los milisegundos
		XOR AX,AX
		MOV AL,[BX+08h] 		;Obtenemos los milisegundos pasados
		ADD [BX+0Bh],AX
		JC  GPM_HAYCARRY_CENT
		JMP GPM_TERM_CENT
		GPM_HAYCARRY_CENT:
		INC WORD PTR [BX+09h]
	GPM_TERM_CENT:
	MOV CX,[BX+09h]
	MOV DX,[BX+0Bh]

	POPF
	POP BX
	POP AX
	RET
getPassedMiliSec endp

;-----------------------getPassedSeconds--------------------------
;Recibe: 														 |
;	DI = Offset TIMER. 										 	 |
;Devuelve: 													  	 |
;	CX = Parte ALTA de los segundos. 					 	 	 |
;	DX = Parte BAJA de los segundos. 					  	  	 |
;Efecto: 													 	 |
;	Devuelve en segundos el tiempo pasado desde su Reset.	 	 |
;-----------------------------------------------------------------
getPassedSeconds proc
	PUSH AX
	PUSH BX
	PUSHF

	MOV BX,DI
	CALL refreshPassedTim

	MOV WORD PTR [BX+0Dh],00h
	MOV WORD PTR [BX+0Fh],00h
	XOR AX,AX

	CMP BYTE PTR [BX+05h],00h
	JNE GPS_CALC_HORAS
	JMP GPS_TERM_HORAS
	GPS_CALC_HORAS:
	;Pasamos las Horas a Segundos
		;Horasx3600 = Segundos
		MOV AL,[BX+05h]
		MOV CX,0E10h
		MUL CX
		ADD [BX+0Dh],DX
		ADD [BX+0Fh],AX
	GPS_TERM_HORAS:
	CMP BYTE PTR [BX+06h],00h
	JNE GPS_CALC_MIN
	JMP GPS_TERM_MIN
	GPS_CALC_MIN:
	;Pasamos los minutos a Segundos
		;Minutosx60 = Segundos
		XOR AX,AX
		MOV AL,[BX+06h]
		MOV CX,3Ch
		MUL CL 			;Resultado en AX
		ADD [BX+0Fh],AX
		JC 	GPS_HAYCARRY_MIN
		JMP GPS_TERM_MIN
		GPS_HAYCARRY_MIN:
			INC WORD PTR [BX+0Dh]
	GPS_TERM_MIN:
	CMP BYTE PTR [BX+07h],00h
	JNE GPS_CALC_SEG
	JMP GPS_TERM_SEG
	GPS_CALC_SEG:
	;Sumamos los segundos restantes
		XOR AX,AX
		MOV AL,[BX+07h]
		ADD [BX+0Fh],AX
		JC 	GPS_HAYCARRY_SEG
		JMP GPS_TERM_SEG
		GPS_HAYCARRY_SEG:
			INC WORD PTR [BX+0Dh]
	GPS_TERM_SEG:
	MOV CX,[BX+0Dh]
	MOV DX,[BX+0Fh]

	POPF
	POP BX
	POP AX
	RET
getPassedSeconds endp

;-----------------------getPassedMinutes--------------------------
;Recibe: 														 |
;	DI = Offset TIMER. 										 	 |
;Devuelve: 													  	 |					 	 	 |
;	DX = Minutos pasados.			 					  	  	 |
;Efecto: 													 	 |
;	Devuelve en minutos el tiempo pasado desde su Reset.	 	 |
;-----------------------------------------------------------------
getPassedMinutes proc
	PUSH AX
	PUSH BX
	PUSH CX
	PUSHF

	MOV BX,DI
	CALL refreshPassedTim

	MOV WORD PTR [BX+11h],00h
	XOR AX,AX

	CMP BYTE PTR [BX+05h],00h
	JNE GPMn_CALC_HORAS
	JMP GPMn_TERM_HORAS
	GPMn_CALC_HORAS:
	;Pasamos las Horas a Minutos
		;Horasx60 = Minutos
		MOV AL,[BX+05h]
		MOV CX,3Ch
		MUL CL
		ADD [BX+11h],AX
	GPMn_TERM_HORAS:
	CMP BYTE PTR [BX+06h],00h
	JNE GPMn_CALC_MIN
	JMP GPMn_TERM_MIN
	GPMn_CALC_MIN:
	;Agreagar los minutos sobrantes
		XOR AX,AX
		MOV AL,[BX+06h]
		ADD [BX+11h],AX
	GPMn_TERM_MIN:
	MOV DX,[BX+11h]

	POPF
	POP CX
	POP BX
	POP AX
	RET
getPassedMinutes endp

;-----------------------cmpMiliSec--------------------------------
;	DI = Offset TIMER.											 |
; 	DX = milisegundos de 0000h a 0FFFEh. 						 |
;Devuelve: 														 |
;	Zero Flag en 1 si el tiempo introducido en DX ya pasó. 		 |
;	Zero Flag en 0 si el tiempo introducido en DX no pasó. 		 |
;Efecto: 														 |
;	Cambia e ZF dependiendo de si paso o no el tiempo 		 	 |
;	indicado en milisegundos.	 								 |
;-----------------------------------------------------------------
cmpMiliSec proc
	PUSH CX
	PUSH DX
	CALL getPassedMiliSec
	CMP CX,00h
	JNE CMS_FIN_VERIFICADO
	MOV CX,DX
	;EN CX QUEDA LO CONTADO
	POP DX


	CMP CX,00h
	JL	CMS_TIM_NEG
	CMP DX,00h
	JL	CMS_ARG_NEG
	;Si sigue aca se hace la comparacion normal (Ambos positivos o ambos negativos)
	CMS_CMP_NORMAL:
		CMP CX,DX
		JGE CMS_FIN_VERIFICADO
		CALL clrZF
		JMP CMS_FIN

	CMS_TIM_NEG:
	CMP DX,00h
	JL	CMS_CMP_NORMAL
	;si sigue aca entonces CX es negativo y DX es positivo en CA2
		JMP CMS_FIN_VERIFICADO

	CMS_ARG_NEG:
	;Si llega aca CX es positivo y DX es negativo en CA2
		CALL clrZF
		JMP CMS_FIN

	CMS_FIN_VERIFICADO:
	CALL setZF
	CMS_FIN:
	;POP DX
	POP CX
	RET
cmpMiliSec endp


;-----------------------setZF-------------------------------------
;Efecto: 														 |
;	Setear el Zero Flag en 1. 						 		 	 |
;-----------------------------------------------------------------
setZF proc
	PUSH AX
	PUSH BX

	PUSHF
	POP BX
	MOV AL,01000000b
	OR 	BL,AL
	PUSH BX
	POPF

	POP BX
	POP AX
	RET
setZF endp

;-----------------------clrZF-------------------------------------
;Efecto: 														 |
;	Setear el Zero Flag en 0. 						 		 	 |
;-----------------------------------------------------------------
clrZF proc
	PUSH AX
	PUSH BX

	PUSHF
	POP BX
	MOV AL,10111111b
	AND	BL,AL
	PUSH BX
	POPF

	POP BX
	POP AX
	RET
clrZF endp

;-----------------------cmpSeconds--------------------------------
;Recibe: 														 |	
;	DI = Offset TIMER.											 |
; 	DX = Segundos de 0000h a 0FFFEh. 						 	 |
;Devuelve: 														 |
;	Zero Flag en 1 si el tiempo introducido en DX ya pasó. 		 |
;	Zero Flag en 0 si el tiempo introducido en DX no pasó. 		 |
;Efecto: 														 |
;	Cambia e ZF dependiendo de si paso o no el tiempo 		 	 |
;	indicado en segundos.	 								 	 |
;-----------------------------------------------------------------
cmpSeconds proc
	PUSH CX
	PUSH DX
	CALL getPassedSeconds
	CMP CX,00h
	JNE CS_FIN_VERIFICADO
	MOV CX,DX
	;EN CX QUEDA LO CONTADO
	POP DX


	CMP CX,00h
	JL	CS_TIM_NEG
	CMP DX,00h
	JL	CS_ARG_NEG
	;Si sigue aca se hace la comparacion normal (Ambos positivos o ambos negativos)
	CS_CMP_NORMAL:
		CMP CX,DX
		JGE CS_FIN_VERIFICADO
		CALL clrZF
		JMP CS_FIN

	CS_TIM_NEG:
	CMP DX,00h
	JL	CS_CMP_NORMAL
	;si sigue aca entonces CX es negativo y DX es positivo en CA2
		JMP CS_FIN_VERIFICADO

	CS_ARG_NEG:
	;Si llega aca CX es positivo y DX es negativo en CA2
		CALL clrZF
		JMP CS_FIN


	CS_FIN_VERIFICADO:
	CALL setZF
	CS_FIN:
	POP CX
	RET
cmpSeconds endp

;-----------------------cmpMinutes--------------------------------
;Recibe: 														 |
;	DI = Offset TIMER.											 |
; 	DX = Minutos de 0000h a 059Fh. 						 	 	 |
;Devuelve: 														 |
;	Zero Flag en 1 si el tiempo introducido en DX ya pasó. 		 |
;	Zero Flag en 0 si el tiempo introducido en DX no pasó. 		 |
;Efecto: 														 |
;	Cambia e ZF dependiendo de si paso o no el tiempo 		 	 |
;	indicado en minutos.	 								 	 |
;-----------------------------------------------------------------
cmpMinutes proc
	PUSH CX
	PUSH DX
	CALL getPassedMinutes
	MOV CX,DX
	;EN CX QUEDA LO CONTADO
	POP DX


	CMP CX,00h
	JL	CM_TIM_NEG
	CMP DX,00h
	JL	CM_ARG_NEG
	;Si sigue aca se hace la comparacion normal (Ambos positivos o ambos negativos)
	CM_CMP_NORMAL:
		CMP CX,DX
		JGE CM_FIN_VERIFICADO
		CALL clrZF
		JMP CM_FIN

	CM_TIM_NEG:
	CMP DX,00h
	JL	CM_CMP_NORMAL
	;si sigue aca entonces CX es negativo y DX es positivo en CA2
		JMP CM_FIN_VERIFICADO

	CM_ARG_NEG:
	;Si llega aca CX es positivo y DX es negativo en CA2
		CALL clrZF
		JMP CM_FIN


	CM_FIN_VERIFICADO:
	CALL setZF
	CM_FIN:
	POP CX
	RET
cmpMinutes endp

;-----------------------delayMilisec------------------------------
;Recibe: 														 |
;	PUSH = MILISEGUNDOS A ESPERAR (de 0 a 65535). 				 |
;Devuelve: 														 |
; 	Nada. 														 |
;Efecto: 														 |
;	Espera el tiempo introducido en milisegundos sin hacer nada. |
;-----------------------------------------------------------------
delayMilisec proc
	PUSH BP
	MOV BP,SP
	PUSH DX
	PUSHF

	LEA DI,INTERN_TIMER
	CALL TimRst
	MOV DX,SS:[BP+04h]
	DMS_LOP:
		CALL cmpMiliSec
		JNE DMS_LOP

	POPF
	POP DX
	POP BP
	RET 2
delayMilisec endp

;-----------------------delaySeconds------------------------------
;Recibe: 														 |
;	PUSH = SEGUNDOS A ESPERAR (de 0 a 65535). 				  	 |
;Devuelve: 														 |
; 	Nada. 														 |
;Efecto: 														 |
;	Espera el tiempo introducido en segundos sin hacer nada. 	 |
;-----------------------------------------------------------------
delaySeconds proc
	PUSH BP
	MOV BP,SP
	PUSH DX
	PUSHF

	LEA DI,INTERN_TIMER
	CALL TimRst
	MOV DX,SS:[BP+04h]
	DS_LOP:
		CALL cmpSeconds
		JNE DS_LOP

	POPF
	POP DX
	POP BP
	RET 2
delaySeconds endp

;-----------------------delayMinutes------------------------------
;Recibe: 														 |
;	PUSH = MINUTOS A ESPERAR (de 0 a 1380). 				  	 |
;Devuelve: 														 |
; 	Nada. 														 |
;Efecto: 														 |
;	Espera el tiempo introducido en minutos sin hacer nada. 	 |
;-----------------------------------------------------------------
delayMinutes proc
	PUSH BP
	MOV BP,SP
	PUSH DX
	PUSHF

	LEA DI,INTERN_TIMER
	CALL TimRst
	MOV DX,SS:[BP+04h]
	DM_LOP:
		CALL cmpMinutes
		JNE DM_LOP

	POPF
	POP DX
	POP BP
	RET 2
delayMinutes endp
;-----------------------------------------------------------------
end main