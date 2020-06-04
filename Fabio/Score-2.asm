.8086
.model small
.stack 100h
.data
	pos1 EQU 021Ch
	pos2 EQU 0224h

	mensaje db "Ingrese un numero 0 a 9 o <Enter> para salir: ", '$'

	scorejugador1 db 20h, 20h
	scorejugador2 db 20h, 20h
	
	cursor	dw 00h, 00h
	punteronumero dw 00h, 00h

	uno1 db 20h, 20h, 20h, 0DFh, 0DBh, '$'
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

 .code
main proc
	mov ax,@data
	mov ds,ax
	
	call CLS ; limpiar pantalla
	
	mov ah, 00h
	mov al, 03h
	int 10h ; modo 80x25 texto

	lea dx, mensaje
	mov ah, 9
	int 21h
	
otro:
	mov ah, 08H ; Leo caracter de teclado
	int 21H 
	
	call CLS ; limpiar pantalla

	mov cx, 2607h
	mov ah,01h
	int 10h ; cursor invisible

	cmp al,0Dh ; <Enter>, termina
	je sigo4 ; salta a "sigo4" porque "final" queda FAR

	cmp al, 31h ; tipeó "1"
	jne sigo0
	mov punteronumero, offset uno1 ; cargo la variable punteronumero con el offset de los ASCIIs del uno
	jmp seguir
sigo0:
	cmp al, 32h
	jne sigo1
	mov punteronumero, offset dos1 ; lo mismo pero con el dos
	jmp seguir
sigo1:
	cmp al, 33h
	jne sigo2
	mov punteronumero, offset tres1
	jmp seguir
sigo2:
	cmp al, 34h
	jne sigo3
	mov punteronumero, offset cuatro1
	jmp seguir
sigo3:
	cmp al, 35h
	jne sigo4
	mov punteronumero, offset cinco1
	jmp seguir
sigo4:
	cmp al, 36h
	jne sigo5
	mov punteronumero, offset seis1
	jmp seguir
sigo5:
	cmp al, 37h
	jne sigo6
	mov punteronumero, offset siete1
	jmp seguir
sigo6:
	cmp al, 38h
	jne sigo7
	mov punteronumero, offset ocho1
	jmp seguir
sigo7:
	cmp al, 39h
	jne sigo8
	mov punteronumero, offset nueve1
	jmp seguir
sigo8:
	cmp al, 30h
	jne final
	mov punteronumero, offset cero1

seguir:
	mov cx, 05h ; variable del LOOP para las 5 líneas de caracteres por número
	mov dx, pos1 ; guardo en DX el valor de POS1 que tiene la fila-columna de la posición superior izquierda del primer nro del score
	mov cursor, dx ; cargo ese valor en la variable cursor
again:
	mov dx, cursor ; traigo a DX el lugar del cursor
	mov ah, 02h
	int 10h ; posiciono el cursor
	add dx, 100h ; Al sumas 100h estoy cambiando de fila, una más abajo
	mov cursor, dx ; actualizo cursor para la próxima línea
	
	mov dx, punteronumero ; traigo a DX el puntero del núemero a imprimir
	mov ah, 09H
	int 21H
	
	Add dx, 06h ; al agregar 6 salto a la segunda línea de caracteres del número. Cada número tiene 5 caracteres ascii más es pesos son 6
	mov punteronumero, dx
	loop again ; loopeo hasta imprimir las cinco líneas de cada número
	jmp otro ; espero teclee otro número o <Enter>

final:
	mov cx, 0607h
	mov ah, 1
	int 10h ; hago visible nuevamente el cursor
	
    mov ah,4ch
    int 21H
main endp


CLS proc ; limpiar la pantalla como el CLS desde el prompt del DOS
	push ax
	push es
	push cx
	push di
	mov ax,3
	int 10h
	mov ax,0b800h
	mov es,ax
	mov cx,1000
	mov ax,7
	mov di,ax
	cld
	rep stosw
	pop di
	pop cx
	pop es
	pop ax
	ret 
CLS endp

end main