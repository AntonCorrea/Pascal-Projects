unit uSistLineales;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils, math, uMatriz, uVector;
const
  MaxIte=100;
type
    clsSistLineales = class

        private

            A: clsMatriz;
            b: clsVector;
            function matrizAmpliada(): tMatriz;
            function sustRegresiva(m: tMatriz; n: integer): clsVector;
            function matrizAmpliadaM(r:clsVector): tMatriz;
            function gaussM(r:clsVector): clsVector;

        public

            constructor crear(m: clsMatriz; v: clsVector);
            function gauss(op:integer): clsVector;
            function gaussJordan(op:integer): clsVector;
            function croutL1U(): clsVector;
            function choleskyU(): clsVector;
            function gaussSeidel(x0: clsVector; e: extended): clsVector;
            function jacobi(x0: clsVector; e: extended): clsVector;
            function relajamiento(x0: clsVector; e: extended): clsVector;
            function mejoramiento(x0: clsVector; e: extended): clsVector;
            function sor(x: clsVector; e: extended; w: extended): clsVector;
            Procedure MenuPivot(var ma: tMatriz;i:integer;var vec:tVectorI;op:integer);
            procedure pivoteo_parcial(var ma: tMatriz;i:integer);
            Procedure pivoteo_simple(var ma: tMatriz;i:integer);
            Procedure pivoteo_completo(var ma: tMatriz;i:integer;var vec:tVectorI);
            Procedure mostrar_matrizAmpliada(m:tMatriz);
            Procedure CarcarVectorIndice(var vec:tVectorI);
            function ordenar(aux:clsVector;vec:tVectorI): clsVector;
            function calcDeter(): extended;

    end;

implementation
    constructor clsSistLineales.crear(m: clsMatriz; v: clsVector);
    begin
        A:= m;
        b:= v;
    end;
function clsSistLineales.calcDeter(): extended;
var
   d:extended;
begin
    d:=A.determinante();
    result:=d;
end;
////////////////////////////////////////////////////////////////////////////////
function clsSistLineales.matrizAmpliadaM(r:clsVector): tMatriz;
var
    i,n: integer;
    m: tMatriz;
begin
    m:= A.getElementos();
    n:= A.getOrden();
    for i:=1 to n do
        m[i,n+1]:= r.getElementos()[i];
    result:= m;
end;
////////////////////////////////////////////////////////////////////////////////
    function clsSistLineales.matrizAmpliada(): tMatriz;
    var
        i,n: integer;
        m: tMatriz;
    begin
        m:= A.getElementos();
        n:= A.getOrden();
        for i:=1 to n do
            m[i,n+1]:= b.getElementos()[i];
        result:= m;
    end;
////////////////////////////////////////////////////////////////////////////////
    function clsSistLineales.sustRegresiva(m: tMatriz; n: integer): clsVector;
    var
        i, j: integer;
        vec: tVector;
        suma: extended;
    begin
        vec[n]:= m[n,n+1]/m[n,n];
        for i:=n-1 downto 1 do
        begin
            suma:=0;
            for j:=i+1 to n do
                suma:= suma + m[i,j]*vec[j];
            vec[i]:= (m[i,n+1] - suma)/ m[i,i];
        end;
        result:= clsVector.crear(n,vec);
    end;
////////////////////////////////////////////////////////////////////////////////
function clsSistLineales.ordenar(aux:clsVector;vec:tVectorI): clsVector;
var
v:tVector;
p,i,j,n:integer;
aux1:extended;
Begin
  v:=aux.getElementos();
  n:=aux.getOrden();
//  for i:=1 to 2 do
//      writeln('v[',i,']:',v[i]);
  for i:=1 to n-1 do
      for j:=1 to n Do
          if i<>vec[j] then
             begin
                 p:=vec[j];
                 vec[j]:=i;
                 vec[p]:=p;
                 //writeln('j:',j);
                 aux1:=v[j];
                 //writeln('aux:',aux1);
                 v[j]:=v[i];
                 //writeln('v[',j,']:',v[j]);
                 v[i]:=aux1;
                 //writeln('v[',i,']:',v[i]);

             end;
  result:=clsVector.crear(n,v);
End;
////////////////////////////////////////////////////////////////////////////////
    function clsSistLineales.gauss(op:integer): clsVector;
    var
        ma: tMatriz;
        i, j, k, n: integer;
        mult: extended;
        vec:tVectorI;
        aux,aux1:clsVector;
    begin
        CarcarVectorIndice(vec);
        ma:= matrizAmpliada();
        n:= A.getOrden();
        for k:=1 to n-1 do// n etapas
        begin
            MenuPivot(ma,k,vec,op);
            //mostrar_matrizAmpliada(ma);
            for i:= k+1 to n do
            begin
                mult:= ma[i,k]/ma[k,k];
                ma[i,k]:= 0;
                for j:=k+1 to n+1 do
                    ma[i,j]:= ma[i,j]-mult*ma[k,j];
            end;
        end;
        //al final de jordan,gaussM,
        aux:= sustRegresiva(ma,n);
        if (op=3) then
        begin
        	aux1:=ordenar(aux,vec);
        	result:=aux1;
        end
        else
        	result:= aux;
        //
    end;
////////////////////////////////////////////////////////////////////////////////
    function clsSistLineales.gaussJordan(op:integer): clsVector;
    var
        ma: tMatriz;
        i, j, k, n: integer;
        mult: extended;
        vec:tVectorI;
        aux:clsVector;
    begin
        CarcarVectorIndice(vec);
        ma:= matrizAmpliada();
        n:= A.getOrden();
        for k:=1 to n do// n etapas
        begin
            MenuPivot(ma,k,vec,op);
            for i:= 1 to n do
                if (i<>k) then
                begin
                    mult:= ma[i,k]/ma[k,k];
                    for j:=k to n+1 do
                        ma[i,j]:= ma[i,j]-mult*ma[k,j];
                end;
        end;
        aux:= sustRegresiva(ma,n);
        aux:=ordenar(aux,vec);
        result:=aux;
    end;
////////////////////////////////////////////////////////////////////////////////
    function clsSistLineales.croutL1U(): clsVector;
    var
        ma: tMatriz;
        i, j, k, n, p: integer;
        suma: extended;
    begin
        ma:= matrizAmpliada();
        n:= A.getOrden();
        for k:=1 to n do// n etapas
        begin
            for j:= k to n+1 do
            begin
                suma:=0;
                if (k>1) then
                    for p:= 1 to k-1 do
                        suma:= suma + ma[k,p]*ma[p,j];
                ma[k,j]:= ma[k,j] - suma;
            end;
            for i:= k+1 to n do
            begin
                suma:=0;
                if (k>1) then
                    for p:= 1 to k-1 do
                        suma:= suma + ma[i,p]*ma[p,k];
                ma[i,k]:= (ma[i,k] - suma)/ma[k,k];
            end;
        end;
        result:= sustRegresiva(ma,n);
    end;
////////////////////////////////////////////////////////////////////////////////
    function clsSistLineales.choleskyU(): clsVector;
    var
        ma: tMatriz;
        i, j, k, n, p: integer;
        suma: extended;
    begin
        ma:= matrizAmpliada();
        n:= A.getOrden();
        for k:=1 to n do// n etapas
        begin
            //pivoteo
            suma:=0;
            for i:=1 to k-1 do
                suma:= suma + power(ma[i,k],2);
            ma[k,k]:= power(ma[k,k]-suma, 1/2);
            for j:= k+1 to n+1 do
            begin
                suma:=0;
                for i:=1 to k-1 do
                    suma:= suma + ma[i,k]*ma[i,j];
                ma[k,j]:=(ma[k,j]-suma)/ma[k,k];
            end;
        end;
        result:= sustRegresiva(ma,n);
    end;
////////////////////////////////////////////////////////////////////////////////
    function clsSistLineales.gaussSeidel(x0: clsVector; e: extended): clsVector;
    begin

    end;
////////////////////////////////////////////////////////////////////////////////
function clsSistLineales.jacobi(x0: clsVector; e: extended): clsVector;
        var
            xk:tVector;
            r,xtemp:clsVector;
            iter, i, j: Integer;
            d: extended;
    begin
        iter:=0;
        xtemp := clsVector.crear();
        Repeat
          iter:=iter+1;
          xtemp.setElementos(x0.getElementos());
            for i:=1 to x0.getOrden() do
          Begin
              xk[i]:= b.getElementos()[i];
              for j:=i+1 to x0.getOrden() do
                 xk[i]:=xk[i]- A.getElementos[i,j]*xtemp.getElementos()[j];
              for j:= 1 to (i-1) do
                xk[i]:=xk[i]- A.getElementos()[i,j]*xtemp.getElementos()[j];
              xk[i]:=xk[i]/A.getElementos()[i,i];
              x0.setElementos(xk);
          end;
            r := x0.restarVector(xtemp);
            d:=r.normaInfinita()/x0.normaUno();
        until (d < e)  or (iter > MaxIte); ;
        //writeln('iter ',iter);
        jacobi:= x0;

    end;
////////////////////////////////////////////////////////////////////////////////

function clsSistLineales.relajamiento(x0: clsVector; e: extended): clsVector;
var
   i,indice:integer;
   r,s,aux:clsVector;
   m: tVector;
   elem,mayorE:extended;
   band:boolean;
    begin
     s:=A.matrizPorVector(x0);
     aux:=b;
     r:=aux.restarVector(s);
     while (r.normaInfinita()>e) do
        begin
         mayorE:=0;
         for i:=1 to r.getOrden() do
          begin
            m[i]:= x0.getElementos()[i];
            elem:=ABS(r.getElementos()[i]);
            if elem>mayorE then
             begin
              mayorE :=ABS(elem);
              indice:=i;
             end;
          end;
          m[indice]:= (x0.getElementos()[indice])+(r.getElementos()[indice]/A.getElementos()[indice,indice]);
          x0.setElementos(m);
          s:=A.matrizPorVector(x0);
          r:=aux.restarVector(s);
       end;
       result:=x0;
end;


/////////////////////////////////////////////////////////////////////////////////
function clsSistLineales.gaussM(r:clsVector): clsVector;
var
    ma: tMatriz;
    i, j, k, n: integer;
    mult: extended;
    vec:tVectorI;
    aux:clsVector;
begin
    CarcarVectorIndice(vec);
    ma:= matrizAmpliadaM(r);
    n:= A.getOrden();
    for k:=1 to n-1 do// n etapas
    begin
        //MenuPivot(ma,k,vec,op);
        //mostrar_matrizAmpliada(ma);
        pivoteo_simple(ma,k);
        for i:= k+1 to n do
        begin
            mult:= ma[i,k]/ma[k,k];
            ma[i,k]:= 0;
            for j:=k+1 to n+1 do
                ma[i,j]:= ma[i,j]-mult*ma[k,j];
        end;
    end;
    aux:= sustRegresiva(ma,n);
    aux:=ordenar(aux,vec);
    result:=aux;
end;
////////////////////////////////////////////////////////////////////////////////
    function clsSistLineales.mejoramiento(x0: clsVector; e: extended): clsVector;
    var
    r,z,x,s:clsVector;
    begin
    x:=x0;
    s:=A.matrizPorVector(x0);
    r:=b;
    r:=r.restarVector(s);
    while (r.normaInfinita()>e) Do
       Begin
        z:=gaussM(r);
        x:=x.sumarVector(z);
        s:=A.matrizPorVector(x);
        r:=r.restarVector(s);
       End;
    result:= x;
    end;
////////////////////////////////////////////////////////////////////////////////
function clsSistLineales.sor(x: clsVector; e: extended; w:extended): clsVector;
    Var
        x0, diferencia: clsVector;
        iteracion, ord, i, j: Integer;
        norma: extended;
        vectorx0, vector: tVector;
    begin
        iteracion:=0;
        ord:=x.getOrden();
        x0 := clsVector.crear();
        repeat
          iteracion:= iteracion+1;
          x0.setElementos(x.getElementos());

          for i:=1 to ord do
          Begin
              vector[i]:= b.getElementos()[i];
              for j:=i+1 to ord do
                 vector[i]:=vector[i]- A.getElementos[i,j]*x0.getElementos()[j];
              for j:= 1 to (i-1) do
                 vector[i]:=vector[i]- A.getElementos()[i,j]*x0.getElementos()[j];
              vector[i]:=vector[i]/A.getElementos()[i,i];
              vector[i]:=(1-w)*vector[i]+w*vector[i];
              x.setElementos(vector);
          end;

          //resta y norma ||x-x0||
          diferencia:= x.restarVector(x0);
          norma:= diferencia.normaInfinita();
        until(norma < e)  or (iteracion > MaxIte);
        //writeln('iter ',iteracion);
        sor:= x;
    end;
/////////////////////////////////////////////////////////////////////////////////
procedure clsSistLineales.pivoteo_parcial(var ma: tMatriz;i:integer);
var
may,aux:extended;
n,k,pos:integer;
Begin
n:= A.getOrden();
may:=ma[i,i];
for k:=i to n-1 Do
   Begin
        if may<=ma[k+1,i] then
           Begin
                may:=ma[k+1,i];
                pos:=k+1;
           end;
   end;
for k:=1 to n+1 Do
   Begin
    aux:=ma[i,k];
    ma[i,k]:=ma[pos,k];
    ma[pos,k]:=aux;
   end;
End;

////////////////////////////////////////////////////////////////////////////////////
Procedure clsSistLineales.pivoteo_simple(var ma: tMatriz;i:integer);
var
piv,aux:extended;
n,k,band,pos:integer;
Begin
n:= A.getOrden();
band:=0;
k:=i;
while (band=0) and (k<=n) Do
   Begin
       if (ma[k,i]<>0) then
          begin
              piv:=ma[k,i];
              pos:=k;
              band:=1;
          end
       else
           k:=k+1;
   End;
for k:=1 to n+1 Do
   Begin
    aux:=ma[i,k];
    ma[i,k]:=ma[pos,k];
    ma[pos,k]:=aux;
   end;
end;
/////////////////////////////////////////////////////////////////////////////////////
Procedure clsSistLineales.pivoteo_completo(var ma: tMatriz;i:integer;var vec:tVectorI);
var
piv,aux1:extended;
n,k,s,band,pos1,pos2,aux2:integer;
Begin
n:= A.getOrden();
band:=0;
piv:=ma[i,i];
for k:=i to n Do
   for s:=i to n Do
      if (abs(ma[k,s])>abs(piv))then
         Begin
              piv:=ma[k,s];
              pos1:=k;
              pos2:=s;
         end;
for k:=1 to n+1 Do
   Begin
    aux1:=ma[i,k];
    ma[i,k]:=ma[pos1,k];
    ma[pos1,k]:=aux1;

   end;
k:=0;
for s:=1 to pos2 Do
   Begin
    aux1:=ma[s,i];
    ma[s,i]:=ma[s,pos2];
    ma[s,pos2]:=aux1;
    if (k=0) then
       begin
          aux2:=vec[i];
          vec[i]:=vec[pos2];
          vec[pos2]:=aux2;
          k:=1;
       end;
   end;
end;
/////////////////////////////////////////////////////////////////////////////////////
Procedure clsSistLineales.MenuPivot(var ma: tMatriz;i:integer;var vec:tVectorI;op:integer);
Begin
     case op of
          1: pivoteo_simple(ma,i);
          2: pivoteo_parcial(ma,i);
          3: pivoteo_completo(ma,i,vec);
     end;
End;
/////////////////////////////////////////////////////////////////////////////////////
Procedure clsSistLineales.mostrar_matrizAmpliada(m:tMatriz);
var
i,j,n:integer;
Begin
 n:=A.getOrden();
 for i:=1 to n do
     for j:= 1 to n+1 do
          //write('m[',i,',',j,']=',m[i,j],'    ');
     //writeln();

end;

/////////////////////////////////////////////////////////////////////////////////////
Procedure clsSistLineales.CarcarVectorIndice(var vec:tVectorI);
var
i,n:integer;
Begin
n:=A.getOrden();
for i:=1 to n Do
   vec[i]:=i;
end;
/////////////////////////////////////////////////////////////////////////////////////
end.


