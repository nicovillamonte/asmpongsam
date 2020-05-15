Ideas de Adrian:
; dibuja p
.8086
.model small
.stack 100h
.data

.code
main proc
.startup
        mov ax, @data
        mov ds, ax

        mov ax, 0012h
        int 10h

        ; Pinta un pixel.
        mov ah,0ch 
        mov al,0ah

        mov cx, 60d
        mov dx, 40d
        int 10h

        ; imprimo P
puntos: 
        inc cx
        cmp cx, 120d
        je devuelta
        int 10h
        jmp puntos

devuelta: 
        mov cx, 60d
        inc dx
        cmp dx, 60d
        je segundo
        jmp puntos

segundo: 
        mov cx, 60d
        mov dx, 60d
        int 10h


puntos2: 
        inc cx
        cmp cx, 80d
        je devuelta2
        int 10h
        jmp puntos2

 
devuelta2:           
         mov cx, 60d
         inc dx
         cmp dx, 150d
         je tercero
         jmp puntos2
 
tercero: 
        mov cx, 100d
        mov dx, 60d 
        int 10h

puntos3: 
        inc cx
        cmp cx, 120d
        je devuelta3
        int 10h
        jmp puntos3

devuelta3: 
        mov cx, 100d
        inc dx
        cmp dx, 90d
        je cuarto
        jmp puntos3

cuarto: 
        mov cx, 80d
        mov dx, 90d 
        int 10h

puntos4: 
        inc cx
        cmp cx, 120d
        je devuelta4
        int 10h
        jmp puntos4

devuelta4: 
        mov cx, 80d
        inc dx
        cmp dx, 110d
        je fin
        jmp puntos4

fin:
.exit
main endp
end main 
