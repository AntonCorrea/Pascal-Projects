unit uRacional;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils, math;
type
    clsRacional = class
        private
            numerador     : integer;
            denominador   : integer;
            function MCD(a,b : integer):integer;
            procedure simplificar();

        public
            constructor crear();
            constructor crear(n: integer; d: integer);
            procedure setNumerador(n: integer);
            function getNumerador(): integer;
            procedure setDenominador(d: integer);
            function getDenominador(): integer;
            function getValorReal(): extended;
            function iguales(rac: clsRacional): boolean;
            procedure mostrarRacional();
    end;

implementation

    constructor clsRacional.crear();
    begin
        numerador:=0;
        denominador:=1;
    end;
{******************************************************************************}
    constructor clsRacional.crear(n: integer; d: integer);
    begin
        numerador:= n;
        denominador:= d;
        simplificar();
    end;
{******************************************************************************}
    function clsRacional.MCD(a,b: integer):integer;
    begin
        if b=0 then
            MCD := a
        else
            MCD := MCD(b,a mod b);
    end;
{******************************************************************************}
    procedure clsRacional.simplificar();
    var
        aux: integer;
    begin
        if(denominador<0) then
            if(numerador<0) then
                begin
                    numerador:= abs(numerador);
                    denominador:= abs(denominador);
                end
            else
                begin
                    numerador:= - numerador;
                    denominador:= abs(denominador);
                end;
        aux:= MCD(abs(numerador),abs(denominador));
        numerador:= numerador div aux;
        denominador:= denominador div aux;
    end;
{******************************************************************************}
    procedure clsRacional.setNumerador(n: integer);
    begin
        numerador:=n;
    end;
{******************************************************************************}
    function clsRacional.getNumerador(): integer;
    begin
        result:= numerador;
    end;
{******************************************************************************}
    procedure clsRacional.setDenominador(d: integer);
    begin
        denominador:=d;
    end;
{******************************************************************************}
    function clsRacional.getDenominador(): integer;
    begin
        result:= denominador;
    end;
{******************************************************************************}
    function clsRacional.getValorReal(): extended;
    begin
        result:= numerador/denominador;
    end;
{******************************************************************************}
    function clsRacional.iguales(rac: clsRacional): boolean;
    begin
        result:= ((numerador=rac.getNumerador) and (denominador=rac.getDenominador));
    end;
{******************************************************************************}
    procedure clsRacional.mostrarRacional();
    begin
        write(numerador,'/',denominador);
    end;


end.
