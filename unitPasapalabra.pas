{ Esta unit implementa los tipos, funciones y acciones necesarios para el juego pasapalabra

Proyecto Final. Intro a la Algoritmica y Programacion 2016
Leonardo Gaitan
Genaro Pennone

  

}
Unit UnitPasaPalabra;

Interface

Uses unitLista,crt;

Const
    m = 26;    // Cantidad de letras jugables
    p = 10;    //Cantidad maxima de puntajes registrados
  	q = 15;   // cantidad de usuarios maxima en el registro

//Definiciones de los tipos usados en esta unidad
Type
	
	Tpalabra = Record	// Tipo palabra: Almacena cada palabra a jugar y su letra correspondiente	
  				   palabra : Lista;
  				   letra : Char;
             valor : Boolean; // Determina si la palabra se jugó 
  End;

  TarchPal = File of Tpalabra;  // Archivo de registros de T palabra

  Tusuario = Record // Tipo Usuario: Variable donde se almacena los datos de usuario
             nombreUs : String;
  				   puntaje : Integer;
  End;

  Tsoporte = Array[1..m] Of Tpalabra; //Soporta las 26 letras y sus palabras a jugar 
  
  Tarch = file of Tusuario;  //archivo de usuarios
  
  Tranking = Record 
              a : Array[1..255]  of  Tusuario;
              cant : Integer;
  End;
  
  TarchivoTexto = Text; //archivo de texto
  
  Taleatorio = Array[1..m] of Integer; //Almacena 26 numero aleatorios
  


//--------------------------------------------------------------------------------------------------------------------//

//Declaraciones 

// Revisa si existe al archivo de texto, si existe inicializa la variable de manejo y luego revisa si existe el archivo de registro de palabras, sino lo crea.
Procedure Init( nombreText : String; Var archTexto : Text ;nombreRegPal : String; var archRegPal :TarchPal);
// Revisa si existe el archivo que contiene los usuarios, si no lo crea.
Procedure InitUS(var bd : Tarch; nombreRegUs : String);
// Creacion de usuarios 
Procedure CrearUsuario (Var  archivo : Tarch; Var  salida : Tusuario);
//cambia de usuario o lo crea
Procedure CambiarUsuario (Var  archivo : Tarch; Var salida : Tusuario);
//Muestra todos los usuarios registrados
Procedure MostrarUsuarios(Var archivo : Tarch );
//Contar la cantidad de registros con un nombre de usuario dado.
Function CantRegistros(entrada : Tusuario; Var archivo :  Tarch): Tranking;
//Calcula el promedio de las partidas jugadas del usuario, recursivamente
Function VerMiPromedio (entrada: Tranking; Var sum: integer; Var i : Integer) : Real;
//Obtiene, ordena y muestra top 10 de puntajes
Procedure VerMejoresPuntajes (Var archivo : Tarch);
//Funcion que dada una palabra te devuelve la misma cargada en una lista simplemente encadenada de caracteres
Procedure CargarArchivoReg(var arch: TarchPal; var archPal:Text);
//Funcion que dada una palabra te devuelve la misma cargada en una lista simplemente encadenada de caracteres
Function CargarPalabraEnLista(palabra : String ): Lista;
//Muestra las palabras que estan cargadas en el archivo de registro
Procedure MostrarPalabras(var arch: TarchPal);
//Muestra palabra a jugar 
Procedure MuestraPal(entrada : Lista );
//Retorna una lista de 26 elementos aleatorios cada v.
Function Aleatoria(v : Integer): Taleatorio;
// Oculta letras para juego facil
Procedure juegoFacil(Var entrada : Tsoporte);
// Oculta letras para juego dificil
Procedure juegoDif(Var entrada : Tsoporte );
//Pasa la palabra
Procedure PasaPalabra(Var i : Integer; Var entrada : Tsoporte; Var pP : Integer);
//Adivina Palabra
Procedure AdivinarPalabra(Var i : Integer; Var entrada : Tsoporte; Var salida : Boolean  );
//Calcula puntaje partida
Function CalcPuntaje(entrada : Integer; ronda: integer): integer;
// Menu en juego
Procedure Menujuego(Var i : integer;  Var puntaje : Integer; Var pP : Integer; Var part :Tsoporte; ik : Integer; Var sal : Boolean ;  Var cantPalabras : Integer);
//Accion de juego
Procedure Jugar(user : Tusuario;Var archivo : Tarch; Var archivoPal : TarchPal );
//Carga en Tipo soporte: obtiene elem de archivo de palabras
Function CargaTsop(Var archivoPal: TarchPal; valor : Integer): Tsoporte;
//Permite elegir dificultad del juego
Procedure Dificultad(Var salida : Boolean );
//Escribe puntaje del jugador en el archivo de usuarios
Procedure EscribePunt(Var archivo1 : Tarch ; jugador : Tusuario);

//--------------------------------------------------------------------------------------------------------------------//
//Implementacion de las funciones y acciones 


Implementation

//Revisa si existe lista de palabras, Inicializa el archivo de registro de palabras
Procedure Init( nombreText : String; Var archTexto : Text ;nombreRegPal : String; var archRegPal :TarchPal);

Begin
    // Reviso si existe el archivo con las palabras
    assign (archTexto,nombreText);
    {$I-}
    RESET(archTexto); //Abre archivo
    {$I+}
    If IORESULT <> 0 Then Begin
        Writeln('ERROR!, la lista de palabras no existe, revise la fuente');
        readkey;
        halt; //Si no hay lista de palabras no se puede jugar
    End
     
    Else Begin
        assign(archRegPal,nombreRegPal);
        {$I-}
        reset(archRegPal);
        {$I+}   
        If IOResult <> 0 then
            Rewrite(archRegPal); // Crea archivo vacio
        End;
        Close(archRegPal); //cierro archivo de palabras
        Close(archTexto); //cierro archivo de texto
    End; 

// Inicializacion del archivo de usuarios
Procedure InitUS(var bd : Tarch; nombreRegUs : String);
Begin
    // Reviso si existe el archivo con las palabras
    assign (bd,nombreRegUs);
    {$I-}
    Reset(bd); //Abre archivo
    {$I+}
    If IORESULT <> 0 Then Begin
        Rewrite(bd); // Crea archivo vacio
    End;
    Close(bd); //cierro archivo de us
   
End;

//Accion de crear usuario
Procedure CrearUsuario (Var  archivo : Tarch; Var salida : Tusuario);
Var
    NombreU:string;
    user : Tusuario;
    encontrado :Boolean;
Begin 
    encontrado := False;
    {$I-} 
    Reset(archivo); //Abre archivo
    {$I+} 
    If (ioresult<>0) then Begin 
        Writeln('Error en el archivo');
    End 
    Else
        Write('ingrese nombre : '); 
        Readln(nombreU); //Busqueda MI
        While (Not EOF(archivo)) Do Begin //Mientras no fin sec
            Read (archivo,user); //Obtengo elem
            Repeat
                If ( nombreU = user.nombreUs ) Then Begin //Tratamiento
                    Writeln('Usuario ya existe'); 
                    encontrado:=true; 
                    Writeln('ingrese otro');
                    readln(nombreU);
                End
                Else
                    encontrado := False;
                    Until(Not encontrado);
                End;
                Close(archivo); // cierra archivo
                If (Not encontrado ) Then Begin; 
                    user.nombreUs := nombreU;
                    user.puntaje := 0;
                    Writeln('Usuario creado'); 
                    Writeln('volviendo menu'); 
                    salida := user;
    End;

End;
//Cambia de usuario activo
Procedure CambiarUsuario (Var  archivo : Tarch; Var salida : Tusuario);
Var
    nombre: String;
    encontrado : Boolean;
    usuBuscado : Tusuario;
Begin
    encontrado := False;
    Writeln('Ingrese nombre usuario');
    Readln(nombre);
    {$I-} 
    Reset(archivo); //Abre archivo
    {$I+} 
    If IORESULT <> 0 Then Begin
      Writeln('Error');
    End
    Else Begin
        While (Not (eof(archivo))) And Not (encontrado ) Do Begin //busco si existe usuario
            Read(archivo, usuBuscado); // Avance en el archivo
            If (usuBuscado.nombreUs = nombre) Then Begin
                encontrado := True;
            End;
        End;                    
    If (encontrado) Then Begin
        Writeln('Cambio de usuario exitoso');
        salida := usuBuscado;
    End
    Else
        Begin 
            Writeln('No se encontro el usuario, primero debe crear un nuevo usuario');    
            Writeln('Use el menu Crear usuario');    
        End;
  End;  
    Close(archivo);
End;
//Muestra todos los usuarios registrados
Procedure MostrarUsuarios(Var archivo : Tarch );
Var
    aux :  Tusuario;
Begin 
    {$I-} 
    Reset(archivo); //Abre archivo
    {$I+} 
    if (ioresult<>0) then Begin 
        Writeln('Error en el archivo'); //revisar
    End
    Else Begin
        While (Not EOF(archivo)) Do Begin
        Read(archivo,aux);  //
        Writeln(aux.nombreUs); // Trat corriente
        Writeln(aux.puntaje); // Trat corriente
    End;
    close(archivo);
    End;
End;
//Contar la cantidad de registros con un nombre de usuario dado.
Function CantRegistros(entrada : Tusuario; Var archivo :  Tarch): Tranking;
Var
    aux : Tusuario;
    cont : Integer;
    salida : Tranking;
Begin 
    cont := 0;
    {$I-} 
    Reset(archivo); //Abre archivo
    {$I+} 
    If (ioresult<>0) then Begin 
      Writeln('Error en el archivo'); //revisar
    End
    Else Begin
        While (Not EOF(archivo)) Do Begin
            Read(archivo,aux);  //
            If ((aux.nombreUs = entrada.nombreUs) and (aux.puntaje > 0)) Then Begin
                  cont := cont +1;
                  salida.a[cont].puntaje := aux.puntaje;
            End;
        End;
        salida.cant := cont;
    End;     
    close(archivo);
    CantRegistros:=salida;
  
End;


//Calcula el promedio de las partidas jugadas del usuario, recursivamente
Function VerMiPromedio (entrada: Tranking; Var sum: integer; Var i : Integer) : Real;

Begin
  If (i = 0) Then Begin
    VerMiPromedio := 0 + sum/entrada.cant;
  End
  {If (entrada.cant = 1) Then Begin
    VerMiPromedio :=  entrada.a[entrada.cant].puntaje/entrada.cant; 
  End} 
  Else Begin
  if (i >=1) Then begin
      sum := entrada.a[i].puntaje +  sum;
      i := i-1; //
      VerMiPromedio := VerMiPromedio(entrada, sum ,i );
    End
  End;      
End;
// Obtiene, ordena y muestra top 10 de puntajes
Procedure VerMejoresPuntajes (Var archivo : Tarch);
Var
  p,i,j,k : integer;
  aux: Tusuario;
  user : Tusuario;
  b : Tranking;
  //a : array[1 ..255] of Tusuario;
Begin
  {$I-} 
  Reset(archivo); //Abre archivo
  {$I+} 
  if (ioresult<>0) then Begin 
    Writeln('Error en el archivo'); //revisar
  End
  Else Begin
    i := 1;
    p := 1;//indice de arreglo, almacena puntajes
    While Not (EOF(archivo)) Do Begin
      Read(archivo, user); //Obtiene
      b.a[p].puntaje := (user.puntaje); {guardo en un arreglo todos los puntajes}
      b.a[p].nombreUs := (user.nombreUs);
      p := p+1;
    End;//fin while
    close(archivo); //Cierro archivo
    i := p;
    While (i >= 1) Do Begin        {ordeno los puntajes}
      j := 1;
      While (j<i) Do Begin
        If (b.a[j].puntaje > b.a[j+1].puntaje) Then Begin 
          aux := b.a[j];   //comparo e intercambio
          b.a[j] := b.a[j+1];
          b.a[j+1] := aux;
        End;
      j := j+1;
      End;
        i := i-1;
    End;{fin while}
     b.cant := p;         
    //Muestra de datos
    If (b.cant>=10) Then Begin// Si hay mas de 9
      Writeln('Los 10 mejores puntajes son :'); {muestro los 10 mejores puntajes}
      i := p;
      While (b.cant>=i-10) Do Begin
        Writeln( b.a[i].nombreUs, ' : -->  ');
        Write(b.a[i].puntaje, ' puntos');
        Writeln(' ');
        i := i-1;
      End;//fin while
    End
    Else Begin                     {muestro todos los puntajes si son menos de 10}
      k := p;
      writeln(' Los mejores puntajes registrados son :');
      While (k >=2 ) Do Begin
        Writeln( b.a[k].nombreUs,' : --> ');
        Writeln(b.a[k].puntaje, ' puntos ');
        Writeln(' ');
        k := k-1;
      End;//fin while
    End;//fin if 
    For i:= 0 to 255 do Begin
    b.a[i].puntaje :=0;
    b.cant := 0;
    End
  End;
  readkey;
  clrscr;
End;//fin accion

//Carga en archivo de registro las palabras del texto
Procedure CargarArchivoReg(var arch: TarchPal; var archPal:Text);
Var

  regDePal:TPalabra;
  i : Integer;
  caracterInit : Char;
  pal:string[20];

begin
  reset (archPal);
  reset (arch);
  i:=0;
  caracterInit:='a';
  while(not(EOF(archPal))) do
  begin
      read(archPal,pal);
      regDePal.palabra := CargarPalabraEnLista(pal);
      if(i<5) then //Son cinco palabras entonces a las primeras cinco les asigna la letra 'a'
        begin
          regDePal.letra:=caracterInit;
          write(arch,regDePal);
          i:=i+1;
        end
      else
        begin
          caracterInit:=Succ(caracterInit); //Agrega el siguiente del abecedario
          regDePal.letra:=caracterInit;
          write(arch,regDePal);
          i:=1;
        end;
    readln(archPal);
  end;
close(archPal);
close(arch);
end;
//Funcion que dada una palabra te devuelve la misma cargada en una lista simplemente encadenada de caracteres
Function CargarPalabraEnLista(palabra : String ): Lista;
Var
mInfo : TInfo;
miLista : Lista;
j  : Integer;

Begin  
inicializar(miLista);
        j:=0;
        while(j<Length((palabra))) do //Se recorre la palabra hasta su ultimo caracter 
            begin
                j:=j+1;;
                mInfo.caracter:=palabra[j]; //Se asigna al campo caracter del TInfo el caracter de la palabra en la posicion j
                mInfo.visible:=true;
                InsertarAlFinal(mInfo,miLista);
            end;
        CargarPalabraEnLista:=miLista;
end;
//Accion de juego

//Muestra las palabras que estan cargadas en el archivo de registro
Procedure MostrarPalabras(var arch: TarchPal);
Var
    regDePal:TPalabra;
    lista1 : Lista;
Begin   
        {$I-}
            reset(arch);
        {$I+}   
        if IOResult=0 then
                reset(arch)
        else
                writeln('error en el archivo');
    while(not(EOF(arch))) do
    begin
            read(arch,regDePal);
            lista1 := regDePal.palabra;
            Writeln(' ');
            MuestraPal(lista1);
            writeln(' ');
            writeln(regDePal.letra);
    end;
close(arch);
end;
//Muestra palabra a jugar 
Procedure MuestraPal(entrada : Lista );
  Var
    corriente : Tpuntero;
  Begin   //R1 MF
    corriente := entrada.Pri;
    Write ('Palabra: ---->   ');
    While (corriente <> nil ) Do Begin //Mientras no fin sec
      If ((corriente^).info.visible) Then Begin
        Write((corriente^).info.caracter);
            
      End
        
      Else
        Begin
          Write('_'); 
                            //Trat del e corriente 
        End;
          
      corriente := (corriente^).next;     //Obtener sig
          
    End;
  End;
 //Retorna una lista de 26 elementos aleatorios cada v.
 Function Aleatoria(v : Integer): Taleatorio;
    Var
      i,variable, indice : Integer;
      lista : Taleatorio;
    Begin
      //Lista de números aleatorios
      //inicilizar semilla en el programa principal
      variable := 0;  
      i := 0;
      While (i <= 25)
      Do begin
        i := i+1;
        indice := (Random(v)+ variable);
        lista[i] := indice;
        variable := variable+v;
        write(' - ',indice);
      End;
      Aleatoria := lista;
    End;
//Juego FACIL
Procedure juegoFacil(Var entrada : Tsoporte );
Var
    a : Char;
    i,contador : Integer; 
    list : Lista;
    anteriorMostrada, mostrada : Boolean;
    corriente : Tpuntero;

Begin
    i := 1;
  While (i<=26) Do Begin
    contador := 0;
    a := entrada[i].letra;
    list := entrada[i].palabra;
    mostrada := False;
    corriente := list.Pri;
    anteriorMostrada := True;
  
    While (corriente <> nil) Do Begin  
      If ((a =  (corriente^).info.caracter) AND (Not mostrada)) Then Begin   //Si elem corriente es igual  a letra jugada se debe mostrar
      (corriente^).info.visible := True;
      mostrada := True;
      End
 
      Else Begin// Si no es igual o ya se mostró
        If ((anteriorMostrada) and (contador<2)) Then Begin
        (corriente^).info.visible := False;  //Se oculta y se almacena la info
        anteriorMostrada := False;
        contador := contador + 1;
        End
        Else Begin // Si  se mostró la anterior,oculta la actual
        (corriente^).info.visible := True;
        anteriorMostrada := True;
        End;
      End;
      corriente := (corriente^).next;
  End;
i:=i+1;
End;
End;

Procedure juegoDif(Var entrada : Tsoporte );
Var
    a : Char;
    i: Integer; 
    list : Lista;
    anteriorMostrada, mostrada : Boolean;
    corriente : Tpuntero;

Begin
    i := 1;
  While (i<=26) Do Begin
    a := entrada[i].letra;
    list := entrada[i].palabra;
    mostrada := False;
    corriente := list.Pri;
    anteriorMostrada := True;
  
    While (corriente <> nil) Do Begin  
      If ((a =  (corriente^).info.caracter) AND (Not mostrada)) Then Begin   //Si elem corriente es igual  a letra jugada se debe mostrar
      (corriente^).info.visible := True;
      mostrada := True;
      End
 
      Else Begin// Si no es igual o ya se mostró
        If (anteriorMostrada) Then Begin
        (corriente^).info.visible := False;  //Se oculta y se almacena la info
        anteriorMostrada := False;
        
        End
        Else Begin // Si  se mostró la anterior,oculta la actual
        (corriente^).info.visible := True;
        anteriorMostrada := True;
        End;
      End;
      corriente := (corriente^).next;
    End;
    i:=i+1;
  End;
End;

// Menu en juego
Procedure Menujuego(Var i : integer;  Var puntaje : Integer; Var pP : Integer; Var part :Tsoporte; ik : Integer; Var sal : Boolean ;  Var cantPalabras : Integer);
  Var
    opcion : Char;
    correcto : Boolean;
  Begin
    correcto := False; //Muestra menu al jugar
    Writeln('Letra Jugada:  >>> ', part[i].letra,' <<< ' );
    Writeln(' ');    
    Writeln('--------------------------------------------------------------------------');    
    Writeln(' Opciones');
    Writeln('1: Pasar palabra');
    Writeln('2: Adivinar palabra');
    Writeln('3: Salir al menu');
    Writeln('--------------------------------------------------------------------------');    
    Writeln('PasaPalabra restantes: ', 3 - pP );
    Writeln('PasaPalabra Usados: ', pP);
    If (ik=1) Then begin
      Writeln('Ronda 1');
    End
    Else Begin
      Writeln('Ronda 2');
    End;

    Readln(opcion);

    
    Case opcion of
      '1': Begin
            If (ik = 2) Then Begin
                Writeln('No se puede usar PP en la 2da ronda');
                readkey;
                clrscr;
            End
            Else Begin

              If (pP <3)Then Begin
                PasaPalabra(i,part,Pp);
                clrscr;
                Writeln('PASAPALABRA');
              End
              Else Begin
                Writeln('No le quedan PP, adivine la palabra');
                readkey;
                clrscr;

              End;  
              End;
        
            
      End;
      '2': begin
            AdivinarPalabra(i, part, correcto);
            pP := 0;
            If (correcto) Then Begin
              puntaje := CalcPuntaje(puntaje,ik);
              cantPalabras := cantPalabras +1;
            End;
            clrscr;          
      end; 
      '3':begin
        Writeln('Saliendo al menu');
        sal := False;
      end;
      Else Begin
        clrscr;
        Writeln('Opcion incorreta, ingrese de nuevo');
      End;
    End;
End;


// Permite usar Pasapalabra
Procedure PasaPalabra(Var i : Integer; Var entrada : Tsoporte; Var pP : Integer);
Begin
  entrada[i].valor := True; // Si se usa PP la palabra pasa a estar disponible p/ ronda 2
  i := i+1;
  pP := pP +1; 
End;
//Permite Adivinar Palabra, compara con la entrada por el usuario
Procedure AdivinarPalabra(Var i : Integer; Var entrada : Tsoporte; Var salida : Boolean );
Var
  pal : String ;
  corriente, corrienteComp : Tpuntero;
  iguales : Boolean;
  listaComp: Lista;

Begin
  iguales := True;
  corriente := entrada[i].palabra.Pri;
  Writeln('-------- Adivinar palabra:--------');
  Writeln('      --- Ingrese palabra: ---');
  readln(pal);
  listaComp := CargarPalabraEnLista(pal) ;
  corrienteComp := listaComp.Pri ;

    
    While ((corriente <> nil) and (corrienteComp <> nil) and(iguales)) Do Begin
          If ( (corriente^).info.caracter <> (corrienteComp^).info.caracter ) Then Begin
            iguales:= False;  
          End;
          corriente := (corriente^).next; 
          corrienteComp := (corrienteComp^).next; // Si hay algun elemento diferente entre las dos listas iguales se pasa a falso
    End;          

       If ((iguales and( corriente = nil ))) Then Begin // Entrada usuario = palabra
        TextColor(Green);
        Writeln('Correcto !---> Siguiente palabra');
        TextColor(White);

        salida := True;
        readkey;
        clrscr;
      End     
      Else begin   // Entrada usuario <> palabra
          Writeln(' ');
          TextColor(Red);
          Writeln('Incorrecto :( ---> Siguiente palabra ');
          TextColor(White);
          readkey;
          clrscr;
      End;
      entrada[i].valor := False;
      i := i + 1;
        
    
   
End;
//Calcula puntaje partida
Function CalcPuntaje(entrada : Integer; ronda: integer): integer;
Begin
  If (ronda = 1 ) Then Begin
    CalcPuntaje := entrada+2;
  End
  Else Begin
    CalcPuntaje := entrada+1;
  End;
End;
 //Carga en Tipo soporte: obtiene elem de archivo de palabras
Function CargaTsop(Var archivoPal: TarchPal; valor : Integer): Tsoporte;
Var
  partida : Tsoporte;
  aux1 : Tpalabra;
  i : Integer;
  indices : Taleatorio;

Begin
 {$I-}   // abre archivo
 reset(archivoPal);
 {$I+}   
 if IOResult=0  then Begin
   indices:= Aleatoria(valor);
   i := 0;
   Seek(archivoPal,indices[i]);
   Read(archivoPal, aux1);

    While ((i <= 25) And (Not EOF(archivoPal))) Do Begin
      i:= i+1;
      Seek(archivoPal,indices[i]);
      Read(archivoPal, aux1);
      partida[i] := aux1;
      partida[i].valor := True;
    End;
  End;
    Close(archivoPal);
    CargaTsop := partida;

End;
//Permite elegir dificultad del juego
Procedure Dificultad(Var salida : Boolean );
Var
 entUs : Char;
Begin
  clrscr;
  Writeln('Juego Facil? S/N');
  Readln(entUs);
  Case entUs of
    's': Begin
        salida := True;
        Writeln('Juego Facil');
    End;
    'S': Begin
        salida := True;
        Writeln('Juego Facil');
    End;
    'N': Begin
        salida := False;
        Writeln('Juego dificil');

    End;
    'n': Begin
        salida := False;
        Writeln('Juego dificil');
    End;
    Else Begin 
      Writeln('Error de ingreso! juego Facil? S/N');
      Readln(entUs); 

    End;
  End;
End;

//Escribe puntaje del jugador en el archivo de usuarios
Procedure EscribePunt(Var archivo1 : Tarch ; jugador : Tusuario);
  Var
  usLocal : Tusuario;
   Begin 
  
  {$I-} 
    Reset(archivo1); //Abre archivo
  {$I+} 
  
  If (ioresult<>0) then Begin 
    Write('Error en el archivo');
  End 
  Else Begin
    While not Eof (archivo1) do begin
      Read (archivo1, usLocal);
    End;
    Write(archivo1,jugador);
  End;
  Close(archivo1);
  End;

//Accion de juego
Procedure Jugar(user : Tusuario;Var archivo : Tarch; Var archivoPal : TarchPal );
Var
  palabras : Tsoporte;
  juego : Boolean;
  q,k :Integer;
  salida : Boolean;
  puntos : Integer;
  contPP : integer;
  palCont : Integer;
Begin
  palabras := CargaTsop(archivoPal,5);
  dificultad(juego);
  q:=1;
  palCont:= 0;
  k := 1;
  salida := True;
  puntos := 0;
  contPP:=0;
  If (juego) Then begin
    juegoFacil(palabras); // JUEGO FACIL
    While ((k <= 2) and ( salida)) Do Begin
    q :=1;
      While ((q<=26) and ( salida)) Do Begin 
           
           Writeln('--------------------------------PASAPALABRA-----------------------------------');
           Writeln('Puntaje: ',puntos );
           If (palabras[q].valor) Then Begin

              MuestraPal(palabras[q].palabra);
              Writeln(' ');
              Menujuego(q,puntos,contPP,palabras,k,salida,palCont);
            End
            Else Begin
                q := q+1;
            End;
            
        End;
      k := k +1; // FIN JUEGO
    End;
   


    
  End
  Else Begin
    juegoDif(palabras); //JUEGO DIFICIL
      While ((k <= 2) and ( salida)) Do Begin
          While ((q<=26) and ( salida)) Do Begin
             Writeln('--------------------------------PASAPALABRA-----------------------------------');
             Writeln('Puntaje: ',puntos );
              If (palabras[q].valor) Then Begin

              MuestraPal(palabras[q].palabra);
              Writeln(' ');
              Menujuego(q,puntos,contPP,palabras,k,salida,palCont);
            End
            Else Begin
                q := q+1;
            End;
            
        End;
      k := k +1; // FIN JUEGO

  End;
   
  End;
    If ((q = 4) and (k =3 ) ) Then Begin //Si la partida se completa escribe  en el archivo una entrada
     If (puntos > 0 ) Then Begin
      user.puntaje:= puntos;
      TextColor(Red);
      Writeln('------------------------- JUEGO TERMINADO-------------------- ');
      TextColor(White);
      Writeln('*                       Jugador: ',user.nombreUs);
      Writeln('*                       Puntaje: ', user.puntaje);
      Writeln('*                       Palabras Acertadas: ', palCont);
      Writeln('*                     Palabras No Acertadas: ', 26-palCont);
      Writeln('------------------------------------------------------------- ');
      Writeln('Presiona cualquier tecla para volver al menu');
      readkey;
      EscribePunt(archivo , user);
      clrscr;
      End
      Else Begin
        Writeln('Su puntaje es 0, no se guardará');
      End;
    End;
End;



//Fin de UnitPasapalabra
End.









