.8086
.model small
.stack 100h
.data
.code

public funcion1; con esta directiva PUBLIC se declaran las funciones que estar�n disponibles en tu librer�a
public funcion2

main proc
; no hay nada en el main
main endp

funcion1 proc
	...... ;c�digo de la funci�n
	......
	......
	......
	......
	ret
funcion1 endp

funcion2 proc
	...... ;c�digo de la funci�n
	......
	......
	......
	......
	ret
funcion2 endp

end main
;=======================================================================