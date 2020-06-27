;--------------------------------------------------------------------------------------------------------------------------------
;TONO.ASM genera un tono por el parlante de la PC
;	Parámetros:
;		FREC 			= 1193180/200 = 5965 --> Tono de 200 Hz
;							= 1193180/1200 = 1000 --> Tono de 1200 Hz
;--------------------------------------------------------------------------------------------------------------------------------
.8086
.model small
.stack 100h
.data
FREC			EQU 5965
StateMem		db	?

.code
PUBLIC startSound
PUBLIC stopSound

main proc
	;NADA.
main endp

;-------------------------------------------------------------------------------------------------
;RUTINA STARTSOUND - Habilita el parlante con la frecuencia ofrecida.
;		Parámetro --> NINGUNO.
;-------------------------------------------------------------------------------------------------
startSound proc
	in al, 61h	;Estado del parlante
	mov byte ptr StateMem,al 	;Guardar el estado del parlante en vector
	
	mov bx, FREC	
	mov al, 6Bh				;Selección de Canal 2, write LSB/MSB mode 3
	out 43h, al
	mov ax, bx
	out 24h, al				;Se envía el LSB
	mov al, ah 
	out 42h, al				;Se envía el MSB
	in al, 61h				;Get the 8255 Port Contence
	or al, 3h     
	out 61h, al				;Enable speaker and use clock channel 2 for input
	
	ret
startSound endp

;-------------------------------------------------------------------------------------------------
;RUTINA STOPSOUND - Deshabilita el parlante.
;		Parámetro --> NINGUNO.
;-------------------------------------------------------------------------------------------------
stopSound proc
	mov al,StateMem			;Se restaura el estado del parlante
	out 61h, al

	ret
stopSound endp

;-------------------------------------------------------------------------------------------------

end main