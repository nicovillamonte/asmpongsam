.8086
.model small
.stack 100h
.data
    MSG DB "Hola mundo",24h
    COLOR DB 0Ah
.code

dibLin proc
    ;obtiene en AX-BX (X-Y) desde que punto y en CX-DX hasta que punto
    CMP AX,CX
    JE  DL_LINEAVERTICAL
    CMP BX,DX
    JE  DL_LINEAHORIZONTAL
    JMP TODAVIANADA
    
    DL_LINEAVERTICAL:
        PUSH DX
        MOV AH,0Ch
        MOV AL,COLOR
        MOV DX,BX
        INT 10h
        POP DX
        INC BX
        CMP BX,DX
        JG  DL_FIN
        JMP DL_LINEAVERTICAL

    DL_LINEAHORIZONTAL:
        PUSH CX
        PUSH AX
        MOV CX,AX
        MOV AH,0CH
        MOV AL,COLOR
        
        INT 10h
        POP AX
        INC AX
        POP CX
        CMP AX,CX
        JG  DL_FIN
        JMP DL_LINEAHORIZONTAL

    TODAVIANADA:
    DL_FIN:
    RET
dibLin endp

main proc
    MOV AX,@data
    MOV DS,AX

    ;CAMBIAR MODO DE VIDEO
    MOV AH,00h
    MOV AL,12h
    INT 10h


    ;dIBUJAR LINEA VERTICAL
    MOV AX,100d
    MOV BX,002d
    MOV CX,100d
    MOV DX,100d
    CALL dibLin

    ;dIBUJAR LINEA HORIZONTAL
    MOV AX,100d
    MOV BX,050d
    MOV CX,200d
    MOV DX,050d
    CALL dibLin

    mov ah,08h
    int 21h

    MOV AX,4C00h
    INT 21h
main endp
end main