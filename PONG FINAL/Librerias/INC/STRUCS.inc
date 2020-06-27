;ESTRUCTURA DEL TIMER (TIMER)
TIMER STRUC
	initH		db		?
	initM		db		?
	initS		db		?
	initC		db		?
	initDate	db		?
	passedH		db		?
	passedM		db		?
	passedS		db		?
	passedC		db		?
	miliSec		dw	 	2 dup (?)
	Seconds 	dw 		2 dup (?)
	Minutes 	dw 	 	?
ENDS

;ESTRUCTURA DE LA PALETA (PALETTE)
PALETTE STRUC
	coordx			db 	?
	coordY			db 	?
	graf			db	?
	largo 			db 	?
	p_old_coordX 	db 	?
	p_old_coordY	db 	?
ENDS

;ESTRUCTURA DE LA PELOTA (BALL)
BALL STRUC
	coordx			db 	?
	coordY			db 	?
	graf			db	?
	direccion		db	?
	sentido 		db	2 dup (?)
	old_coordX 		db 	?
	old_coordY		db 	?
	backup_ASCII	db	?
ENDS