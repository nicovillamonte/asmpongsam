.8086
.model small 
.stack 100h
.data 

.code
public SetTimC
main proc
		;No hace nada
main endp

SetTimC proc
;Setea el contador por cantidad de clocks.
;Recibe dos push. El primero es la parte alta del contador y el segundo la parte baja.
;Asegurarse antes de hacer el push que el registro usado para el mismo este limpio. 
;Recuerde que cada segundo son aprox. 18.2 pulsos de clock.
;
	;Guardo en la pila los registros que necesito para el poceso.
	push bp 
	mov bp, sp 
	pushf 
	push ax
	push cx
	push dx
	;Limpio los registros que voy a usar para asegurarme que no queden residuos.
	xor ax, ax
	xor cx, cx
	xor dx, dx

	;Pongo en ah la funcion que voy a usar de la int 1Ah
	mov ah, 01h
	;Pusheo desde la pila los valores pasado, en cx y dx la parte alta y baja del contador respectivamente.
	mov cx, ss:[bp+6]
	mov dx, ss:[bp+4]
	int 1Ah

	;Devuelvo los valores de los registros y limpio la pila.
	pop dx
	pop cx
	pop ax
	popf
	pop bp
	ret 4
SetTimC endp
end main 
