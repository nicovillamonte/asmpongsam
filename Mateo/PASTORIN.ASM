.8086
.model small
.stack 100h
.data
     txt db 255 dup(20h), 24h
     msg db "Ingrese un texto: ", 24h
     msg2 db "Error - La suma es de mas de 8 bits.", 0dh, 0ah, 24h
     msg3 db "Cantidad de vocales: ", 24h
     msg4 db "Cantidad de puntos: ", 24h
     msg5 db "Cantidad de comas: ", 24h
     msg6 db "Suma: ", 24h
     salto db " ", 0dh, 0ah, 24h
     voc db 2 dup (0), 24h
     pun db 2 dup (0), 24h
     com db 2 dup (0), 24h
     total db 3 dup (0), 24h
.code
     main proc
          mov ax, @data
          mov ds, ax
          mov bx, 0
          mov cx, 0
          mov ah, 09h
          mov dx, offset msg
          int 21h

Carga:
          mov ah, 01h
          int 21h
          mov txt[bx], al
          cmp al, 0dh
          je Aux1
          inc bx
          jmp Carga

Aux1:
          mov bx, 0

Comparar:
          cmp txt[bx], 41h
          je Vocal
          cmp txt[bx], 61h
          je Vocal
          cmp txt[bx], 45h
          je Vocal
          cmp txt[bx], 65h
          je Vocal
          cmp txt[bx], 49h
          je Vocal
          cmp txt[bx], 69h
          je Vocal
          cmp txt[bx], 4fh
          je Vocal
          cmp txt[bx], 6fh
          je Vocal
          cmp txt[bx], 55h
          je Vocal
          cmp txt[bx], 75h
          je Vocal
          cmp txt[bx], 0dh
          je Aux2
          inc bx
          jmp Comparar

Vocal:
          add voc[1], 1
          cmp voc[1], 10
          je VocDec
          inc bx
          jmp Comparar

VocDec:
          mov voc[1], 0
          add voc[0], 1
          inc bx
          jmp Comparar

Aux2:
          mov bx, 0

Comparar2:
          cmp txt[bx], 2eh
          je Punto
          cmp txt[bx], 2ch
          je Coma
          cmp txt[bx], 0dh
          je Suma1
          inc bx
          jmp Comparar2

Punto:
          add pun[1], 1
          cmp pun[1], 10
          je PuntoDec
          inc bx
          jmp Comparar2

PuntoDec:
          mov pun[1], 0
          add pun[0], 1
          inc bx
          jmp Comparar2

Coma:
          add com[1], 1
          cmp com[1], 10
          je ComaDec
          inc bx
          jmp Comparar2

ComaDec:
          mov com[1], 0
          add com[0], 1
          inc bx
          jmp Comparar2

Suma1:
          mov al, voc[1]
          add total[2], al
          mov al, pun[1]
          add total[2], al
          mov al, com[1]
          add total[1], al
          cmp total[1], 9
          jg Totaldec
          jmp Suma2

TotalDec:
          cmp total[2], 19
          jg TotalCen2
          sub total[2], 10
          add total[1], 1
          jmp Suma1

TotalDec2:
          sub total[2], 20
          add total[1], 2
          jmp Suma2

Suma2:
          mov al, voc[0]
          add total[1], al
          mov al, pun[0]
          add total[1], al
          mov al, com[0]
          add total[1], al
          cmp total[1], 9
          jg TotalCen
          jmp Calc

TotalCen:
          cmp total[1], 19
          jg TotalCen2
          sub total[1], 10
          add total[0], 1
          jmp Calc

TotalCen2:
          sub total[1], 20
          add total[0], 2
          jmp Calc

Calc:
          cmp total[2], 2
          jl Aux3
          jg Masde8
          cmp total[1], 5
          jl Aux3
          jg Masde8
          cmp total[0], 5
          jl Aux3
          jg Masde8

Masde8:
          mov ah, 09h
          mov dx, offset msg2

Aux3:
          add voc[0], 30h
          add voc[1], 30h
          add pun[0], 30h
          add pun[1], 30h
          add com[0], 30h
          add com[1], 30h
          add total[0], 30h
          add total[1], 30h
          add total[2], 30h

Imprimir:
          mov ah, 09h
          mov dx, offset salto
          int 21h
          mov dx, offset msg3
          int 21h
          mov dx, offset voc
          int 21h
          mov dx, offset salto
          int 21h
          mov dx, offset msg4
          int 21h
          mov dx, offset pun
          int 21h
          mov dx, offset salto
          int 21h
          mov dx, offset msg5
          int 21h
          mov dx, offset com
          int 21h
          mov dx, offset salto
          int 21h
          mov dx, offset msg6
          int 21h
          mov dx, offset total
          int 21h

Fin:
          mov ax, 4c00h
          int 21h
     main endp
     end main
