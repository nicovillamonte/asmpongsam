.8086
.model small
.stack 100h
.data
tfinal			db 4 dup (30) 		;inicializa la hora final

.code

main proc
	MOV	AX,@data
	MOV	DS, AX
	
	IN AL, 61h	;Estado del parlante
	PUSH AX 	;Guardar en la pila
	
	;MOV BX, 1000	;1193180/1200 hz --> Cálculo del valor a colocar en BX según la frecuencia deseada
	MOV BX, 5965	;1193180/200 hz --> Cálculo del valor a colocar en BX según la frecuencia deseada
	MOV AL, 6Bh		;Selección de Canal 2, write LSB/MSB mode 3
	OUT 43h, AL
	MOV AX, BX
	OUT 24h, AL		;Se envía el LSB
	MOV AL, AH 
	OUT 42h, AL		;Se envía el MSB
	IN AL, 61h			;Get the 8255 Port Contence
	OR AL, 3h     
	OUT 61h, AL		;Enable speaker and use clock channel 2 for input
	
	mov	bh, 3			;Espera de 3 centésimas de segundo
	call 	ESPERA2		;Llamado a espera
	
	POP AX				;Se restaura el estado del parlante
	OUT 61h, AL

	mov ax,4C00h
	int 21h
main endp

;-------------------------------------------------------------------------------------------------
;RUTINA ESPERA2 - Provoca demora de XX centésimas de segundo
;		Parámetro --> BH
;-------------------------------------------------------------------------------------------------
ESPERA2 proc
	push ax		;guardo los registros que ateraré
	push bx
	push cx
	push dx

	call TIEMPO 	;llamado a seteo de tiempos
	call TERMINAL	;llamado hasta obtener los segundos de espera

	pop dx	;restauro registros111
	pop cx
	pop bx
	pop ax

	ret
ESPERA2 endp

;-------------------------------------------------------------------------------------------------
;RUTINA TIEMPO - 	Guarda la hora de inicio de la espera y la hora final 
;		que es la de inicio más los segundos de espera que
;		se reciben por BH
;-------------------------------------------------------------------------------------------------
TIEMPO proc
	mov ah, 2ch	;hora actual
	int 21h
	
	add dl, bh		;sumo los segundos de espera a los segundos de la hora actual
	
	cmp dl, 63h		;si la suma supera 99 significa que pasa al segundo siguiente
	jle step0			;como no supera las 99 centésimas de segundos, salto
	sub dl, 64h	;superó, resto 100 segundos
	inc dh				;sumo 1 minuto

step0:
	cmp dh, 3Bh	;si la suma supera 59 significa que pasa al minuto siguiente
	jle step1			;como no supera los 59 segundos, salto
	sub dh, 3Ch	;superó los 59 segundos, resto 60 segundos
	inc cl				;sumo 1 minuto

step1:
	cmp cl, 3Bh		;hago la misma comparación de los minutos con 59 para ver si se pasa de hora
	jle step2
	sub cl, 3Ch		;resto 60 minutos
	inc ch				;sumo 1 hora

step2:
	cmp ch, 17h	;Lo mismo pero con las horas si se pasan de 23
	jle step3
	sub ch, 18h		;resto 24 horas

step3:
	mov byte ptr [offset tfinal], cl		;cargo el vector con la hora final (con la espera sumada)
	mov byte ptr [offset tfinal + 1], ch
	mov byte ptr [offset tfinal + 2], dl
	mov byte ptr [offset tfinal + 3], dh

	ret
TIEMPO endp
;-------------------------------------------------------------------------------------------------

;-------------------------------------------------------------------------------------------------
;RUTINA TERMINAL - 	Compara la hora del computador con la hora final
;-------------------------------------------------------------------------------------------------
TERMINAL proc
tick:
	mov ah,2ch		;hora actual
	int 21h
	mov bx, word ptr [offset tfinal]
	cmp cx,bx		;comparo HS:MIN actuales con la HS:MIN finales
	jl tick				;si no llegaron aún, epiezo de nuevo

	mov bx, word ptr [offset tfinal +2]
	cmp dx,bx		;comparo SS:CENTESIMAS DE SEG actuales con la SEG:CENTESIMAS DE SEG finales
	jl tick

final:
	ret		;Se alcanzó la hora final, vuelvo

TERMINAL endp
;-------------------------------------------------------------------------------------------------
end main
