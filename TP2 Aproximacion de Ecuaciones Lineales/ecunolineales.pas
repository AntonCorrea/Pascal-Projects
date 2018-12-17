unit EcuNoLineales;

{$mode objfpc}{$H+}

interface
  uses
  Classes,SysUtils,uFuncion,DiffExpress,Dialogs;
  const
    maxIter = 1000;
  type
    vs = array[1..maxIter] of String;
    TNoLineales=class
        private
          Err:Extended;
          Fun:Tfuncion;
          FunDif:Tfuncion;
          a,b:extended;
          function EvaluarExtremos():boolean;
          function ExisteRaiz():boolean ;
          Function Verifica():boolean;
          procedure CargarDerivada();
          Function VerificaDer():boolean;
          Function Fourier(ini:extended):boolean;

        public
          vecStr :vs;
          iteraciones:integer;
          constructor crear;
          Function CargaIntervalo(x1,x2:extended): boolean;
          function Cargar(f:string ; er: extended):boolean;
//          procedure MostrarFuncion();
          Function Biseccion():extended;
          Function RegulaFalsi():extended;
          Function RegulaFalsiMod():Extended;
          Function Newton(x:extended):Extended;
          Function Secante(x1, x2: extended):Extended;
          Function NewtonHH(x:extended):Extended;
          //lo agregó matías
//          procedure Mostrar();
    end;



implementation



Constructor TNoLineales.crear;

begin
   Fun:=Tfuncion.crear;
   Err:=0;
   inherited Create;

end;
Function TNoLineales.CargaIntervalo(x1,x2:extended): boolean;
//var i:integer;
Begin
    //val(x1,a,i);
    //val(x2,b,i);
    a := x1;
    b := x2;
    if Verifica()then
       CargaIntervalo:= TRUE
    else
       CargaIntervalo:= FALSE;
end;

{Carga la funcion, devuelve False si la expresion ingresada es invalidada y true caso contrario}
function TnoLineales.Cargar(f:string ; er: extended):boolean;
var
//  f:shortstring;
//  inf,sup,er:extended;
//  i:integer;
  Validar:boolean;
begin
//     writeln('Ingrese la funcion:');
//     readln(f);
     validar:=Fun.Validar_Expresion(f);   //Validar en la gui
     if validar then
        begin
 //            writeln('Ingrese el margen de error');
 //            readln(er);
 //            writeln('Ingrese el intervalo');
 //            write('a:');
 //            readln(inf);
 //            a:=inf;
 //            write('b:');
 //            readln(sup);
 //            b:=sup;
             Fun.Setup(f);
             Err := er;
             Cargar:=TRUE;
        end
     else

        Cargar:=FALSE;


end;

{*procedure TNoLineales.MostrarFuncion();
begin
     writeln('La Funcion es :', Fun.Formula);

end;*}

{Evalua la funcion en los extremos }
function TNoLineales.EvaluarExtremos():boolean;
var
i,j:extended;
r:boolean;
begin
    r:=TRUE;
    i:=Fun.f(a);
    j:=Fun.f(b);
    if (i=InDefinido) or (j=InDefinido) then
       r:=FALSE;
    EvaluarExtremos:=r;
end;

{Se Fija si f(a)*f(b) es menor que cero}
function TNoLineales.ExisteRaiz():boolean;
var
r:boolean;
begin
     if (Fun.f(a)*Fun.f(b)<0)then
        r:=TRUE
     else
        r:=FALSE;
     ExisteRaiz:=r;
end;

{LA Funcion Verifica se fija si la funcion esta definida en el intervalo
propuetso por el usuario y si exite una raiz en ese intevalo}
Function TNoLineales.Verifica(): boolean;
var
     i:boolean;
     r:boolean;
begin
     r:=TRUE;
     i:=EvaluarExtremos();
     if (not i) then
        begin
        //writeln('La funcion no esta definida en los intervalos dados, proponga otro intervalo');
        r:=FALSE;
        end
     else
        begin
             i:=ExisteRaiz();
             if (not i) then
                begin
                     //writeln('No se puede asegurar que en el intervalo halla una raiz ya que f(a).f(b)>0');
                     r:=FALSE;
                end;
        end;
        Verifica:=r;
end;

{Metodo de Biseccion}
Function TNoLineales.Biseccion():Extended;
var
  inf,sup,c,d:extended;
  cad,aux1,aux2,aux3:string;
  i,cont:integer;
begin
  c:=InDefinido;
  if Verifica()then
     begin
          i := 1;
          inf:=a;
          sup:=b;
          cont:=0;
          str(cont,aux1);
          cad:='';
          str(inf,aux2);
          str(sup,aux3);
          cad:=cad+aux1+':'+aux2+':'+aux3;
          c:=(inf+sup)/2;
          d := a;
          str(c,aux1);
          cad:=cad+':'+aux1;
          str(abs(Fun.f(c)),aux2);
          cad:=cad+':'+aux2;
          str(abs(inf-c),aux1);
          cad:=cad+':'+aux1;
          vecStr[i]:=cad;
          while (abs(d-c)>=Err) and (abs(Fun.f(c))>=Err) and (cont<=maxIter) do
              begin
              if (Fun.f(inf)*Fun.f(c)<0) then
                 Begin
                     sup:=c;
                 end
              else
                 Begin
                   inf:=c;
                 end;
              i:=i+1;
              d := c;
              c:=(inf+sup)/2;
              cont:=cont+1;
              str(cont,aux1);
              cad:='';
              str(inf,aux2);
              str(sup,aux3);
              cad:=cad+aux1+':'+aux2+':'+aux3;
              str(c,aux1);
              cad:=cad+':'+aux1;
              str(abs(Fun.f(c)),aux2);
              cad:=cad+':'+aux2;
              str(abs(d-c),aux1);
              cad:=cad+':'+aux1;
              vecStr[i]:=cad;
              end;
          iteraciones:=cont+1;
          if (cont>maxIter) then
                   Biseccion:=InDefinido
          else
              Begin
                   //writeln();
                   //writeln('Cantidad de Iteraciones: ', iteraciones);
                   Biseccion:=c;
              end;
     end
  else
      Biseccion:=c;
end;

{Metodo Regula Falsi}
Function TNoLineales.RegulaFalsi():extended ;
var
   inf,sup,c,d:extended;
   i,cont:integer;
   cad,aux1,aux2,aux3:String;
begin
     c:=InDefinido;
     if Verifica()then
        begin
            i := 1;
            inf:=a;
            sup:=b;
            cont:=0;
            str(cont,aux1);
            cad:='';
            str(inf,aux2);
            str(sup,aux3);
            cad:=cad+aux1+':'+aux2+':'+aux3;
            d := a;
            c:=(inf * Fun.f(sup) - sup * Fun.f(inf))/(Fun.f(sup)-Fun.f(inf));
            str(c,aux1);
            cad:=cad+':'+aux1;
            str(abs(Fun.f(c)),aux2);
            cad:=cad+':'+aux2;
            str(abs(inf-c),aux1);
            cad:=cad+':'+aux1;
            vecStr[i]:=cad;
            while (abs(d-c)>=Err) and (abs(Fun.f(c))>=Err) and (cont<=maxIter) do
                begin
                     if (Fun.f(inf)*Fun.f(c)<0) then
                        Begin
                           sup:=c;
                        end
                     else
                        Begin
                           inf:=c;
                        end;
                     i:=i+1;
                     d:= c;
                     c:=(inf * Fun.f(sup) - sup * Fun.f(inf))/(Fun.f(sup)-Fun.f(inf));
                     cont:=cont+1;
                     str(cont,aux1);
                     cad:='';
                     str(inf,aux2);
                     str(sup,aux3);
                     cad:=cad+aux1+':'+aux2+':'+aux3;
                     str(c,aux1);
                     cad:=cad+':'+aux1;
                     str(abs(Fun.f(c)),aux2);
                     cad:=cad+':'+aux2;
                     str(abs(d-c),aux1);
                     cad:=cad+':'+aux1;
                     vecStr[i]:=cad;
                end;
            iteraciones:=cont+1;
            if (cont>maxIter) then
                   RegulaFalsi:=InDefinido
            else
              Begin
                   //writeln();
                   //writeln('Cantidad de Iteraciones: ', iteraciones);
                   RegulaFalsi:=c;
              end;
        end
     else
            RegulaFalsi:=c;

end;

{Metodo Regula Falsi Modificada}
Function TNoLineales.RegulaFalsiMod():Extended;
var
    inf,sup,c,F,G,w,d:extended;
    cont,i:integer;
    cad, aux1, aux2, aux3: string;
begin
      c:=InDefinido;
      if Verifica() then
         begin
             inf:=a;
             sup:=b;
             cont:=0;
             i := 1;
             str(cont,aux1);
             cad:='';
             str(inf,aux2);
             str(sup,aux3);
             cad:=cad+aux1+':'+aux2+':'+aux3;
             F:=Fun.f(inf);
             G:=Fun.f(sup);
             w:=Fun.f(inf);
             c:=(inf * Fun.f(sup) - sup * Fun.f(inf))/(Fun.f(sup)-Fun.f(inf));
             d := a;
             str(c,aux1);
             cad:=cad+':'+aux1;
             str(abs(Fun.f(c)),aux2);
             cad:=cad+':'+aux2;
             str(abs(d-c),aux1);
             cad:=cad+':'+aux1;
             vecStr[i]:=cad;
             while (abs(d-c)>=Err) and (abs(Fun.f(c))>=Err) and (cont<=maxIter) do
                 begin
                      if (Fun.f(inf)*Fun.f(c)<0) then
                         begin
                             sup:=c;
                             G:=Fun.f(c);
                             if (w*G>0) then
                                F:=F/2;
                         end
                      else
                          begin
                             inf:=c;
                             F:=Fun.f(c);
                             if (w*F>0) then
                                G:=G/2;
                          end;
                      w:=Fun.f(c);
                      i:=i+1;
                      d := c;
                      c:=(inf * Fun.f(sup) - sup * Fun.f(inf))/(Fun.f(sup)-Fun.f(inf));
                      cont:=cont+1;
                      str(cont,aux1);
                      cad:='';
                      str(inf,aux2);
                      str(sup,aux3);
                      cad:=cad+aux1+':'+aux2+':'+aux3;
                      str(c,aux1);
                      cad:=cad+':'+aux1;
                      str(abs(Fun.f(c)),aux2);
                      cad:=cad+':'+aux2;
                      str(abs(d-c),aux1);
                      cad:=cad+':'+aux1;
                      vecStr[i]:=cad;
                 end;
             iteraciones:=cont+1;
             if (cont>maxIter) then
                   RegulaFalsiMod:=InDefinido
            else
              Begin
                   //writeln();
                   //writeln('Cantidad de Iteraciones: ', iteraciones);
                   RegulaFalsiMod:=c;
              end;
         end
      else
          RegulaFalsiMod:=c;
end;

{Carga la Derivada de la Funcion}
procedure TNoLineales.CargarDerivada();
var
    diff:TDiffExpress;
    aux:string;
begin

     diff:=TDiffExpress.Create;
     diff.Formula:=Fun.Formula;
     FunDif:=Tfuncion.Crear;
     aux:=StringReplace(diff.diff('X'),',','.',[rfReplaceAll, rfIgnoreCase]);
     FunDif.Setup(aux);

end;

{Verifica que la derivada exista en los extremos}
Function TNoLineales.VerificaDer():boolean;


begin
    if (FunDif.f(a)<>InDefinido) and (FunDif.f(b)<>InDefinido)then
           VerificaDer:=TRUE
    else
        begin
            //writeln('No Existe la Derivada en los Extremos ');
            VerificaDer:=FALSE;
        end;
end;

{Verifica la condicion de fourier, es decir si tanto la  funcion como la derivada  existan en los extremos
y que la derivada en el punto inicial sea distinto de cero}
Function TNoLineales.Fourier(ini:extended):boolean;
var
diff2:TDiffExpress;
der2:Tfuncion;

begin

   if Verifica() and  VerificaDer() then
      begin
          if FunDif.f(ini)<>0 then
             begin
                 diff2:=TDiffExpress.Create;
                 diff2.Formula:=FunDif.Formula;
                 der2:=Tfuncion.crear;
                 der2.Setup(diff2.diff('X'));
                 if Fun.f(ini)*der2.f(ini)>0 then
                    Fourier:=TRUE
                 else
                     begin
                       //writeln('EL punto Inicial propuesto no cumple con la condicion de Fourier f(x0).f''(x0)>0');
                       Fourier:=FALSE;

                     end;

             end
          else
             begin
                 //writeln('La derivada evaluada en el Punto Inicial es cero');
                 Fourier:=FALSE;
             end;

      end
   else
       begin
          Fourier:=FALSE;

       end;
end;

{Metodo de Newton}
Function TNoLineales.Newton(x:extended):Extended;
var
xn,y1,y2: extended;
cont: integer;
cad: String;
i: integer;
aux1, aux2, aux3: String;
begin
     i:=1;
     CargarDerivada();
     cad:='';

     {if Fourier(x)then}
 //      begin
         cont:=0;

         repeat
             begin
                 xn:=x;
                 y1 := Fun.f(xn);
                 y2 := FunDif.f(xn);
                 //writeln('f(xn): ',y1);
                 //writeln('f´(xn): ',y2);
                 if (y1 = InDefinido) or (y2 = InDefinido) or (y2 = 0.0)then
                    begin
                        x := InDefinido;
                        cont := maxIter + 1;
                    end
                 else
                     begin
                          x:=xn-(y1/y2);
                          str(cont,aux1);
                          str(xn,aux2);
                          str(x,aux3);
                          cad:=aux1+':'+aux2+':'+aux3;
                          str(abs(Fun.f(x)),aux1);
                          str(abs(x-xn),aux2);
                          cad:=cad+':'+aux1+':'+aux2;
//                        writeln(cad);
//                        writeln;
                          cont:=cont+1;
                          vecStr[i]:=cad;
                          i:=i+1;
                     end;
             end;
         until ((abs(x-xn)<Err) and (abs(Fun.f(x))< Err)) or (cont>maxIter);
         iteraciones:=cont;

         if (cont>maxIter) then
            Newton:=InDefinido
         else
            Begin
              //writeln();
              //writeln('Cantidad de Iteraciones: ', iteraciones);
              Newton:=x;
            end;




//       end
     {else

            Newton:=InDefinido;
      }
end;

{Metodo Secante}
Function TNoLineales.Secante(x1,x2: extended):extended;
var
xa,xn,xn2,y1,y2:extended;
cont, i: integer;
aux1, aux2, aux3, cad : String;
begin
      //if Verifica() then
        //begin
            xn:=x1;
            xn2:=x2;
            cont:=0;
            i := 1;
            repeat
                begin
                  xa:=xn;
                  xn:=xn2;
                  str(cont,aux1);
                  str(xa,aux2);
                  str(xn,aux3);
                  cad := aux1+':'+aux2+':'+aux3+':';
                  y1 := Fun.f(xn);
                  y2 := Fun.f(xa);
                  if (y1 = InDefinido) or (y2 = InDefinido) or (y1=y2) then
                     begin
                          xn2 := InDefinido;
                          cont := maxIter +1;
                     end
                  else
                      begin
                           xn2:=xn-((y1*(xn-xa))/(y1-y2));
                           str(xn2,aux1);
                           str(abs(Fun.f(xn2)),aux2);
                           str(abs(xn2-xn),aux3);
                           cad := cad + aux1+':'+aux2+':'+aux3;
                           vecStr[i]:=cad;
                           i:=i+1;
                           cont:=cont+1;
                      end;
                end;
            until ((abs(xn2-xn)<Err) and (abs(Fun.f(xn2))< Err)) or (cont>maxIter);
            iteraciones := cont;
            //writeln('Cantidad de Iteraciones: ', iteraciones);
            if (cont>maxIter) then
               Secante:=InDefinido
            else
                Begin
                     //writeln();
                     //writeln('Cantidad de Iteraciones: ', iteraciones);
                     Secante:=xn2;
                end;
        //end
      //else
          //Secante:=InDefinido;


end;

{Metodo de Newton-HouseHolder}
Function TNoLineales.NewtonHH(x:extended):Extended;
var
   diff2:TDiffExpress;
   FunDif2: Tfuncion;
   xn, y1, y2, y3: extended;
   cont, i:integer;
   aux1, aux2, aux3, cad : String;
begin
     CargarDerivada();
     diff2:=TDiffExpress.Create;
     diff2.Formula:=FunDif.Formula;
     FunDif2:=Tfuncion.Crear;
     aux1:=StringReplace(diff2.diff('X'),',','.',[rfReplaceAll, rfIgnoreCase]);
     FunDif2.Setup(aux1);
//     if Fourier(x)then
//       begin
     cont:=0;
     i := 1;
     repeat
         begin
             xn:=x;
             y1 := Fun.f(xn);
             y2 := FunDif.f(xn);
             y3 := FunDif2.f(xn);
             if (y2 =0.0) or(y1 = InDefinido) or (y2 = InDefinido) or (y3 = InDefinido) or ((2*y2*y2)=(y1*y3)) then
                begin
                   x := InDefinido;
                   cont := maxIter + 1;
                end
             else
                 begin
                      x:=xn-((2*y1*y2)/((2*y2*y2)-(y1*y3)));
                      str(cont,aux1);
                      str(xn,aux2);
                      str(x,aux3);
                      cad:=aux1+':'+aux2+':'+aux3;
                      str(abs(Fun.f(x)),aux1);
                      str(abs(x-xn),aux2);
                      cad:=cad+':'+aux1+':'+aux2;
                      vecStr[i]:=cad;
                      i:=i+1;
                      cont:=cont+1;
                 end;
         end;
     until ((abs(x-xn)<Err) and (abs(Fun.f(x))<Err)) or (cont>maxIter);
     iteraciones:=cont;
     if (cont>maxIter) then
            NewtonHH:=InDefinido
     else
          Begin
            //writeln();
            //writeln('Cantidad de Iteraciones: ', iteraciones);
            NewtonHH:=x;
          end;
end;

{*procedure TNoLineales.Mostrar();
var i: integer;
Begin
      i:=1;
      writeln('entro al while');
      while (vecStr[i] <> '') do
          Begin
            Writeln(vecStr[i]);
            i:=i+1;
          End;
End;*}

end.

