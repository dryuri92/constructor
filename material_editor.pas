unit Material_editor;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TreeFilterEdit, Forms, Controls,
  Graphics, ExtCtrls, StdCtrls, Buttons, ComCtrls,
  Grids, service_bd, unit_classes, system_info, instance_class,
  db, IBQuery, IBDatabase, IBCustomDataSet,  Dialogs,
  DBGrids, DbCtrls, Menus, ActnList,Fillinstinfo,
  Service,ExportImport,header,thread_process,windows;


type

  { TFormMatedit }

  TFormMatedit = class(TForm)
    Bitaccmat: TBitBtn;
    Btnaddnucl: TBitBtn;
    Btndelnucl: TBitBtn;
    Combodens: TComboBox;
    Combotemp: TComboBox;
    DataSourcenucl: TDataSource;
    DBGrid1: TDBGrid;
    DBLookupComboBox1: TDBLookupComboBox;
    DBLookupComboBox2: TDBLookupComboBox;
    EditDensity: TEdit;
    Editaem: TEdit;
    Edittemperature: TEdit;
    Editname: TEdit;
    Editdesc: TEdit;
    Label10: TLabel;
    Label9: TLabel;
    btnIG: TMenuItem;
    btnIC: TMenuItem;
    btnQue: TMenuItem;
    btnaddmat: TMenuItem;
    btndelmat: TMenuItem;
    btnaccmat: TMenuItem;
    btnwtq: TMenuItem;
    btnexecmat: TMenuItem;
    btnAccept: TMenuItem;
    btnuwrp: TMenuItem;
    btnwrap: TMenuItem;
    btnunwrap: TMenuItem;
    btnexmat: TMenuItem;
    MIInsertpattern: TMenuItem;
    MIcreatepattern: TMenuItem;
    dlgOpen: TOpenDialog;
    Panelbd: TPanel;
    PopupMenu1: TPopupMenu;
    MenuEI: TPopupMenu;
    PopupMenu2: TPopupMenu;
    QueryNuclID: TIntegerField;
    QueryNuclMASS: TFloatField;
    QueryNuclNAME: TIBStringField;
    dlgSave: TSaveDialog;
    dlgSelect: TSelectDirectoryDialog;
    Splitter2: TSplitter;
    TransactionNucl: TIBTransaction;
    QueryNucl: TIBQuery;
    ImageList1: TImageList;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Paneltree: TPanel;
    Panelmat: TPanel;
    Splitter1: TSplitter;
    Grid: TStringGrid;
    ToolBar1: TToolBar;
    BtnAdd: TToolButton;
    Btndel: TToolButton;
    Btnmod: TToolButton;
    Btnacc: TToolButton;
    BtnSave: TToolButton;
    Btnload: TToolButton;
    TreeFilterEdit1: TTreeFilterEdit;
    MaterialTree: TTreeView;
    TreeFilterEdit2: TTreeFilterEdit;
    procedure BitaccmatClick(Sender: TObject);
    procedure btnAcceptClick(Sender: TObject);
    procedure btnaccmatClick(Sender: TObject);
    procedure BtnAddClick(Sender: TObject);
    procedure btnaddmatClick(Sender: TObject);
    procedure BtnaddnuclClick(Sender: TObject);
    procedure BtndelClick(Sender: TObject);
    procedure btndelmatClick(Sender: TObject);
    procedure BtndelnuclClick(Sender: TObject);
    procedure btnexmatClick(Sender: TObject);
    procedure btnICClick(Sender: TObject);
    procedure btnIGClick(Sender: TObject);
    procedure BtnloadClick(Sender: TObject);
    procedure BtnmodClick(Sender: TObject);
    procedure btnQueClick(Sender: TObject);
    procedure BtnSaveClick(Sender: TObject);
    procedure btnunwrapClick(Sender: TObject);
    procedure btnwrapClick(Sender: TObject);
    procedure DBGrid1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure DBLookupComboBox1Change(Sender: TObject);
    procedure DBLookupComboBox2Change(Sender: TObject);

    procedure EditaemKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);

    procedure EditDensityKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);

    procedure EditdescKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EditnameChange(Sender: TObject);
    procedure EditnameKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EdittemperatureChange(Sender: TObject);
    procedure EdittemperatureKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure GridDblClick(Sender: TObject);
    procedure GridEditingDone(Sender: TObject);
    procedure GridKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure MaterialTreeAdvancedCustomDrawItem(Sender: TCustomTreeView;
      Node: TTreeNode; State: TCustomDrawState; Stage: TCustomDrawStage;
      var PaintImages, DefaultDraw: Boolean);
    procedure MaterialTreeDblClick(Sender: TObject);
    procedure MaterialTreeExpanded(Sender: TObject; Node: TTreeNode);
    procedure MIcreatepatternClick(Sender: TObject);
    procedure MIInsertpatternClick(Sender: TObject);
    procedure PopupMenu2Popup(Sender: TObject);
  private
    function  Fillclassinfo(id : Integer): Boolean;     // Fill the entity of a class
    function  GetMatbyInstance(inst : TInstanceConstr) : PTMatter; //
    procedure Fillnuclgrid;                             // Fill the array nuclgrid
    procedure MakePattern;                              // pattern for material
    procedure ByPattern;                                // Fill the form by pattern of material
    procedure Delnucl(number : Integer);                // Delete nuclid from form
    procedure Insnucl(ind: INteger);                    // Insert nuclid to form
    procedure Materialacc;                              // Accept all changes in material form
    procedure Nuclacc;                                  // Accept all changes in nuclgrid
    procedure Refreshnucdb;                             // ReSelect nuclids from database
    procedure Filltree;                                 // Fill tree by nodes
    procedure UpdateNuclidStatus (material : Pointer;newStatus: TInstatus);// Update nuclids status

    procedure Upmatnode(Node : TTreeNode);              // Update data for material
    procedure Upnuclnode(Node : TTreeNode);             // Update data for nculids
    procedure Writemattoqueue(P:Pointer);               // Write changes from material class to queue changes
    //procedure Readformtomat();                        // Read new value from form to class
    //procedure Readformtonucl();                       // Read new value from form to class
    { private declarations }
  public
    { public declarations }
    procedure UpdateExpanded(Node : TTreeNode);         // Update data for expanded nodes
    procedure NewMaterial;                              // Create inserted material
    procedure DeleteMaterial(material : Pointer);       // Change material status on deleted
    procedure ExcludeMaterial(material : Pointer);      // Delete a material reference from list
    procedure BeforeAddmat;                             // Reset a generator
    procedure Clearmodform;                             // Clear all text field
    procedure Fillmodform;                              // Get info from base and fill all text field
    procedure Fillmodtable;                             // Get info from base and fill all text field
    procedure Refreshmat(id : Integer;const newStatus : TInStatus); overload;// Refresh form status
    procedure Refreshmat(material : Pointer); overload; // Refresh form status
    procedure OnInsert;                                 // Execute insertion chain
    procedure OnAccept(material : Pointer);             // Execute acception chain
    procedure OnDelete(material : Pointer);             // Execute removing chain
    procedure SendChanges();                            // Execute the query with changed instance
    procedure ReadDataFromConsyst(FileName : String);   // Read a Consyst input file
    procedure ReadDataFromGetera(FileName : String);overload;    // Read a Getera Mtr file
    procedure ReadDataFromGetera(FileName,path : String);overload; // Read a Getera input file
   procedure ImportMaterialInsert(Const namemat,desc: String; Const temperature,density : Real;
      nuclidnames : array of string; nuclidconc : array of Real; Const key_conc: Integer = -1);
    procedure ExportMaterialConsyst(FileName : String); //Export data into CONSYST file format

  end;

var
  FormMatedit: TFormMatedit;
  current_mat,pattern_mat: TMatter;
  filecons : TCONSYSTfile;
  nuclGrid : TSortList;

implementation
 uses unitqueue;
{$R *.lfm}
// Procedures of class TFormMatedit
 procedure TFormMatedit.Clearmodform;                                           // Clear all text field
 begin
      Editname.Text := '';
      Editaem.Text := '';
      Edittemperature.Text := '';
      Editdesc.Text := '';
      EditDensity.Text := '';
      //
      Combodens.ItemIndex := 0;
      Combotemp.ItemIndex := 0;
      //
      Grid.RowCount := 1;
      //
      if (QueryNucl.Active=True) then QueryNucl.Close;
      //
      Btnaddnucl.Enabled := False;
      Btndelnucl.Enabled := False;
      Bitaccmat.Enabled  := False;
      //
      MIcreatepattern.Enabled := False;
      MIInsertpattern.Enabled := False;

 end;
 //
 procedure TFormMatedit.Fillmodform;                                            // Get info from base and fill all text field

 begin

      Editname.Text := current_mat.Name;
      Editaem.Text := Floattostring(current_mat.Weight);
      Edittemperature.Text := Floattostring(current_mat.Temperature);
      EditDensity.Text :=Floattostring(current_mat.Density);
      Editdesc.Text := current_mat.Description;
      //
      Combodens.ItemIndex := 0;
      Combotemp.ItemIndex := 0;
      //
      Fillmodtable;
      //
      Btnaddnucl.Enabled := True;
      Btndelnucl.Enabled := True;
      Bitaccmat.Enabled  := True;
      //
      //
      MIcreatepattern.Enabled := True;
      MIInsertpattern.Enabled := True;

 end;
  procedure TFormMatedit.Fillmodtable;                                          // Get info from base and fill all text field
   var
   i : Integer;
   begin
      Grid.RowCount := nuclGrid.Len + 1;
      for i:=0 to nuclGrid.Len - 1 do
       begin
         Grid.Cells[0,i + 1] := current_mat.Nuclids[nuclGrid.Values[i]].Name;
         Grid.Cells[1,i + 1] := Inttostr(current_mat.Nuclids[nuclGrid.Values[i]].NumAtom);
         Grid.Cells[2,i + 1] := Floattostring(current_mat.Nuclids[nuclGrid.Values[i]].Concentration);
         Grid.Cells[3,i + 1] := Floattostring(current_mat.Nuclids[nuclGrid.Values[i]].Weight);
         Grid.Cells[4,i + 1] := Floattostring(current_mat.Nuclids[nuclGrid.Values[i]].Fraction);
         end;
    end;

procedure TFormMatedit.EditnameChange(Sender: TObject);
begin
    current_mat.ChangeStatus(Modified);
end;

procedure TFormMatedit.EditnameKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  current_mat.ChangeStatus(Modified);
end;

procedure TFormMatedit.EdittemperatureChange(Sender: TObject);
begin
   current_mat.ChangeStatus(Modified);
end;

procedure TFormMatedit.EdittemperatureKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  current_mat.ChangeStatus(Modified);
end;

procedure TFormMatedit.FormCreate(Sender: TObject);
begin
   nuclGrid := TSortList.Create();
   Clearmodform;
   //panelMat.Width :=  Panelbd.Width + panelMat.Width;
   panelbd.Width := 0;
end;

procedure TFormMatedit.FormDestroy(Sender: TObject);
begin
    nuclGrid.Destroy();
end;

procedure TFormMatedit.GridDblClick(Sender: TObject);
begin
    Grid.Options := Grid.Options - [goRangeSelect];
    Grid.Options := Grid.Options + [goEditing];
end;

procedure TFormMatedit.GridEditingDone(Sender: TObject);
begin
    Grid.Options := Grid.Options - [goEditing];
    Grid.Options := Grid.Options + [goRangeSelect];
    current_mat.Nuclids[nuclgrid.Values[Grid.Row - 1]].ChangeStatus(Modified);

end;

procedure TFormMatedit.GridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (ssShift in Shift) and (Key = VK_RIGHT) then BtnDelNuclClick(Sender);
end;

procedure TFormMatedit.MaterialTreeAdvancedCustomDrawItem(
  Sender: TCustomTreeView; Node: TTreeNode; State: TCustomDrawState;
  Stage: TCustomDrawStage; var PaintImages, DefaultDraw: Boolean);

  var
   NodeRect : TRect;
   pt : PTInstanceConstr;
begin
   if Node <> nil then
   begin
   //NodeRect := Node.DisplayRect(True);
   if Node.Level > 0 then
   begin
   pt := Node.Data;
   if (pt <> nil)then
   begin
   //with (Sender as TTreeView).Canvas do
  // begin
      //DefaultDraw := True;

      //if cdsSelected in State then // Выбранный пользователем элемент?
      //begin
         //Brush.Color := clHighlightText;
         //FillRect(NodeRect);
         if pt^.GetQueord() then // Отмечаем цветом элементы первого уровня
            Sender.Canvas.Font.Color := clGreen
         else
            Font.Color := clBlack;
      //end
      //else // Обычный, не выбранный
      //begin
        // if pt^.GetQueord() then // Отмечаем цветом элементы первого уровня
        //    Font.Color := clGreen
        // else
        //    Font.Color := clBlack;
      //end;
//      TextOut(NodeRect.Left + 2, NodeRect.Top + 1, Node.Text);
   //end;


   end;
end;

end;

end;

procedure TFormMatedit.MaterialTreeDblClick(Sender: TObject);
begin

 if (MaterialTree.Selected <> nil) then
 begin
    UpdateExpanded(MaterialTree.Selected);
    if (MaterialTree.Selected.Level = 1) then Refreshmat(MaterialTree.Selected.Data);
 end;

end;

procedure TFormMatedit.MaterialTreeExpanded(Sender: TObject; Node: TTreeNode);
begin
  UpdateExpanded(Node);
end;

procedure TFormMatedit.MIcreatepatternClick(Sender: TObject);
begin
  if (current_mat <> nil) then
     if (current_mat.Status <> None) then MakePattern();
end;

procedure TFormMatedit.MIInsertpatternClick(Sender: TObject);
begin
  ByPattern;
  Refreshmat(@current_mat);
end;

procedure TFormMatedit.PopupMenu2Popup(Sender: TObject);
begin
  if not (MaterialTree.Selected = nil) then
     if (MaterialTree.Selected.Level = 1) then
     begin
        btndelmat.Enabled := True;
        btnaccmat.Enabled := True;
        btnexmat.Enabled := True;
        btnwtq.Enabled := True;
        btnexecmat.Enabled := True;
     end
     else
     begin
        btndelmat.Enabled := False;
        btnaccmat.Enabled := False;
        btnexmat.Enabled := False;
        btnwtq.Enabled := False;
        btnexecmat.Enabled := False;
     end
     else
        begin
        btndelmat.Enabled := False;
        btnaccmat.Enabled := False;
        btnexmat.Enabled := False;
        btnwtq.Enabled := False;
        btnexecmat.Enabled := False;
        end;
end;


procedure TFormMatedit.BitaccmatClick(Sender: TObject);
begin
  OnAccept(@current_mat);
  FillTree;
end;

procedure TFormMatedit.btnAcceptClick(Sender: TObject);
begin
  BitaccmatClick(Sender);
end;

procedure TFormMatedit.btnaccmatClick(Sender: TObject);
begin
  BitaccmatClick(Sender);
end;

procedure TFormMatedit.BtnAddClick(Sender: TObject);
begin
   OnInsert;
end;

procedure TFormMatedit.btnaddmatClick(Sender: TObject);
begin
  BtnAddClick(Sender);
end;

procedure TFormMatedit.BtnaddnuclClick(Sender: TObject);
begin
  Nuclacc;
  Insnucl(QueryNucl.FieldByName('ID').AsInteger);
  Fillnuclgrid;
  Fillmodtable;
  if Grid.RowCount > 1 then Btndelnucl.Enabled := True;
end;

procedure TFormMatedit.BtndelClick(Sender: TObject);
begin
  if (MaterialTree.Selected <> nil) then
   if ((MaterialTree.Selected.Level = 1) and (MaterialTree.Selected.Data <> nil)) then
      begin
        OnDelete(MaterialTree.Selected.Data);
        MaterialTree.Selected.Expanded := False;
        Clearmodform;
        unitqueue.FormQueue.FullRefreshQueue;
        Editing_material.ClearListbyNone;
        Filltree;
      end;
end;

procedure TFormMatedit.btndelmatClick(Sender: TObject);
begin
  BtndelClick(Sender);
end;

procedure TFormMatedit.BtndelnuclClick(Sender: TObject);
begin
  Nuclacc;
  Delnucl(Grid.Row - 1);
  Fillnuclgrid;
  Fillmodtable;
  if Grid.RowCount < 2 then Btndelnucl.Enabled := False;
end;

procedure TFormMatedit.btnexmatClick(Sender: TObject);
begin
  BtnmodClick(Sender);
end;

procedure TFormMatedit.btnICClick(Sender: TObject);
begin
  dlgOpen.Options := [ofFileMustExist];
  dlgOpen.Filter := 'cst-files|*.cst|All files|*.*';
  dlgOpen.FilterIndex := 1;
  dlgOpen.InitialDir := gPath;
  dlgOpen.Title := 'Open the Consyst input file';
  if (dlgOpen.Execute) then ReadDataFromConsyst(dlgOpen.Filename);

end;

procedure TFormMatedit.btnIGClick(Sender: TObject);
begin
  dlgOpen.Options := [ofFileMustExist];
  dlgOpen.Filter := 'inp-files|*.inp|All files|*.*';
  dlgOpen.FilterIndex := 1;
  dlgOpen.InitialDir := gPath;
  dlgOpen.Title := 'Open the Getera input file';
  dlgSelect.InitialDir := gPath;
  dlgSelect.Title := 'Point out on bin directory with mtr files';
  if (dlgOpen.Execute) then
   begin
    if (dlgSelect.Execute) then
     ReadDataFromGetera(dlgOpen.Filename,dlgSelect.FileName)
    else
     ReadDataFromGetera(dlgOpen.Filename);
   end;
end;

procedure TFormMatedit.BtnloadClick(Sender: TObject);
begin


   //ReadDataFromGetera('e:\constructor\backup\Kol_425u.inp','e:\constructor\backup\bin\');

end;

procedure TFormMatedit.BtnmodClick(Sender: TObject);
begin
if (MaterialTree.Selected <> nil) then
  if ((MaterialTree.Selected.Level = 1) and (MaterialTree.Selected.Data <> nil)) then
     begin
       ExcludeMaterial(MaterialTree.Selected.Data);
       Clearmodform;
       unitqueue.FormQueue.FullRefreshQueue;
       Editing_material.ClearListbyNone;
       //Filltree;
        UpdateExpanded(MaterialTree.Selected.Parent);

     end;
end;

procedure TFormMatedit.btnQueClick(Sender: TObject);
begin
   SendChanges;
end;

procedure TFormMatedit.BtnSaveClick(Sender: TObject);
begin
  dlgSave.Filter := 'txt-files|*.txt|All files|*.*';
  dlgSave.FilterIndex := 1;
  dlgSave.InitialDir := gPath;
  dlgSave.Title := 'Save the CONSYST input file';
  if (dlgSave.Execute) then  ExportMaterialConsyst(dlgSave.FileName);
end;

procedure TFormMatedit.btnunwrapClick(Sender: TObject);
begin
  Panelbd.Width := 0;
  FormMatedit.Width := FormMatedit.Width - 350;
end;

procedure TFormMatedit.btnwrapClick(Sender: TObject);
begin
  Panelbd.Width := 350;
  FormMatedit.Width := FormMatedit.Width + 350;
end;

procedure TFormMatedit.DBGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (ssShift in Shift) and (Key = VK_LEFT) then BtnAddnuclClick(Sender);
end;

procedure TFormMatedit.DBLookupComboBox1Change(Sender: TObject);
begin
  QueryNucl.Locate('ID', DBLookupComboBox1.KeyValue , []);
end;

procedure TFormMatedit.DBLookupComboBox2Change(Sender: TObject);
begin
    QueryNucl.Locate('ID', DBLookupComboBox2.KeyValue , []);
end;



procedure TFormMatedit.EditaemKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  current_mat.ChangeStatus(Modified);
end;



procedure TFormMatedit.EditDensityKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  current_mat.ChangeStatus(Modified);
end;



procedure TFormMatedit.EditdescKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  current_mat.ChangeStatus(Modified);
end;

 // class TFormMatedit
 procedure TFormMatedit.Delnucl(number : Integer);                              // Delete nuclid from form
 begin
   try
     current_mat.Nuclids[nuclgrid.Values[number]].ChangeStatus(Deleted);
     nuclgrid.Delete(number);
     current_mat.ClearnuclidbyNone;
    except on e : Exception do
            begin{e - новый дескриптор ошибки}
             MessageDlg(e.message,mtError,[mbOK],0);
             Exit;
            end;
   end;
 end;
  // class TFormMatedit
  procedure TFormMatedit.Insnucl(ind: INteger);                                 // Insert nuclid to form
  var
     pos : Integer;
  begin
    try // Check is it nuclid been added before
       pos := current_mat.FindposbyIndex(GetNuclidByIndex(ind).Index);
       if pos < 0 then
          begin
          current_mat.AddNuclid(GetNuclidByIndex(ind));
          current_mat.Nuclids[current_mat.NumNuclid - 1].ChangeStatus(Inserted);
          end
       else
           pos := 0;//current_mat.Nuclids[pos].ChangeStatus(Modified);
    except on e : Exception do
            begin{e - новый дескриптор ошибки}
             MessageDlg(e.message,mtError,[mbOK],0);
             Exit;
            end;
   end;
  end;

 // Procedures of class TFormMatedit
 function TFormMatedit.Fillclassinfo(id : Integer): Boolean;                    // Fill the entity of a class
 var
  //Pnuclids:PTNuclidList;
  pMat : PTMatter;
begin
    Result := False;
    try
       // trying to get information from database
       pMat := Fillmaterialinfo(id);
       if (pMat <> nil) then
        begin
       current_mat := pMat^;
       current_mat.ChangeStatus(Selected);
       Editing_material.Append(pMat^);
       Result := True;
       end
       else
           Result := False;
     except on e : Exception do
            begin{e - новый дескриптор ошибки}
             MessageDlg(e.message,mtError,[mbOK],0);
             Result := False;
             Exit;
            end;
     end;
     end;
  // Procedures of class TFormMatedit
 procedure TFormMatedit.Refreshmat(id : Integer;const newStatus : TInStatus);   // Refresh form status
 begin
     if Fillclassinfo(id) then
     begin
     //
     //Editing_material.Append(current_mat);
     //
     current_mat.ChangeStatus(newStatus);
    if (newStatus <> Deleted) then
    begin
     Fillnuclgrid;
     Fillmodform;
     Refreshnucdb;
    end;
     Filltree;
     end;
 end;
// class TFormMatedit
 procedure TFormMatedit.Fillnuclgrid;
 var
    i : Integer;
 begin
     nuclGrid.Clear;
     for i:=0 to current_mat.NumNuclid - 1 do
        if (current_mat.Nuclids[i].Status <> Deleted) and
        (current_mat.Nuclids[i].Status <> None) then
         nuclGrid.Append(i);
 end;
  //  class TFormMatedit
 procedure TFormMatedit.Refreshmat(material : Pointer);                         // Refresh form status
 var
    pMat : PTMatter;
 begin
    pMat := material;
    if (pMat <> nil) then
    begin
    if (pMat^.Status = None) then
     Fillclassinfo(pMat^.id)
    else
     current_mat := pMat^;
    if (current_mat.Status <> Deleted) then
    begin
       Fillnuclgrid;
       Fillmodform;
       Refreshnucdb;
    end;

    end;

    Filltree;
 end;
 //  class TFormMatedit
  procedure TFormMatedit.Materialacc;                                           // Accept all changes in material form
  begin
     //
      current_mat.Name := Editname.Text;
      current_mat.Description := Editdesc.Text;
      try
         current_mat.Weight := Strtofloat(Editaem.Text);
      except
            Editaem.Text := '0.';
      end;
      try
         current_mat.Temperature := Strtofloat(Edittemperature.Text);
      except
            Edittemperature.Text := '0.';
      end;
      try
         current_mat.Density := Strtofloat(EditDensity.Text);
      except
            EditDensity.Text := '0.';
      end;
      // add to the queue
      end;
  //  class TFormMatedit
  procedure TFormMatedit.Nuclacc;                                                // Accept all changes in nuclgrid
  var
     i : Integer;
  begin
     for i:=0 to nuclGrid.Len - 1 do
      if (current_mat.Nuclids[nuclGrid.Values[i]].Status <> Selected) then
       with current_mat do
       begin
         //current_mat.Nuclids[nuclGrid.Values[i]].Name := Grid.Cells[0,i + 1];
         try
            Nuclids[nuclGrid.Values[i]].NumAtom := Strtoint(Grid.Cells[1,i + 1]);
         except
            Grid.Cells[1,i + 1] := '1';
         end;
         try
            Nuclids[nuclGrid.Values[i]].Concentration := Strtofloat(Grid.Cells[2,i + 1]);
         except
            Grid.Cells[2,i + 1] := '0.0';
         end;
         try
           Nuclids[nuclGrid.Values[i]].Weight := Strtofloat(Grid.Cells[3,i + 1]);
         except
            Grid.Cells[3,i + 1] := '0.0';
         end;
         try
           Nuclids[nuclGrid.Values[i]].Fraction := Strtofloat(Grid.Cells[4,i + 1]);
         except
            Grid.Cells[4,i + 1] := '0.0';
         end;

         end;
  end;
  //  class TFormMatedit
   procedure TFormMatedit.BeforeAddmat;                                         // Reset a generator
   begin
      if (QTables[1].GetGeneratorValue < 0 ) then
         QTables[1].ActuateGen(ExecGenerator(1));
      QTables[1].IncGenerator;
   end;
    //  class TFormMatedit
  procedure  TFormMatedit.NewMaterial;                                          // Create inserted material
  var
     pMat :PTMatter;
  begin
     New(pMat);
     pMat^ := TMatter.Create(Qtables[1].GetGeneratorValue(),
     'Material_' + Inttostr(Qtables[1].GetGeneratorValue()));
     pMat^.ChangeStatus(Inserted);
     Editing_material.Add(pMat);
  end;
   //  class TFormMatedit
  procedure TFormMatedit.ImportMaterialInsert(Const namemat,desc: String;                // Import new material into editing list
    Const temperature,density : Real;nuclidnames : array of string;
    nuclidconc : array of Real; Const key_conc: Integer = -1);
  var
     pMat :PTMatter;
     i : Integer;
     str : String;
  begin
    BeforeAddmat;
    New(pMat);
    if (namemat = '') then
       str := 'Material_' + Inttostr(Qtables[1].GetGeneratorValue())
    else
       str :=  namemat;
    pMat^:= TMatter.Create(Qtables[1].GetGeneratorValue(),str);
    pMat^.Description := desc;
    pMat^.Density := density;
    pMat^.Temperature := temperature;
    pMat^.ChangeStatus(Inserted);
    for i := 0 to Length(nuclidnames) - 1 do
    begin
     pMat^.AddNuclid(GetNuclidbyName(nuclidnames[i]));
     case key_conc of
       -1:   pMat^.Nuclids[pMat^.NumNuclid - 1].Concentration := nuclidconc[i];
       1:   pMat^.Nuclids[pMat^.NumNuclid - 1].Fraction := nuclidconc[i];
       2:   pMat^.Nuclids[pMat^.NumNuclid - 1].Weight := nuclidconc[i];
     end;
     pMat^.Nuclids[pMat^.NumNuclid - 1].ChangeStatus(Inserted);
    end;
    Editing_material.Add(pMat);

  end;

  //  class TFormMatedit
  procedure TFormMatedit.DeleteMaterial(material : Pointer);                    // Change material status on deleted
  var
     pMat :PTMatter;
  begin
     pMat := material;
     pMat^.ChangeStatus(Deleted);
     UpdateNuclidStatus(material,None);
  end;
  //  class TFormMatedit
  procedure TFormMatedit.ExcludeMaterial(material : Pointer);                   // Delete a material reference from list
  var
     pMat :PTMatter;
  begin
     pMat := material;
     pMat^.ChangeStatus(None);
     UpdateNuclidStatus(material,None);
  end;
  //  class TFormMatedit
  procedure TFormMatedit.UpdateNuclidStatus (material : Pointer;newStatus: TInstatus);// Update nuclids status
  var
     pMat :PTMatter;
     iNucl : Integer;
  begin
     pMat := material;
     for iNucl := 0 to pMat^.NumNuclid - 1 do
     begin
          pMat^.Nuclids[iNucl].ChangeStatus(newStatus);
     end;
  end;

  //  class TFormMatedit
      procedure TFormMatedit.MakePattern;                                       // pattern for material
      begin
           if pattern_mat = nil then
              pattern_mat := TMatter.Create('pattern');
           pattern_mat.Copy(current_mat);

      end;

  //  class TFormMatedit
    procedure TFormMatedit.ByPattern;                                           // Fill the form by pattern of material
    begin
       if pattern_mat <> nil then
          current_mat.Copy(pattern_mat);
    end;

  //  class TFormMatedit
  procedure TFormMatedit.Writemattoqueue(P:Pointer);                            // Write changes from material class to queue changes
  var
     pMat : PTMatter;
     i : Integer;
     iBind : Integer;
  begin
     pMat := nil;
     iBind := -1;
     pMat := P;
     if (pMat^.Status <> Selected) and (pMat^.Status <> None) then Queue.FormChangetext(1,pMat^.Getproperties,-1,pMat^);
     for i := 0 to pMat^.NumNuclid - 1 do
         if (pMat^.Nuclids[i].Status <> Selected) and (pMat^.Nuclids[i].Status <> None) then
           if (pMat^.Status = Inserted) then
              Queue.FormChangetext(2,pMat^.GetNuclidproperties(i),pMat^,pMat^.Nuclids[i])
           else
              Queue.FormChangetext(2,pMat^.GetNuclidproperties(i),iBind,pMat^.Nuclids[i]);
  end;
  // class TFormMatedit
  procedure TFormMatedit.SendChanges();                                         // Execute the query with changed instance
  var
     pMat : PTMatter;
     pNucl : PTNuclidList;
     ExportList : TInstList;
     i,j : Integer;
  begin
     ExportList := TInstList.Create;
     pMat := nil;
     pNucl := nil;
     for i := 0 to Editing_material.Len - 1 do
         begin
          pMat := Editing_material.Items[i];
          if ((pMat^.Status <> None) and (pMat^.Status <> Selected) and pMat^.GetQueord()) then ExportList.Add(pMat);
          for j := 0 to pmat^.NumNuclid - 1 do
              begin
                New(pnucl);
                pnucl^ := pMat^.Nuclids[j];
                if ((pNucl^.Status <> None) and (pNucl^.Status <> Selected) and pNucl^.GetQueord()) then ExportList.Add(pNucl);
              end;
         end;
       FormHeader.ExecuteExported(ExportList);
  end;

  //  class TFormMatedit
   procedure TFormMatedit.Filltree;                                              // Fill tree by nodes
   var
      selected_node : TTreeNode;
   begin
      if (Editing_material.Count > 0)  then
       if (MaterialTree.Items.Count < 1) then
         //UpdateExpanded(MaterialTree.Items.AddChild(nil,'Editing materials'))
        MaterialTree.Items.AddChild(nil,'Editing materials')
       else
         if (MaterialTree.Items[0].Expanded) then
          begin
               UpdateExpanded(MaterialTree.Items[0]);
               if (current_mat <> nil) and (current_mat.Status <> None) then
                begin
                     selected_node := MaterialTree.Items[0].FindNode(current_mat.Name);
                   if (selected_node <> nil) then selected_node.Selected := True;
                end;
          end;
   end;

   //  class TFormMatedit
    procedure TFormMatedit.UpdateExpanded(Node : TTreeNode);                    // Update data for expanded nodes
    var
       i : Integer;
    begin
              case Node.Level of
                   0 :  Upmatnode(Node);
                   1 :  Upnuclnode(Node);
              end;
              for i := 0 to Node.Count - 1 do
                  if (Node.Items[i].Expanded) then  UpdateExpanded(Node.Items[i]);
    end;

    //  class TFormMatedit
    procedure TFormMatedit.Upmatnode(Node : TTreeNode);                         // Update data for material
    var
       i: Integer;
       pMat : PTMatter;
       Child : TTreeNode;
       pt : Pointer;
    begin

       MaterialTree.BeginUpdate;
       try
             i := 0;
             for i:=Node.Count - 1 downto 0 do
                 begin
                   pt := Node.Items[i].Data;

                   if (pt <> nil) then
                    begin
                   pMat := pt;
                   // Change name
                   if (Node.Items[i].Text <> pMat^.Name) then
                    begin
                         //Node.EditText := True;
                         Node.Items[i].Text := pMat^.Name;
                         //Node.EditText := False;
                    end;
                   case pMat^.Status of
                        //Deleted : Node.Items[i].Delete;
                        None : Node.Items[i].Delete;
                        Selected : Node.Items[i].ImageIndex:=-1;
                        Modified : Node.Items[i].ImageIndex:=3;
                        Deleted : Node.Items[i].ImageIndex:=0;
                        Inserted : Node.Items[i].ImageIndex:=4;
                   end;

                 end;

                 end;
             for i:=Node.Count to Editing_material.Count - 1 do
                 begin
                 pMat := Editing_material.Items[i];
                 if (pMat^.Status <> None) then
                 begin
                    //pt := Editing_material.GetAddr(i);
                    //pMat := pt;// GetMatbyInstance(Editing_material.Values[i]);
                    Child := MaterialTree.Items.AddChildObject(Node,pMat^.Name,Editing_material.Items[i]);
                 end;

                 end;

       except
          ShowMessage('Strange message');
       end;

       MaterialTree.EndUpdate;

    end;

    //  class TFormMatedit
   procedure TFormMatedit.Upnuclnode(Node : TTreeNode);                        // Update data for nculids
    var
       i: Integer;
       pMat : PTMatter;
       pNucl : PTNuclidList;
       Child : TTreeNode;
    begin
       MaterialTree.BeginUpdate;
       try
       pMat := Node.Data;
        i := 0;
        if (pMat <> nil) then
        begin
            for i:=Node.Count - 1 downto 0 do
                 begin
                   pNucl := Node.Items[i].Data;
                   if (pNucl <> nil) then
                   begin
                   // Change name
                   if (Node.Items[i].Text <> pNucl^.Name) then
                    begin
                         //Node.EditText := True;
                         Node.Items[i].Text := pNucl^.Name;
                         //Node.EditText := False;
                    end;
                   case pNucl^.Status of
                        //Deleted : Node.Items[i].Delete;
                        None : Node.Items[i].Delete;
                        Selected : Node.Items[i].ImageIndex:=-1;
                        Modified : Node.Items[i].ImageIndex:=3;
                        Deleted : Node.Items[i].ImageIndex:=0;
                        Inserted : Node.Items[i].ImageIndex:=4;
                   end;

                   end;

                 end;
             for i := Node.Count to pMat^.NumNuclid - 1 do
                 if (pMat^.Status <> None) then
                 begin
                    New(pNucl);
                    pNucl^ :=  pMat^.Nuclids[i];
                    if (pNucl^.Status <> None) then Child := MaterialTree.Items.AddChildObject(Node,pMat^.Nuclids[i].Name,pMat^.GetNuclidAddr(i));
                 end;
        end;


       except
          ShowMessage('Strange message');
       end;


       MaterialTree.EndUpdate;
    end;
      function  TFormMatedit.GetMatbyInstance(inst : TInstanceConstr) : PTMatter; //
      var
         p: Pointer;
         pMat: PTMatter;
      begin
         pMat := @inst;
         Result := pMat;
      end;
    //  class TFormMatedit
    procedure TFormMatedit.OnInsert;                                            // Execute insertion chain
    begin
      BeforeAddmat;
      NewMaterial;
      Refreshmat(Editing_material.Items[Editing_material.Count - 1]);
    end;

    //  class TFormMatedit
    procedure TFormMatedit.OnAccept(material : Pointer);                        // Execute acception chain
    begin
      Materialacc;
      Nuclacc;
      Writemattoqueue(material);
      FormHeader.FullRefreshQueue;
    end;

    //  class TFormMatedit
    procedure TFormMatedit.OnDelete(material : Pointer);                        // Execute removing chain
    begin
        DeleteMaterial(material);
        Writemattoqueue(material);
        FormHeader.FullRefreshQueue;
        Clearmodform;
    end;

  //  class TFormMatedit
  procedure TFormMatedit.Refreshnucdb;                                          // ReSelect nuclids from database
  begin
           if (QueryNucl.Active=True) then QueryNucl.Close;
           QueryNucl.Prepare;

  try
         QueryNucl.Open;
         QueryNucl.Fetchall;
  except
    on
      E: Exception do
    begin
      TransactionNucl.Rollback;
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end;
  end;
  //  class TFormMatedit
  procedure TFormMatedit.ReadDataFromGetera(FileName : String);   // Read a Consyst input file
  var
     i:Integer;
     getfile: Tgeterafile;
  begin
      getfile := Tgeterafile.Create(FileName);
      try
         getfile.ReadMtr(FileName);
         for i := 0 to getfile.material_number - 1 do
         begin
          ImportMaterialInsert(getfile.material_name[i],getfile.material_desc[i],getfile.material_temp[i],getfile.material_density[i],getfile.GetMaterialnuclidname(I),
          getfile.GetMaterialnuclidconc(i),getfile.material_identificator[i]);
          Header.FormHeader.Writelog('Material_' + Inttostr(Qtables[1].GetGeneratorValue()) +
          'has been succesfully imported from Getera input data file');
          end;
      finally
        getfile.Free;
      end;
  end;
  //  class TFormMatedit
  procedure TFormMatedit.ReadDataFromGetera(FileName,path : String);overload; // Read a Getera input file
  var
     i:Integer;
     getfile: Tgeterafile;
  begin
      getfile := Tgeterafile.Create(FileName,path);
      try
         getfile.ParseInput;
         for i := 0 to getfile.material_number - 1 do
         begin
          ImportMaterialInsert(getfile.material_name[i],getfile.material_desc[i],getfile.material_temp[i],getfile.material_density[i],getfile.GetMaterialnuclidname(I),
          getfile.GetMaterialnuclidconc(i),getfile.material_identificator[i]);
          Header.FormHeader.Writelog('Material_' + Inttostr(Qtables[1].GetGeneratorValue()) +
          'has been succesfully imported from Getera input data file');
          end;
      finally
        getfile.Free;
      end;
  end;

  //  class TFormMatedit
  procedure TFormMatedit.ReadDataFromConsyst(FileName : String);                              // Read a Consyst input file
  var
     i : Integer;
  begin
      filecons := TCONSYSTfile.Create(FileName);
      try
         filecons.ParseFile;
         for i := 0 to filecons.IZT - 1 do
         begin
          ImportMaterialInsert('','',filecons.GetMaterialtemp(i),0.0,filecons.GetMaterialnuclidname(i),
          filecons.GetMaterialnuclidconc(i));
          Header.FormHeader.Writelog('Material_' + Inttostr(Qtables[1].GetGeneratorValue()) +
          'has been succesfully imported from CONSYST input data file');
          end;
      finally
        filecons.Free;
      end;
  end;
  //  class TFormMatedit
  procedure TFormMatedit.ExportMaterialConsyst(FileName : String); //Export data into CONSYST file format
  var
     Matters : TinstList;
     i : Integer;
     pMat : PTMatter;
     pl :PTThreadL;
  begin
     Matters := TinstList.Create;
     for i := 0 to Editing_material.Count - 1 do
     begin
          pMat := Editing_material.Items[i];
         if (pMat^.Status <> None) then
           Matters.Append(pMat^);
     end;

     try
       New(pl);
       _threads.Add(pl);
       pl^ := ThreadFileLoad.Create(Filename,True);
       pl^.Linklist(Matters);
       pl^.FreeOnTerminate := True;
       pl^.Resume();

     except on E: Exception  do
        MessageDlg('Thread not load ' + e.message, mtError, [mbOK], 0);
     end;
  end;

end.

