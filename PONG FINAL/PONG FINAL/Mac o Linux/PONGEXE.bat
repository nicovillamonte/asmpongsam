@echo off
:comparaciones
if "%1" == "" 			goto 	PONGEXEHELP
if "%1" == "help" 		goto 	PONGEXEHELP
if "%1" == "/?" 		goto 	PONGEXEHELP
if "%1" == "Nicolas" 	goto 	nico
if "%1" == "Adrian" 	goto 	adri
if "%1" == "Mateo" 		goto 	mate
if "%1" == "Lucas" 		goto 	lucas
if "%1" == "Ezequiel" 	goto 	eze
goto PONGEXEHELPERR

:PONGEXEHELPERR
echo Error: %1 no es un argumento valido
goto FIN
:PONGEXEHELP
echo.
echo PONGEXE [Version]
echo  Versiones:
echo 	Nicolas
echo 	Adrian
echo 	Mateo
echo 	Lucas
echo 	Ezequiel
echo.
echo	(Respetar mayusculas y minusculas en el ingreso de los argumentos)
echo.
goto FIN

:nico
cls
echo Controles:
echo    W		Paleta 1 arriba
echo    S		Paleta 1 abajo
echo    I		Paleta 2 arriba
echo    K		Paleta 2 abajo
echo    ESC		Pausa
echo    UP		Moverse por el menu
echo    DOWN		Moverse por el menu
echo    ENTER	Seleccionar opcion
echo.
echo Presione cualquier tecla para comenzar el juego.
pause>nul
cls
cd PONG
PONGN
cd..
goto FIN
:adri
cls
echo Controles:
echo    W		Paleta 1 arriba
echo    S		Paleta 1 abajo
echo    I		Paleta 2 arriba
echo    K		Paleta 2 abajo
echo    ESPACIO	Pausa
echo    X		Nuevo Juego
echo    Z		Continuar Juego
echo    B		Cierra el juego
echo.
echo Presione cualquier tecla para comenzar el juego.
pause>nul
cls
cd PONG
PONGA
cd..
cls
goto FIN
:mate
cls
echo Controles:
echo    W		Paleta 1 arriba
echo    S		Paleta 1 abajo
echo    I		Paleta 2 arriba
echo    K		Paleta 2 abajo
echo    ESC		Salir del juego
echo.
echo Presione cualquier tecla para comenzar el juego.
pause>nul
cls
cd PONG
PONGM
cd..
cls
goto FIN
:lucas
cls
echo Controles:
echo    D		Paleta 1 arriba
echo    C		Paleta 1 abajo
echo    K		Paleta 2 arriba
echo    M		Paleta 2 abajo
echo    ESC		Salir del juego
echo.
echo Presione cualquier tecla para comenzar el juego.
pause>nul
cd PONG
PONGL
cd..
goto FIN
:eze
cls
echo Controles:
echo    W		Paleta 1 arriba
echo    S		Paleta 1 abajo
echo    I		Paleta 2 arriba
echo    K		Paleta 2 abajo
echo    ESC		Salir del juego
echo.
echo Presione cualquier tecla para comenzar el juego.
pause>nul
cls
cd PONG
PONGE
cd..
cls
:FIN
@echo on