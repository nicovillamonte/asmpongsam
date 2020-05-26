.8086
.model small
.stack 100h
INCLUDE SC.inc
PUERTO_TECLADO      EQU     60h
.data

.code
PUBLIC getScanCode
PUBLIC SCtoASCII

main proc
    ;NADA
main endp

;-----------------------------------------------------------------

getScanCode proc
    ;En esta funcion devolvemos el scancode del teclado
    ;mediante el puerto 60h de la interfaz de E/S
    ;y lo ingresamos en el registro AL
    push CX

    mov CX, 3
    SC_lop:
    in AL, PUERTO_TECLADO        ;Ingresamos en AL el scancode del puerto 60h
    jmp short $+2                ;le damos tiempo a la operacion
    loop SC_lop                  ;Lo realizamos 3 veces para disminuir errores

    pop CX
    ret
getScanCode endp

;-----------------------------------------------------------------

SCtoASCII proc
    ;Realizamos la conversion de SCANCODE a ASCII
    ;En AL se devuelve el valor de ASCII si el modo en AH no es 2 y no es tecla especial
    ;      se devuelve el valor de SCANCODE nuevamente si es una tecla especial o el modo en AH se encuentra en 2
    ;En AH se devuelve 0 si la tecla esta presioniada
    ;      se devuelve 1 si la tecla esta soltada
    ;      se devuelve 2 si la tecla es una tecla especial (Excepto si ya esta en 2 cuando entra)

    ;Vemos si esta en el modo 2
    CMP AH,02h
    JNE StoA_NO_MODO2       ;Si no es el modo 2 seguir con el programa
    CALL SCtoASCIImodo2
    RET

    StoA_NO_MODO2:
    CMP AL,00h
    JL  StoA_SOLTADA
    ;PRESIONADA
    MOV AH,00h
    JMP StoA_GO_SWITCH
    StoA_SOLTADA:
    ;SOLTADA
    MOV AH,01h
    SUB AL,80h

    StoA_GO_SWITCH:
    CALL switchConvert
    ;En AL queda el valor ASCII convertido

    RET
SCtoASCII endp

SCtoASCIImodo2 proc
    ;MODO 2
    CMP AL,00h
    JL  MODO2_MAY80
        ;ESTA PRESIONADA
        MOV AH,00h
        JMP MODO2_FIN
    MODO2_MAY80:
        ;ESTA SOLTADA
        MOV AH,01h
        SUB AL,80h

    MODO2_FIN:
    RET
SCtoASCIImodo2 endp

switchConvert proc
    
;-------------LETRAS---------------------------------------
    CMP AL,SC_A
    JNE C1
        ;PROGRAMA
        MOV AL,61h
        RET
C1: CMP AL,SC_B
    JNE C2
        ;PROGRAMA
        MOV AL,62h
        RET
C2: CMP AL,SC_C
    JNE C3
        ;PROGRAMA
        MOV AL,63h
        RET
C3: CMP AL,SC_D
    JNE C4
        ;PROGRAMA
        MOV AL,64h
        RET
C4: CMP AL,SC_E
    JNE C5
        ;PROGRAMA
        MOV AL,65h
        RET
C5: CMP AL,SC_F
    JNE C6
        ;PROGRAMA
        MOV AL,66h
        RET
C6: CMP AL,SC_G
    JNE C7
        ;PROGRAMA
        MOV AL,67h
        RET
C7: CMP AL,SC_H
    JNE C8
        ;PROGRAMA
        MOV AL,68h
        RET
C8: CMP AL,SC_I
    JNE C9
        ;PROGRAMA
        MOV AL,69h
        RET
C9: CMP AL,SC_J
    JNE D1
        ;PROGRAMA
        MOV AL,6Ah
        RET
D1: CMP AL,SC_K
    JNE D2
        ;PROGRAMA
        MOV AL,6Bh
        RET
D2: CMP AL,SC_L
    JNE D3
        ;PROGRAMA
        MOV AL,6Ch
        RET
D3: CMP AL,SC_M
    JNE D4
        ;PROGRAMA
        MOV AL,6Dh
        RET
D4: CMP AL,SC_N
    JNE D5
        ;PROGRAMA
        MOV AL,6Eh
        RET
D5: CMP AL,SC_O
    JNE D6
        ;PROGRAMA
        MOV AL,6Fh
        RET
D6: CMP AL,SC_P
    JNE D7
        ;PROGRAMA
        MOV AL,70h
        RET
D7: CMP AL,SC_Q
    JNE D8
        ;PROGRAMA
        MOV AL,71h
        RET
D8: CMP AL,SC_R
    JNE D9
        ;PROGRAMA
        MOV AL,72h
        RET
D9: CMP AL,SC_S
    JNE E1
        ;PROGRAMA
        MOV AL,73h
        RET
E1: CMP AL,SC_T
    JNE E2
        ;PROGRAMA
        MOV AL,74h
        RET
E2: CMP AL,SC_U
    JNE E3
        ;PROGRAMA
        MOV AL,75h
        RET
E3: CMP AL,SC_V
    JNE E4
        ;PROGRAMA
        MOV AL,76h
        RET
E4: CMP AL,SC_W
    JNE E5
        ;PROGRAMA
        MOV AL,77h
        RET
E5: CMP AL,SC_X
    JNE E6
        ;PROGRAMA
        MOV AL,78h
        RET
E6: CMP AL,SC_Y
    JNE E7
        ;PROGRAMA
        MOV AL,79h
        RET
E7: CMP AL,SC_Z
    JNE E8
        ;PROGRAMA
        MOV AL,7Ah
        RET

;-------------NUMERO---------------------------------------
E8: CMP AL,SC_0
    JNE E9
        ;PROGRAMA
        MOV AL,30h
        RET
E9: CMP AL,SC_1
    JNE F1
        ;PROGRAMA
        MOV AL,31h
        RET
F1: CMP AL,SC_2
    JNE F2
        ;PROGRAMA
        MOV AL,32h
        RET
F2: CMP AL,SC_3
    JNE F3
        ;PROGRAMA
        MOV AL,33h
        RET
F3: CMP AL,SC_4
    JNE F4
        ;PROGRAMA
        MOV AL,34h
        RET
F4: CMP AL,SC_5
    JNE F5
        ;PROGRAMA
        MOV AL,35h
        RET
F5: CMP AL,SC_6
    JNE F6
        ;PROGRAMA
        MOV AL,36h
        RET
F6: CMP AL,SC_7
    JNE F7
        ;PROGRAMA
        MOV AL,37h
        RET
F7: CMP AL,SC_8
    JNE F8
        ;PROGRAMA
        MOV AL,38h
        RET
F8: CMP AL,SC_9
    JNE F9
        ;PROGRAMA
        MOV AL,39h
        RET

;-------------ESPECIALES---------------------------------------
F9: CMP AL,SC_ESC               ;NO SPECIAL
    JNE G1
        ;PROGRAMA
        MOV AL,1Bh
        RET
G1: CMP AL,SC_ENTER             ;NO SPECIAL
    JNE G2
        ;PROGRAMA
        MOV AL,0Dh
        RET
G2: CMP AL,SC_LSHIFT
    JNE G3
        ;PROGRAMA
        JMP StoA_COMPESPECIAL
G3: CMP AL,SC_RSHIFT
    JNE G4
        ;PROGRAMA
        JMP StoA_COMPESPECIAL
G4: CMP AL,SC_CTRL
    JNE G5
        ;PROGRAMA
        JMP StoA_COMPESPECIAL
G5: CMP AL,SC_ALT
    JNE G6
        ;PROGRAMA
        JMP StoA_COMPESPECIAL
G6: CMP AL,SC_SPACE             ;NO SPECIAL
    JNE G7
        ;PROGRAMA
        MOV AL,20h
        RET
G7: CMP AL,SC_HOME
    JNE G8
        ;PROGRAMA
        JMP StoA_COMPESPECIAL
G8: CMP AL,SC_END
    JNE G9
        ;PROGRAMA
        JMP StoA_COMPESPECIAL
G9: CMP AL,SC_DEL
    JNE H1
        ;PROGRAMA
        JMP StoA_COMPESPECIAL
H1: CMP AL,SC_PGUP
    JNE H2
        ;PROGRAMA
        JMP StoA_COMPESPECIAL
H2: CMP AL,SC_PGDN
    JNE H3
        ;PROGRAMA
        JMP StoA_COMPESPECIAL
H3: CMP AL,SC_BS                ;NO SPECIAL
    JNE ERROR
        ;PROGRAMA
        MOV AL,08h
        RET

StoA_COMPESPECIAL:
    CMP AH,01h
    MOV AH,02h
    JNE StoA_FIN
    ADD AL,80h
    JMP StoA_FIN

ERROR:
    MOV AX,0FFFFh

    StoA_FIN:
    RET
switchConvert endp

;-----------------------------------------------------------------
end main