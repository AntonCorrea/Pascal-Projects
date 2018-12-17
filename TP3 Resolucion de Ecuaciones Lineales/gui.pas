unit gui;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ActnList, ExtCtrls, ComCtrls, uComplejo, uPolinomio, uRacional;

type
  TArrayS=array [0..15] of string;
  TEditArray=array[0..15] of TEdit;
  TLabelArray=array[0..14] of TLabel;
  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    Edit1: TEdit;
    Edit10: TEdit;
    Edit11: TEdit;
    Edit12: TEdit;
    Edit13: TEdit;
    Edit14: TEdit;
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
    Edit25: TEdit;
    Edit26: TEdit;
    Edit27: TEdit;
    Edit28: TEdit;
    Edit29: TEdit;
    Edit3: TEdit;
    Edit30: TEdit;
    Edit31: TEdit;
    Edit32: TEdit;
    Edit33: TEdit;
    Edit34: TEdit;
    Edit35: TEdit;
    Edit36: TEdit;
    Edit37: TEdit;
    Edit38: TEdit;
    Edit39: TEdit;
    Edit4: TEdit;
    Edit40: TEdit;
    Edit41: TEdit;
    Edit42: TEdit;
    Edit43: TEdit;
    Edit44: TEdit;
    Edit45: TEdit;
    Edit46: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label2: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label3: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    TabSheet6: TTabSheet;
    TabSheet7: TTabSheet;
    TabSheet8: TTabSheet;
    procedure Button1Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure Edit17Change(Sender: TObject);
    procedure Cargar();
  private
         EditArr: TEditArray;
         LabelArr: TLabelArray;
  public

  end;

var
  {Form1: TForm1;
  vec:TArray;
  vecS:TArrayS;
  polinomio,q:clsPolinomio;
  resto:extended;}
  Form1: TForm1;
  vecS:TArrayS;
  vec:tArray;
  vi:tListaImag;
  polinomio,Q:clsPolinomio;
  a,b,c,resto:extended;
  error2,error,error1,i:integer;
  cad:string;
  imag,real,x0:extended;

implementation
procedure TForm1.ComboBox1Change(Sender: TObject);
var
  i,j,c:integer;
begin
   EditArr[0]:=Edit1;
   EditArr[1]:=Edit2;
   EditArr[2]:=Edit3;
   EditArr[3]:=Edit4;
   EditArr[4]:=Edit5;
   EditArr[5]:=Edit6;
   EditArr[6]:=Edit7;
   EditArr[7]:=Edit8;
   EditArr[8]:=Edit9;
   EditArr[9]:=Edit10;
   EditArr[10]:=Edit11;
   EditArr[11]:=Edit12;
   EditArr[12]:=Edit13;
   EditArr[13]:=Edit14;
   EditArr[14]:=Edit15;
   EditArr[15]:=Edit16;


   LabelArr[0]:=Label2;
   LabelArr[1]:=Label3;
   LabelArr[2]:=Label4;
   LabelArr[3]:=Label5;
   LabelArr[4]:=Label6;
   LabelArr[5]:=Label7;
   LabelArr[6]:=Label8;
   LabelArr[7]:=Label9;
   LabelArr[8]:=Label10;
   LabelArr[9]:=Label11;
   LabelArr[10]:=Label12;
   LabelArr[11]:=Label13;
   LabelArr[12]:=Label14;
   LabelArr[13]:=Label15;
   LabelArr[14]:=Label16;


   //Actualizar labels
   for i:=0 to 14 do
       begin
       EditArr[i].Visible:= False;
       LabelArr[i].Visible:= False;
       end;
   EditArr[15].Visible:= False;

   c:=(Combobox1.ItemIndex);
   for i:=0 to c+1 do
       EditArr[i].Visible:= True;

   j:=c+2;
   for i:=0 to c do
   begin
       j:=j-1;
       LabelArr[i].Visible:= True;
       LabelArr[i].Caption:= ' *x^'+intToStr(j)+'+';
   end;
   //
   ComboBox2.Visible:=True;
   Label17.Visible:=True;

end;

procedure TForm1.Cargar();
var
 a:extended;
 i,error:integer;
begin
//Cargando...
   for i:=0 to ComboBox1.ItemIndex+1 do
   Begin
        val(EditArr[i].text,a,error);
        if (error=0) then
           vec[i]:=a
        else
            Showmessage('El coeficiente "'+EditArr[i].text+'" es incorrecto');
   end;
 //
   polinomio:= clsPolinomio.crear(ComboBox1.ItemIndex+1,vec);
end;

procedure TForm1.ComboBox2Change(Sender: TObject);
begin
   Cargar();
   PageControl1.TabIndex:=ComboBox2.ItemIndex;
   PageControl1.ShowTabs:=False;
   PageControl1.Visible:=True;
   Button1.Visible:=True;
end;

procedure TForm1.Edit17Change(Sender: TObject);
var
   a,x0:extended;
   error:integer;
   cad:string;
begin
   val(Edit17.Text,a,error);
   if(error=0) then
   begin
     x0:=a;
     a:=polinomio.evaluarPol(x0);
     str(a,cad);
     Edit18.Text:=cad;
   end
   else
       if not(Edit17.Text='') then
          showmessage('El valor para P(x) es Invalido');
end;


procedure TForm1.Button1Click(Sender: TObject);
var
{  error,error1,error2,i,a,b:integer;
  cad,c,r:string;
  v:tListInt;
  vr:tListRac;
  tam:integer;
  band:boolean;
  d,imag,real:extended;
  vi:tListaImag;}
  error,error1,error2,i,a,b:integer;
  c,r,cad:string;
  vec:tArray;
  v:tListInt;
  vr:tListRac;
  tam:integer;
  band:boolean;
  d,imag,real:extended;
  vi:tListaImag;
begin
  case ComboBox2.ItemIndex of
     0:begin
          Edit17Change(Sender);
     end;
     1:begin
        val(Edit19.Text,a,error1);
        val(Edit20.Text,b,error);
        if (error1=0) and (error=0) then
          Begin
             polinomio.ruffini(a,b,Q,resto);
             for i:=0 to Q.grado do
                     begin
                     str(Q.coeficiente[i]:2:2,cad);
                     vecS[i]:=cad;
                     end;
             cad:='';
             for i:=Q.grado downto 0  do
                     Begin
                     if i=0 then
                       cad:=cad+vecS[i]
                     else
                       begin
                       str(i,c);
                       cad:=cad+vecS[i]+'x^'+c+'+ ';
                       end;
                     end;
             Edit21.Text:=cad;
             str(resto:2:6,cad);
             Edit22.Text:=cad;
          end
        else
            showmessage('Los Coeficientes de Q(x) son Invalidos');
     end;
     2:begin
        val(Edit23.Text,a,error1);
        val(Edit24.Text,b,error);
        if (error=0) and (error1=0) then
          Begin
            polinomio.hornerCuadratico(a,b,Q,vec);
            for i:=0 to Q.grado do
            begin
               str(Q.coeficiente[i]:2:2,cad);
               vecS[i]:=cad;
            end;
            cad:='';
            for i:=Q.grado downto 0  do
            Begin
                if i=0 then
                   cad:=cad+vecS[i]
                else
                   begin
                      str(i,c);
                      cad:=cad+vecS[i]+'x^'+c+'+ ';
                   end;
            end;
            Edit25.Text:=cad;

          end
        else
            showmessage('Los Coeficientes de Q(x) son Invalidos');
     end;
     3:begin
        cad:='[';
        polinomio.posRaicesEnteras(v,tam,band);
        if band then
          Begin
            for i:=0 to tam-1 do
                if (i=tam-1) then
                  begin
                  str(v[i],c);
                  cad:=cad+c+']';
                  end
                else
                  begin
                  str(v[i],c);
                  cad:=cad+c+',';
                  end;
            Edit26.Text:=cad;
          end
        else
            showmessage('El Polinomio no tiene todos sus coeficientes Enteros.El Metodo no se puede aplicar');
     end;
     4:begin
        cad:='[';
         polinomio.posRaicesRacionales(vr,tam,band);
         if band then
           Begin
            for i:=0 to tam-1 do
                if (i=tam-1) then
                  begin
                  str(v[i],c);
                  cad:=cad+c+']';
                  end
                else
                  begin
                  str(v[i],c);
                  cad:=cad+c+',';
                  end;
            Edit27.Text:=cad;
           end
         else
             showmessage('El Polinomio no tiene todos sus coeficientes Enteros.El Metodo no se puede aplicar');
     end;
     5:begin
         if CheckBox1.Checked then
         Begin
             polinomio.cotasLagrange(vec);
             for i:=0 to 3 do
             begin
                 str(vec[i]:1:6,cad);
                 vecS[i]:=cad;
             end;
             if (vec[0]<0) or (vec[1]<0) then
                showmessage('El Polinomio no tiene cotas Positivas')
             else
                Begin
                  Edit28.Text:=vecS[0];
                  Edit29.Text:=vecS[1];
                end;
             if (vec[2]>0) or (vec[3]>0) then
                showmessage('El Polinomio no tiene cotas Negativas')
             else
                Begin
                  Edit30.Text:=vecS[2];
                  Edit31.Text:=vecS[3];
                end;
         end;
         if CheckBox2.Checked then
         Begin
              polinomio.cotasLaguerre(vec);
              for i:=0 to 3 do
              begin
                 str(vec[i]:1:6,cad);
                 vecS[i]:=cad;
              end;
              if (vec[0]<0) or (vec[1]<0) then
                 showmessage('El Polinomio no tiene cotas Positivas')
              else
              Begin
                  Edit32.Text:=vecS[0];
                  Edit33.Text:=vecS[1];
              end;
              if (vec[2]>0) or (vec[3]>0) then
                 showmessage('El Polinomio no tiene cotas Negativas')
              else
              Begin
                  Edit34.Text:=vecS[2];
                  Edit35.Text:=vecS[3];
              end;
         end;
         if CheckBox3.Checked then
         Begin
              polinomio.cotasNewton(vec);
              for i:=0 to 3 do
              begin
                str(vec[i]:1:6,cad);
                vecS[i]:=cad;
              end;
          if (vec[0]<0) or (vec[1]<0) then
             showmessage('El Polinomio no tiene cotas Positivas')
          else
              Begin
                Edit36.Text:=vecS[0];
                Edit37.Text:=vecS[1];
              end;
          if (vec[2]>0) or (vec[3]>0) then
              showmessage('El Polinomio no tiene cotas Negativas')
          else
              Begin
                Edit38.Text:=vecS[2];
                Edit39.Text:=vecS[3];
              end;
          end;
     end;
     6:Begin
       val(Edit40.Text,a,error1);
       val(Edit41.Text,b,error);
       if (error1=0) and (error=0) then
         begin
            d:=polinomio.newtonPol(a,b);
            str(d,cad);
            Edit42.Text:=cad;
         end
       else
           Begin
               if error1<>0 then
                  showmessage('El valor de X0 es invalido');
               if error<>0 then
                  showmessage('El valor del error es invalido');
           end;
      end;
     7:Begin
         val(Edit43.Text,a,error1);
         val(Edit44.Text,b,error);
         val(Edit45.Text,d,error2);
         if (error1=0) and (error2=0) and (error=0) then
           begin
             try
             polinomio.bairstow(b,d,a,vi);
             except
              on E: Exception  do
               showmessage( 'Problemas con el r y s, por favor ingrese otro nuevamente.');
             end;
             cad:='[';
             for i:=1 to polinomio.grado do
                 begin
                    imag:=vi[i].getImag();
                    str(imag:2:6,c);
                    real:=vi[i].getReal();
                    str(real:2:6,r);
                    if i=polinomio.grado then
                         begin
                            if imag=0 then
                            cad:=cad+r+']'
                            else
                                if real=0 then
                                   cad:=cad+c+'i]'
                                else
                                   cad:=cad+r+' + '+c+'i]';
                         end;
                    if imag=0 then
                       cad:=cad+r+' , '
                    else
                        if real=0 then
                          cad:=cad+c+'i , '
                        else
                          cad:=cad+r+' + '+c+'i , ';
                 end;
             Edit46.Text:=cad;
             end;
      end;
  end

end;


{$R *.lfm}

end.

