.8086
.model small
.stack 100h

.DATA
    ...... ; data de este programa
    ......
    ......
	
.CODE

	EXTRN funcion1:PROC ; funciones externas
	EXTRN funcion2:PROC

main proc
    ......
    ......
	
	mov ax, 4c00h
	int 21h
main endp

otrafuncion proc ; funciones locales
    ......
    ......
    ......
otrafuncion endp

end main
