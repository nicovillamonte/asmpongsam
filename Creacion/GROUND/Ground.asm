.8086
.model small
.stack 100h
.data
SCREEN 	DB 	        20h,0DEh,37 dup (20h),0BAh,37 dup (20h),20h,0DDh
		DB	0Dh,0Ah,20h,0DEh,37 dup (20h),0BAh,37 dup (20h),20h,0DDh
		DB	0Dh,0Ah,20h,0DEh,37 dup (20h),0BAh,37 dup (20h),20h,0DDh
		DB	0Dh,0Ah,20h, 20h,37 dup (20h),0BAh,37 dup (20h),20h,020h
		DB	0Dh,0Ah,20h, 20h,37 dup (20h),0BAh,37 dup (20h),20h,020h
		DB	0Dh,0Ah,20h, 20h,37 dup (20h),0BAh,37 dup (20h),20h,020h
		DB	0Dh,0Ah,20h, 20h,37 dup (20h),0BAh,37 dup (20h),20h,020h
		DB	0Dh,0Ah,20h, 20h,37 dup (20h),0BAh,37 dup (20h),20h,020h
		DB	0Dh,0Ah,20h, 20h,37 dup (20h),0BAh,37 dup (20h),20h,020h
		DB	0Dh,0Ah,20h, 20h,37 dup (20h),0BAh,37 dup (20h),20h,020h
		DB	0Dh,0Ah,20h, 20h,37 dup (20h),0BAh,37 dup (20h),20h,020h
		DB	0Dh,0Ah,20h, 20h,37 dup (20h),0BAh,37 dup (20h),20h,020h
		DB	0Dh,0Ah,20h, 20h,37 dup (20h),0BAh,37 dup (20h),20h,020h
		DB	0Dh,0Ah,20h, 20h,37 dup (20h),0BAh,37 dup (20h),20h,020h
		DB	0Dh,0Ah,20h, 20h,37 dup (20h),0BAh,37 dup (20h),20h,020h
		DB	0Dh,0Ah,20h, 20h,37 dup (20h),0BAh,37 dup (20h),20h,020h
		DB	0Dh,0Ah,20h, 20h,37 dup (20h),0BAh,37 dup (20h),20h,020h
		DB	0Dh,0Ah,20h, 20h,37 dup (20h),0BAh,37 dup (20h),20h,020h
		DB	0Dh,0Ah,20h, 20h,37 dup (20h),0BAh,37 dup (20h),20h,020h
		DB	0Dh,0Ah,20h, 20h,37 dup (20h),0BAh,37 dup (20h),20h,020h
		DB	0Dh,0Ah,20h, 20h,37 dup (20h),0BAh,37 dup (20h),20h,020h
		DB	0Dh,0Ah,20h, 20h,37 dup (20h),0BAh,37 dup (20h),20h,020h
		DB	0Dh,0Ah,20h, 20h,37 dup (20h),0BAh,37 dup (20h),20h,020h
		DB	0Dh,0Ah,20h, 20h,37 dup (20h),0BAh,37 dup (20h),20h,020h
		DB	0Dh,0Ah,20h, 20h,37 dup (20h),0BAh,37 dup (20h),20h,020h,24h
.code
main proc
	MOV AX,@DATA
	MOV DS,AX

	CALL Draw

	mov ah,08h
	int 21h

	MOV AX,4C00h
	INT 21h
main endp

;-----------------------------------------------------------------

Draw proc
	PUSH AX 					;Push de los registros
	PUSH DX

	MOV AX,03h 					;Borramos pantalla
	INT 10h

	MOV AH,09h 					;Imprimimos el vector SCREEN
	LEA DX,SCREEN
	INT 21h

	POP DX 						;Pop de los registros
	POP AX
	RET
Draw endp

;-----------------------------------------------------------------

setCoord proc
	;Ezequiel
setCoord endp

;-----------------------------------------------------------------

getCoord proc
	;Ezequiel
getCoord endp

;-----------------------------------------------------------------

chgCoord proc
	;Adrian
chgCoord endp

;-----------------------------------------------------------------

getPos proc
	;Mateo
getPos endp

;-----------------------------------------------------------------

getPosXY proc
	;Mateo
getPosXY endp

;-----------------------------------------------------------------

FillSq proc
	;Adrian
FillSq endp

;-----------------------------------------------------------------

end main