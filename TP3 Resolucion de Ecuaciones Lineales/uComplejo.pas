unit uComplejo;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils;
type
    clsComplejo = class
        private
            real     : extended;
            imag     : extended;
        public
            constructor crear();
            constructor crear(r: extended; i: extended);
            procedure setReal(r: extended);
            function getReal(): extended;
            procedure setImag(i: extended);
            function getImag(): extended;
            procedure mostrarComplejo();
    end;
implementation

    constructor clsComplejo.crear();
    begin
        real:=0;
        imag:=0;
    end;
{******************************************************************************}
    constructor clsComplejo.crear(r: extended; i: extended);
    begin
        real:= r;
        imag:= i;
    end;
{******************************************************************************}
    procedure clsComplejo.setReal(r: extended);
    begin
        real:=r;
    end;
{******************************************************************************}
    function clsComplejo.getReal(): extended;
    begin
        result:= real;
    end;
{******************************************************************************}
    procedure clsComplejo.setImag(i: extended);
    begin
        imag:=i;
    end;
{******************************************************************************}
    function clsComplejo.getImag(): extended;
    begin
        result:= imag;
    end;
{******************************************************************************}
    procedure clsComplejo.mostrarComplejo();

    begin

        if (imag=0)then
            writeln(real:2:6)
        else
            if (real=0) then
                writeln(imag:2:6,' i')
            else
                if(imag<0) then
                    writeln(real:2:6,' - ',abs(imag):2:6,' i')
                else
                    writeln(real:2:6,' + ',imag:2:6,' i');
    end;


end.

