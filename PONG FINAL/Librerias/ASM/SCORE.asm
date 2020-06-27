.8086
.model small
.stack 100h
.data
	JUG1 EQU 0218h ; JUGX es la fila-columna de la posición superior izquierda del primero de los dos nros  de score del jugador X
	JUG2 EQU 022Ah
	
	DISTCIFRAS EQU 07h
	;DELAYBORRADO EQU 03h

	scorejugador1 db 00h ; SCOREJUGADORX es el valor de score que se quiere mostrar en pantalla para el jugador X
	scorejugador2 db 00h
	
	cursor					dw 00h, 00h ; CURSOR se utiliza para posicionar el cursor en la impresión del dígito del score
	punteronumero dw 00h, 00h ; PUNTERONUMERO es la variable cuyo valor es el offset del número a mostrar
	punterocursor	dw 00h, 00h ; PUNTEROCRURSOR el para posicionar cada línea de impresión del digito del score

	uno1 db 20h, 20h, 20h, 0DFh, 0DBh, '$' ; Composión del número 1, fila 1 en adelante
	uno2 db 20h, 20h, 20h, 20h, 0DBh, '$'
	uno3 db 20h, 20h, 20h, 20h, 0DBh, '$'
	uno4 db 20h, 20h, 20h, 20h, 0DBh, '$'
	uno5 db 20h, 20h, 20h, 20h, 0DBh, '$'

	dos1 db 0DFh, 0DFh, 0DFh, 0DFh, 0DBh, '$'
	dos2 db 20h, 20h, 20h, 20h, 0DBh, '$'
	dos3 db 0DBh, 0DFh, 0DFh, 0DFh, 0DFh, '$'
	dos4 db 0DBh,20h, 20h, 20h, 20h, '$'
	dos5 db 0DBh, 0DCh, 0DCh, 0DCh, 0DCh, '$'

	tres1 db 0DFh, 0DFh, 0DFh, 0DFh, 0DBh, '$'
	tres2 db 20h, 20h, 20h, 20h, 0DBh, '$'
	tres3 db 20h, 0DFh, 0DFh, 0DFh, 0DBh, '$'
	tres4 db 20h, 20h, 20h, 20h, 0DBh, '$'
	tres5 db 0DCh, 0DCh, 0DCh, 0DCh, 0DBh, '$'

	cuatro1 db 0DBh, 20h, 20h, 20h, 0DBh, '$'
	cuatro2 db 0DBh, 20h, 20h, 20h, 0DBh, '$'
	cuatro3 db 0DFh, 0DFh, 0DFh, 0DFh, 0DBh, '$'
	cuatro4 db 20h, 20h, 20h, 20h, 0DBh, '$'
	cuatro5 db 20h, 20h, 20h, 20h, 0DBh, '$'

	cinco1 db 0DBh, 0DFh, 0DFh, 0DFh, 0DFh, '$'
	cinco2 db 0DBh, 20h, 20h, 20h, 20h, '$'
	cinco3 db 0DFh, 0DFh, 0DFh, 0DFh, 0DBh, '$'
	cinco4 db 20h, 20h, 20h, 20h, 0DBh,'$'
	cinco5 db 0DCh, 0DCh, 0DCh, 0DCh, 0DBh, '$'

	seis1 db 0DBh, 0DFh, 0DFh, 0DFh, 0DFh, '$'
	seis2 db 0DBh, 20h, 20h, 20h, 20h, '$'
	seis3 db 0DBh, 0DFh, 0DFh, 0DFh, 0DBh, '$'
	seis4 db 0DBh, 20h, 20h, 20h, 0DBh,'$'
	seis5 db 0DBh, 0DCh, 0DCh, 0DCh, 0DBh, '$'

	siete1 db 0DFh, 0DFh, 0DFh, 0DFh, 0DBh, '$'
	siete2 db 20h, 20h, 20h, 20h, 0DBh, '$'
	siete3 db 20h, 20h, 20h, 20h, 0DBh, '$'
	siete4 db 20h, 20h, 20h, 20h, 0DBh, '$'
	siete5 db 20h, 20h, 20h, 20h, 0DBh, '$'

	ocho1 db 0DBh, 0DFh, 0DFh, 0DFh, 0DBh, '$'
	ocho2 db 0DBh, 20h, 20h, 20h, 0DBh, '$'
	ocho3 db 0DBh, 0DFh, 0DFh, 0DFh, 0DBh, '$'
	ocho4 db 0DBh, 20h, 20h, 20h, 0DBh,'$'
	ocho5 db 0DBh, 0DCh, 0DCh, 0DCh, 0DBh, '$'

	nueve1 db 0DBh, 0DFh, 0DFh, 0DFh, 0DBh, '$'
	nueve2 db 0DBh, 20h, 20h, 20h, 0DBh, '$'
	nueve3 db 0DFh, 0DFh, 0DFh, 0DFh, 0DBh, '$'
	nueve4 db 20h, 20h, 20h, 20h, 0DBh,'$'
	nueve5 db 20h, 20h, 20h, 20h, 0DBh, '$'

	cero1 db 0DBh, 0DFh, 0DFh, 0DFh, 0DBh, '$'
	cero2 db 0DBh, 20h, 20h, 20h, 0DBh, '$'
	cero3 db 0DBh, 20h, 20h, 20h, 0DBh, '$'
	cero4 db 0DBh, 20h, 20h, 20h, 0DBh,'$'
	cero5 db 0DBh, 0DCh, 0DCh, 0DCh, 0DBh, '$'
	
	borrarlineascore db 20h, 20h, 20h, 20h, 20h, '$'

 .code
 
 PUBLIC ShowScore
 PUBLIC EraseScore
;extrn ESPERA:proc

;------------------------------------------------------------------------------------------------------------------------------------------------------------------
; Función SHOWSCORE - Muestra los scores de los dos jugadores en pantalla.
;		Recibe: 		AH socre del jugador 1 en hexa
;							AL socre del jugador 2 en hexa
;		Devuelve: 	Nada
;------------------------------------------------------------------------------------------------------------------------------------------------------------------
ShowScore proc
	push ax
	push bx
	push cx
	push dx
	
	mov scorejugador1, ah ; Guardo parámetros de score de cada jugador recibidos por AX: AH jugador 1, AL jugador 2
	mov scorejugador2, al
	
	mov ax, JUG1 ; Paso parámetro de posición del cartel de score del Jugador 1
	mov bl, scorejugador1
	call mostrarscore
	
	mov ax, JUG2 ; Paso parámetro de posición del cartel de score del Jugador 1
	mov bl, scorejugador2
	call mostrarscore
	
	;mov ah, DELAYBORRADO ; Establezco en Ah el parametro de delay en segundos 
	;call espera
	
	;call borrarscore ; Borro los marcadores de score
	
	pop dx
	pop cx
	pop bx
	pop ax
	ret
ShowScore endp

;-------------------------------------------------------------------------------------------------------------------------------------------------
; Función MOSTRARSCORE - 	Muestra el score de un jugador. El marcador es de dos dígitos. Si el score a
;												mostrar es menor a 10 muestra un solo dígito de la forma X, no dos de la forma 0X
;		Recibe: AX = fila-columna superior izquierdo del marcador
;		Devuelve: Nada
;-------------------------------------------------------------------------------------------------------------------------------------------------
mostrarscore proc
	mov cursor, ax ; Guardo el parámetro del cursor
	
	; Se muestra el dígito más significativo del score
	cmp bl, 09h
	jle digitomenor ; El score es menor o igual a 9 es de un solo dígito. No muestro dos dígitos
	
	xor ax, ax
	mov al, bl
	mov cl, 0Ah ; Como es mayor a nueve, lo divido por 10 y tomo el resto
	div cl
	mov bl, al ; El cociente lo paso como parámetro BL ya que es el dígito más significativo

	push ax ; Guardo el AX porque tengo el cociente de la división que me servirá para mostrar después
	call muestrodigito 	; Llamo al mostrador de dígitos en pantalla teniendo en cuenta que el cursos está posicionado en el
									; borde superior izquierdo de su presentación
	pop ax ; Restauro el AX para tratar el otro dígito
	
	mov bl, ah ; Paso ahora el resto al parámetro BL que es el dígito menos significativo
	
digitomenor:
	add cursor, DISTCIFRAS 	; Agrego 7 al cursor para que apunte al borde superior izquierdo del dígito menos significativo, 
								; o sea, lo corro 7 columnas a la derecha
	call muestrodigito ; se muestra el otro dígito
	
	ret
mostrarscore endp
;-------------------------------------------------------------------------------------------------------------------------------------------------
; Función MUESTRODIGITO - Muestra un dígito del score en pantalla en función de la variable cursor
;		Recibe: AX = fila-columna superior izquierdo del digito del marcador
;		Devuelve: Nada
;-------------------------------------------------------------------------------------------------------------------------------------------------
muestrodigito proc
	mov ax, cursor
	mov punterocursor, ax ; Guardo el parámetro del cursor
	
	mov cx, 2607h
	mov ah, 01h
	int 10h ; cursor invisible

	cmp bl, 00h ; tipeó "1"
	jne noescero ; No es el cero, sigo
	mov punteronumero, offset cero1 ; Es el cero, cargo la variable punteronumero con el offset de los ASCIIs del uno
	jmp seguir

noescero:
	cmp bl, 01h
	jne noesuno
	mov punteronumero, offset uno1
	jmp seguir

noesuno:
	cmp bl, 02h
	jne noesdos
	mov punteronumero, offset dos1
	jmp seguir
	
noesdos:
	cmp bl, 03h
	jne noestres
	mov punteronumero, offset tres1
	jmp seguir
	
noestres:
	cmp bl, 04h
	jne noescuatro
	mov punteronumero, offset cuatro1
	jmp seguir
	
noescuatro:
	cmp bl, 05
	jne noescinco
	mov punteronumero, offset cinco1
	jmp seguir

noescinco:
	cmp bl, 06h
	jne noesseis
	mov punteronumero, offset seis1
	jmp seguir
	
noesseis:
	cmp bl, 07h
	jne noessiete
	mov punteronumero, offset siete1
	jmp seguir

noessiete:
	cmp bl, 08h
	jne noesocho
	mov punteronumero, offset ocho1
	jmp seguir

noesocho: ; es nuevie
	mov punteronumero, offset nueve1

seguir:
	mov cx, 05h ; variable del LOOP para las 5 líneas de caracteres por número
	xor bx, bx
imprimolineanumero:
	mov dx, punterocursor ; traigo a DX el lugar del cursor
	mov ah, 02h
	int 10h ; posiciono el cursor

	add dx, 100h ; Al sumas 100h estoy cambiando de fila, una más abajo
	mov punterocursor, dx ; actualizo cursor para la próxima línea
	mov dx, punteronumero ; traigo a DX el puntero del núemero a imprimir
	mov ah, 09H
	int 21H	

	add dx, 06h ; al agregar 6 salto a la segunda línea de caracteres del número. Cada número tiene 5 caracteres ascii más es pesos son 6
	mov punteronumero, dx
	loop imprimolineanumero ; loopeo hasta imprimir las cinco líneas de cada número

	ret
muestrodigito endp

;------------------------------------------------------------------------------------------------------------------------------------------------------------------
; Función ERASESCORE - Borra las zonas donde se imprimen los scores
;		Recibe: 		Parametros de contadores de score a través de variables JUG1 y JUG2
;		Devuelve: 	Nada
;------------------------------------------------------------------------------------------------------------------------------------------------------------------
EraseScore proc
	mov punterocursor, JUG1 ; Guardo el parámetro del cursor
	call borrardigito
	mov punterocursor, JUG1 + DISTCIFRAS; Guardo el parámetro del cursor
	call borrardigito
	mov punterocursor, JUG2 ; Guardo el parámetro del cursor
	call borrardigito
	mov punterocursor, JUG2 + DISTCIFRAS ; Guardo el parámetro del cursor
	call borrardigito
	ret
EraseScore endp

;------------------------------------------------------------------------------------------------------------------------------------------------------------------
; Función BORRARDIGITO - Borra un dígito del score
;		Recibe: 		Parametros de contadores de score a través de variable punterocursor
;		Devuelve: 	Nada
;------------------------------------------------------------------------------------------------------------------------------------------------------------------BORRARDIGITO proc
BORRARDIGITO proc
	mov cx, 05h ; variable del LOOP para las 5 líneas de caracteres por número
	xor bx, bx
borrolineanumero:
	mov dx, punterocursor ; traigo a DX el lugar del cursor
	mov ah, 02h
	int 10h ; posiciono el cursor

	add dx, 100h ; Al sumas 100h estoy cambiando de fila, una más abajo
	mov punterocursor, dx ; actualizo cursor para la próxima línea
	lea dx, borrarlineascore ; traigo a DX el puntero del núemero a imprimir
	mov ah, 09H
	int 21H	

	loop borrolineanumero ; loopeo hasta imprimir las cinco líneas de cada número

	ret
BORRARDIGITO endp
;------------------------------------------------------------------------------------------------------------------------------------------------------------------
end