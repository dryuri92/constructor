unit unit_DB;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, DividerBevel, ExtendedNotebook, TreeFilterEdit,
  LvlGraphCtrl, Forms, Controls, Graphics, Dialogs, StdCtrls, ComboEx,
  ButtonPanel, ExtCtrls, DBGrids, Header, DataModule, IBDatabase,
  IBCustomDataSet, IBQuery, IBDynamicGrid, system_info, unit_classes,
  QTable_class, db,Regexpr,Service_bd,Material_editor,Instance_class,material_table,saver;


  type
  { TDBmod }

  TDBmod = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Execute: TButton;
    Edit1: TEdit;
    State: TButton;
    Queuecall: TButton;
    Material: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure ExecuteClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MaterialClick(Sender: TObject);
    procedure QueuecallClick(Sender: TObject);
    procedure StateClick(Sender: TObject);
  private

    { private declarations }
  public
    procedure RefreshallWindow;                                                  // Update a state of all opened windows
    { public declarations }
  end;

var
  DBmod: TDBmod;
  Nucls : array of TNuclid;
  Matters : array of TMatter;
implementation
  uses
    unitqueue;

{$R *.lfm}

{ TDBmod }

procedure TDBmod.Button1Click(Sender: TObject);
begin
  FormHeader.Show();
end;

procedure TDBmod.Button2Click(Sender: TObject);
var
  wheresec : TStringarray;
begin
  SetLength(wheresec, 1);
  wheresec[0] := 'ID_M';
  FormHeader.Writelog(QTables[2].GetSelect(wheresec));
  FormHeader.Writelog(QTables[2].GetSelect(2));
  //Queue.Append(QTables[2].GetSelect(wheresec),-1);
  SetLength(wheresec, 0);
  FormHeader.Writelog(Inttostr(GetVersionInfo()));
end;

procedure TDBmod.Button3Click(Sender: TObject);
begin
  FormHeader.Writelog(QTables[2].GetInsert());
  //Queue.Append(QTables[1].GetInsert(),0);
end;

procedure TDBmod.Button4Click(Sender: TObject);
var
  wheresec : TStringarray;
begin
    SetLength(wheresec, 1);
    wheresec[0] := 'ID_M';
    //wheresec[1] := 'ID_N';
    FormHeader.Writelog(QTables[2].GetDelete(wheresec));
    FormHeader.Writelog(QTables[2].GetDelete(2));
    //Queue.Delete(1);
    SetLength(wheresec, 0);
end;

procedure TDBmod.Button5Click(Sender: TObject);
var
  wheresec : TStringarray;
begin
    SetLength(wheresec, 2);
    wheresec[0] := 'ID_M';
    wheresec[1] := 'ID_N';
   FormHeader.Writelog(QTables[2].GetUpdate(wheresec));
   FormHeader.Writelog(QTables[2].GetUpdate(2));
   //Queue.Insert(1,QTables[2].GetUpdate(wheresec),-1);
   SetLength(wheresec, 0);
end;

procedure TDBmod.Button6Click(Sender: TObject);
begin
   FormHeader.Writelog(QTables[4].GetGenerator());
   FormHeader.Writelog(Inttostr(ExecGenerator(4)));
   //Queue.Exchange(2,4);
   Queue.Append(QTables[4].GetGenerator(),1);
   DM.Getbackup();

end;

procedure TDBmod.ExecuteClick(Sender: TObject);
var
  str,s : String;
  RegExp : TRegExpr;
begin
  RegExp := TRegExpr.Create;
  try
  //RegExp.Expression := '\d+[.eE0-9+-]+\d+';
  //RegExp.Expression := '[^''\s,]+';
  RegExp.Expression := '(TEM[^IZ])';
  s := '';
  str := Edit1.Text;


  if (RegExp.Exec(str)) then
  begin
       repeat
             s := RegExp.Match[0];
       until not RegExp.ExecNext ;
  end;
  finally
   RegExp.Free;
   Edit1.Text := s;
  end;


end;

procedure TDBmod.FormCreate(Sender: TObject);
begin
  DM := TDM.Create(Self);// Create an entitty of database connection
  DM.Read_Ini(); // Read an ini-file
  if DM.rReConnect(dbPath) then
     begin
          FormHeader.Writelog('Connection with database' + dbPath + 'established');
          VI._vnumber := GetVersionInfo;

     end
  else
     FormHeader.Writelog('Error:Connection with database' + dbPath + 'not established');

end;
// class TDBmod
procedure TDBmod.RefreshallWindow;                                                  // Update a state of all opened windows
begin
  if (WS._o_material) then Formmattable.RefreshMTForm(True);

end;

procedure TDBmod.MaterialClick(Sender: TObject);
begin
    if not (Assigned(FormQueue)) then
    FormQueue := TFormQueue.Create(Application);
    FormQueue.Show;
end;

procedure TDBmod.QueuecallClick(Sender: TObject);
begin
  if not (Assigned(Formmattable)) then
    Formmattable := TFormmattable.Create(Application);
    Formmattable.Show;
end;

procedure TDBmod.StateClick(Sender: TObject);
begin
    if not (Assigned(Formstater)) then
    Formstater := TFormstater.Create(Application);
    Formstater.Show;
end;

end.

