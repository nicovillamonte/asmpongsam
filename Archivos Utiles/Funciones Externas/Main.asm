.8086
.model small
.stack 100h
.data

.code
EXTRN SUMA:PROC
EXTRN RESTA:PROC

main proc
	MOV AX,@DATA
	MOV DS,AX

	MOV AX,45d
	MOV BX,05d
	CALL SUMA

	MOV AX,45d
	MOV BX,05d
	CALL RESTA	

	MOV AX,4C00h
	INT 21h
main endp
end main