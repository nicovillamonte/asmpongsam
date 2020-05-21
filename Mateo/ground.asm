.8086
.model small
.stack 100h
	BytesPL equ 78d
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

	mov dh, 64d
	mov dl, 16d
	CALL getPos

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
		push ax
		push bx

		xor ax, ax
		mov al, dl
		mov bl, BytesPL
		add bl, 3
		mul bl
		xchg dh, dl
		xor dh, dh
		add ax, dx
		mov dx, ax

		pop bx
		pop ax
		ret
getPos endp

;-----------------------------------------------------------------

getPosXY proc
		push ax
		push bx
		push cx
		push dx
		xor cx, cx

PosY:
		mov ax, dx
		mov bl, BytesPL
		div bl
		mov bh, 3
		mul bh
		sub dx, ax
		mov ax, dx
		div bl
		mov cl, al
		
PosX:
		pop dx
		mov ax, dx
		mov bl, BytesPL
		div bl
		mov bh, 3
		mul bh
		sub dx, ax
		mov ax, dx
		div bl
		mov ch, ah

FinPosXY:
		mov dx, cx		
		pop cx
		pop bx
		pop ax
		ret
getPosXY endp

;-----------------------------------------------------------------

FillSq proc
	;Adrian
FillSq endp

;-----------------------------------------------------------------

end main
