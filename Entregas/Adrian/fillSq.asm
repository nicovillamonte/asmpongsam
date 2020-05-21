.8086
.model small
.stack 100h
.data 
 
.code
public fillSq
extrn setCoord:proc
extrn Draw:proc
main proc
		; No hace nada. 
main endp 

fillSq proc
;Sobreescribe dos valores ASCII correspondiente a (x1,y1) y (x2,y2).
;Recibe las coordenadas (x1,y1), (x2,y2).
;Las coord x e y o el valor ASCII, no pueden ser de mas de 8 bits de longitud
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
        ;Push di

        mov ax, ss:[bp+4]

        ;Muevo a DX las coord (x1,y1)
        mov cx, ss:[bp+12]
        mov dx, ss:[bp+10]
        mov dh, cl 

        ;Reescribo el valor ASCII en al en las coord (x1,y1)
        call setCoord

        ;Muevo a DX las coord (x2,y2)
        mov cx, ss:[bp+8]
        mov dx, ss:[bp+6]
        mov dh, cl

        ;Reescribo el valor ASCII en las coord (x2,y2)
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
        ret 10   
fillSq endp 
end main 