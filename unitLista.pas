{********** Lista Simplemente Enlazada (LSE)  **********************
Esta unit, crea la lista (deben decidir si con elemento ficticio o no)
y tiene dos punteros, uno q apunta siempre al
Inicio de la lista y otro que apunta siempre al final de la lista.
Implementacion sin elemento ficticio.
Entrega Laboratorio Lunes 10/10/2016
Practica 14 -UnitList
Genaro Pennone

********************************************************************}

unit unitLista;

Interface
  
{********** Tipos visibles para quienes utilizan esta Unidad **********}
 type
   	TPuntero = ^TNodo; {Puntero a un nodo de la lista.}
   	TInfo= record {Tipo de la informacion que va a contener la lista.}
			caracter:integer; /// CAMBIAR A CARACTER/// 
	        numero : integer;
           end;
 	TNodo = record {Representa un nodo de la lista.}  
             info: TInfo; 
             next: TPuntero; {Puntero al nodo siguiente.}                
            end;
    Lista = record
        	 Pri: TPuntero; {Puntero al primer nodo de la lista.}
        	 Ult: TPuntero; {Puntero al ultimo nodo de la lista.}
       		 cant : integer; {Contiene la cantidad de nodos que tiene la lista.}
    		end;

{======================================================================================}
{Declaraciones de las acciones y funciones visibles para quienes utilizan esta unidad}

{Retorna un Puntero al primer elemento valido de la Lista, Fin(l) si esta vacia}
function Inicio( l : Lista ) : TPuntero;

{Retorna un Puntero al primer elemento no valido de la Lista}
function Fin ( l : Lista ) : TPuntero;

{Retorna un Puntero al ultimo elemento valido de la Lista, Fin(l) si esta vacia}
function Ultimo (l : Lista) : TPuntero;

{Retorna el puntero al siguiente elemento de un elemento valido}
{pre: pos <> nil}
function Siguiente(pos : TPuntero ) : TPuntero;

{Retorna True si la Lista esta vacia, falso en caso contrario}
function esVacia( l : Lista ) : boolean;

{Retorna el valor del elemento que corresponde a un Puntero }
{pre: pos <> nil}
function Obtener( pos : TPuntero) : TInfo;

{Retorna la longitud de la Lista }
function Longitud( l : Lista ) : integer;

{Inicializa la Lista como vacia }
procedure Inicializar( var l : Lista );

{Modifica el elemento que esta en un Puntero }
{pre: pos <> nil}
procedure Modificar( e : TInfo; pos : TPuntero);

{Inserta un elemento al principio de la Lista }
procedure InsertarAlInicio(  e : TInfo; var l : Lista);

{Inserta un elemento al final de la Lista }
procedure InsertarAlFinal(  e : TInfo;  var l : Lista);

{Inserta un elemento en una posicion dada}
procedure InsertarEnPos(e: TInfo; var l: Lista; pos: integer);
        
{Elimina el primer elemento de la Lista}
{pre: Longitud(l) >= 1 }
procedure EliminarPrincipio(var l : Lista);

{Elimina el elemento que se encuentra en la posicion dada}
{pre: pos <= Loncitud(l)}
procedure EliminarEnPos(var l: Lista; pos: integer);

{Elimina el ultimo elemento de la Lista}
{pre: Longitud(l) >= 1 }
procedure EliminarFinal(var l : Lista);

{Controla si un elemento dado se encuentra en la lista}
function TieneElem(info: TInfo; l : Lista): boolean;

{Muestra los elementos de l}
procedure MostrarLista(l: Lista);

{Verifica condiciones para que una accion/funcion funcione correctamente, de no ser asi, cierra el programa.}
procedure Verificar( cond : boolean; mensaje_error : string );

{======================================================================================}
{Implementacion del Modulo}
Implementation
{******************************************************************************************}
{********** Declaracion de Acciones y Funciones Auxiliares locales al modulo **************}
{******************************************************************************************}

{Incrementa en 1 el campo cant de la lista }
procedure IncrementarCantidadElementos(var l : Lista); forward;

{Decrementa en 1 el campo cant de la lista }
procedure DecrementarCantidadElementos(var l : Lista); forward;

{Crea un nuevo Nodo de la Lista y le setea la informacion recibida como parametro}
procedure CrearNuevoNodo( var nuevoNodo : TPuntero; e: TInfo); forward;


{******************************************************************************************}
{************************ Implementacion de Acciones y Funciones Exportadas ***************}
{******************************************************************************************}

{Retorna un Puntero al primer elemento valido de la Lista, Fin(l) si esta vacia}
function Inicio( l : Lista ) : TPuntero;
begin
    Inicio:= l.pri;      //retorno el puntero inicial 
end;

{Retorna un Puntero al primer elemento no valido de la Lista}
function Fin ( l : Lista ) : TPuntero;
begin
    Fin := nil; // ESTO NO LO ENTIENDO, La funciono devuelve nil, para que le pasp como parametro la lista?//
end;

{Retorna un Puntero al ultimo elemento valido de la Lista, Fin(l) si esta vacia}
function Ultimo (l : Lista) : TPuntero;
begin
    Ultimo := l.ult
end;

{Retorna el puntero al siguiente elemento de un elemento valido}
{pre: pos <> nil}
function Siguiente(pos : TPuntero ) : TPuntero;
begin
    Verificar(pos <> nil,'No se puede obtener siguiente posicion. Puntero nulo.');
    If (pos <> nil) 
        Then 
            Begin
                Siguiente := (pos^).next;
            End;
    //completo//
end;

{Retorna True si la Lista esta vacia, falso en caso contrario}
function esVacia( l : Lista ) : boolean;
begin
	if (longitud(l)=0) then
		EsVacia:=true
	else
		EsVacia:=false;
end;

{Retorna el valor del elemento que corresponde a un Puntero }
{pre: pos <> nil}
function Obtener( pos : TPuntero) : TInfo;

begin
    Verificar(pos <> nil,'No se puede obtener valor. Puntero nulo.');
    If (pos <> nil) then
        Begin
            Obtener := (pos^).info 
        End;
end;

{Retorna la longitud de la Lista.}
function Longitud( l : Lista ) : integer;
begin
    longitud:=l.cant;
end;

{Inicializa la Lista como vacia.}
procedure Inicializar( var l : Lista );
begin
 ;  //NO usa elemento ficticio //
    l.Pri := nil;
    l.Ult := l.Pri ;
    l.cant := 0; 
    Writeln('Lista inicializada');
end;

{Modifica el elemento que esta en un Puntero.}
{pre: pos <> nil}
procedure Modificar (e:TInfo; pos : TPuntero);
begin
    Verificar(pos <> nil,'No se puede modificar valor. Puntero nulo.'); 
    If (pos <> nil) Then
        Begin
            (pos^).info := e;
        End;
end;


{Inserta un elemento al principio de la Lista.}
procedure InsertarAlInicio(e:TInfo; var l : Lista);
var
    r: TPuntero; { puntero al Nuevo nodo que se va a Insertar.}   
begin
    CrearNuevoNodo(r,e);
    (r^).next := Inicio(l) ;
    l.Pri:= r;
    IncrementarCantidadElementos(l);
    If (Longitud(l) = 1) Then
        Begin
        l.ult := r;
        End;
end;

{Inserta un elemento en una posicion dada}
{pre: pos <= Longitud(l) && pos > 0}
procedure InsertarEnPos(e: TInfo; var l: Lista; pos: integer);
Var
    g : Tpuntero; //Puntero al nuevo nodo a insertar//
    aux : Tpuntero; //Puntero para apuntar a la posicion
    cont : Integer; // contador indicador de posicion//
begin
    cont := 1;
    CrearNuevoNodo(g,e);
    aux := Inicio(l);
    If (pos  = 1 ) Then 
    Begin
        InsertarAlInicio(e,l)
    End
    
    Else
        While ((cont < pos-1 ) and (aux<> nil) ) Do
            Begin
                aux := siguiente(aux);
                cont := cont +1;
            End;
        (g^).next := Siguiente(aux);
        (aux^).next := g;
        IncrementarCantidadElementos(l);
    

end;

{Inserta un elemento al final de la Lista }
procedure InsertarAlFinal(e:TInfo;  var l : Lista);
var
    r: TPuntero; { puntero al Nuevo nodo que se va a Insertar.} 
begin
    CrearNuevoNodo(r,e);
    If ( esVacia(l)) Then
    Begin
        InsertarAlInicio(e,l);
    End
    Else
    Begin
        (l.Ult^).next := r; {Notar que si la lista era vacia, pri y ult apuntaban al ficticio}   
        l.Ult:=r;
        IncrementarCantidadElementos(l);
    End
    
    
    //completo
end;

{ Elimina el primer elemento de la Lista}
{ pre: Longitud(l) >= 1 }
procedure EliminarPrincipio(var l : Lista);
var
    r : TPuntero; { puntero al nodo q vamos a eliminar}    
begin
   	Verificar((l.pri <> nil), 'La lista esta vacia no se puede Eliminar.');
	r := Inicio(l); 	
	l.pri:=Siguiente(r);
	dispose (r);
	DecrementarCantidadElementos(l);
    //completo
end;

{Elimina el elemento que se encuentra en la posicion0 dada}
{pre: pos <= Longitud(l) && pos > 0}
procedure EliminarEnPos(var l: Lista; pos: integer);
Var
 cont : Integer; {contador para determinar posicion}
 q : Tpuntero; {Puntero a la cabeza}
 s,t : Tpuntero; {Punteros aux}
 begin
    Verificar((l.pri <> nil), 'La lista esta vacia no se puede Eliminar.');    
    If (pos = 1 ) Then
        Begin
            EliminarPrincipio(l);
        End
    Else
        Begin
            q := Inicio(l);
            cont := 1;
            While ((cont < pos-1 ) and (q<> nil) ) Do
                Begin
                    q := Siguiente(q);
                    cont := cont +1;
                End;
                s := Siguiente(q);
                t := Siguiente(s);
                (q^).next := t;
                dispose(s);
                DecrementarCantidadElementos(l);
            End;
end;

{Elimina el ultimo elemento de la Lista}
{ pre: Longitud(l) >= 1 }
procedure EliminarFinal(var l : Lista);
var
    q : Tpuntero ; {Puntero aux}
    r : TPuntero; { puntero al nodo q vamos a eliminar}    
begin
 Verificar((l.pri <> nil), 'La lista esta vacia no se puede Eliminar.');    
 If (l.cant < 2) Then
    Begin 
        EliminarPrincipio(l);
    End
    
    Else
    Begin
    q := Inicio(l);
    While ((q^).next)^.next <> nil Do 
        Begin
            q := Siguiente(q);
        End;
        r := Ultimo(l);
        (q^).next := nil;
        dispose(r);
        l.Ult := q;
        DecrementarCantidadElementos(l);
    End;
    end;

{Controla si un elemento dado se encuentra en la lista}
function TieneElem(info: TInfo; l : Lista): boolean;
Var 
 apuntador : Tpuntero;
 encontrado : Boolean;
begin
encontrado := False;
apuntador := l.Pri;
While ((encontrado = False) and (apuntador <> nil) ) Do 
    Begin
        If (info.caracter = (apuntador^).info.caracter) Then
            Begin
                encontrado := True;
            End;
    End;
    TieneElem := encontrado;
end;

{Muestra los elementos de l}
procedure MostrarLista(l: Lista);
Var 
    punta : Tpuntero;
begin
punta := Inicio(l);
    While (punta <> nil) Do
    Begin
        Writeln(punta^.info.caracter);
        punta := (punta^).next; 
    End;
end;

{ Verifica condiciones para que una accion/funcion funcione correctamente, de no ser asi, cierra el programa.}
procedure Verificar( cond : boolean; mensaje_error : string );
begin
    if (not cond) then
    begin
        writeln('ERROR: ', mensaje_error);
        halt;
    end;
end;

{******************************************************************************************}
{********** Implementacion de Acciones y Funciones Auxiliares locales al modulo **********}
{******************************************************************************************}

//--------------------------------------------------------
procedure IncrementarCantidadElementos(var l : Lista);
begin
    l.cant := l.cant + 1;
end;

//--------------------------------------------------------
procedure DecrementarCantidadElementos(var l : Lista);
begin
    l.cant := l.cant - 1;
end;


//--------------------------------------------------------
procedure CrearNuevoNodo( var nuevoNodo : TPuntero; e: TInfo);
begin 
New( nuevoNodo);
(nuevoNodo^).next := nil;
(nuevoNodo^).info.caracter := e.caracter;
end;

end.