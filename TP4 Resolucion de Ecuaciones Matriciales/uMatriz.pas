unit uMatriz;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils, math, uVector;
const
    maxOrden = 20;
type
    tMatriz = array [1..maxOrden, 1..maxOrden+1] of extended;

    clsMatriz = class

        private
            orden       : integer;
            elementos   : tMatriz;

            function clonarMatriz(): clsMatriz;
            function adjunta(a: clsMatriz; fila, columna: integer): clsMatriz;
            function detRecursivo(a: clsMatriz): extended;
            function matrizMenorK(ord: integer): clsMatriz;

        public
            constructor crear();
            constructor crear(ord: integer);
            constructor crear(ord: integer; elem: tMatriz);
            procedure setOrden(ord: integer);
            function getOrden(): integer;
            procedure setElementos(elem: tMatriz);
            function getElementos(): tMatriz;
            function sumarMatriz(b: clsMatriz): clsMatriz;
            function restarMatriz(b: clsMatriz): clsMatriz;
            function matrizPorEscalar(k: extended): clsMatriz;
            function normaUno(): extended;
            function normaDos(): extended;// Pendiente
            function normaInfinita(): extended;
            function normaFrobenius(): extended;
            function traspuesta(): clsMatriz;
            function iguales(b: clsMatriz): boolean;
            function simetrica(): boolean;// condición para Cholesky
            function diagonalDominante(): boolean;//condición para métodos abiertos
            function determinante(): extended;
            function matrizPorMatriz(b: clsMatriz): clsMatriz;
            function matrizPorVector(v: clsVector): clsVector;
            function condNySFactLU(): boolean;//condición necesaria y suficiente para factorización LU
            function definidaPositiva(): boolean;// condición para Cholesky
            procedure mostrarMatriz();//método a quitar en versión final

    end;

implementation
    constructor clsMatriz.crear();
    begin
        orden:=0;
        elementos[1,1]:=0;
    end;
////////////////////////////////////////////////////////////////////////////////
    constructor clsMatriz.crear(ord: integer);
    begin
        orden:= ord;
        elementos[1,1]:=0;
    end;
////////////////////////////////////////////////////////////////////////////////
    constructor clsMatriz.crear(ord: integer; elem: tMatriz);
    begin
        orden:= ord;
        elementos:=elem;
    end;
////////////////////////////////////////////////////////////////////////////////
    procedure clsMatriz.setOrden(ord: integer);
    begin
        orden:= ord;
    end;
////////////////////////////////////////////////////////////////////////////////
    function clsMatriz.getOrden(): integer;
    begin
        result:= orden;
    end;
////////////////////////////////////////////////////////////////////////////////
    procedure clsMatriz.setElementos(elem: tMatriz);
    begin
        elementos:= elem;
    end;
////////////////////////////////////////////////////////////////////////////////
    function clsMatriz.getElementos(): tMatriz;
    begin
        result:= elementos;
    end;
////////////////////////////////////////////////////////////////////////////////
    function clsMatriz.sumarMatriz(b: clsMatriz): clsMatriz;
    var
        i, j: integer;
        m: tMatriz;
    begin
        for i:= 1 to orden do
            for j:= 1 to orden do
                m[i,j]:= elementos[i,j]+ b.getElementos()[i,j];
        result:= clsMatriz.crear(orden, m);
    end;
////////////////////////////////////////////////////////////////////////////////
    function clsMatriz.restarMatriz(b: clsMatriz): clsMatriz;
    var
        i, j: integer;
        m: tMatriz;
    begin
        for i:= 1 to orden do
            for j:= 1 to orden do
                m[i,j]:= elementos[i,j]- b.getElementos()[i,j];
        result:= clsMatriz.crear(orden, m);
    end;
////////////////////////////////////////////////////////////////////////////////
    function clsMatriz.matrizPorEscalar(k: extended): clsMatriz;
    var
        i, j: integer;
        m: tMatriz;
    begin
        for i:= 1 to orden do
            for j:= 1 to orden do
                m[i,j]:= elementos[i,j]* k;
        result:= clsMatriz.crear(orden, m);
    end;
////////////////////////////////////////////////////////////////////////////////
    function clsMatriz.normaUno(): extended;
    var
        i, j : integer;
        max, suma: extended;
    begin
        max:= 0;
        for j:= 1 to orden do
        begin
            suma:=0;
            for i:=1 to orden do
                suma:= suma + abs(elementos[i,j]);
            if(suma>max)then
                max:= suma;
        end;
        result:= max;
    end;
////////////////////////////////////////////////////////////////////////////////
    function clsMatriz.normaDos(): extended;
    begin

    end;
////////////////////////////////////////////////////////////////////////////////
    function clsMatriz.normaInfinita(): extended;
    var
        i, j: integer;
        max, suma: extended;
    begin
        max:= 0;
        for i:= 1 to orden do
        begin
            suma:=0;
            for j:=1 to orden do
                suma:= suma + abs(elementos[i,j]);
            if(suma>max)then
                max:= suma;
        end;
        result:= max;
    end;
////////////////////////////////////////////////////////////////////////////////
    function clsMatriz.normaFrobenius(): extended;
    var
        i, j: integer;
        suma: extended;
    begin
        suma:= 0;
        for i:= 1 to orden do
            for j:=1 to orden do
                suma:= suma + power(elementos[i,j],2);
        result:= power(suma,1/2);
    end;
////////////////////////////////////////////////////////////////////////////////
    function clsMatriz.traspuesta(): clsMatriz;
    var
        i, j: integer;
        m: tMatriz;
    begin
        for i:= 1 to orden do
            for j:= 1 to orden do
                m[j,i]:= elementos[i,j];
        result:= clsMatriz.crear(orden,m);
    end;
////////////////////////////////////////////////////////////////////////////////
    function clsMatriz.iguales(b: clsMatriz): boolean;
    var
        i, j: integer;
        band: boolean;
    begin
        band:= true;
        if(orden=b.getOrden) then
        begin
            i:=1;
            while(i<=orden) and (band)do
            begin
                j:= 1;
                while(j<=orden) and (band)do
                begin
                    if(elementos[i,j]<>b.getElementos()[i,j]) then
                        band:= false
                    else
                        inc(j);
                end;
                inc(i);
            end;
        end
        else
            band:= false;
        result:= band;
    end;
////////////////////////////////////////////////////////////////////////////////
    function clsMatriz.simetrica(): boolean;
    begin
       result:= iguales(traspuesta());
    end;
////////////////////////////////////////////////////////////////////////////////
    function clsMatriz.diagonalDominante(): boolean;//condición para métodos abiertos
    var
        i, j: integer;
        band: boolean;
        aux, suma: extended;
    begin
        band:= true;
        i:=1;
        while(i <= orden) and (band) do
        begin
            aux:= abs(elementos[i,i]);
            suma:=0;
            for j:=1 to orden do
                if(i<>j)then
                    suma:= suma+ abs(elementos[i,j]);
            if(suma>aux) then
                band:= false
            else
                inc(i);
        end;
        result:= band;
    end;
////////////////////////////////////////////////////////////////////////////////
    function clsMatriz.clonarMatriz(): clsMatriz;
    begin
        result:= clsMatriz.crear(orden,elementos);
    end;
////////////////////////////////////////////////////////////////////////////////
    function clsMatriz.adjunta(a: clsMatriz; fila, columna: integer): clsMatriz;
    var
        i, j,n: integer;
        m: tMatriz;
    begin
        m:= a.getElementos();
        n:= a.getOrden();
        for i:=fila to n-1 do
            for j:= 1 to n do
                m[i,j]:= m[i+1,j];
        for j:=columna to n-1 do
            for i:= 1 to n-1 do
                m[i,j]:= m[i,j+1];
        result:= clsMatriz.crear(n-1,m);
    end;
////////////////////////////////////////////////////////////////////////////////
    function clsMatriz.detRecursivo(a: clsMatriz): extended;
    var
        j, n: integer;
        resultado: extended;
    begin
        resultado:=0;
        n:=a.getOrden();
        if(n=1)then
            resultado:= a.getElementos()[1,1]
        else
            if (n=2) then
                resultado:= a.getElementos()[1,1]*a.getElementos()[2,2] - a.getElementos()[1,2]*a.getElementos()[2,1]
            else
                if (n>2) then
                begin
                    for j:=1 to n do
                        resultado:= resultado + power(-1,j+1)*a.getElementos()[1,j]* detRecursivo(adjunta(a,1,j));
                end;
        result:= resultado;
    end;
////////////////////////////////////////////////////////////////////////////////
    function clsMatriz.determinante(): extended;
    var
        aux: clsMatriz;
    begin
        aux:= clonarMatriz();
        result:= detRecursivo(aux);
    end;
////////////////////////////////////////////////////////////////////////////////
    function clsMatriz.matrizPorMatriz(b: clsMatriz): clsMatriz;
    var
        i, j, k: integer;
        m: tMatriz;
        suma: extended;
    begin
        for i:=1 to orden do
        begin
            for k:= 1 to orden do
            begin
                suma:=0;
                for j:=1 to orden do
                    suma:= suma+ elementos[i,j]*b.getElementos()[j,k];
                m[i,k]:= suma;
            end;
        end;
        result:= clsMatriz.crear(orden, m);
    end;
////////////////////////////////////////////////////////////////////////////////
    function clsMatriz.matrizPorVector(v: clsVector): clsVector;
    var
        i, j: integer;
        vec: tVector;
        suma:extended;
    begin
        for i:=1 to orden do
        begin
            suma:=0;
            for j:=1 to orden do
                suma:= suma+(elementos[i,j]*v.getElementos()[j]);
            vec[i]:= suma;
        end;
        result:= clsVector.crear(orden, vec);
    end;
////////////////////////////////////////////////////////////////////////////////
    function clsMatriz.matrizMenorK(ord: integer): clsMatriz;
    var
        i, j: integer;
        m: tMatriz;
    begin
        for i:=1 to ord do
            for j:= 1 to ord do
                m[i,j]:= elementos[i,j];
        result:= clsMatriz.crear(ord, m);
    end;

////////////////////////////////////////////////////////////////////////////////
    function clsMatriz.condNySFactLU(): boolean;//condición necesaria y suficiente para factorización LU
    var
        i, j: integer;
        m: clsMatriz;
        band: boolean;
        aux: extended;
    begin
        i:=1;
        band:= true;
        while (i<= orden) and (band) do
        begin
            aux:= detRecursivo(matrizMenorK(i));
            if(aux=0) then
                band:= false
            else
                inc(i);
        end;
        result:= band;
    end;

////////////////////////////////////////////////////////////////////////////////
    function clsMatriz.definidaPositiva(): boolean;// condición para Cholesky
    var
        i, j: integer;
        m: clsMatriz;
        band: boolean;
        aux: extended;
    begin
        i:=1;
        band:= true;
        while (i<= orden) and (band) do
        begin
            aux:= detRecursivo(matrizMenorK(i));
            if(aux<=0) then
                band:= false
            else
                inc(i);
        end;
        result:= band;
    end;
////////////////////////////////////////////////////////////////////////////////
    procedure clsMatriz.mostrarMatriz();//método a quitar en versión final
    var
        i, j: integer;
    begin
        for i:=1 to orden do
        begin
            for j:=1 to orden do
                write('  ', elementos[i,j]:2:6,'  ');
            writeln();
        end;
    end;

end.

