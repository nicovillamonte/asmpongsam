.8086
.model small
.stack 100h
.data
tfinal	db 4 dup (30) 		;inicializa la hora final

.code
public ESPERA	;función publica

;-------------------------------------------------------------------------------------------------
;Función ESPERA 
;		Realiza: 		Muestra los scores de los dos jugadores en pantalla, espera un tiempo parametrizable y los borra
;		Recibe: 		AH un número entero con la cantidad de segundos a esperar
;		Devuelve: 	Nada
;------------------------------------------------------------------------------------------------------------------------------------------------------------------
ESPERA proc
	push ax		; guardo los registros que ateraré
	push bx
	push cx
	push dx

	mov bh, ah	; paso por BH la cantidad de segundos de espera

	call tiempo 	;llamado a seteo de tiempos
	call terminal	;llamado hasta obtener los segundos de espera

	pop dx	;restauro registros
	pop cx
	pop bx
	pop ax

	ret
ESPERA endp

;-------------------------------------------------------------------------------------------------
;Función TIEMPO - 	Guarda la hora de inicio de la espera y la hora final 
;								que es la de inicio más los segundos de espera que
;								se reciben por BH
;		Recibe: 		BH un número entero con la cantidad de segundos a esperar
;		Devuelve: 	Nada
;-------------------------------------------------------------------------------------------------
tiempo proc
	mov ah, 2ch	; Funcion del D.O.S. para obtener la hora actual
	int 21h
	
	add dh, bh		; Sumo los segundos de la hora actual los segundos de espera recibidos en el parámetro
	
	cmp dh, 3Bh	; Si la suma supera 59 significa que pasa al minuto siguiente
	jle step1			; Como no supera los 59 segundos, salto
	sub dh, 3Ch	; Superó los 59 segundos, resto 60 segundos
	inc cl				; Sumo 1 minuto

step1:
	cmp cl, 3Bh		; Hago la misma comparación de los minutos con 59 para ver si se pasa de hora
	jle step2
	sub cl, 3Ch		; Resto 60 minutos
	inc ch				; Sumo 1 hora

step2:
	cmp ch, 17h	; Lo mismo pero con las horas si se pasan de 23
	jle step3
	sub ch, 18h		; Resto 24 horas

step3:
	mov byte ptr [offset tfinal], cl		; Cargo el vector con la hora final (con la espera sumada)
	mov byte ptr [offset tfinal + 1], ch
	mov byte ptr [offset tfinal + 2], dl
	mov byte ptr [offset tfinal + 3], dh

	ret
tiempo endp

;-------------------------------------------------------------------------------------------------
;Función TERMINAL - 	Compara la hora del computador con la hora final
;		Recibe: 		BH un número entero con la cantidad de segundos a esperar
;		Devuelve: 	Nada
;-------------------------------------------------------------------------------------------------
terminal proc
tick:
	mov ah,2ch		; Hora actual
	int 21h
	mov bx, word ptr [offset tfinal]
	cmp cx,bx		; Comparo HS:MIN actuales con la HS:MIN finales
	jl tick				; Si no llegaron aún, epiezo de nuevo

	mov bx, word ptr [offset tfinal +2]
	cmp dx,bx		; Comparo SS:CENTESIMAS DE SEG actuales con la SEG:CENTESIMAS DE SEG finales
	jl tick

final:
	ret		; Se alcanzó la hora final, vuelvo

terminal endp
;-------------------------------------------------------------------------------------------------

end