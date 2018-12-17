unit uVector;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils, math;
const
    maxOrden = 20;
type
    tVectorI = array [1..maxOrden] of integer;
    tVector = array [1..maxOrden] of extended;

    clsVector = class

        private
            orden       : integer;
            elementos   : tVector;

        public
            constructor crear();
            constructor crear(ord: integer);
            constructor crear(ord: integer; elem: tVector);
            procedure setOrden(ord: integer);
            function getOrden(): integer;
            procedure setElementos(elem: tVector);
            function getElementos(): tVector;
            function sumarVector(v: clsVector): clsVector;
            function restarVector(v: clsVector): clsVector;
            function vectorPorEscalar(k: extended): clsVector;
            function normaUno(): extended;
            function normaDos(): extended;
            function normaInfinita(): extended;
            procedure mostrarVector();//método a quitar en versión final
    end;

implementation

    constructor clsVector.crear();
    begin
        orden:= 0;
        elementos[1]:= 0;
    end;
////////////////////////////////////////////////////////////////////////////////
    constructor clsVector.crear(ord: integer);
    begin
        orden:= ord;
        elementos[1]:= 0;
    end;
////////////////////////////////////////////////////////////////////////////////
    constructor clsVector.crear(ord: integer; elem: tVector);
    begin
        orden:= ord;
        elementos:= elem;
    end;
////////////////////////////////////////////////////////////////////////////////
    procedure clsVector.setOrden(ord: integer);
    begin
        orden:= ord;
    end;
////////////////////////////////////////////////////////////////////////////////
    function clsVector.getOrden(): integer;
    begin
        result:= orden;
    end;
////////////////////////////////////////////////////////////////////////////////
    procedure clsVector.setElementos(elem: tVector);
    begin
        elementos:= elem;
    end;
////////////////////////////////////////////////////////////////////////////////
    function clsVector.getElementos(): tVector;
    begin
        result:= elementos;
    end;
////////////////////////////////////////////////////////////////////////////////
    function clsVector.sumarVector(v: clsVector):clsVector;
    var
        i: integer;
        vec: tVector;
    begin
        for i:= 1 to orden do
            vec[i]:= elementos[i] + v.getElementos()[i];
        result:= clsVector.crear(orden,vec);
    end;
////////////////////////////////////////////////////////////////////////////////
    function clsVector.restarVector(v: clsVector):clsVector;
    var
        i: integer;
        vec: tVector;
    begin
        for i:= 1 to orden do
            vec[i]:= elementos[i] - v.getElementos()[i];
        result:= clsVector.crear(orden,vec);
    end;
////////////////////////////////////////////////////////////////////////////////
    function clsVector.vectorPorEscalar(k: extended): clsVector;
    var
        i: integer;
        vec: tVector;
    begin
        for i:= 1 to orden do
            vec[i]:= k * elementos[i];
        result:= clsVector.crear(orden,vec);
    end;
////////////////////////////////////////////////////////////////////////////////
    function clsVector.normaUno(): extended;
    var
        i: integer;
        suma: extended;
    begin
        suma:= 0;
        for i:= 1 to orden do
            suma:= suma + abs(elementos[i]);
        result:= suma;
    end;
////////////////////////////////////////////////////////////////////////////////
    function clsVector.normaDos(): extended;
    var
        i: integer;
        suma: extended;
    begin
        suma:= 0;
        for i:= 1 to orden do
            suma:= suma + power(elementos[i],2);
        result:= power(suma,1/2);
    end;
////////////////////////////////////////////////////////////////////////////////
    function clsVector.normaInfinita(): extended;
    var
        i: integer;
        max, aux: extended;
    begin
        max:= abs(elementos[1]);
        for i:= 2 to orden do
        begin
            aux:= abs(elementos[i]);
            if(aux>max)then
                max:= aux;
        end;
        result:= max;
    end;
////////////////////////////////////////////////////////////////////////////////
procedure clsVector.mostrarVector();//método a quitar en versión final
var
    i: integer;
begin
    //write('[ ');
    for i:= 1 to orden-1 do
        //write(elementos[i]:2:6,' , ');
    //writeln(elementos[orden]:2:6,' ]');
end;

end.

