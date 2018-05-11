unit material_table;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, FileUtil, IBDynamicGrid, IBQuery, IBCustomDataSet,
  IBDatabase, Forms, Controls, Graphics, Dialogs, EditBtn, FileCtrl, ExtCtrls,
  ComCtrls, DbCtrls, StdCtrls,system_info, unit_classes,
  QTable_class,Service_bd,Instance_class;

type

  { TFormmattable }

  TFormmattable = class(TForm)
    DataSourceMat: TDataSource;
    DBLookupComboBox1: TDBLookupComboBox;
    IBDynamicGrid1: TIBDynamicGrid;
    ImageList1: TImageList;
    Label1: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    QueryMat: TIBQuery;
    QueryMatDATETIME: TDateTimeField;
    QueryMatDENSITY: TFloatField;
    QueryMatDESCRIPTION: TIBStringField;
    QueryMatID: TIntegerField;
    QueryMatMASSA: TFloatField;
    QueryMatNAME: TIBStringField;
    QueryMatTEMPERATURE: TFloatField;
    QueryMatUSERNAME: TIBStringField;
    ToolBar1: TToolBar;
    btnopen: TToolButton;
    btnadd: TToolButton;
    btnmod: TToolButton;
    btndel: TToolButton;
    TransactionMat: TIBTransaction;
    procedure btnaddClick(Sender: TObject);
    procedure btndelClick(Sender: TObject);
    procedure btnmodClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnopenClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    procedure Clearall;                                                         // All components are disabled
    procedure InsertMaterial;                                                   // Insert material into editing list
    procedure DeleteMaterial(id : Integer);                                     // Insert material into editing list with delete status
    { private declarations }
  public
    procedure RefreshMatTable;                                                  // Refresh material table
    procedure Editmaterial(id : Integer);                                       // Call material editor
    procedure RefreshMTForm(Const ClearEditform : Boolean);                     // Refresh form Material table
    { public declarations }
  end;

var
  Formmattable: TFormmattable;

implementation

{$R *.lfm}
 uses Material_editor;

procedure TFormmattable.btnopenClick(Sender: TObject);
begin
  if not (Assigned(FormMatedit)) then
    FormMatedit := TFormMatedit.Create(Formmattable);
    FormMatedit.Show;
    EditMaterial(QueryMat.FieldByName('ID').AsInteger);
end;

procedure TFormmattable.FormDestroy(Sender: TObject);
begin
  WS._o_material := False;
end;

procedure TFormmattable.FormCreate(Sender: TObject);
begin
   RefreshMTForm(False);
   WS._o_material := True;
end;

procedure TFormmattable.btnaddClick(Sender: TObject);
begin
  if not (Assigned(FormMatedit)) then
    FormMatedit := TFormMatedit.Create(Formmattable);
    FormMatedit.Show;
    InsertMaterial;
end;

procedure TFormmattable.btndelClick(Sender: TObject);
begin
   if not (Assigned(FormMatedit)) then
    FormMatedit := TFormMatedit.Create(Formmattable);
    FormMatedit.Show;
    DeleteMaterial(QueryMat.FieldByName('ID').AsInteger);
end;

procedure TFormmattable.btnmodClick(Sender: TObject);
begin
  if not (Assigned(FormMatedit)) then
    FormMatedit := TFormMatedit.Create(Formmattable);
    FormMatedit.Show;
    EditMaterial(QueryMat.FieldByName('ID').AsInteger);
end;

// class TFormmattable
procedure TFormmattable.Editmaterial(id : Integer);
var
  temp : TInstanceConstr;
begin
  temp:=nil;
  if (id > 0) then
    if Editing_material.IsIn([id]) then
       begin
            temp := Editing_material.SearchbyID([id]);
            FormMatedit.Refreshmat(@temp);
       end
    else
       FormMatedit.Refreshmat(id,Selected);

end;
// class TFormmattable
procedure TFormmattable.InsertMaterial();                                       // Insert material into editing list
begin
  FormMatedit.OnInsert();
end;

// class TFormmattable
procedure TFormmattable.DeleteMaterial(id : Integer);                           // Insert material into editing list with delete status
var
  temp : TInstanceConstr;
begin
  temp:=nil;
  if (id > 0) then
    if Editing_material.IsIn([id]) then
       begin
            temp := Editing_material.SearchbyID([id]);
            FormMatedit.OnDelete(@temp);
       end
    else
       FormMatedit.Refreshmat(id,Deleted);
end;

// class TFormmattable
procedure TFormmattable.Clearall;                                               // All components are disabled
begin
   ToolBar1.Enabled := False;
   Panel1.Enabled := False;
end;

// class TFormmattable
procedure TFormmattable.RefreshMTForm(Const ClearEditform : Boolean);           // Refresh form Material table
var
  i : Integer;
begin
   RefreshMatTable;
   if QueryMat.RecordCount > 0 then
      begin
           ToolBar1.Enabled := True;
           Panel1.Enabled := True;
      end
   else
       Clearall;
   if ClearEditform then
     if Assigned(Formmatedit) then
          begin

          for i := Editing_material.Len - 1 downto 0  do
              Formmatedit.ExcludeMaterial(Editing_material.Items[i]);
          Formmatedit.UpdateExpanded(Formmatedit.MaterialTree.Items[0]);
          Formmatedit.Clearmodform;
          Editing_material.ClearListbyNone;
          end;

end;

// class TFormmattable
procedure TFormmattable.RefreshMatTable;                                        // Refresh material table
begin
    if (QueryMat.Active=True) then QueryMat.Close;
        QueryMat.Prepare;

  try
         QueryMat.Open;
         QueryMat.Fetchall;
  except
    on
      E: Exception do
    begin
      TransactionMat.Rollback;
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

end.

