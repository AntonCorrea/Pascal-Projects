unit uPolinomio;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils , math, uComplejo, uRacional;

const
    maxGrado  = 1000;
    maxIter: integer=500;
    incParaCotas: extended = 1; //incremento para L de Laguerre y Newton

type

    tArray = array [0..maxGrado] of extended;
    tListaImag = array [0..maxGrado] of clsComplejo;
    tListInt = array [0..maxGrado] of integer;
    tListRac = array [0..maxGrado] of clsRacional;

    clsPolinomio = class
    private

        gradoPol     : integer;
        coeficientes : tArray;
        procedure setCoeficiente(pos: integer; valor: extended);
        function getCoeficiente(pos: integer):extended;
        procedure setGradoPol(Valor: integer);
        function getGradoPol():integer;
        procedure invertirArray(var Vec : tArray);
        procedure prodEscalar(valor: integer; var vec: tArray; tam: integer);
        function evaluarPolEnMenosT(vec: tArray; tam: integer):tArray;
        function todosPositivos(vec: tArray; tam: integer): boolean;
        function lagrange(vec: tArray; tam: integer): extended;
        function laguerre(vec : tArray; tam: integer): extended;
        function newton(vec: tArray; tam: integer): extended;
        procedure hornerDoble(b:extended;var p:extended; var dp:extended);
        procedure hornerCuadDoble(r,s: extended; var b,c: tArray);
        function todosEnteros(vec: tArray; tam: integer):boolean;
        procedure divisores(n: integer; var vec: tListInt; var cant: integer);
        procedure formulaCuadratica(vec: tArray; var x1,x2: clsComplejo);


    public

        constructor crear();
        constructor crear(grad: integer);
        constructor crear(grad: integer; pol: tArray);
        constructor cargarPolinomio(); //AUXULIAR .. quitar en la version final
        procedure setCoeficientes(pol: tArray);
        function getCoeficientes():tArray;
        function clonarPol():clsPolinomio;
        function evaluarPol(x: extended): extended;
        procedure horner(valor : extended; var cociente: clsPolinomio; var resto: extended);
        procedure ruffini(a: extended; b: extended; var cociente: clsPolinomio; var resto: extended);
        procedure hornerCuadratico(r, s: extended; var cociente: clsPolinomio; var resto: tArray);// P(x)/ x^2+rx+s
        procedure posRaicesEnteras(var vec: tListInt; var tam: integer; var band: boolean);// bandera pasa saber si se pudo calcular o no
        procedure posRaicesRacionales(var vec: tListRac; var tam: integer; var band: boolean);// idem arriba
        procedure cotasLagrange(var cotas: tArray);
        procedure cotasLaguerre(var cotas: tArray);
        procedure cotasNewton(var cotas: tArray);
        function newtonPol(x1: extended; error: extended): extended;
        procedure bairstow(r,s,e: extended; var raices: tListaImag);
        procedure mostrarPolinomio(); // AUXULIAR .. quitar en la version final
        procedure mostrarVector(vec: tArray; tam: integer);// AUXULIAR .. quitar en la version final



           property coeficiente[pos : integer] : extended read getCoeficiente write setCoeficiente;
           property grado                      : integer read getGradoPol write setGradoPol;
    end;

implementation

    constructor clsPolinomio.crear();
    begin
        gradoPol:= 0;
        coeficientes[0]:= 0;
    end;
{******************************************************************************}
    constructor clsPolinomio.crear(grad:integer);
    begin
        gradoPol:= grad;
        coeficientes[0]:= 0;
    end;
{******************************************************************************}
    constructor clsPolinomio.crear(grad: integer; pol: tArray);
    begin
        gradoPol:= grad;
        coeficientes:= pol;
    end;
{******************************************************************************}
    constructor clsPolinomio.cargarPolinomio(); //AUXULIAR .. quitar en la version final
    var
        coef: extended;
        i:integer;
    begin
        for i:= grado downto 0 do
        begin
            write('coeficiente X^',i,'= ');
            readln(coef);
            coeficiente[i] := coef;
        end;
        writeln();
    end;
{******************************************************************************}
    procedure clsPolinomio.setCoeficientes(pol: tArray);
    begin
        coeficientes := pol;
    end;
{******************************************************************************}
    function clsPolinomio.getCoeficientes():tArray;
    begin
        result:= coeficientes;
    end;
{******************************************************************************}
    procedure clsPolinomio.setCoeficiente(pos: integer; valor: extended);
    begin
        coeficientes[pos]:= valor;
    end;
{******************************************************************************}
    function clsPolinomio.getCoeficiente(pos: integer): extended;
    begin
        result:= coeficientes[pos];
    end;
{******************************************************************************}
    procedure clsPolinomio.setGradoPol(valor: integer);
    begin
        gradoPol:= valor;
    end;
{******************************************************************************}
    function clsPolinomio.getGradoPol(): integer;
    begin
        result:= gradoPol;
    end;
{******************************************************************************}
    function clsPolinomio.ClonarPol(): clsPolinomio;
    var
        aux: clsPolinomio;
    begin
        aux:= clsPolinomio.crear(gradoPol,coeficientes);
        clonarPol:= aux;
    end;
{******************************************************************************}
    procedure clsPolinomio.invertirArray( var Vec : tArray);
       var
         i : integer;
       begin
         for i:= 0 to grado do
           vec[i]:= coeficiente[grado-i];
       end;
{******************************************************************************}
    procedure clsPolinomio.prodEscalar(valor: integer; var vec: tArray; tam: integer);
       var
         i:integer;
       begin
          for i:=0 to tam-1 do
              vec [i]:= valor * vec[i];
       end;
{******************************************************************************}
    function clsPolinomio.evaluarPolEnMenosT(vec: tArray; tam: integer):tArray;
    var
        i : integer;
    begin
        for i := 0 to tam-1 do
            if(i mod 2 <> 0)then
                vec[i]:= vec[i]*(-1);

        result := vec;
    end;
{******************************************************************************}
    function clsPolinomio.todosPositivos(vec: tArray; tam: integer): boolean;
    var
        i: integer;
        band: boolean;
    begin
        band:= true;
        i:=0;
        while ((i<tam) and band) do
            if(vec[i]<0) then
                band:= false
            else
                inc(i);
        result:= band;
    end;
{******************************************************************************}
    procedure clsPolinomio.divisores(n: integer; var vec: tListInt; var cant: integer);
    var
        i,j: integer;
    begin
        j:=0;
        for i:=1 to n do
        begin
            if (n mod i = 0) then
                begin
                    vec[j]:= i;
                    j:=j+1;
                end;
        end;
        for i:=0 to j do
        begin
            vec[i+j] := vec[i]*(-1);
        end;
        cant:=j*2;
    end;
{******************************************************************************}
    function clsPolinomio.lagrange(vec: tArray; tam: integer): extended;
    var
        M, cota: extended;
        k, i: integer;
        bandera: boolean;
    begin
        if(vec[0]<0)then
        begin
            prodEscalar(-1,vec,tam);
        end;
        i:= 0;
        cota:= -1;
        bandera:= false;
        while ((i<= tam-1) and (not bandera)) do
        begin
            if(vec[i]<0)then{si el polinomio tiene al menos un negativo}
            begin
                bandera:=true;
            end
            else
                inc(i);
        end;

        if (bandera = true) then {hay al menos un coeficiente negativo}
            begin
                k := i;
                M:= abs(vec[k]);
                for i:=1 to tam-1 do{el mayor coeficiente negatico en valor abs}
                begin
                    if ((vec[i]<0) and (abs(vec[i])>M))then
                    begin
                        M:=abs(vec[i]);
                    end;
                end;
                cota:= 1+power((M/vec[0]),1/k);
            end;
        lagrange:= cota;
    end;
{******************************************************************************}
    function clsPolinomio.laguerre(vec : tArray; tam: integer): extended;
    var
        i: integer;
        L, resto: extended;
        aux: tArray;
        polAux: clsPolinomio;
        bandera: boolean;
        bandera2: boolean;
        cociente: clsPolinomio;
    begin
        if(vec[tam-1]<0)then
        begin
            prodEscalar(-1,vec,tam);
        end;
        if(not todosPositivos(vec,tam))then
        begin
            polAux := clsPolinomio.crear(grado);
            polAux.coeficientes := vec;
            L := 1;
            bandera := false; // si todos son positivos bandera = true
            while (not bandera) do
            begin
                polAux.horner(-L,cociente, resto);
                aux:=cociente.coeficientes;
                bandera2:= false; //busca coeficientes negativos
                i:=0;
                if(resto<= 0) then
                bandera2:= true;
                while((i<=cociente.grado) and (not bandera2)) do
                    if(aux[i]< 0)then
                        begin
                        bandera2:= true;
                        end
                    else
                        inc(i);
                if bandera2 then
                    L:= L + incParaCotas
                else
                    bandera := true;
            end;
            result := L;
        end
        else
            result:= -1;
    end;
{******************************************************************************}
    function clsPolinomio.newton(vec: tArray; tam: integer): extended;
    var
        L,resto : extended;
        polAux, cociente :clsPolinomio;
        bandera : boolean;
    begin
        if(vec[tam-1]<0)then
        begin
            prodEscalar(-1,vec,tam);
        end;
        if(not todosPositivos(vec,tam))then
        begin
            polAux:= clsPolinomio.crear(tam-1);
            polAux.coeficientes := vec;
            L :=1;
            bandera := false;
            while (not bandera) do
            begin
                polAux.horner(-L,cociente,resto);
                while(resto>0)and(cociente.grado > 0)do
                begin
                    cociente.horner(-L,cociente,resto);
                    //cociente := cociente2.clonarPol();
                end;
                if (resto<= 0) then
                    L:= L + incParaCotas
                else
                    bandera := true;
            end;
            result := L;
        end
        else
            result:= -1;
    end;
{******************************************************************************}
    procedure clsPolinomio.hornerDoble(b:extended;var p:extended; var dp:extended);
    var
        i:integer;
    Begin
        p:= coeficiente[grado];
        dp:=0;
        for i:=(grado-1) downto 0 do
        Begin
            dp:= p + b*dp;
            p:= coeficiente[i]+b*p;
        end;
    end;
{******************************************************************************}
    procedure clsPolinomio.hornerCuadDoble(r,s: extended; var b,c: tArray);
    var
        i: integer;
    begin
        b[grado]:=coeficiente[grado];
        b[grado-1]:=coeficiente[grado-1]+ r*b[grado];

        c[grado]:=b[grado];
        c[grado-1]:=b[grado-1]+ r*c[grado];

        for i:=grado-2 downto 1 do
        begin
            b[i]:= coeficiente[i]+ r*b[i+1]+s*b[i+2];
            c[i]:= b[i]+ r*c[i+1]+s*c[i+2];
        end;
        b[0]:= coeficiente[0]+s*b[2];
        c[0]:= b[0]+ s*c[2];
    end;
{******************************************************************************}
    function clsPolinomio.todosEnteros(vec: tArray; tam: integer):boolean;
    var
        i : integer;
        band : boolean = true;
    begin
        i := 0;
        while(i < tam) and (band) do
        begin
            if(vec[i] <> trunc(vec[i]))then
                band := false;
            inc(i);
        end;
        result := band;
    end;
{******************************************************************************}
    procedure clsPolinomio.formulaCuadratica(vec: tArray; var x1,x2: clsComplejo);
    var
        disc,aux1,aux2: extended;
        real: boolean;
    begin
        real:=true;
        disc:= power(vec[1],2)-4*vec[2]*vec[0];
        if (disc<0) then
        begin
            real:= false;
            disc:= disc*(-1);
        end;
        if real then
            begin
                aux1:= (- vec[1]+power(disc,0.5))/(2*vec[2]);
                aux2:= (- vec[1]-power(disc,0.5))/(2*vec[2]);
            end
        else
            begin
                aux1:= (-vec[1])/(2*vec[2]);
                aux2:= power(disc,0.5)/(2*vec[2]);
            end;
        if (real) then
            begin
                x1:= clsComplejo.crear(aux1,0);
                x2:= clsComplejo.crear(aux2,0);
            end
        else
            begin
                x1:= clsComplejo.crear(aux1,aux2);
                x2:= clsComplejo.crear(aux1,-aux2);
            end;
    end;
{******************************************************************************}
    function clsPolinomio.evaluarPol(x: extended): extended;
    var
        i: integer;
        b: extended;
    begin
        b:= coeficiente[grado];
        for i:= grado - 1 downto 0 do
        begin
            b:= coeficiente[i] + x * b;
        end;
        result:= b;
    end;
{******************************************************************************}
    procedure clsPolinomio.horner(valor : extended; var cociente: clsPolinomio; var resto: extended);
    var
        i : integer;
    begin
        cociente:= clsPolinomio.crear(grado-1);
        cociente.coeficiente[grado-1]:= coeficiente[grado];
        for i := grado-2 downto 0 do
        begin
            cociente.coeficiente[i]:= coeficiente[i+1] + (-1)*valor * cociente.coeficiente[i+1];
        end;
        resto:= cociente.coeficiente[0] * (-1)*valor + coeficiente[0];
    end;
{******************************************************************************}
    procedure clsPolinomio.ruffini(a: extended; b: extended; var cociente: clsPolinomio; var resto: extended);
       var
         aux: extended;
         i: integer;
       begin
           aux:= b/a;
           cociente:= clsPolinomio.crear(grado - 1);
           horner(aux, cociente, resto);
           for i:=0 to cociente.grado - 1 do
               cociente.coeficiente[i]:=cociente.coeficiente[i]/a;
       end;
{******************************************************************************}
{division por polinomio x^2+rx+s }
    procedure clsPolinomio.hornerCuadratico(r, s: extended; var cociente: clsPolinomio; var resto: tArray);
    var
        i : integer;
    begin
        cociente := clsPolinomio.Crear(grado -2);
        cociente.coeficiente[grado] := coeficiente[grado];
        cociente.coeficiente[grado-1] := (-1)*r*cociente.coeficiente[grado] + coeficiente[grado-1];
        for i:=grado-2 downto 1 do
        begin
            cociente.coeficiente[i] := (-1)*r*cociente.coeficiente[i+1]+(-1)*s*cociente.coeficiente[i+2]+coeficiente[i];
        end;
    cociente.coeficiente[0]:= (-1)* s * cociente.coeficiente[2]+ coeficiente[0];
    resto[0]:=cociente.coeficiente[0];
    resto[1]:=cociente.coeficiente[1];
    for i:= 0 to grado-2 do
        cociente.coeficiente[i]:= cociente.coeficiente[i+2];
    end;
{******************************************************************************}
    procedure clsPolinomio.posRaicesEnteras(var vec: tListInt; var tam: integer; var band: boolean);// bandera pasa saber si se pudo calcular o no
    var
        i,j,n: integer;
    begin
        band:= todosEnteros(coeficientes,grado + 1);
        if band then
            begin
                j:=0;
                n:= trunc(abs(coeficiente[0]));
                divisores(n,vec,tam);
            end
        else
            tam:=0;
end;
{******************************************************************************}
    procedure clsPolinomio.posRaicesRacionales(var vec: tListRac; var tam: integer; var band: boolean);
    var
        divA0, divAn: tListInt;
        tamA0, tamAn, i, j, k: integer;
        a0, an: integer;
        aux: clsRacional;
        esta: boolean;
    begin
        band:= todosEnteros(coeficientes,grado + 1);
        if band then
            begin
                a0:= trunc(abs(coeficiente[0]));
                an:= trunc(abs(coeficiente[grado]));
                divisores(a0,divA0,tamA0);// numeradores
                divisores(an,divAn,tamAn);// denominadores
                tam:=0;
                for i:= 0 to tamA0 do
                    for j:= 0 to tamAn do
                    begin
                        aux:= clsRacional.crear(divA0[i],divAn[j]);
                        esta:= false;
                        if (aux.getValorReal()= trunc(aux.getValorReal())) then
                            esta:= true;
                        k:=0;
                        while (k<tam) and (not esta) do
                            begin
                                if (not aux.iguales(vec[k])) then
                                    begin
                                        inc(k);
                                    end
                                else
                                    esta:= true;
                            end;
                        if (not esta) then
                            begin
                                vec[k]:= aux;
                                inc(tam);
                            end;
                    end;
            end
        else
            tam:= 0;
    end;
{******************************************************************************}
    {LAGRANGE
    cotas es vector de tam 4:
        cotas[0]: almacena cota superior positiva o -1 en su defecto
        cotas[1]: almacena cota inferior positiva o -1 en su defecto
        cotas[2]: almacena cota superior negativa o 1 en su defecto
        cotas[3]: almacena cota inferior negativa o 1 en su defecto}
    procedure clsPolinomio.cotasLagrange(var cotas: tArray);
    var
        aux,aux2:tArray;
    begin
        aux:=coeficientes;//aux es el vector sin cambio
        invertirArray(aux2);  //aux2 es el vector invertido
{--------------------- calculo de cota superior positiva ----------------------}
        cotas[0]:= lagrange(aux2,grado+1); //tamaño del vector es grado+1
{--------------------- calculo de cota inferior positiva ----------------------}
        if( cotas[0]>0) then
            begin
                cotas[1]:= lagrange(aux,grado+1);//tamaño del vector es grado+1
                if (cotas[1] > 0) then
                    cotas[1]:= 1/cotas[1]
                else
                    cotas[1]:= -1;
            end
        else
            begin
                cotas[0]:= -1;
                cotas[1]:= -1;
            end;
{--------------------- calculo de cota superior negativa ----------------------}
        aux:= evaluarPolEnMenosT(aux,grado+1);//tamaño del vector es grado+1
        cotas[2]:=lagrange(aux,grado+1);
{--------------------- calculo de cota inferior negativa ----------------------}
        if( cotas[2]>0) then
            begin
                aux2:= evaluarPolEnMenosT(aux2,grado+1); //tamaño del vector es grado+1
                cotas[3]:= lagrange(aux2,grado+1); //tamaño del vector es grado+1
                cotas[2]:= (-1)/cotas[2];
                if (cotas[3]>0) then
                    cotas[3]:= (-1)*cotas[3]
                else
                    cotas[3]:=1;
            end
        else
            begin
                cotas[2]:= 1;
                cotas[3]:= 1;
            end;
    end;
{******************************************************************************}
    {LAGUERRE
    cotas es vector de tam 4:
        cotas[0]: almacena cota superior positiva o -1 en su defecto
        cotas[1]: almacena cota inferior positiva o -1 en su defecto
        cotas[2]: almacena cota superior negativa o 1 en su defecto
        cotas[3]: almacena cota inferior negativa o 1 en su defecto}
    procedure clsPolinomio.cotasLaguerre(var cotas: tArray);
    var
        aux,aux2:tArray;
    begin
        aux:=coeficientes;//aux es el vector sin cambio
        invertirArray(aux2);  //aux2 es el vector invertido
{--------------------- calculo de cota superior positiva ----------------------}
        cotas[0]:= laguerre(aux,grado+1); //tamaño del vector es grado+1
{--------------------- calculo de cota inferior positiva ----------------------}
        if( cotas[0]>0) then
            begin
                cotas[1]:= laguerre(aux2,grado+1);//tamaño del vector es grado+1
                if (cotas[1] > 0) then
                    cotas[1]:= 1/cotas[1]
                else
                    cotas[1]:= -1;
            end
        else
            begin
                cotas[0]:= -1;
                cotas[1]:= -1;
            end;
{--------------------- calculo de cota superior negativa ----------------------}
        aux2:= evaluarPolEnMenosT(aux2,grado+1);//tamaño del vector es grado+1
        cotas[2]:=laguerre(aux2,grado+1);
{--------------------- calculo de cota inferior negativa ----------------------}
        if( cotas[2]>0) then
            begin
                aux:= evaluarPolEnMenosT(aux,grado+1); //tamaño del vector es grado+1
                cotas[3]:= laguerre(aux,grado+1); //tamaño del vector es grado+1
                cotas[2]:= (-1)/cotas[2];
                if (cotas[3]>0) then
                    cotas[3]:= (-1)*cotas[3]
                else
                    cotas[3]:=1;
            end
        else
            begin
                cotas[2]:= 1;
                cotas[3]:= 1;
            end;
    end;
{******************************************************************************}
    {NEWTON
    cotas es vector de tam 4:
        cotas[0]: almacena cota superior positiva o -1 en su defecto
        cotas[1]: almacena cota inferior positiva o -1 en su defecto
        cotas[2]: almacena cota superior negativa o 1 en su defecto
        cotas[3]: almacena cota inferior negativa o 1 en su defecto}
    procedure clsPolinomio.cotasNewton(var cotas: tArray);
    var
        aux,aux2:tArray;
    begin
        aux:=coeficientes;//aux es el vector sin cambio
        invertirArray(aux2);  //aux2 es el vector invertido
{--------------------- calculo de cota superior positiva ----------------------}
        cotas[0]:= newton(aux,grado+1); //tamaño del vector es grado+1
{--------------------- calculo de cota inferior positiva ----------------------}
        if( cotas[0]>0) then
            begin
                cotas[1]:= newton(aux2,grado+1);//tamaño del vector es grado+1
                if (cotas[1] > 0) then
                    cotas[1]:= 1/cotas[1]
                else
                    cotas[1]:= -1;
            end
        else
            begin
                cotas[0]:= -1;
                cotas[1]:= -1;
            end;

{--------------------- calculo de cota superior negativa ----------------------}
        aux2:= evaluarPolEnMenosT(aux2,grado+1);//tamaño del vector es grado+1
        cotas[2]:=newton(aux2,grado+1);
{--------------------- calculo de cota inferior negativa ----------------------}
        if( cotas[2]>0) then
            begin
                aux:= evaluarPolEnMenosT(aux,grado+1); //tamaño del vector es grado+1
                cotas[3]:= newton(aux,grado+1); //tamaño del vector es grado+1
                cotas[2]:= (-1)/cotas[2];
                if (cotas[3]>0) then
                    cotas[3]:= (-1)*cotas[3]
                else
                    cotas[3]:=1;
            end
        else
            begin
                cotas[2]:= 1;
                cotas[3]:= 1;
            end;
    end;
{******************************************************************************}
    function clsPolinomio.newtonPol(x1: extended; error: extended): extended;
    var
    p,dp,x0:extended;
    Begin
        Repeat
            x0:=x1;
            hornerDoble(x0,p,dp);
            x1:=x0-(p/dp)
        until (abs(x1-x0)<error) and (abs(evaluarPol(x1))<error);//((abs(x-xn)<Err) and (abs(Fun.f(x))< Err)) or (cont>maxIter)
        NewtonPol:=x1;
    end;
{******************************************************************************}
    procedure clsPolinomio.bairstow(r,s,e: extended; var raices: tListaImag);
    var
        polAux: clsPolinomio;
        b,c,factor,aux: tArray;
        det,er,es,dr,ds: extended;
        iter, i, n: integer;
    begin
        polAux:= clonarPol();
        n:= grado;
        iter:= 0;
        er:=1;
        es:=1;
        while ((n>2) and (iter<=maxIter)) do
        begin
            iter:= 0;
            repeat
                inc(iter);
                polAux.hornerCuadDoble(r,s,b,c);
                //write('vector B: ');
                //mostrarVector(b,grado);
                //write('vector C: ');
                //mostrarVector(c,grado);
                //readln();
                det:= c[2]*c[2]-c[1]*c[3];
                if(det<>0)then
                    begin
                        dr:= (-b[1]*c[2]+b[0]*c[3])/det;
                        ds:= (-b[0]*c[2]+b[1]*c[1])/det;
                        r:= r + dr;
                        s:= s + ds;
                        if (r<>0) then er:=abs(dr/r);
                        if (s<>0) then es:=abs(ds/s);
                    end
                else
                    begin
                        r:= r + 1;
                        s:= s + 1;
                        iter:= 0;
                    end;
            until ((er<e) and (es<e)) or (iter>maxIter);
            //writeln('R: ',r, ' y S: ',s);
            factor[0]:=-s;factor[1]:=-r;factor[2]:=1;
            formulaCuadratica(factor,raices[n],raices[n-1]);
            n:=n-2;
            polAux.hornerCuadratico(-r,-s,polAux,aux);
            //polAux.mostrarPolinomio();
            //writeln('resto: ', aux[1],'X + ( ', aux[0],' )');
            //writeln();
        end;
        if iter<maxIter then
            begin
                if (n=2) then
                    begin
                        polAux.formulaCuadratica(polAux.coeficientes,raices[n],raices[n-1]);
                    end
                else
                    begin
                        raices[n]:= clsComplejo.crear(-polAux.coeficiente[0]/polAux.coeficiente[1],0);
                    end;
            end;
    end;
{******************************************************************************}
    procedure clsPolinomio.mostrarPolinomio(); //AUXULIAR .. quitar en la version final
    var
        i:integer;
    begin
        write(coeficiente[grado]:2:6,' X^',grado);
        for i := grado-1 downto 1 do
        begin
            if (coeficiente[i]<0)then
                write(' - ',abs(coeficiente[i]):2:6,' X^',i,'')
            else
                write(' + ',coeficiente[i]:2:6,' X^',i,'');
        end;
        i:=i-1;
        if (coeficiente[0]<0)then
            write(' - ',abs(coeficiente[0]):2:6)
        else
            write(' + ',coeficiente[0]:2:6);
        writeln();
    end;
{******************************************************************************}
    procedure clsPolinomio.mostrarVector(vec: tArray; tam: integer);// AUXULIAR .. quitar en la version final
    var
        i: integer;
    begin
        write('[ ',vec[tam-1]:2:6);
        for i:=tam-2 downto 0 do
            write(' , ',vec[i]:2:6);
        writeln(' ]');
    end;

end.

