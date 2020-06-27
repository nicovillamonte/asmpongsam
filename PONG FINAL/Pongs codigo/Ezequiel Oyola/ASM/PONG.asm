.8086
.model small
.stack 100h
INCLUDE STRUCS.inc          ;Incluimos las estructuras a utilizar en el pong (TIMER-PALETTE-BALL)
INCLUDE GROUND.inc              ;Incluimos la libreria GROUND para el manejo de la pantalla.
;INCLUDE TIMER.inc              ;Incluimos la libreria TIMER para el manejo del tiempo. (No puede estar incluida si se va a usar TIMER2)
INCLUDE TIMER2.inc              ;Incluimos la libreria TIMER2 para el manejo del tiempo. (No puede estar incluida si se va a usar TIMER)
INCLUDE KEYBOARD.inc            ;Incluimos la libreria KEYBOARD para el manejo del teclado.
INCLUDE PALETTE.inc             ;Incluimos la libreria PALETTE para el manejo y creación de las paletas.
INCLUDE BALL.inc                ;Incluimos la libreria BALL para el manejo y creación de la pelota.
INCLUDE SCORE.inc               ;Incluimos la libreria SCORE para el manejo de la puntuación.
INCLUDE SOUND.inc               ;Incluimos la libreria SOUND para el manejo del sonido del juego.
.data
     paleta1 PALETTE <01d, 00d, 0DEh, 03d>
     paleta2 PALETTE <78d, 22d, 0DDh, 03d>
     pelota BALL <03d, 01d, 254d>
     tim1 TIMER <>
     tim2 TIMER <>
     flagW db 1 dup (1) ;no utilizado
     flagS db 1 dup (1) ;no utilizado
     flagI db 1 dup (1) ;no utilizado
     flagK db 1 dup (1) ;no utilizado
     flagarriba db 1 dup (1)
     flagabajo db 1 dup (1)
     flagreinicioP1 db 1 dup (1) 
     flagreinicioP2 db 1 dup (1) 
     flagpaleta1 db 1 dup (1)
     flagpaleta2 db 1 dup (1)
     flagsentido db 1 dup (0)
.code
main proc
    MOV AX,@DATA
    MOV DS,AX
    
    mov di, offset paleta1
    call  initializatePalette ;inicio paleta 1
    call refreshPalette

    mov di, offset paleta2
    call  initializatePalette ;inicio paleta 2
    call refreshPalette

    mov di, offset pelota
    call  initializateBall ;inicio la pelota
    call refreshBall

    call DRAW
 ;------------------------------------------------------------------------------------------------------------------   
    call StartSound
    call StopSound ;agrego estas funciones al principio por un error en el sonido, ya que en el primer rebote de la pelota no sonaba ningun ruido

    mov ah, 0 ;puntuacion de jugador 1 inicial
    mov al, 0 ;puntuacion de jugador 2 inicial
    push ax ;guardo los valores iniciales para no modificarlos durante el ciclo
ciclo_pong:
    mov di, offset tim1
    call TimRst          ;reseteamo el tiempo cada vez que reiniciamos el ciclo
repito_pelota:
    mov ax, 0001h
    push ax
    call delayMilisec ;ese delay es para todo el ciclo
    
    mov di, offset pelota
    call getBallPos
    cmp dl, 00 ;limite superior
    jle reboto_abajoF
    cmp dl, 24 ;limite inferior
    jge reboto_arribaF
    cmp dh, 01 ;limite izquierdo 
    jle reinicioP2F_paso 
    cmp dh, 78 ;limite derecho 
    jge reinicioP1F
    cmp dh, 02 ;posicion en coordenadas X que puede tocar a la paleta1
    je reboto_paleta1F_paso
    cmp dh, 77 ;posicion en coordenadas X que puede tocar a la paleta2
    je reboto_paleta2F_paso
    jmp voy_pelota

reboto_arribaF:
    mov flagarriba, 0 ;activo la posibilidad de rebotar arriba
    mov flagabajo, 1 ;desactivo la posibilidad de rebotar abajo
    jmp sonido

reboto_abajoF: 
    mov flagabajo, 0 ;activo la posibilidad de rebotar abajo
    mov flagarriba, 1 ;desactivo la posibilidad de rebotar arriba
    jmp sonido

reinicioP2F_paso: jmp reinicioP2F

reinicioP1F:
    call StartSound ;cuando el jugador 1 hace un punto suena un ruido mas extenso
    mov ax, 0030h
    push ax
    call delayMilisec 
    call StopSound

    pop ax ;devuelvo los valores de puntuacion de ambos jugadores
    inc ah ;incremento un punto al jugador 1
    cmp ah, 99
    jg reseteo_score ;si el score supera los 99 puntos se recetea
    call ShowScore
    push ax ;guardo las puntuaciones actuales
    
    mov ax, 0001h
    push ax
    call delaySeconds ;muestro por un segundo el score
    
    mov flagreinicioP1, 0 ;reincorporo pelota en paleta1
    mov flagreinicioP2, 1 ;desactivo la posibilidad de reincorporar la pelota en paleta2
    mov flagsentido, 0 ;el sentido debe ser a la derecha de la paleta1
    jmp voy_pelota

reboto_paleta1F_paso: jmp reboto_paleta1F
reboto_paleta2F_paso: jmp reboto_paleta2F

reseteo_score:
    mov ah, 0
    mov al, 0
    push ax ;guardo el score receteado
    jmp ciclo_pong

reinicioP2F:
    call StartSound ;cuando el jugador 2 hace un punto suena un ruido mas extenso
    mov ax, 0030h
    push ax
    call delayMilisec 
    call StopSound

    pop ax ;devuelvo los valores de puntuacion de ambos jugadores
    inc al ;incremento un punto al jugador 2
    cmp al, 99
    jg reseteo_score ;si el score supera los 99 puntos se recetea
    call ShowScore
    push ax ;guardo las puntuaciones actuales
    
    mov ax, 0001h
    push ax
    call delaySeconds ;muestro por un segundo el score
    
    mov flagreinicioP2, 0 ;reincorporo pelota en paleta2
    mov flagreinicioP1, 1 ;desactivo la posibilidad de reincorporar la pelota en paleta1
    mov flagsentido, 1 ;el sentido debe ser a la izquierda de la paleta2
    jmp voy_pelota

reboto_paleta1F:
    mov flagpaleta1, 0 ;activo la posibiidad de rebotar en la paleta1
    mov flagpaleta2, 1 ;desactivo la posibilidad de rebotar en la paleta2
    mov flagsentido, 0 ;direccion de la pelota a la derecha
    jmp sonido

reboto_paleta2F: 
    mov flagpaleta2, 0 ;activo la posibiidad de rebotar en la paleta2
    mov flagpaleta1, 1 ;desactivo la posibilidad de rebotar en la paleta2
    mov flagsentido, 1 ;direccion de la pelota a la izqierda
  
sonido: ;cada vez que la pelota rebote contra algo, sonara un sonido
    call StartSound
    mov ax, 0001h
    push ax
    call delayMilisec 
    call StopSound

voy_pelota:
    mov ax, offset paleta2
    push ax ;bp+8
    mov ax, offset paleta1
    push ax ;bp+6
    mov ax, offset pelota
    push ax ;bp+4
    
    call muevo_pelota ;muevo la pelota
   
    mov flagreinicioP1, 1 ;vuelvo a poner el flag en 1 para que no se mantenga la pelota en la paleta
    mov flagreinicioP2, 1 ;vuelvo a poner el flag en 1 para que no se mantenga la pelota en la paleta
    mov flagpaleta1, 1 ;vuelvo a poner el flag en 1 para que en el caso de haber rebotado la pelota contra la paleta1, no lo haga mas
    mov flagpaleta2, 1 ;vuelvo a poner el flag en 1 para que en el caso de haber rebotado la pelota contra la paleta2, no lo haga mas

    mov di, offset tim1
    call  refreshPassedTim ;actualizo el tiempo transcurrido
    mov dx, 1
    call cmpMilisec ;veo si paso un milisegundo
    jz sigo_paletas         ;en caso de que haya pasado 1 milisegundo muevo las paletas
    jmp repito_pelota
    
sigo_paletas:
    mov ax, offset paleta1
    push ax ;bp+6
    mov ax, offset paleta2
    push ax ;bp+4
    call muevo_paletas ;muevo ambas
    jmp ciclo_pong
;------------------------------------------------------------------------------------------------------------------   

salir:
    ;PROGRAMA
    call DRAW

    MOV AX,4C00h
    INT 21h
main endp

muevo_paletas proc ;recibo por stack los offset de ambas paletas, verifico los scan codes, si las teclas estan precionadas o no 
                   ;w para mover paleta1 arriba, s para mover paleta1 abajo, i para mover paleta2 arriba, k para mover paleta2 abajo
                   ;las paletas tendran un limite de coordenadas Y para que no puedan salir de la pantalla y solo podran moverse por la coordenada Y
    push bp
    mov bp, sp
    push ax
    push dx

comparo: 
    call getScanCode
    call SCtoASCII
    cmp al,1Bh
    je salirjuego
    cmp ah, 00h 
    je precionada ;si hay scan code se la compara
    jmp nada_paso ;si no se detecta scan code se finaliza la funcion 
salirjuego:
    mov ax,03h
    int 10h
    mov ax,4C00h
    int 21h
precionada:
    cmp al, 77h ;w
    je arribaP1
    cmp al, 73h ;s
    je abajoP1
    cmp al, 69h ;i 
    je arribaP2
    cmp al, 6bh ;k
    je abajoP2_paso
    jmp nada_paso ;si se detecta un scan code distinto se sale de la funcion
  
arribaP1:
    mov di, ss:[bp+6]
    call GetPalettePos
    cmp dl, 00  ;extremo superior
    jle nosuboP1
    call goUp
nosuboP1:
    call refreshPalette 
    call DRAW
    jmp nada_paso

abajoP1:    
    mov di, ss:[bp+6]
    call GetPalettePos
    cmp dl, 22  ;extremo inferior
    jge nobajoP1
    call goDown
nobajoP1:
    call refreshPalette 
    call DRAW
    jmp nada

nada_paso: jmp nada
abajoP2_paso: jmp abajoP2

arribaP2:  
    mov di, ss:[bp+4]
    call GetPalettePos
    cmp dl, 00  ;extremo superior
    jle nosuboP2
    call goUp
nosuboP2:
    call refreshPalette
    call DRAW
    jmp nada

abajoP2:  
    mov di, ss:[bp+4]
    call GetPalettePos
    cmp dl, 22  ;extremo inferior
    jge nobajoP2
    call goDown
nobajoP2:
    call refreshPalette
    call DRAW

nada:
    pop dx
    pop ax
    pop bp
    ret 4
muevo_paletas endp

muevo_pelota proc ;recibo por stack el offset se la pelota, de la paleta1 y paleta2
                  ;utilizamos flags para ver si la pelota tiene que rebotar para arriba o abajo:
                  ;flagarriba=0(rebota arriba), flagabajo=0(rebota abajo), flagreinicioP1=0(muevo la pelota al medio de la paleta1), flagreinicioP2=0(muevo la pelota al medio de la paleta2)
                  ;utilizamos flags para ver si la pelota toca las paletas: flagpaleta1=0(la pelota rebota en la paleta1), flagpaleta2=0(la pelota rebota en la paleta2)
                  ;y usamos un flag para el sentido de la pelota, izquierda o derecha, flagsentido=1(pelota con sentido a la izquierda), flagsentido=0(pelota con sentido a la derecha)
    push bp
    mov bp, sp
    push si
    push di
    push dx
    push ax

    mov di, ss:[bp+4] ;pelota
    cmp flagreinicioP1, 0 ;si esta en cero se reincorpora la pelota en el medio de la pelota 1
    je reincorporo_pelotaP1_paso
    
    cmp flagreinicioP2, 0 ;si esta en cero se reincorpora la pelota en el medio de la pelota 2
    je reincorporo_pelotaP2_paso
    
    cmp flagpaleta1, 0 ;si esta en cero la pelota rebota con la pelota 1
    je reboto_paleta1_paso 
    
    cmp flagpaleta2, 0 ;si esta en cero la pelota rebota con la pelota 2
    je reboto_paleta2_paso
    
    cmp flagsentido, 1 ;si el sentido es 1 entonces la pelota va a la izquierda, si es 0 la pelota va a la derecha
    je pelota_izquierda
    
    cmp flagarriba, 0 ;si esta en cero la pelota rebota para arriba con sentido derecho
    je reboto_arriba_derecha
    
    cmp flagabajo, 0 ;si esta en cero la pelota rebota para abajo con sentido derecho
    je reboto_abajo_derecha

pelota_derecha:
    mov ax, 01h ;modo de direccionamiento
    push ax
    mov ax, 01h ;sentido parte alta(derecha)
    push ax
    mov ax, 00h ;sentido parte baja(abajo)
    push ax
    call setBallDirec
    call moveBall
    call refreshBall ;muevo la pelota
    jmp salgo

pelota_izquierda:
    cmp flagarriba, 0 ;si esta en cero la pelota rebota para arriba con sentido izquierdo
    je reboto_arriba_izquierda
    
    cmp flagabajo, 0 ;si esta en cero la pelota rebota para abajo con sentido izquierdo
    je reboto_abajo_izquierda

    mov ax, 01h ;modo de direccionamiento
    push ax
    mov ax, 00h ;sentido parte alta(izquierda)
    push ax
    mov ax, 00h ;sentido parte baja(abajo)
    push ax
    call setBallDirec
    call moveBall
    call refreshBall ;muevo la pelota
    jmp salgo

reincorporo_pelotaP1_paso: jmp reincorporo_pelotaP1
reincorporo_pelotaP2_paso: jmp reincorporo_pelotaP2
reboto_paleta1_paso: jmp reboto_paleta1
reboto_paleta2_paso: jmp reboto_paleta2

reboto_arriba_derecha:
    mov ax, 01h ;modo de direccionamiento
    push ax
    mov ax, 01h ;sentido parte alta(derecha)
    push ax
    mov ax, 01h ;sentido parte baja(arriba)
    push ax
    call setBallDirec
    call moveBall
    call refreshBall 
    jmp salgo

reboto_abajo_derecha:
    mov ax, 01h ;modo de direccionamiento
    push ax
    mov ax, 01h ;sentido parte alta(derecha)
    push ax
    mov ax, 00h ;sentido parte baja(abajo)
    push ax
    call setBallDirec
    call moveBall
    call refreshBall  
    jmp salgo

reboto_abajo_izquierda:
    mov ax, 01h ;modo de direccionamiento
    push ax
    mov ax, 00h ;sentido parte alta(izquierda)
    push ax
    mov ax, 00h ;sentido parte baja(abajo)
    push ax
    call setBallDirec
    call moveBall
    call refreshBall  
    jmp salgo

reboto_arriba_izquierda:
    mov ax, 01h ;modo de direccionamiento
    push ax
    mov ax, 00h ;sentido parte alta(izquierda)
    push ax
    mov ax, 01h ;sentido parte baja(arriba)
    push ax
    call setBallDirec
    call moveBall
    call refreshBall 
    jmp salgo

reincorporo_pelotaP1:   
    mov di, ss:[bp+4] ;pelota
    mov si, ss:[bp+6] ;paleta1
    mov dl, 1
    call initialPosBall ;devuelvo la pelota al medio de la paleta1
    call refreshBall
    jmp salgo

reincorporo_pelotaP2:
    mov di, ss:[bp+4] ;pelota
    mov si, ss:[bp+8] ;paleta2
    mov dl, 0
    call initialPosBall ;devuelvo la pelota al medio de la paleta2
    call refreshBall
    jmp salgo

reboto_paleta1:
    mov di, ss:[bp+6] ;paleta1
    mov dh, 1
    call isPaletteAt
    jz existe_P1 ;si existe la paleta1 en las coordenadas entonces nos fijamos si la pelota toca una esquina o el centro de la paleta
    jmp sigo_pelotaP1
existe_P1:
    mov di, ss:[bp+4] ;pelota
    call getBallDirec ;me fijo en el direccionamiento y sentido de la pelota
    cmp dl, 00h ;me fijo si la pelota esta bajando
    je reboto_abajoP1
    mov ax, 01h ;modo de direccionamiento
    push ax
    mov ax, 01h ;sentido parte alta(derecha)
    push ax
    mov ax, 01h ;sentido parte baja(arriba)
    push ax
    call setBallDirec ;en el caso de que este subiendo la pelota, solo se cambia el sentido a la derecha
    call moveBall
    call refreshBall 
    jmp salgo
reboto_abajoP1:
    mov ax, 01h ;modo de direccionamiento
    push ax
    mov ax, 01h ;sentido parte alta(derecha)
    push ax
    mov ax, 00h ;sentido parte baja(abajo)
    push ax
    call setBallDirec ;en el caso de que este bajando la pelota, solo se cambia el sentido a la derecha
    call moveBall
    call refreshBall   
    jmp salgo

sigo_pelotaP1:
    mov di, ss:[bp+4] ;pelota
    call getBallDirec ;me fijo en el direccionamiento y sentido de la pelota
    cmp dl, 00h 
    je sigo_abajoP1
    mov ax, 01h ;modo de direccionamiento
    push ax
    mov ax, 00h ;sentido parte alta(izquierda)
    push ax
    mov ax, 01h ;sentido parte baja(arriba)
    push ax
    call setBallDirec
    call moveBall
    call refreshBall 
    jmp salgo
sigo_abajoP1:
    mov ax, 01h ;modo de direccionamiento
    push ax
    mov ax, 00h ;sentido parte alta(izquierda)
    push ax
    mov ax, 00h ;sentido parte baja(abajo)
    push ax
    call setBallDirec
    call moveBall
    call refreshBall 
    jmp salgo

salgo_paso: jmp salgo

reboto_paleta2:
    mov di, ss:[bp+8] ;paleta2
    mov dh, 78 
    call isPaletteAt
    jz existe_P2 ;si existe la paleta2 en las coordenadas entonces nos fijamos si la pelota toca una esquina o el centro de la paleta
    jmp sigo_pelotaP2
existe_P2:
    mov di, ss:[bp+4] ;pelota
    call getBallDirec ;me fijo en el direccionamiento y sentido de la pelota
    cmp dl, 00h ;me fijo si la pelota esta bajando
    je reboto_abajoP2
    mov ax, 01h ;modo de direccionamiento
    push ax
    mov ax, 00h ;sentido parte alta(izquierda)
    push ax
    mov ax, 01h ;sentido parte baja(arriba)
    push ax
    call setBallDirec ;en el caso de que este subiendo la pelota, solo se cambia el sentido a la izquierda
    call moveBall
    call refreshBall  
    jmp salgo
reboto_abajoP2:
    mov ax, 01h ;modo de direccionamiento
    push ax
    mov ax, 00h ;sentido parte alta(izquierda)
    push ax
    mov ax, 00h ;sentido parte baja(abajo)
    push ax
    call setBallDirec ;en el caso de que este bajando la pelota, solo se cambia el sentido a la izquierda
    call moveBall
    call refreshBall 
    jmp salgo

sigo_pelotaP2:
    mov di, ss:[bp+4] ;pelota
    call getBallDirec ;me fijo en el direccionamiento y sentido de la pelota
    cmp dl, 00h 
    je sigo_abajoP2
    mov ax, 01h ;modo de direccionamiento
    push ax
    mov ax, 01h ;sentido parte alta(derecha)
    push ax
    mov ax, 01h ;sentido parte baja(arriba)
    push ax
    call setBallDirec
    call moveBall
    call refreshBall 
    jmp salgo
sigo_abajoP2:
    mov ax, 01h ;modo de direccionamiento
    push ax
    mov ax, 01h ;sentido parte alta(derecha)
    push ax
    mov ax, 00h ;sentido parte baja(abajo)
    push ax
    call setBallDirec
    call moveBall
    call refreshBall 

salgo:
    call DRAW
    pop ax
    pop dx
    pop di
    pop si
    pop bp
    ret 6
muevo_pelota endp 
;PUEDEN CREAR FUNCIONES A SU ANTOJO


end main