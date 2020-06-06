Subi los programas:
llscore.asm --> Main para llamar al score (no se usará en el Pong, es solo para prueba)
scorpong.asm --> Función que muestra en pantalla los scores y los borra en un tiempo parametrizado
espepong.asm --> Función de espera temporal (no se usará en el Pong porque ya hay rutinas de espera de tiempos)

Hay que compilar los 3 y linkearlos como
tlink llscore scorppong espepong
