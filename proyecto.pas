{
	Proyecto Final 
	Introduccion a la Algoritmica y Programacion
	Juego Pasapalabra.
	
	Alumnos: Genaro Pennone
			Leonardo Gaitan

}

Program proyecto;


Uses unitPasapalabra, unitLista,crt ;
Var
	h : Integer;
	sum : integer;
	jugador : Tusuario;
	promedio :  Real;
	sal1 : Tranking;
	listaTxt : Text;
	archivoUs : Tarch;
	archPalabras : TarchPal;
	nombreArchPalabras, nombreArchUsuarios,nombreArchRegistro : String;
//Presentacion de inicio
Procedure Portada();
Begin
    	TextColor(white);
    	TextBackground(black);
		Writeln('*************************************************************************');
		Writeln('*************************************************************************');
		Writeln('-------------------------------------------------------------------------');
		Writeln('-------------------------------------------------------------------------');
		Writeln('				>>>------      JUEGO PASAPALABRA      ---<<<'              );
		Writeln('-------------------------------------------------------------------------');
		Writeln('-------------------------------------------------------------------------');
		Writeln('*************************************************************************');
		Writeln('*************************************************************************');	
		Writeln('Para comenzar presione una tecla');
		Readkey;
		clrscr;
	End;	
//Ingreso de usuario inicial
Procedure Inicio(Var salida: Tusuario );
	Var
		nombre : String;
	Begin
		Writeln('*************************************************************************');
		Writeln('-------------------------------------------------------------------------');
		Writeln('>>>>>>>>>>>>>>>>>>>>>>>>> Ingrese nombre usuario <<<<<<<<<<<<<<<<<<<<<<<<');
		Writeln('-------------------------------------------------------------------------');
		Writeln('*************************************************************************');
		Readln(nombre); // Entrada por teclado, nombre del jugador
		salida.nombreUs := nombre; // asignacion a la variable jugador
		salida.puntaje:= 0; // inicializacion del puntaje
		clrscr;
	End;
//Menu Principal
Procedure CargaMenu( Var user : Tusuario);
	Var
	entrada: String;
		
	Begin
		Repeat
		Writeln('------------------------------------------------------------------------------');		
		Writeln('--------------------------------PASAPALABRA-----------------------------------');
		Writeln('>>>>>>>>>>>>>>>>>>>>>> Jugador Actual: ', user.nombreUs,'  <<<<<<<<<<<<<<<<<<<');
		Writeln('------------------------------------------------------------------------------');		
		Writeln('Menu principal: '); // 
		Writeln('1: Iniciar partida');
		Writeln('2: Ver mi promedio');
		Writeln('3: Crear Usuario');
		Writeln('4: Cambiar de usuario');
		Writeln('5: Ver los 10 mejores');
		Writeln('6: Salir del juego');
		Writeln('Ingrese opcion:');
		Readln(entrada);

		
		Case entrada of
			'1': Begin
				clrscr;
				Jugar(jugador ,archivoUs, archPalabras );

			End;
			'2': Begin	
				clrscr;
				sum := 0;
				sal1 := CantRegistros(jugador, archivoUs);
				h := sal1.cant;
				If (h > 0) Then Begin
					promedio := SumaProm(sal1,sum, h)/sal1.cant;
					Writeln('El promedio de sus puntajes es: ');
					Write(promedio:2:2);
				End
				Else Begin
					Writeln('No tiene juegos registrados');
				End;
			End;
			'3': Begin
				clrscr;
				crearUsuario(archivoUs, jugador);

				End;
			'4':Begin
				clrscr;
				CambiarUsuario(archivoUs, jugador);

			End;
			'5':Begin
				clrscr;
				Writeln('Top 10 puntajes:');
				VerMejoresPuntajes(archivoUs);
			End;
			'6':Begin
				clrscr;
				Writeln('Saliendo del juego...');
				entrada := '66';
			End;
			'7':Begin
				clrscr;
				Writeln('Menu oculto; usuarios...');
				MostrarUsuarios(archivoUs);
			End;
			'8':Begin
				clrscr;
				Writeln('Menu oculto; lista palabras en registro...');
				MostrarPalabras(archPalabras);
			End;
			Else Begin
				clrscr;
				Writeln('opcion incorrecta reingrese')
				
			End;
		End;
		
		Until (entrada = '66');
End;
//Cuerpo principal del programa
Begin
    Randomize;
	nombreArchPalabras := 'palabras.txt'; //Nombre del archivo que contiene las palabras
	nombreArchRegistro :='palabras.dat';
	nombreArchUsuarios := 'usuariosBD.dat'; // Nombre del archivo que almacena los usuarios
	Init(nombreArchPalabras, listaTxt,  nombreArchRegistro, archPalabras); 
	InitUs(archivoUs,nombreArchUsuarios);
 	Portada();
 	CargarArchivoReg(archPalabras, listaTxt);
 	Inicio(jugador);
	CargaMenu(jugador);
End. 
