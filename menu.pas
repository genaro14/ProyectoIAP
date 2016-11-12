{ 
*Menu Proyecto final Algoritmica y Prog
Leonardo Gaitan
Genaro Pennone
}
Program menu;
Uses unitLista, unitPP;
Var
entrada : Integer;


//Muestra menu de opciones y segun opcion ejecuta una salida
procedure CargaMenu(var opcion: Integer);
	Begin
		Writeln('------------------------------------------------------------------------------');		
		Writeln('----------------------PASAPALABRA----------------------');
		Writeln('Menu principal: ');
		Writeln('1: Iniciar partida');
		Writeln('2: Ver mi promedio');
		Writeln('3: Cambiar de usuario');
		Writeln('4: Ver los 10 mejores');
		Writeln('5: Salir del juego');
		Writeln('Ingrese opcion:');
		Readln(entrada);
		Case opcion of
		1:EmpezarPartida();
		2:VerPromedio();
		3:CambiarUsuario();
		4:MejoresPuntajes();
		5:opcion := 66;
		End;
	End;

Begin
	entrada :=0;
	Repeat
		CargaMenu(entrada);
	Until (entrada = 66);
End.