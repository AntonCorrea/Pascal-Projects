unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Spin,
  StdCtrls, Grids, ExtCtrls, Menus, EditBtn,uVector,uMatriz,uSistLineales;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    ComboBox1: TComboBox;
    Edit1: TEdit;
    Edit2: TEdit;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Panel1: TPanel;
    Pivoteo: TRadioGroup;
    SpinEdit1: TSpinEdit;
    StringGrid1: TStringGrid;
    StringGrid2: TStringGrid;
    StringGrid3: TStringGrid;
    StringGrid4: TStringGrid;
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure UpdateGrids();
    procedure Button1Click(Sender: TObject);
    procedure SpinEdit1Change(Sender: TObject);
    function checkMatriz(matriz: TStringGrid): boolean;
    procedure RandomMatriz(matriz: TStringGrid);
    procedure ClearMatriz(matriz: TStringGrid);
    procedure CargarMatriz();
    procedure CargarVector();
    procedure CargarVectorX();
    procedure CargarResultado();
  private

  public

  end;

var
  Form1: TForm1;
  vec: tVector;
  x0,vector,vector1: clsVector;
  e: extended;
  m: tMatriz;
  matriz: clsMatriz;
  sist: clsSistLineales;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.CargarMatriz();
var
  i,j:integer;
begin
  for i:=0 to SpinEdit1.Value-1 do
        for j:=0 to SpinEdit1.Value-1 do
              begin
                   m[i+1,j+1]:=StringGrid1.Cells[j,i].ToExtended;
                   //showmessage(concat('cargado: ',m[i+1,j+1].ToString()));

              end;
end;

procedure TForm1.CargarVector();
var
  i:integer;
begin
  for i:=0 to SpinEdit1.Value-1 do
      begin
           vec[i+1]:=StringGrid3.Cells[0,i].ToExtended;

      end;
end;

procedure TForm1.CargarVectorX();
var
  i:integer;
begin
  for i:=0 to SpinEdit1.Value-1 do
      begin
           vec[i+1]:=StringGrid4.Cells[i,0].ToExtended;
      end;
end;

procedure TForm1.CargarResultado();
var
i:integer;
begin
  for i:=0 to spinedit1.value-1 do
     StringGrid2.Cells[0,i]:=vector1.getElementos()[i+1].ToString();
end;

procedure TForm1.Button1Click(Sender: TObject);
var
 b:boolean;
begin
  b:=True;
  if((checkMatriz(StringGrid1))and(checkMatriz(StringGrid3))) then
     begin
         CargarMatriz();
         matriz:=clsMatriz.crear(SpinEdit1.Value,m);
         CargarVector();
         vector:=clsVector.crear(SpinEdit1.Value,vec);
         sist:=clsSistLineales.crear(matriz,vector);
         vector1.crear(SpinEdit1.Value);
         if sist.calcDeter()<>0 then
         begin
              e:=strtofloat(edit1.text);
             case ComboBox1.ItemIndex of
               0:begin //Gauss
                       vector1:=sist.gauss(Pivoteo.ItemIndex+1);
               end;
               1:begin //Gauss-Jordan
                       vector1:=sist.gaussJordan(Pivoteo.ItemIndex+1);
               end;
               2:begin //Cruot
                       if ((matriz.condNySFactLU()) and (matriz.simetrica()))  then
                          vector1:=sist.croutL1U()
                       else
                           begin
                                showmessage('La matriz A no cumple las condiciones para aplicar Crout.');
                                b:=False;
                           end;
               end;
               3:begin //Cholesky
                       if ((matriz.condNySFactLU()) and (matriz.simetrica()) and (matriz.definidaPositiva()))  then
                          vector1:=sist.choleskyU()
                       else
                           begin
                                showmessage('La matriz A no cumple las condiciones para aplicar Cholesky.');
                                b:=False;
                           end;

               end;
               4:begin //Gauss-Seidel
                       if(matriz.diagonalDominante()) then
                       begin
                         CargarVectorX();
                         x0:=clsVector.crear(SpinEdit1.Value,vec);
                         vector1:=sist.sor(x0,e,1);
                       end
                       else
                       begin
                          showmessage('La matriz A no cumple las condiciones para aplicar .');
                          b:=False;
                       end;
               end;
               5:begin //Jacobi
                       if(matriz.diagonalDominante()) then
                       begin
                       CargarVectorX();
                       x0:=clsVector.crear(SpinEdit1.Value,vec);
                       vector1:=sist.jacobi(x0,e);
                       end
                       else
                       begin
                          showmessage('La matriz A no cumple las condiciones para aplicar .');
                          b:=False;
                       end;

               end;
               6:begin //Relajamiento
                       if(matriz.diagonalDominante()) then
                       begin
                       CargarVectorX();
                       x0:=clsVector.crear(SpinEdit1.Value,vec);
                       vector1:=sist.relajamiento(x0,e);
                       end
                       else
                       begin
                          showmessage('La matriz A no cumple las condiciones para aplicar .');
                          b:=False;
                       end;
               end;
               7:begin //Mejoramiento
                       if(matriz.diagonalDominante()) then
                       begin
                       CargarVectorX();
                       x0:=clsVector.crear(SpinEdit1.Value,vec);
                       vector1:=sist.mejoramiento(x0,e);
                       end
                       else
                       begin
                          showmessage('La matriz A no cumple las condiciones para aplicar .');
                          b:=False;
                       end;

               end;
               8:begin //Sor
                       if(matriz.diagonalDominante()) then
                       begin
                       CargarVectorX();
                       x0:=clsVector.crear(SpinEdit1.Value,vec);
                       //e:=strtofloat(edit1.text);
                       vector1:=sist.sor(x0,e,strtofloat(edit2.text));
                       end
                       else
                       begin
                          showmessage('La matriz A no cumple las condiciones para aplicar .');
                          b:=False;
                       end;
               end;
             end;
         //imprima en la gui
         if b then
            CargarResultado();
         end
         else
             showmessage('El determinante de la matriz A es 0.');


     end
  else
  begin
       if not(checkMatriz(StringGrid1)) then
          ShowMessage('Revise la matriz A');
       if not(checkMatriz(StringGrid3)) then
          ShowMessage('Revise la matriz B');
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
     RandomMatriz(StringGrid1);
     RandomMatriz(StringGrid3);
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
     ClearMatriz(StringGrid1);
     ClearMatriz(StringGrid3);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  UpdateGrids();
  StringGrid4.ColCount:=SpinEdit1.Value;
end;

procedure TForm1.SpinEdit1Change(Sender: TObject);
begin
  UpdateGrids();
  StringGrid4.ColCount:=SpinEdit1.Value;
end;

procedure TForm1.ComboBox1Change(Sender: TObject);
begin
  if ((ComboBox1.ItemIndex=0)or(ComboBox1.ItemIndex=1)or(ComboBox1.ItemIndex=7)) then
     Pivoteo.Enabled:=True
  else
     Pivoteo.Enabled:=False;
  if((ComboBox1.ItemIndex>=4)and(ComboBox1.ItemIndex<=8)) then
  begin
     GroupBox1.Visible:=True;
     Pivoteo.Visible:=False;
     if ComboBox1.ItemIndex=8 then
     begin
        Label7.Visible:=True;
        Edit2.Visible:=True;
     end
     else
     begin
        Label7.Visible:=False;
        Edit2.Visible:=False;
     end
  end
  else
  begin
     GroupBox1.Visible:=False;
     Pivoteo.Visible:=True;
  end


end;

procedure TForm1.UpdateGrids();
var
  i:integer;
begin
  StringGrid1.ColCount:=SpinEdit1.Value;
  StringGrid1.RowCount:=SpinEdit1.Value;
  StringGrid2.RowCount:=SpinEdit1.Value;
  StringGrid3.RowCount:=SpinEdit1.Value;
  for i:=0 to SpinEdit1.Value-1 do
  begin
       StringGrid2.Cells[0,i]:=concat('X',i.ToString);
  end;
end;

procedure TForm1.RandomMatriz(matriz: TStringGrid);
var
  i,j:integer;
begin
  for j:=0 to matriz.RowCount-1 do
    for i:=0 to matriz.ColCount-1 do
        matriz.Cells[i,j]:= (random(100)-random(100)).ToString;
end;

procedure TForm1.ClearMatriz(matriz: TStringGrid);
var
  i,j:integer;
begin
  for j:=0 to matriz.RowCount-1 do
    for i:=0 to matriz.ColCount-1 do
        matriz.Cells[i,j]:= '';
end;

function TForm1.checkMatriz(matriz: TStringGrid): boolean;
var
  i,j:integer;
  r:boolean;
begin
  r:=True;
  UpdateGrids();
  for j:=0 to matriz.RowCount-1 do
  begin
       for i:=0 to matriz.ColCount-1 do
       begin
            if not (matriz.Cells[i,j].IsEmpty) then
            begin
                Try
                  StrToFloat(matriz.Cells[i,j]);
                except
                  On E: EConvertError do
                  begin
                    ShowMessage(concat('Valor invalido: ',matriz.Cells[i,j]));
                    r:=False;
                  end;
                end;
            end
            else
            r:=False;
       end;
  end;
  checkMatriz:=r;
end;

end.

