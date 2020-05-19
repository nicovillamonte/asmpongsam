;   ESTE PROGRAMA SE ENCARGA DE DEVOLVER EL SCANCODE DE LA ULTIMA
;ACCION REALIZADA POR EL TECLADO, ASI SEA LA PRESION DE UNA TECLA
;O LA ULTIMA TECLA QUE SE HA DEJADO DE PULSAR.
;   PARA ESTO, LE DA UN TIEMPITO MUY CORTO AL USUARIO, EL CUAL
;LE PERMITIRA MANTENER PRESIONADA UNA TECLA HASTA QUE SE TERMINE
;EL TIEMPO DE ESPERA O PRESIONAR Y DEJAR DE PRESIONAR UNA TECLA
;PARA LUEGO DE LA ESPERA RECIBIR EL SCANCODE.
.8086
.model small
.stack 100h
.data
    msg db "El programa te da un tiempo corto para mantener presionada o dejar de presionar una tecla para obtener el Scancode"
        db 0Dh,0Ah,"ScanCode en Hexa: ",24h
    VEC DB 00H,00H,24H
.code
main proc
    MOV AX,@DATA
    MOV DS,AX

    MOV AX,03h
    INT 10h

    mov ah,09h
    mov dx,offset msg
    int 21h

    CALL TIMRST

    MOV CX,02h
    SEGUIR:
        IN AL,60h           ;Leo el SCAN CODE de la tecla presionada desde el puerto 60h
        JMP SHORT $+2       ;Le damos tiempo a la operacion de entrada
        CALL TIMER          ;Revisamos el tiempo
        CMP DX,022h         ;Tiempo q nos da para presionar la tecla
        JGE CONTAR
        INC CX
        LOOP SEGUIR
        CONTAR:
        LOOP SEGUIR

    MOV DI,OFFSET VEC
    CALL PASARAHEX

    IMPRIMIR:
        MOV AH,09h
        MOV DX,offset VEC
        INT 21h
        ;JMP LOP


    MOV AX,4C00h
    INT 21h
main endp


PASARAHEX proc
    ;Dejar offset del vector donde guardar el resultado en DI
    ;Dejar en AL lo que se quiere pasar a hex

    MOV AH,00h
    MOV DL,16d
    DIV DL
    CMP AL,0Ah
    JNL NOSUMAR30
    ADD AL,30h
    MOV BYTE PTR [DI+00h],AL
    JMP SEGUIRPARTE2
    NOSUMAR30:
    ADD AL,37h
    MOV BYTE PTR [DI+00h],AL

    SEGUIRPARTE2:
    CMP AH,0Ah
    JNL NOSUMAR30DOS
    ADD AH,30h
    MOV BYTE PTR [DI+01h],AH
    JMP FINPASARHEX
    NOSUMAR30DOS:
    ADD AH,37h
    MOV BYTE PTR [DI+01h],AH
    
    FINPASARHEX:
    RET
PASARAHEX endp

TIMRST proc
    PUSH AX
    PUSH CX
    PUSH DX

    MOV AH,01h
    MOV CX,00h
    MOV DX,00h
    INT 1Ah

    POP DX
    POP CX
    POP AX
    RET
TIMRST endp

TIMER proc
;LA LLAMAMOS Y NOS DEVUELVE EL TIEMPO EN DX Y (CX), EN AL DEVUELVE SI PASARON 24 HORAS
    PUSH AX
    PUSH CX

    MOV AH,00h
    INT 1Ah

    POP CX
    POP AX
    RET
TIMER endp
end main