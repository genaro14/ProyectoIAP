Program CrearArchReg;
Uses unitLista;
type
	TPalabra=record
            palabra:string[20];//Lista de caracteres(lse) debe ser
						letra:char;
         	end;

  tarch=file of TPalabra;

var
archPal:Text;
mInfo:TInfo;
miLista:Lista;
arch:tarch;
regDePal:TPalabra;
i,j:integer;
caracterInit:Char;
pal:string[20];
{Inicializa el archivo de registro}
procedure Init(var arch: tarch);
	begin
		assign (archPal,'palabras.txt');
		assign(arch,'palabras.dat');
		Inicializar(miLista);	
		{$I-}
			reset(arch);
		{$I+}	
		if IOResult=0 then
				reset(arch)
		else
				rewrite(arch);
	end;

procedure CargarArchivoReg(var arch: tarch; var archPal:Text);
begin
	reset (archPal);
	i:=0;
	caracterInit:='a';
	while(not(EOF(archPal))) do
	begin
			read(archPal,pal);
			regDePal.palabra:=pal;
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
function CargarPalabraEnLista(regDePal: TPalabra ): Lista;
begin 
		j:=0;
		while(j<=Length((regDePal.palabra))) do //Se recorre la palabra hasta su ultimo caracter 
			begin
				j:=j+1;
				mInfo.caracter:=regDePal.palabra[j]; //Se asigna al campo caracter del TInfo el caracter de la palabra en la posicion j
				mInfo.visible:=true;
				InsertarAlFinal(mInfo,miLista);
			end;
		CargarPalabraEnLista:=miLista;
end;

{Muestra las palabras que estan cargadas en el archivo de registro}
Procedure MostrarPalabras(var arch: tarch);
begin	
		{$I-}
			reset(arch);
		{$I+}	
		if IOResult=0 then
				reset(arch)
		else
				writeln('error');
	while(not(EOF(arch))) do
	begin
			//read(arch,regDePal);
			//writeln(regDePal.palabra);
	end;
close(arch);
end;

//Accion para probar la el pasaje de string a lista simplemente encadenada de TInfo
//Mustra la primer palabra del archivo que se convierte en lista de TInfo.
Procedure PruebaConvertPalALista(var arch: tarch);
begin	
	reset (arch);
	if(not(EOF(arch))) then
		begin
			read(arch,regDePal);
			miLista:=CargarPalabraEnLista(regDePal);
			MostrarLista(miLista);
			writeln('');
		end
	else
		writeln('archivo vacio');
	close(arch);
end;

{Programa Principal}
begin
	Init(arch);
	CargarArchivoReg(arch,archPal);	
	PruebaConvertPalALista(arch);
end.
	
