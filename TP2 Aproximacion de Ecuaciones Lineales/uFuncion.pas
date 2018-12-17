Unit uFuncion;



INTERFACE

Const
    InDefinido: Extended = 1.1e4932;

Type
    TFuncion = Class
       private

           Fnc : ShortString;
           Function Operar(b, y: Extended; Var op : Char): Extended;
           FUNCTION ChkNumero(Const valorStr: ShortString):boolean;
           FUNCTION sgn(s:Extended): Extended;
           Function EsPar(Exponente: Extended): Boolean;
           Function Radical(Rcndo, Ind:Extended):Extended;
           FUNCTION POT (B,EP: Extended):Extended;
           Function GetExpresion: ShortString;
           FUNCTION Valor_FunLIB(Var v:ShortString; Arg:Extended):Extended;
           Function Func(_Formula: ShortString; X:Extended):Extended;
           Function Validar(Var expresion:ShortString;var pos:integer):boolean;


       public

           Constructor Crear;
           Function  Validar_Expresion(s : ShortString): boolean;
           Function  f(x:Extended):Extended;
           Function  Valor(Var Ex : ShortString): Extended;
           Procedure Setup(strg: ShortString);

           Property Formula: ShortString read GetExpresion;
    End;

IMPLEMENTATION

Uses Dialogs, sysutils;

Function FloatToStr(Const Float: Extended): ShortString;
Var S : ShortString;
    P : Byte;
Begin
   Str(Float:22:20, S);
   P:= 1;
   While (p<= Length(S)) and (S[p]=' ') Do Inc(p);
   If p >1 then Delete(S, 1, P-1);
   P:= Length(S);

   While ( S[P]='0' ) and (P >1) Do Dec(P);
   Delete(S, P, 21);

   FloatToStr:= S;
End;

Constructor TFuncion.Crear;
Begin

   self.Fnc:='';
   inherited Create;
End;

{
  ChkNumero es un Automata Finito Determinista que valida
  si una cadena puede o no ser considerado un Numero
}
FUNCTION TFuncion.ChkNumero(Const valorStr: ShortString):boolean;
Type TEstados = (Ini, DE, P, DF, E, S, DEx);
 var k,Len : integer;
     Valido: boolean;
         ch: char;
     Estado: TEstados;
 begin
  Len:= length(valorStr); k:=1 ;
  Valido:= True; Estado:= Ini;
  While (k <= Len) and Valido do
   begin
    ch:=valorStr[k];
    Case Estado Of
       Ini: If ch in ['0'..'9'] Then Estado:= DE Else Valido:= False;
        DE: If ch = '.' then Estado:= P Else
              If ch ='E' then Estado:= E Else
                If Not (ch in ['0'..'9']) Then Valido:= False;
         P: If ch in ['0'..'9'] Then Estado:= DF Else Valido:= False;
        DF: If ch ='E' then Estado:= E Else
              If Not (ch in ['0'..'9']) Then Valido:= False;
         E: If ch in ['+','-'] then Estado:= S Else
              If Not (ch in ['0'..'9']) Then Valido:= False;
         S: If ch in ['0'..'9'] Then Estado:= DEx Else Valido:= False;
       DEx: If Not (ch in ['0'..'9']) Then Valido:= False;
    End;
    k:=k+1;
  End;
  If Not (Estado in [DE, DF, DEx]) Then Valido := False;

  Result:= Valido;
end;

FUNCTION TFuncion.Validar(Var expresion:ShortString;var pos:integer):boolean;
 var
     Par_apertura, Par_Cierre, Tope  : Integer;
                    c  : Char;
     ErrorTexto,texto  : ShortString;
            st,estado  : Boolean;
       Error,PtrPos,p  : Byte;

FUNCTION Es_FunLIB(Const texto:ShortString): Boolean;
 begin
    Result:= True;

  if texto='' then Result:= False
  else
   if ((texto<>'SIN') and (texto<>'COS')) and (texto<>'TANG') then
    if ((texto<>'COTG') and (texto<>'SEC')) and (texto<>'COSEC') then
     if ((texto<>'ASIN') and (texto<>'ACOS')) and (texto<>'ATANG') then
      if ((texto<>'ACOTG') and (texto<>'ASEC')) and (texto<>'ACOSEC') then
       if ((texto<>'SINH') and (texto<>'COSH')) and (texto<>'TANGH') then
        if ((texto<>'COTGH') and (texto<>'SECH')) and (texto<>'COSECH') then
         if ((texto<>'ASENH') and (texto<>'ACOSH')) and (texto<>'ATANGH') then
         if ((texto<>'ACOTGH') and (texto<>'ASECH')) and (texto<>'ACOSECH') then
          if ((texto<>'EXP') and (texto<>'ABS')) and (texto<>'INT') then
            if (texto<>'LN') then
               Result:= false;

 end;

Function Chk_Identificador(texto:ShortString;var posi:byte):boolean;
 var status: boolean;
Begin
  status:= true;
  if texto='' then status:= false
  else
   If Not (Es_FunLIB(texto) or ChkNumero(texto)) and
     ((texto<>'X') and (texto<>'ã')) then
     status:=false;
  if not status then posi:=posi-length(texto);

  Result:= status;
End;


FUNCTION SigChar(Const Expr:ShortString; Idx:byte; Var posicion: byte):Char;
  Begin
     While (Expr[Idx]=' ') and (Idx<= Length(Expr)) Do Inc(Idx);
     If Idx<= Length(Expr) Then
        Begin
           Result := Expr[Idx];
           Posicion := Idx;
        End
     Else
        Begin
           Result := '@';
           Posicion := 0;
        End;
  End;

begin   (*  PRINCIPAL  *)
   Estado:=true;  Tope:=length(expresion);
   Par_apertura:=0; Par_cierre:=0; texto:=''; p:=1;
   st:=true;Error:=0;ErrorTexto:='';
   if SigChar(expresion,p,PtrPos)='-' then p:=PtrPos+1;
   While (p <= Tope) and estado do
     Begin
        Case Expresion[p] Of
             '(' : Begin
                      Inc(Par_apertura);
                      c:=SigChar(expresion,p+1,PtrPos);
                      If c = ')' Then
                         Begin
                            Estado:= false;
                            Error:= 12;
                            ErrorTexto:= '';
                         End;
                      If c ='-' then p:=PtrPos;
                   end;
             ')' : Begin
                      Inc(Par_cierre);
                      if Par_cierre > Par_apertura then
                         Begin
                            Error:=6; estado:= false
                         end
                      else
                         begin
                            c:=SigChar(expresion,p+1,PtrPos);
                            if not (c in ['*','/','+','-','^','û',')','@']) then
                               begin
                                  Error:=8; ErrorTexto:=' Despues del ")"';
                                  estado:=false;
                               end
                            else if (c<>'@') and (c<>')') then p:= PtrPos;
                         end;
                   end;
             ' ' : if SigChar(expresion,p+1,PtrPos)='(' then p:=PtrPos-1;
       Else
          Begin
            c:= expresion[p];
            while not (c in ['+','-','*','/','(',')']) and ((p<= Tope) and st) do
             Begin
               Case c of
                   '^','û' : begin
                               p:=p-1;
                               st:=false;
                             end;
                   '0'..'9' : Begin
                               while (p<= Tope) and (c in ['0'..'9','.']) do
                                  begin
                                    texto:= texto + c;
                                    Inc(p);
                                    c:= expresion[p];
                                  end;

                                If c = 'E' then //in ['E','+','-'] then
                                   Begin
                                      texto:= texto + c;
                                      Inc(p);
                                      c:= expresion[p];
                                      If c in ['+','-'] then
                                         Begin
                                            texto:= texto + c;
                                            Inc(p);
                                            c:= Expresion[p];
                                         End;

                                      while (p<= Tope) and (c in ['0'..'9']) do
                                         begin
                                            texto:= texto + c;
                                            Inc(p);
                                            c:= expresion[p];
                                         end;
                                   End;

                                if ChkNumero(texto) and
                                    (SigChar(expresion,p,PtrPos) in ['A','C','E','I','L','S','T','X','ã']) then
                                     Begin
                                       Insert('*',expresion,PtrPos);
                                       Tope:= Length(expresion);
                                     End;
                                Dec(p);
                              End;

                   ' ' : if (SigChar(expresion,p+1,PtrPos) in ['0'..'9','X','ã']) and
                                  Not ChkNumero(texto) then
                                  Begin
                                    st:= False;
                                    Dec(p);
                                  End;
                   else
                      if c<>' ' then texto:=texto+c;
               End;
               p:=p+1;
               If P <= Tope then c:= expresion[p] else c:= #0;
             end;

             if (not Chk_Identificador(texto,p)) then
               begin
               if (texto='') and (c in ['*','/','+','-','^','û']) then
                   begin
                     estado:=false;
                     ErrorTexto := Copy(expresion,p,1);
                     case c of
                         '^' : Error := 1;
                         'û' : Error := 2;
                      '+','-': Error := 3;
                      '*','/': Error := 4;
                     end;
                   end
                else
                  begin
                    estado:=false;
                    Error := 5; ErrorTexto := texto;
                  end;
               end
             Else
               if (c in ['*','/','+','-','^','û',')']) and Es_FunLIB(texto) then
                  Begin
                    Estado:= false;
                    Error:= 11;
                    ErrorTexto:= texto;
                  End
               else
                  If Es_FunLIB(texto) and (p > Tope) then
                     Begin
                        Estado:= false;
                        Error:= 11;
                        ErrorTexto:= texto;
                     End;

             if (c=')') or (c='(') then p:=p-1;
             texto:='';
             st:=true;
          end;
       end; (* Primer Case *)

       if (P <= Tope) and (expresion[p] in ['*','/','+','-','^','û']) and Estado then
         if SigChar(expresion,p+1,PtrPos)='@' then
           Begin
             estado:= false;
             ErrorTexto:= Copy(expresion,p,1);
             Case expresion[p] of
                'û': Error:=  9;
                '^': Error:= 10;
                '+','-': Error := 3;
                '*','/': Error := 4;
             End;
           End;
       p:=p+1;
     end;     (* while *)

  if (Error=0) and (Par_apertura > par_cierre) then Begin Error:= 7; estado:=false  end;
 { if Error >0 then
    Begin
      Case Error Of
       1 : //writeln('Error: Falta Base para la potencia (',ErrorTexto,')');
       2 : //writeln('Error: Falta indice para la radicacion (',ErrorTexto,')');
       3 : //writeln('Error: Termino nulo. Error en signo de (',ErrorTexto,')');
       4 : //writeln('Error: Factor nulo. Error en signo de (',ErrorTexto,')');
       5 : //writeln('Error: Identificador Desconocido (',ErrorTexto,')');
       6 : //writeln('Error: Falta un "("');
       7 : //writeln('Error: Falta un ")"');
       8 : //writeln('Error: Falta un Operador. ',ErrorTexto);
       9 : //writeln('Error: Falta el Radicando en la Operacionn û');
      10 : //writeln('Error: Falta exponente en la Operaci¢n ^');
      11 : //writeln('Error: Funcion ',ErrorTexto,' sin argumento  ---> Por ej: ',ErrorTexto,'(x)');
      12 : //writeln('Error: Expresi¢n nula entre par‚ntesis');
      end;
    end;}
  pos:=p;
  Validar:=estado;
end;

{****************************************************************************}
Function UpperCase(const S: string): string;
var
  Ch: Char;
  L: Integer;
  Source, Dest: PChar;
begin
  L := Length(S);
  SetLength(Result, L);
  Source := Pointer(S);
  Dest := Pointer(Result);
  while L <> 0 do
  begin
    Ch := Source^;
    if (Ch >= 'a') and (Ch <= 'z') then Dec(Ch, 32);
    Dest^ := Ch;
    Inc(Source);
    Inc(Dest);
    Dec(L);
  end;
End;

{****************************************************************************}
Function _Racional(Const Numero: Extended; Const i: Word; Var p, q : Extended): Boolean;
Var Dmd, Ent: Extended;
    TipoNumero: Boolean;
Begin
   Ent:= Int(Numero);
   Dmd:= 1.0/(Numero-Ent);
   TipoNumero:= True;

   If (Int(Dmd+1.0)-Dmd) < 1.0e-13 Then
           Dmd:= Int(Dmd+1.0);
   If Frac(Dmd)<= 1.0e-13 Then
           Dmd:= Int(Dmd);

   If Frac(Dmd) <>0.0 then
      Begin
         If i < 24 then
            Begin
               TipoNumero:= _Racional(Dmd, i+1, p, q);
               Dmd:= p;
               p  := q;
            End
         Else
            Begin
               Dmd:= 1.0 * Round(Dmd);
               P  := 1.0;
               TipoNumero:= False
            End
      End;

   p:= Int(Dmd * Ent + p);
   q:= Int(Dmd);
   _Racional:= TipoNumero;
End;

Function Racional(Const Numero: Extended; Var p, q: Extended): Boolean;
Begin
   Result:= _racional(Numero, 1, p, q);
End;

FUNCTION TFuncion.sgn(s:Extended): Extended;
 begin
   if s > 0.0 then sgn:= 1.0
    else if s = 0.0 then sgn:= 0.0
            else sgn:= -1.0;
 end;

Function TFuncion.EsPar(Exponente: Extended): Boolean;
Var Numerador, Denominador: Extended;
Begin
  if Frac(Exponente) = 0.0 Then
    EsPar:= Not Odd(Trunc(Exponente))
  Else
    Begin
      Racional(Exponente, Numerador, Denominador);
      EsPar:= Not Odd(Trunc(Denominador));
    End;
End;

Function TFuncion.Radical(Rcndo, Ind:Extended):Extended;
Var  Ind_Par : Boolean;
     Ind_Pos : Boolean;
     Raiz    : Extended;
Begin
  Ind_Pos:= True;
  if Ind < 0.0 Then
    Begin
      Ind_Pos := False;
      Ind:= Abs(Ind);
    end;

  Ind_Par := EsPar(Ind);

  If Rcndo = 0.0 then Raiz:= 0.0
  Else
    If Ind_Par Then
      If Rcndo >0.0 Then
         Raiz:= Exp(Ind * Ln(Rcndo))
      Else
         Raiz:= InDefinido
    Else
       Raiz:= Sgn(Rcndo) * Exp(Ind * Ln(Abs(Rcndo)));

  if (Not Ind_pos) and (raiz <>InDefinido) then
    if Raiz <>0.0 then
        Raiz:= 1.0/Raiz
    else
       Raiz:= InDefinido;

  Radical:= Raiz;
End;

FUNCTION TFuncion.POT (B,EP: Extended):Extended;
  VAR Y  : Extended;
      Par: Boolean;
  Begin
    If B = 0.0 THEN Y:=0.0
    Else
      Begin
        If Frac(ep) = 0.0 Then
          Begin
            Par := Not Odd(Trunc(ep));
            Y:= EXP(EP*LN(ABS(B)));
            IF Not Par THEN Y:= SGN(B)*Y;
           End
        Else
           Y:= Radical(b,ep);
      End;
  POT:=Y;
  End;

FUNCTION TFuncion.Valor_FunLIB(Var v:ShortString; Arg:Extended):Extended;
VAR
    code  : integer;

BEGIN
  if (v='SIN') then Result:= sin(arg)
  else if (v='COS') then Result:= cos(arg)
  else if (v='TANG') then
       if Cos(arg)=0.0 then Result:= InDefinido else Result:=sin(arg)/cos(arg)
  else if (v='COTG') then
       if Sin(arg)=0.0 then Result:= InDefinido else Result:=cos(arg)/sin(arg)
  else if (v='SEC') then
       if Cos(arg)=0.0 then Result:= InDefinido else Result:=1.0/cos(arg)
  else if (v='COSEC') then
       if Sin(arg)=0.0 then Result:= InDefinido else Result:=1.0/sin(arg)
  else if (v='ASIN') then
       if (arg <=-1.0) or (arg >=1.0) then Result:= InDefinido else Result:=arctan(arg/sqrt(-arg*arg+1.0))
  else if (v='ACOS') then
       if (arg <=-1.0) or (arg >=1.0) then Result:= InDefinido else Result:=-arctan(arg/sqrt(-arg*arg+1.0))+1.5708
  else if (v='ATANG') then Result:=arctan(arg)
  else if (v='ACOTG') then Result:=arctan(-arg) + 1.5708
  else if (v='ASEC') then
       if (arg >=-1.0) and (arg <=1.0) then
          Result:= InDefinido else
          Result:=arctan(arg/sqrt(arg*arg-1.0))+sgn(sgn(arg)-1.0)*1.5708
  else if (v='ACOSEC')  then
       if (arg >=-1.0) and (arg <=1.0) then
         Result:= InDefinido else Result:=arctan(arg/sqrt(arg*arg-1.0)) +(sgn(arg)-1.0)*1.5708
  else if (v='SENH') then Result:=(exp(arg)-exp(-arg))/2.0
  else if (v='COSH') then Result:=(exp(arg)+exp(-arg))/2.0
  else if (v='TANGH') then Result:=(exp(arg)-exp(-arg))/(exp(arg)+exp(-arg))
  else if (v='COTGH') then
       if arg =0.0 then Result:= InDefinido else Result:=(exp(arg)+exp(-arg))/(exp(arg)-exp(-arg))
  else if (v='SECH') then Result:=2.0/(exp(arg)+exp(-arg))
  else if (v='COSECH') then
       if arg =0.0 then Result:= InDefinido else Result:=2.0/(exp(arg) - exp(-arg))
  else if (v='ASENH') then Result:=ln(arg+sqrt(arg*arg+1.0))
  else if (v='ACOSH') then
       if (arg <1.0) then Result:= InDefinido else Result:=ln(arg+sqrt(arg*arg-1.0))
  else if (v='ATANGH') then
       if (arg <=-1.0) or (arg >=1.0) then Result:= InDefinido else Result:=ln((1.0+arg)/(1.0-arg))/2.0
  else if (v='ACOTGH') then
       if (arg <=1.0) and (arg >=-1.0) then Result:= InDefinido else Result:=ln((arg+1.0)/(arg-1.0))/2.0
  else if (v='ASECH') then
       if (arg <=0.0) or (arg >1.0) then Result:= InDefinido else Result:=ln(1.0/arg+sqrt(1.0/(arg*arg)-1.0))
  else if (v='ACOSECH') then
       if (arg =0.0) then Result:= InDefinido else Result:=ln(1.0/arg+sqrt(1.0/(arg*arg)+1.0))
  else if (v='EXP') then Result:=exp(arg)
  else if (v='INT') then Result:=int(arg)
  else if (v='ABS') then Result:=abs(arg)
  else if (v='LN') then
       if (arg <=0.0) then Result:= InDefinido else Result:=ln(arg)
  else if (v ='ã') then Result:= Pi
  else val(v,Result,code);
  v:= '';
  Valor_FunLIB:= Result;
END;

Function TFuncion.Operar(b, y: Extended; Var op : Char): Extended;
Var  r: Extended;
Begin
  R := 0.0;
  Case op of
    '^': r:= Pot(b,y);
    'û': r:= Radical(y, b);
    '*': r:= b * y;
    '/': if y=0.0 then r:= Indefinido else r:= b / y;
    '+': r:= b + y;
    '-': r:= b - y;
  End;
  op:= #0;

  Result:= r;
End;

Function TFuncion.Func(_Formula: ShortString; X:Extended):Extended;
Type
    Operando = Record
        A : Extended;
        op: Char;
    end;
Var
   Termino, Factor : Operando;
   Arg, A, B : Extended;
   Operador  : Char;
   Tope, p   : Byte;
   Tot_Par   : Byte;
   Parentesis: ShortString;
   Identif   : ShortString;
   Code      : Integer;
   Continuar : Boolean;

Begin
  Operador:= #0; Termino.Op:= #0; Factor.Op:= #0; Arg:= 0.0;
  Tope:= Length(_Formula); p:=1; A:= 0.0; Identif:= ''; B:= 0.0;
  Continuar:= True;
  While (p <= Tope) and Continuar Do
    Begin
      Case _Formula[p] of
               '(': Begin
                      Inc(p); Tot_par:= 1; Parentesis:='';
                      while (Tot_Par<>0) and (p <=Tope) do
                       Begin
                         if _Formula[p] = '(' then tot_par:= tot_par + 1;
                         if _Formula[p] = ')' then tot_par:= tot_par - 1;
                         if Tot_Par<>0 then
                            Begin
                              Parentesis:= Parentesis + _Formula[p];
                              Inc(p);
                            End;
                       End;
                      if Identif <>'' then
                         Arg:= Valor_FunLIB(Identif, Func(Parentesis,x))
                      else
                         Arg:= Func(Parentesis, x);
                      if Arg = Indefinido then Continuar:= False;
                      if Operador =#0 then
                         A:= Arg
                      else
                         B:= Arg;
                    End;
          '0'..'9': Begin
                       parentesis:='';
                       While (p<= Tope) and (_Formula[p] in ['0'..'9','.']) do
                           begin
                              parentesis:= parentesis + _Formula[p];
                              Inc(p);
                           end;

                       If (p < Tope) and (_Formula[p] = 'E') then //in ['E','+','-'] then
                          Begin
                             parentesis:= parentesis + _Formula[p];
                             Inc(p);

                             If _Formula[p] in ['+','-'] then
                                Begin
                                   parentesis:= parentesis + _Formula[p];
                                   Inc(p);
                                End;

                             While (p<= Tope) and (_Formula[p] in ['0'..'9']) do
                                begin
                                   parentesis:= parentesis + _Formula[p];
                                   Inc(p);
                                end;
                          End;

                       val(parentesis, Arg, code);
                       if Identif <>'' then
                          Arg:= Valor_FunLIB(Identif, Arg);

                      if Arg = Indefinido then Continuar:= False;

                       if Operador =#0 then
                          A:= Arg
                       else
                          B:= Arg;
                       Dec(p);
                    End;

          'X','ã' : Begin
                      Case _Formula[p] of
                           'X' : Arg:= X;
                           'ã' : Arg:= Pi;
                      End;
                      if Identif <>'' then
                         Arg:= Valor_FunLIB(Identif, Arg);
                      if Arg = Indefinido then Continuar:= False;
                      if Operador =#0 then
                         A:= Arg
                      else
                         B:= Arg;
                    End;

          'A','C',
          'E','I',
          'L','S','T': Begin
                         Identif:='';
                         while (p<=Tope) and Not (_Formula[p] in [' ','(']) do
                             Begin
                               Identif:= Identif + _Formula[p];
                               Inc(p);
                             End;
                         Dec(p);
                       End;

          '+','-' : Begin
                      if Operador <>#0 then
                         Begin
                           A:= Operar(a, b, Operador);
                           if A = Indefinido then Continuar:= False;
                           if (Factor.Op <>#0) and Continuar then
                              A:= Operar(Factor.a, a, Factor.Op);
                           if A = Indefinido then Continuar:= False;
                           if (Termino.Op <>#0) and Continuar then
                              A:= Operar(Termino.a, a, Termino.Op);
                         End;
                      Operador:= _Formula[p];
                    End;

          '*','/' : Begin
                      if Operador in ['+','-'] then
                         Begin
                           Termino.a:= a;
                           Termino.Op:= Operador;
                           A:= b;
                         End
                      else if Operador <>#0 then
                              Begin
                                A:= Operar(a, b, Operador);
                                if A=Indefinido then Continuar:= False;
                                if (Factor.Op <>#0) and Continuar then
                                   A:= Operar(Factor.a, a, Factor.Op);
                              End;
                      Operador:= _Formula[p];
                    End;

          '^','û' : Begin
                      Case Operador of
                         '+','-' : Begin
                                     Termino.a:= a;
                                     Termino.op:= Operador;
                                     a:= b;
                                   End;
                         '*','/' : Begin
                                     Factor.a:= a;
                                     Factor.Op:= Operador;
                                     a:= b;
                                   End;
                         else
                                   if Operador <>#0 then
                                      Begin
                                        A:= Operar(a, b, Operador);
                                        if A=Indefinido then Continuar:=False;
                                      End;
                      End;
                      Operador:= _Formula[p];
                    End;
      End;
      Repeat
        Inc(p);
      Until _Formula[p] <>' ';
    End;

  if Continuar then
    Begin
      if Operador <> #0 then A:= Operar(a, b, Operador);
      if Factor.Op<> #0 then A:= Operar(Factor.a, a, Factor.Op);
      if Termino.Op<>#0 then A:= Operar(Termino.a, a, Termino.Op);
      Func:= A;
    End
  else
     Func:= Indefinido;
END;

Function TFuncion.Valor(Var Ex : ShortString): Extended;
Var Numerador, Denominador: Extended;
        P : Integer;
        N, D : ShortString;
Begin
   If ChkNumero(Ex) Then
     Begin
        Val(Ex, Result, P);
        If Not (Frac(Result)=0.0) then
          Begin
             Numerador:= 2.0 * Trunc(Result);
             Repeat
                Numerador:= Numerador + 1.0;
                Denominador:= Numerador / Result;
                If (Int(Denominador+1.0)-Denominador) < 1.0e-10 Then
                   Denominador:= Int(Denominador+1.0);
                If Frac(Denominador)<= 1.0e-10 Then
                   Denominador:= Int(Denominador);
             Until Frac(Denominador) = 0.0;
             N:= FloatToStr(Numerador);
             D:= FloatToStr(Denominador);
             Ex := N+'/'+D;
          End;
     End
   Else
     Result := Func(Ex, 0);
End;

FUNCTION TFuncion.f(x:Extended):Extended;
Begin { f(x) }
   f:= Func(Fnc, x);
End;

Function TFuncion.Validar_Expresion(s: ShortString): boolean;
Var p : integer;
Begin
   s:= UpperCase(s);
   Validar_Expresion:= validar(s,p);
End;

Procedure TFuncion.Setup(strg: ShortString);
Var p: integer;
    j:boolean;
    fu:shortstring;
Begin
   fu:= UpperCase(strg);
   if not validar(fu,p) then
     // writeln(' La Formula ingresada es Incorrecta !!!')
   else
     Fnc:=fu;

End;

Function TFuncion.GetExpresion: ShortString;
Begin
   GetExpresion:= Fnc;
End;

END.
