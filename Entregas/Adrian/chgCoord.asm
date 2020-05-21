.8086
.model small
.stack 100h
.data 
 
.code
public chgCoord
extrn getCoord:proc
extrn setCoord:proc
extrn Draw:proc
main proc
		; No hace nada.
main endp 

chgCoord proc
;Intercambia dos valores ASCII.
;Recibe las coordenadas (x1,y1), (x2,y2).
;Las coord x o y no pueden ser de mas de 8 bits de longitud
;Deben pushearse de tal forma, que al extraerlas del stack
;queden en la parte baja del registro.
        push bp 
        mov bp, sp
        Pushf
        Push ax
        ;Push bx
        Push cx
        Push dx
        ;Push si
        
        ;Pongo coord(x1, y1) en DX.
        mov cx, ss:[bp+10]
        mov dx, ss:[bp+8]
        mov dh, cl
        ;Busco valor ASCII en coord (x1,y1).
        call getCoord

        ;Muevo a DX las coord (x2,y2).
        mov cx, ss:[bp+6]
        mov dx, ss:[bp+4]
        mov dh, cl

        ;Guardo en ah el valor ASCII de las coord(x1,y1)
   		mov ah, al

   		;Busco valor ASCII de las coord (x2,y2)    
   		call getCoord

   		;Pongo coord(x1, y1) en DX.
        mov cx, ss:[bp+10]
        mov dx, ss:[bp+8]
        mov dh, cl

        ;Muevo valor ASCII de las coord(x2,y2) a (x1,y1).
        call setCoord

        ;Muevo valor ASCII (x1,y1) que esta en ah a al.
        mov al, ah

        ;Muevo a DX las coord (x2,y2).
        mov cx, ss:[bp+6]
        mov dx, ss:[bp+4]
        mov dh, cl

        ;Muevo valor ASCII de las coord(x1,y1) a (x2,y2).
        call setCoord

        ;Refresco pantalla.
        call Draw
        
		;pop di
        ;pop si
        pop dx
        pop cx
        ;pop bx
        pop ax
        popf
        pop bp
        ret 8   	
chgCoord endp
end main