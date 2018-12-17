unit guiBK;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ComCtrls, ExtCtrls, MaskEdit, Grids, Menus,ecunolineales,uFuncion;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    ComboBox1: TComboBox;
    Edit1: TEdit;
    Edit31: TEdit;
    Edit32: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    EditBisecP: TEdit;
    EditBisecIter: TEdit;
    Edit15: TEdit;
    Edit16: TEdit;
    Edit17: TEdit;
    Edit18: TEdit;
    Edit19: TEdit;
    Edit2: TEdit;
    Edit20: TEdit;
    Edit21: TEdit;
    Edit22: TEdit;
    Edit23: TEdit;
    Edit24: TEdit;
    Edit3: TEdit;
    Edit38: TEdit;
    Edit39: TEdit;
    Edit4: TEdit;
    Error3: TLabel;
    Funcion3: TLabel;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Image1: TImage;
    Iter: TLabel;
    Iter1: TLabel;
    Iter2: TLabel;
    Iter3: TLabel;
    Iter4: TLabel;
    Iter5: TLabel;
    Label1: TLabel;
    Label13: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Metodo: TLabel;
    Metodo1: TLabel;
    Metodo2: TLabel;
    PageControl1: TPageControl;
    Panel2: TPanel;
    StringGrid1: TStringGrid;
    StringGrid2: TStringGrid;
    StringGrid3: TStringGrid;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    X: TLabel;
    X1: TLabel;
    X2: TLabel;
    X3: TLabel;
    X4: TLabel;
    X5: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    function cargarFuncion(s1:string;s2:string):boolean;




  private

  public

  end;

var
  Form1: TForm1;
  Ecu:TNoLineales;

implementation

{$R *.lfm}

{ TForm1 }
//CargarFuncion
Function TForm1.cargarFuncion(s1:string;s2:string):boolean;
var
 car:boolean;
 e:extended;
 error:integer;
Begin
  Ecu:=TNoLineales.crear;
  val(s2,e,error);
  if error=0 then
    Begin
        car:=Ecu.Cargar(s1,e);
        if car then
          cargarFuncion:=TRUE
        else
          cargarFuncion:=FALSE;
    end
  else
     ShowMessage('INVALIDO');
end;

//Al presionar el boton comparar...
procedure TForm1.Button2Click(Sender: TObject);
var
 a,b,z:extended;
 error1,error2:integer;
 car:boolean;
 aux1,aux2:string;
Begin
  if cargarFuncion(Edit32.Text,Edit31.Text) then
    Begin
          if(CheckBox1.Checked) then
          Begin
               val(Edit1.Text,a,error1);
               val(Edit5.Text,b,error2);
               if ((error1=0) and (error2=0)) then
                  Begin
                       car:=Ecu.CargaIntervalo(a,b);
                       if car then
                         Begin
                            z:=Ecu.Biseccion();
                            if (z = Indefinido) then
                               ShowMessage('No se pudo aplicar el metodo de Biseccion.')
                            else
                               Begin
                                  str(z,aux1);
                                  str(Ecu.iteraciones,aux2);
                                  EditBisecP.Caption:=aux1;
                                  EditBisecIter.Caption:=aux2;
                               end;
                         end
                       else
                           ShowMessage('El intervalo no es valido.');
                  end
               else
                   if (error1)<>0 then
                      ShowMessage('Error en el intervalo,limite inferior')
                   else
                       ShowMessage('Error en el intervalo,limite superior');
          end
          else
              Begin
                   EditBisecP.Text:='';
                   EditBisecIter.Text:='';
              end;
          if(CheckBox2.Checked) then
            Begin
                 val(Edit1.Text,a,error1);
                 val(Edit5.Text,b,error2);
                 if ((error1=0) and (error2=0)) then
                    Begin
                         car:=Ecu.CargaIntervalo(a,b);
                         if car then
                           Begin
                              z:=Ecu.RegulaFalsi();
                              if (z = Indefinido) then
                                 ShowMessage('No se pudo aplicar el metodo de Regula Falsi.')
                              else
                                 Begin
                                    str(z,aux1);
                                    str(Ecu.iteraciones,aux2);
                                    Edit17.Caption:=aux1;
                                    Edit18.Caption:=aux2;
                                 end;
                           end
                         else
                             ShowMessage('El intervalo no es valido.');
                    end
                 else
                     if (error1)<>0 then
                        ShowMessage('Error en el intervalo,limite inferior')
                     else
                         ShowMessage('Error en el intervalo,limite superior');
            end
          else
              Begin
                   Edit17.Text:='';
                   Edit18.Text:='';
              end;
          if(CheckBox3.Checked) then
            Begin
                 val(Edit1.Text,a,error1);
                 val(Edit5.Text,b,error2);
                 if ((error1=0) and (error2=0)) then
                    Begin
                         car:=Ecu.CargaIntervalo(a,b);
                         if car then
                           Begin
                              z:=Ecu.RegulaFalsiMod();
                              if (z = Indefinido) then
                                 ShowMessage('No se pudo aplicar el metodo de Regula Falsi Modificada.')
                              else
                                 Begin
                                    str(z,aux1);
                                    str(Ecu.iteraciones,aux2);
                                    Edit21.Caption:=aux1;
                                    Edit22.Caption:=aux2;
                                 end;
                           end
                         else
                             ShowMessage('El intervalo no es valido.');
                    end
                 else
                     if (error1)<>0 then
                        ShowMessage('Error en el intervalo,limite inferior')
                     else
                         ShowMessage('Error en el intervalo,limite superior');
            end
          else
              Begin
                   Edit21.Text:='';
                   Edit22.Text:='';
              end;
          if(CheckBox4.Checked) then
               Begin
                 val(Edit2.Text,a,error1);
                 if (error1=0) then
                    Begin
                              z:=Ecu.Newton(a);
                              if (z = Indefinido) then
                                 ShowMessage('No se pudo aplicar el metodo de Newton.')
                              else
                                 Begin
                                    str(z,aux1);
                                    str(Ecu.iteraciones,aux2);
                                    Edit15.Caption:=aux1;
                                    Edit16.Caption:=aux2;
                                 end;
                    end
                 else
                     ShowMessage('Error en el punto inicial');

               end
          else
              Begin
                   Edit15.Text:='';
                   Edit16.Text:='';
              end;
          if(CheckBox5.Checked) then
             Begin
               val(Edit2.Text,a,error1);
               if (error1=0) then
                  Begin
                            z:=Ecu.NewtonHH(a);
                            if (z = Indefinido) then
                               ShowMessage('No se pudo aplicar el metodo Cubico.')
                            else
                               Begin
                                  str(z,aux1);
                                  str(Ecu.iteraciones,aux2);
                                  Edit19.Caption:=aux1;
                                  Edit20.Caption:=aux2;
                               end;
                  end
               else
                   ShowMessage('Error en el punto inicial');

             end
          else
          Begin
               Edit19.Text:='';
               Edit20.Text:='';
          end;
          if(CheckBox6.Checked) then
             Begin
                  val(Edit3.Text,a,error1);
                  val(Edit4.Text,b,error2);
                  if ((error1=0) and (error2=0)) then
                     Begin
                               z:=Ecu.Secante(a,b);
                               if (z = Indefinido) then
                                  ShowMessage('No se pudo aplicar el metodo de la Secante.')
                               else
                                  Begin
                                     str(z,aux1);
                                     str(Ecu.iteraciones,aux2);
                                     Edit23.Caption:=aux1;
                                     Edit24.Caption:=aux2;
                                  end;
                     end
                  else
                      if (error1)<>0 then
                         ShowMessage('Error en el primer punto inicial.')
                      else
                          ShowMessage('Error en el segundo punto inicial.');
             end
          else
            Begin
                 Edit23.Text:='';
                 Edit24.Text:='';
            end;
    end;

end;
//Al presionar el boton aproximar...
procedure TForm1.Button1Click(Sender: TObject);
var
 a,b,z:extended;
 error1,error2,h,i,j,k,aux:integer;
 car:boolean;
 cadena,aux1,aux2:string;
begin
if  cargarFuncion(Edit32.Text,Edit31.Text) then
  Begin
     if(ComboBox1.ItemIndex=0) then
       Begin

            val(Edit38.Text,a,error1);
            val(Edit39.Text,b,error2);
            if ((error1=0) and (error2=0)) then
              Begin
                  car:=Ecu.CargaIntervalo(a,b);
                  if car then
                    Begin
                        z:=Ecu.Biseccion();
                        if (z = Indefinido) then
                              ShowMessage('No se pudo aplicar el metodo de Biseccion.')
                        else
                            begin
                                StringGrid1.RowCount:=Ecu.iteraciones+1;
                                for k:=1 to Ecu.iteraciones do
                                  begin
                                      cadena:=Ecu.vecStr[k];
                                      for j:=1 to 6 do
                                          begin
                                               aux:=1;
                                               i:=-1;
                                               h:=1;
                                               while (i=-1) and (h<=length(cadena)) do
                                                   begin
                                                        if (cadena[h]=':') then
                                                           begin
                                                                i:=h;
                                                                StringGrid1.Cells[j-1,k]:=copy(cadena,1,i-1);
                                                                aux:=i+1;
                                                                cadena := copy(cadena,aux,length(cadena));

                                                           end
                                                        else
                                                            begin
                                                                 if (h=length(cadena)) then
                                                                    StringGrid1.Cells[j-1,k]:= cadena;
                                                                 h:= h+1;
                                                            end;

                                                   end;
                                          end;

                                  end;
                               STringGrid1.Visible:=True;
                               STringGrid2.Visible:=False;
                               STringGrid3.Visible:=False;
                               Metodo1.Visible:=TRUE;
                               Metodo2.Visible:=TRUE;
                               Edit6.Visible:=TRUE;
                               Edit7.Visible:=TRUE;
                               str(z,aux1);
                               Edit6.Caption:=aux1;
                               str(Ecu.iteraciones,aux2);
                               Edit7.Caption:=aux2;
                            end;
                   end
                  else
                      ShowMessage('El intervalo no es valido.');
              end
            else
             Begin
               if (error1)<>0 then
                   ShowMessage('Error en el intervalo,limite inferior')
               else
                   ShowMessage('Error en el intervalo,limite superior');
             end;
       end;
       if (ComboBox1.ItemIndex=1) then
         Begin

            val(Edit38.Text,a,error1);
            val(Edit39.Text,b,error2);
            if ((error1=0) and (error2=0)) then
              Begin
                  car:=Ecu.CargaIntervalo(a,b);
                  if car then
                    Begin
                        z:=Ecu.RegulaFalsi();
                        if(z=InDefinido) then
                             ShowMessage('No se pudo aplicar el metodo de Regula Falsi.')
                        else
                            begin
                                  StringGrid1.RowCount:=Ecu.iteraciones+1;
                                  for k:=1 to Ecu.iteraciones do
                                    begin
                                        cadena:=Ecu.vecStr[k];
                                        for j:=1 to 6 do
                                            begin
                                                 aux:=1;
                                                 i:=-1;
                                                 h:=1;
                                                 while (i=-1) and (h<=length(cadena)) do
                                                     begin
                                                          if (cadena[h]=':') then
                                                             begin
                                                                  i:=h;
                                                                  StringGrid1.Cells[j-1,k]:=copy(cadena,1,i-1);
                                                                  aux:=i+1;
                                                                  cadena := copy(cadena,aux,length(cadena));

                                                             end
                                                          else
                                                              begin
                                                                   if (h=length(cadena)) then
                                                                      StringGrid1.Cells[j-1,k]:= cadena;
                                                                   h:= h+1;
                                                              end;

                                                     end;
                                            end;

                                    end;
                                 STringGrid1.Visible:=True;
                                 STringGrid2.Visible:=False;
                                 STringGrid3.Visible:=False;
                                 Metodo1.Visible:=TRUE;
                                 Metodo2.Visible:=TRUE;
                                 Edit6.Visible:=TRUE;
                                 Edit7.Visible:=TRUE;
                                 str(z,aux1);
                                 Edit6.Caption:=aux1;
                                 str(Ecu.iteraciones,aux2);
                                 Edit7.Caption:=aux2;
                            end;
                   end
                  else
                      ShowMessage('El intervalo no es valido.');
              end
                 else
                     Begin
                       if (error1)<>0 then
                           ShowMessage('Error en el intervalo,limite inferior')
                       else
                           ShowMessage('Error en el intervalo,limite superior');
                     end;
         end;
         if (ComboBox1.ItemIndex=2)then
           Begin

                       val(Edit38.Text,a,error1);
                       val(Edit39.Text,b,error2);
                       if ((error1=0) and (error2=0)) then
                         Begin
                             car:=Ecu.CargaIntervalo(a,b);
                             if car then
                               Begin
                                   z:=Ecu.RegulaFalsiMod();
                                   if(z=InDefinido) then
                                        ShowMessage('No se pudo aplicar el metodo de Regula Falsi Modificada.')
                                   else
                                       begin
                                             StringGrid1.RowCount:=Ecu.iteraciones+1;
                                             for k:=1 to Ecu.iteraciones do
                                               begin
                                                   cadena:=Ecu.vecStr[k];
                                                   for j:=1 to 6 do
                                                       begin
                                                            aux:=1;
                                                            //for i:=1 to length(cadena) do
                                                            i:=-1;
                                                            h:=1;
                                                            while (i=-1) and (h<=length(cadena)) do
                                                                begin
                                                                     if (cadena[h]=':') then
                                                                        begin
                                                                             i:=h;
                                                                             StringGrid1.Cells[j-1,k]:=copy(cadena,1,i-1);
                                                                             aux:=i+1;
                                                                             cadena := copy(cadena,aux,length(cadena));

                                                                        end
                                                                     else
                                                                         begin
                                                                              if (h=length(cadena)) then
                                                                                 StringGrid1.Cells[j-1,k]:= cadena;
                                                                              h:= h+1;
                                                                         end;

                                                                end;
                                                       end;

                                               end;
                                            STringGrid1.Visible:=True;
                                            STringGrid2.Visible:=False;
                                            STringGrid3.Visible:=False;
                                            Metodo1.Visible:=TRUE;
                                            Metodo2.Visible:=TRUE;
                                            Edit6.Visible:=TRUE;
                                            Edit7.Visible:=TRUE;
                                            str(z,aux1);
                                            Edit6.Caption:=aux1;
                                            str(Ecu.iteraciones,aux2);
                                            Edit7.Caption:=aux2;
                                       end;
                               end
                                  else
                                      ShowMessage('El Intervalo no es valido.');
                         end
                            else
                                 Begin
                                   if (error1)<>0 then
                                       ShowMessage('Error en el intervalo,limite inferior')
                                   else
                                       ShowMessage('Error en el intervalo,limite superior');
                                 end;
           end;
       if(ComboBox1.ItemIndex=3) then
       Begin

            val(Edit38.Text,a,error1);
            if (error1=0) then
              Begin
                    z:=Ecu.Newton(a);
                    if(z=InDefinido) then
                        ShowMessage('No se pudo aplicar el metodo de Newton.')
                    else
                        begin
                            StringGrid2.RowCount:=Ecu.iteraciones+1;
                            for k:=1 to Ecu.iteraciones do
                              begin
                                  cadena:=Ecu.vecStr[k];
                                  for j:=1 to 5 do
                                      begin
                                           aux:=1;
                                           i:=-1;
                                           h:=1;
                                           while (i=-1) and (h<=length(cadena)) do
                                               begin
                                                    if (cadena[h]=':') then
                                                       begin
                                                            i:=h;
                                                            //ShowMessage(cadena[h]);
                                                            StringGrid2.Cells[j-1,k]:=copy(cadena,1,i-1);
                                                            aux:=i+1;
                                                            cadena := copy(cadena,aux,length(cadena));

                                                       end
                                                    else
                                                        begin
                                                             if (h=length(cadena)) then
                                                                StringGrid2.Cells[j-1,k]:= cadena;
                                                             h:= h+1;
                                                        end;

                                               end;
                                      end;

                              end;
                            STringGrid1.Visible:=False;
                            STringGrid2.Visible:=True;
                            STringGrid3.Visible:=False;
                            Metodo1.Visible:=TRUE;
                            Metodo2.Visible:=TRUE;
                            Edit6.Visible:=TRUE;
                            Edit7.Visible:=TRUE;
                            str(z,aux1);
                            Edit6.Caption:=aux1;
                            str(Ecu.iteraciones,aux2);
                            Edit7.Caption:=aux2;
                        end;
              end


            else
                ShowMessage('Punto Inicial no valido.');
       end;
       if(ComboBox1.ItemIndex=4) then
       Begin

            val(Edit38.Text,a,error1);
            val(Edit39.Text,b,error2);
            if ((error1=0) and (error2=0)) then
              Begin
                    z:=Ecu.Secante(a,b);
                    if(z=InDefinido) then
                        ShowMessage('No se pudo aplicar el metodo de la Secante.')
                    else
                        begin
                              StringGrid3.RowCount:=Ecu.iteraciones+1;
                              for k:=1 to Ecu.iteraciones do
                                begin
                                    cadena:=Ecu.vecStr[k];
                                    for j:=1 to 6 do
                                        begin

                                             aux:=1;
                                             i:=-1;
                                             h:=1;
                                             while (i=-1) and (h<=length(cadena)) do
                                                 begin
                                                      if (cadena[h]=':') then
                                                         begin
                                                              i:=h;
                                                              StringGrid3.Cells[j-1,k]:=copy(cadena,1,i-1);
                                                              aux:=i+1;
                                                              cadena := copy(cadena,aux,length(cadena));

                                                         end
                                                      else
                                                          begin
                                                               if (h=length(cadena)) then
                                                                  StringGrid3.Cells[j-1,k]:= cadena;
                                                               h:= h+1;
                                                          end;

                                                 end;
                                        end;

                                end;
                              STringGrid1.Visible:=False;
                              STringGrid2.Visible:=False;
                              STringGrid3.Visible:=True;
                              Metodo1.Visible:=TRUE;
                              Metodo2.Visible:=TRUE;
                              Edit6.Visible:=TRUE;
                              Edit7.Visible:=TRUE;
                              str(z,aux1);
                              Edit6.Caption:=aux1;
                              str(Ecu.iteraciones,aux2);
                              Edit7.Caption:=aux2;
                        end;

              end


            else
             Begin
               if (error1)<>0 then
                   ShowMessage('Error en el primer punto inicial.')
               else
                   ShowMessage('Error en el segundo punto inicial.');
             end;
       end;
       if(ComboBox1.ItemIndex=5) then
       Begin

            val(Edit38.Text,a,error1);
            if (error1=0) then
              Begin
                    z:=Ecu.NewtonHH(a);
                    if(z=InDefinido) then
                         ShowMessage('No se pudo aplicar el metodo de convergencia Cubica.')
                    else
                        begin
                              StringGrid2.RowCount:=Ecu.iteraciones+1;
                              for k:=1 to Ecu.iteraciones do
                                begin
                                    cadena:=Ecu.vecStr[k];
                                    for j:=1 to 5 do
                                        begin
                                             aux:=1;
                                             i:=-1;
                                             h:=1;
                                             while (i=-1) and (h<=length(cadena)) do
                                                 begin
                                                      if (cadena[h]=':') then
                                                         begin
                                                              i:=h;
                                                              StringGrid2.Cells[j-1,k]:=copy(cadena,1,i-1);
                                                              aux:=i+1;
                                                              cadena := copy(cadena,aux,length(cadena));

                                                         end
                                                      else
                                                          begin
                                                               if (h=length(cadena)) then
                                                                  StringGrid2.Cells[j-1,k]:= cadena;
                                                               h:= h+1;
                                                          end;

                                                 end;
                                        end;

                                end;
                              STringGrid1.Visible:=False;
                              STringGrid2.Visible:=True;
                              STringGrid3.Visible:=False;
                              Metodo1.Visible:=TRUE;
                              Metodo2.Visible:=TRUE;
                              Edit6.Visible:=TRUE;
                              Edit7.Visible:=TRUE;
                              str(z,aux1);
                              Edit6.Caption:=aux1;
                              str(Ecu.iteraciones,aux2);
                              Edit7.Caption:=aux2;
                        end;
              end
            else
                 ShowMessage('Punto Inicial no valido.');
       end;

     StringGrid1.ExtendedColSizing:=True;
     StringGrid2.ExtendedColSizing:=True;
     StringGrid3.ExtendedColSizing:=True;
     StringGrid1.AutoSizeColumns;
     StringGrid2.AutoSizeColumns;
     StringGrid3.AutoSizeColumns;
     StringGRid1.Options:=[goFixedVertLine,goFixedHorzLine,goVertLine,goHorzLine,goRangeSelect,goSmoothScroll,goColSizing];
     StringGRid2.Options:=[goFixedVertLine,goFixedHorzLine,goVertLine,goHorzLine,goRangeSelect,goSmoothScroll,goColSizing];
     StringGRid3.Options:=[goFixedVertLine,goFixedHorzLine,goVertLine,goHorzLine,goRangeSelect,goSmoothScroll,goColSizing];

  end
else
    Begin
         ShowMessage('FUNCION INVALIDA');
    end;
end;

//Mostrar/Ocultar campos de la primera pestaña
procedure TForm1.ComboBox1Change(Sender: TObject);
begin
     if(ComboBox1.ItemIndex=-1) then
     begin
          Label5.Visible:=False;
          Label13.Visible:=False;
          Label18.Visible:=False;
          Label5.Visible:=False;
          Label13.Visible:=False;
          Label18.Visible:=False;
          Edit38.Visible:=True;
          Edit39.Visible:=True;
     end
     else
     begin
       if((ComboBox1.ItemIndex=0) or (ComboBox1.ItemIndex=1) or (ComboBox1.ItemIndex=2))then
         begin
              Label5.Visible:=True;
              Label13.Visible:=True;
              Label18.Visible:=True;
              Edit38.Visible:=True;
              Edit39.Visible:=True;
              //No quiero ver...
              Label6.Visible:=False;
              Label17.Visible:=False;
              Label19.Visible:=False;
         end
       else
       if((ComboBox1.ItemIndex=3) or (ComboBox1.ItemIndex=5))then
         begin
              Label6.Visible:=True;
              Label17.Visible:=True;
              Edit38.Visible:=True;
              //No quiero ver...
              Label19.Visible:=False;
              Edit39.Visible:=False;
              Label5.Visible:=False;
              Label13.Visible:=False;
              Label18.Visible:=False;
          end
       else
       begin

              Label19.Visible:=True;
              Edit39.Visible:=True;
              Edit38.Visible:=True;
              Label17.Visible:=True;
              Label6.Visible:=True;
              //No quier ver...
              Label5.Visible:=False;
              Label13.Visible:=False;
              Label18.Visible:=False;
       end;
     end;
end;



end.

