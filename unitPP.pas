{*
Esta unit, almacena las acciones/funciones y los tipos de variables utilizadas en el programa pasapalabra
Leonardo Gaitan
Genaro Pennone
*}

unit pasaPalabra

Interface

Type 
	//Puntero a TpalabraLSE
	Tpuntero :^TpalabraLSE;

	//Letras en las palabras del juego
	TpalabraLSE : Record
				   info: Char;
				   sig : Tpuntero;
	
	//Contenedor de letras del abecedario//
	Tletra : Record
			  letra : Char;
			  valor : Boolean;
			  puntajeLetra : Boolean;
			  Tpalabras : Array[1..5] of TpalabraLSE;
			 End;
	
	Tarreglo : Array[1..26] of Tletra;
	
	Tusuario : Record
			    nombreUsuario :  String;
			    puntajes : Array[1..10] of Integer;
			   End;
	
	listaUsuarios : Record 
					 a : Array[1..255] de Tusuario;
					 cantidad : Integer;
					End;
//--------------------------------------------------------------------------------------------------------------------//
//Declaraciones 

// comenzar la partida
Procedure EmpezarPartida();

//ver promedio del usuario
Procedure VerPromedio();

//cambia de usuario o lo crea
Procedure CambiarUsuario();

//Muestra 10 mejores juegos
Procedure MejoresPuntajes();

Uses unitLista;



