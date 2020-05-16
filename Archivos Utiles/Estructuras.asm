.8086
.model small
.stack 100h
.data
  msg db "Nombre: ",24h           ;Vector msg
  msg2 db "Edad: ",24h            ;Vector msg2

Datos STRUC                       ;Estructura "Datos"
  Nombre db 32 dup(?),24h           ;Nombre
  Edad   db 3 dup(00h),24h          ;Edad
ENDS                              ;End Structure

  Cliente1 Datos <>                  ;Objeto "Cliente" de la estructura "Datos"
  Cliente2 Datos <"Pedro$","32$">    ;Objeto "Cliente2" de la estructura "Datos"

.code
main proc
  MOV AX,@DATA                    ;Movemos el Offset de DATA al Data Segment
  MOV DS,AX

  MOV AH,09h                      ;Imprimir el vector msg
  MOV DX,OFFSET msg
  INT 21h

  MOV CX,020h                     ;Dar un limite de 20h caracteres
  MOV SI,00h
  LEERNOMBRE:                     ;Caja de lectura para el nombre
    MOV AH,01h                    ;Esperamos el ingreso
    INT 21h
    CMP AL,0Dh                    ;Si es enter terminamos ingreso
    JE TERMINARINGRESO
    MOV Cliente1.Nombre[SI],AL     ;Guardamos el caracter en la posicion SI del vctor nomrbe del objeto cliente
    INC SI
    LOOP LEERNOMBRE

  TERMINARINGRESO:                ;Termina el ingreso y aniadimos el 24h para su correcta impresion
  INC SI
  MOV Cliente1.Nombre[SI],24h

  MOV AH,09h                      ;Imprimir el vector msg2
  MOV DX,OFFSET msg2
  INT 21h

  LEEREDAD:                       ;Caja de lectura para la edad
  MOV CX,02h
  MOV SI,00h
  LOP2:
    MOV AH,01h                    ;Esperamos el ingreso
    INT 21h
    MOV Cliente1.Edad[SI],AL       ;Guardamos el caracter en la posicion SI del vctor nomrbe del objeto cliente
    INC SI
    LOOP LOP2
    MOV Cliente1.Edad[SI],24h      ;Termina el ingreso y aniadimos el 24h para su correcta impresion

  call saltarLinea                ;Realizamos saltos de linea
  call saltarLinea

  MOV AH,09h                      ;imprimir el nombre del cliente 1
  MOV DX,OFFSET Cliente1.Nombre
  INT 21h

  call saltarLinea                ;imprimir el nombre del cliente 2
  MOV DX,OFFSET Cliente2.Nombre
  INT 21h

  call saltarLinea
  call saltarLinea                ;imprimir la edad del cliente 1
  MOV DX,OFFSET Cliente1.Edad
  INT 21h

  call saltarLinea                ;imprimir la edad del cliente 2
  MOV DX,OFFSET Cliente2.Edad
  INT 21h

  MOV AX,4C00h                    ;Terminar el programa
  INT 21h
main endp


;--------------------------------OTROS-----------------------------------------

saltarLinea proc
  push ax
  push dx
    MOV AH,02h
    MOV DL,0Dh
    INT 21h
    MOV DL,0Ah
    INT 21h
  pop dx
  pop ax
  ret
saltarLinea endp
end main