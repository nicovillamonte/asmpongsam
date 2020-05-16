.8086
.model small
.stack 100h
.data
.code

public funcion1; con esta directiva PUBLIC se declaran las funciones que estarán disponibles en tu librería
public funcion2

main proc
; no hay nada en el main
main endp

funcion1 proc
	...... ;código de la función
	......
	......
	......
	......
	ret
funcion1 endp

funcion2 proc
	...... ;código de la función
	......
	......
	......
	......
	ret
funcion2 endp

end main
;=======================================================================