unit Element_editor;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TreeFilterEdit, Forms, Controls,
  Graphics, ExtCtrls, StdCtrls, Buttons, ComCtrls,
  Grids, service_bd, unit_classes, system_info, instance_class,
  db, IBQuery, IBDatabase, IBCustomDataSet, IBLookupComboEditBox,  Dialogs,
  DBGrids, DbCtrls, Menus, ActnList, FileCtrl, EditBtn, ComboEx,Fillinstinfo,
  Service,ExportImport,header,thread_process,windows;


type

  { TFormElemedit }

  TFormElemedit = class(TForm)
    Bitaccelem: TBitBtn;
    ComboType: TComboBoxEx;
    DataSourceGeom: TDataSource;
    DataSourceMat: TDataSource;
    DBLookupComboBox1: TDBLookupComboBox;
    Editname: TEdit;
    Editdesc: TEdit;
    btnQue: TMenuItem;
    btnaddelem: TMenuItem;
    btndelelem: TMenuItem;
    btnaccelem: TMenuItem;
    btnwtq: TMenuItem;
    btnexecelem: TMenuItem;
    btnAccept: TMenuItem;
    btnexelem: TMenuItem;
    IBLookupComboEditBox2: TIBLookupComboEditBox;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    MIInsertpattern: TMenuItem;
    MIcreatepattern: TMenuItem;
    dlgOpen: TOpenDialog;
    PopupMenu1: TPopupMenu;
    MenuEI: TPopupMenu;
    PopupMenu2: TPopupMenu;
    dlgSave: TSaveDialog;
    dlgSelect: TSelectDirectoryDialog;
    QueryGeomID: TIntegerField;
    QueryGeomNAME: TIBStringField;
    QueryMat: TIBQuery;
    QueryMatID: TIntegerField;
    QueryMatNAME: TIBStringField;
    ToolBar2: TToolBar;
    Btnaddp: TToolButton;
    Btnaddm: TToolButton;
    BtnChange: TToolButton;
    TransactionGeom: TIBTransaction;
    QueryGeom: TIBQuery;
    ImageList1: TImageList;
    Label1: TLabel;
    Label2: TLabel;
    Paneltree: TPanel;
    Panelelem: TPanel;
    Splitter1: TSplitter;
    Grid: TStringGrid;
    ToolBar1: TToolBar;
    BtnAdd: TToolButton;
    Btndel: TToolButton;
    Btnmod: TToolButton;
    Btnacc: TToolButton;
    BtnSave: TToolButton;
    Btnload: TToolButton;
    TransactionMat: TIBTransaction;
    TreeFilterEdit1: TTreeFilterEdit;
    ElementTree: TTreeView;
    TreeFilterEdit2: TTreeFilterEdit;
    procedure BitaccelemClick(Sender: TObject);
    procedure btnAcceptClick(Sender: TObject);
    procedure btnaccelemClick(Sender: TObject);
    procedure BtnAddClick(Sender: TObject);
    procedure btnaddelemClick(Sender: TObject);
    procedure BtnaddmClick(Sender: TObject);
    procedure BtnaddnuclClick(Sender: TObject);
    procedure BtnaddpClick(Sender: TObject);
    procedure BtndelClick(Sender: TObject);
    procedure BtnChangeClick(Sender: TObject);
    procedure btndelelemClick(Sender: TObject);
    procedure btnexelemClick(Sender: TObject);
    procedure btnICClick(Sender: TObject);
    procedure btnIGClick(Sender: TObject);
    procedure BtnloadClick(Sender: TObject);
    procedure BtnmodClick(Sender: TObject);
    procedure btnQueClick(Sender: TObject);
    procedure BtnSaveClick(Sender: TObject);
    procedure btnunwrapClick(Sender: TObject);
    procedure btnwrapClick(Sender: TObject);
    procedure ComboTypeMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DBGrid1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure DBLookupComboBox1Change(Sender: TObject);
    procedure DBLookupComboBox1Select(Sender: TObject);
    procedure EditdescKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EditnameChange(Sender: TObject);
    procedure EditnameKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EdittemperatureChange(Sender: TObject);
    procedure EdittemperatureKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FilterComboBox1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure GridDblClick(Sender: TObject);
    procedure GridDrawCell(Sender: TObject; aCol, aRow: Integer; aRect: TRect;
      aState: TGridDrawState);
    procedure GridEditingDone(Sender: TObject);
    procedure GridKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ElementTreeAdvancedCustomDrawItem(Sender: TCustomTreeView;
      Node: TTreeNode; State: TCustomDrawState; Stage: TCustomDrawStage;
      var PaintImages, DefaultDraw: Boolean);
    procedure ElementTreeDblClick(Sender: TObject);
    procedure ElementTreeExpanded(Sender: TObject; Node: TTreeNode);
    procedure GridSelectCell(Sender: TObject; aCol, aRow: Integer;
      var CanSelect: Boolean);
    procedure IBLookupComboEditBox1Change(Sender: TObject);
    procedure IBLookupComboEditBox2Change(Sender: TObject);
    procedure IBLookupComboEditBox2Select(Sender: TObject);
    procedure MIcreatepatternClick(Sender: TObject);
    procedure MIInsertpatternClick(Sender: TObject);
    procedure PopupMenu2Popup(Sender: TObject);
  private
    function  Fillclassinfo(id : Integer): Boolean;     // Fill the entity of a class
    function  GetElembyInstance(inst : TInstanceConstr) : PTElement; //
    procedure Fillnuclgrid;                             // Fill the array nuclgrid
    procedure MakePattern;                              // pattern for element
    procedure ByPattern;                                // Fill the form by pattern of element
    procedure Delcomp(number : Integer);                // Delete composition from form
    procedure Inscomp();                                // Insert composition to form
    procedure elementacc;                               // Accept all changes in element form
    procedure Compacc;                                  // Accept all changes in nuclgrid
    function GetBeforeAddcomp:Integer;                  // Reset a composition generator

    procedure Filltree;                                // Fill tree by nodes
    procedure Updatecompstatus (element : Pointer;newStatus: TInstatus);// Update Compositions status

    procedure UpElemnode(Node : TTreeNode);            // Update data for element
    procedure UpCompnode(Node : TTreeNode);            // Update data for Compositions
    procedure Upmatgeom(Node: TTreeNode);              // Update data for Compostion material and geometry
    procedure Writeelemtoqueue(P:Pointer);             // Write changes from element class to queue changes
    procedure RefreshGeomdb;                           // Refresh Geometry List
    procedure RefreshMatdb;                            // Refresh material List
    { private declarations }
  public
    { public declarations }
    procedure Refreshcompdb;                           // ReSelect Compositions from database
    procedure UpdateExpanded(Node : TTreeNode);        // Update data for expanded nodes
    procedure Newelement;                              // Create inserted element
    procedure Deleteelement(element : Pointer);        // Change element status on deleted
    procedure Excludeelement(element : Pointer);       // Delete a element reference from list
    procedure BeforeAddelem;                           // Reset a generator
    procedure Clearmodform;                            // Clear all text field
    procedure Fillmodform;                             // Get info from base and fill all text field
    procedure Fillmodtable;                            // Get info from base and fill all text field
    procedure Refreshelem(id : Integer;const newStatus : TInStatus); overload;// Refresh form status
    procedure Refreshelem(element : Pointer); overload;// Refresh form status
    procedure OnInsert;                                // Execute insertion chain
    procedure OnAccept(element : Pointer);             // Execute acception chain
    procedure OnDelete(element : Pointer);             // Execute removing chain
    procedure SendChanges();                           // Execute the query with changed instance
    procedure SaveMod(number : Integer);               // Save all modifications
  end;

var
  FormElemedit: TFormElemedit;
  current_element,pattern_element: TElement;
  nuclGrid : TSortList;
  current_compnumber : Integer;

implementation
{$R *.lfm}
// Procedures of class TFormElemedit
 procedure TFormElemedit.Clearmodform;                                           // Clear all text field
 begin
      Editname.Text := '';
      Editdesc.Text := '';
      ComboType.ItemIndex := -1;
      //
      Grid.RowCount := 1;
      current_compnumber := -1;
      //
      if (QueryGeom.Active=True) then QueryGeom.Close;
      if (QueryMat.Active=True) then QueryMat.Close;
      //
      Panelelem.Enabled := False;

 end;
 //
 //class TFormElemedit
 procedure TFormElemedit.Fillmodform;                                            // Get info from base and fill all text field

 begin

      Editname.Text := current_element.Name;
      Editdesc.Text := current_element.Description;
      //
      ComboType.ItemIndex := current_element.ETYPE;
      //
      Fillmodtable;
      //
      Panelelem.Enabled := True;

      if (QueryGeom.RecordCount > 0) and (QueryMat.RecordCount > 0) then
         ToolBar2.Enabled := True
      else
         ToolBar2.Enabled := False;
      if Grid.RowCount < 2 then
         begin
           BtnChange.Enabled := False;
           Btnaddm.Enabled := False;
         end
      else
          begin
           BtnChange.Enabled := True;
           Btnaddm.Enabled := True;

          end;
      //

 end;


 //class TFormElemedit
  procedure TFormElemedit.Fillmodtable;                                          // Get info from base and fill all text field
   var
   i,j : Integer;
   begin
      i := nuclGrid.Len + 1;
      Grid.RowCount := nuclGrid.Len + 1;
      for i:=0 to nuclGrid.Len - 1 do
       begin
            Grid.Cells[0,i + 1] := Inttostr(i + 1);
            Grid.Cells[1,i + 1] := current_element.Compositions[nuclGrid.Values[i]].Geometry.Name;
            Grid.Cells[2,i + 1] := current_element.Compositions[nuclGrid.Values[i]].Material.Name;
       end;
    end;

procedure TFormElemedit.EditnameChange(Sender: TObject);
begin
    current_element.ChangeStatus(Modified);
end;

procedure TFormElemedit.EditnameKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  current_element.ChangeStatus(Modified);
end;

procedure TFormElemedit.EdittemperatureChange(Sender: TObject);
begin

end;

procedure TFormElemedit.EdittemperatureKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

end;

procedure TFormElemedit.FilterComboBox1Change(Sender: TObject);
begin

end;


procedure TFormElemedit.FormCreate(Sender: TObject);
begin
   nuclGrid := TSortList.Create();
   Clearmodform;
end;

procedure TFormElemedit.FormDestroy(Sender: TObject);
begin
    nuclGrid.Destroy();
end;

procedure TFormElemedit.GridDblClick(Sender: TObject);
begin

end;

procedure TFormElemedit.GridDrawCell(Sender: TObject; aCol, aRow: Integer;
  aRect: TRect; aState: TGridDrawState);
begin
  //if (current_compnumber > 0) and (current_compnumber < Grid.RowCount) and (aRow = current_compnumber) then
  //   Grid.Canvas.Brush.Color := clTeal
  //else
  //   Grid.Canvas.Brush.Color := clWindow;
  //Grid.Canvas.FillRect(aRect);
end;

procedure TFormElemedit.GridEditingDone(Sender: TObject);
begin

end;


procedure TFormElemedit.GridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  //if (ssShift in Shift) and (Key = VK_RIGHT) then BtnDelsurfClick(Sender);
end;

procedure TFormElemedit.ElementTreeAdvancedCustomDrawItem(
  Sender: TCustomTreeView; Node: TTreeNode; State: TCustomDrawState;
  Stage: TCustomDrawStage; var PaintImages, DefaultDraw: Boolean);

  var
   NodeRect : TRect;
   pt : PTInstanceConstr;
begin
{   if Node <> nil then
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

end;}

end;

procedure TFormElemedit.ElementTreeDblClick(Sender: TObject);
begin

 if (ElementTree.Selected <> nil) then
 begin
    UpdateExpanded(ElementTree.Selected);
    if (ElementTree.Selected.Level = 1) then Refreshelem(ElementTree.Selected.Data);
 end;

end;

procedure TFormElemedit.ElementTreeExpanded(Sender: TObject; Node: TTreeNode);
begin
  UpdateExpanded(Node);
end;

procedure TFormElemedit.GridSelectCell(Sender: TObject; aCol, aRow: Integer;
  var CanSelect: Boolean);
begin
 if (nuclGrid.Len > 0) then
 begin
    if (current_compnumber > -1) then
       begin
       if aRow <> current_compnumber then

             Savemod(current_compnumber);
             current_compnumber := -1;
          end;
  if (aRow > 0) then  DBLookupComboBox1.KeyValue:=current_element.Compositions[nuclGrid.Values[aRow - 1]].IDg;//QueryGeom.Locate('ID',current_element.Compositions[nuclGrid.Values[aRow - 1]].IDg,[]);
  if (aRow > 0) then  QueryMat.Locate('ID',current_element.Compositions[nuclGrid.Values[aRow - 1]].IDm,[]);
 end;

end;

procedure TFormElemedit.IBLookupComboEditBox1Change(Sender: TObject);
begin
   QueryGeom.Locate('ID',IBLookupComboEditBox2.KeyValue,[]);
  //if (current_compnumber > 0) then
  //begin
  //  Grid.Cells[2,current_compnumber + 1] := QueryMat.FieldByName('NAME').ASString;
  //end;
end;

procedure TFormElemedit.IBLookupComboEditBox2Change(Sender: TObject);
begin
  //QueryMat.Locate('ID',IBLookupComboEditBox2.KeyValue,[]);
 // if (current_compnumber > -1) then
 // begin
 //   Grid.Cells[2,current_compnumber + 1] := QueryMat.FieldByName('NAME').ASString;
 // end;
end;

procedure TFormElemedit.IBLookupComboEditBox2Select(Sender: TObject);
begin
  QueryMat.Locate('ID',IBLookupComboEditBox2.KeyValue,[]);
  if (current_compnumber > -1) then
  begin
    Grid.Cells[2,current_compnumber + 1] := QueryMat.FieldByName('NAME').ASString;
  end;
end;

procedure TFormElemedit.MIcreatepatternClick(Sender: TObject);
begin
  if (current_element <> nil) then
     if (current_element.Status <> None) then MakePattern();
end;

procedure TFormElemedit.MIInsertpatternClick(Sender: TObject);
begin
  ByPattern;
  Refreshelem(@current_element);
end;

procedure TFormElemedit.PopupMenu2Popup(Sender: TObject);
begin
  if not (ElementTree.Selected = nil) then
     if (ElementTree.Selected.Level = 1) then
     begin
        btndelelem.Enabled := True;
        btnaccelem.Enabled := True;
        btnexelem.Enabled := True;
        btnwtq.Enabled := True;
        btnexecelem.Enabled := True;
     end
     else
     begin
        btndelelem.Enabled := False;
        btnaccelem.Enabled := False;
        btnexelem.Enabled := False;
        btnwtq.Enabled := False;
        btnexecelem.Enabled := False;
     end
     else
        begin
        btndelelem.Enabled := False;
        btnaccelem.Enabled := False;
        btnexelem.Enabled := False;
        btnwtq.Enabled := False;
        btnexecelem.Enabled := False;
        end;
end;


procedure TFormElemedit.BitaccelemClick(Sender: TObject);
begin
  OnAccept(@current_element);
  if (current_compnumber > -1) then Savemod(current_compnumber);
  FillTree;
end;

procedure TFormElemedit.btnAcceptClick(Sender: TObject);
begin
  BitaccelemClick(Sender);
end;

procedure TFormElemedit.btnaccelemClick(Sender: TObject);
begin
  BitaccelemClick(Sender);
end;

procedure TFormElemedit.BtnAddClick(Sender: TObject);
begin
   OnInsert;
end;

procedure TFormElemedit.btnaddelemClick(Sender: TObject);
begin
  BtnAddClick(Sender);
end;

procedure TFormElemedit.BtnaddmClick(Sender: TObject);
begin
  if (Grid.Row > 0) then
   begin
        Compacc;
        Delcomp(Grid.Row - 1);
        Fillnuclgrid;
        Fillmodtable;

        if Grid.RowCount < 2 then
         begin
           BtnChange.Enabled := False;
           Btnaddm.Enabled := False;
         end;

   end;
end;

procedure TFormElemedit.BtnaddnuclClick(Sender: TObject);
begin

end;

procedure TFormElemedit.BtnaddpClick(Sender: TObject);
begin
  Compacc;
  Inscomp();
  Fillnuclgrid;
  Fillmodtable;
  if Grid.RowCount > 1 then
   begin
      begin
           BtnChange.Enabled := True;
           Btnaddm.Enabled := True;
         end;
   end;
end;



procedure TFormElemedit.BtndelClick(Sender: TObject);
begin
  if (ElementTree.Selected <> nil) then
   if ((ElementTree.Selected.Level = 1) and (ElementTree.Selected.Data <> nil)) then
      begin
        OnDelete(ElementTree.Selected.Data);
        ElementTree.Selected.Expanded := False;
        Clearmodform;
        Editing_element.ClearListbyNone;
        Filltree;
      end;
end;

procedure TFormElemedit.BtnChangeClick(Sender: TObject);
begin
  if (Grid.Row > 0) then
   begin
       current_compnumber := Grid.Row - 1;

   end;
end;

procedure TFormElemedit.btndelelemClick(Sender: TObject);
begin
   //
end;


procedure TFormElemedit.btnexelemClick(Sender: TObject);
begin
  BtnmodClick(Sender);
end;

procedure TFormElemedit.btnICClick(Sender: TObject);
begin
  dlgOpen.Options := [ofFileMustExist];
  dlgOpen.Filter := 'cst-files|*.cst|All files|*.*';
  dlgOpen.FilterIndex := 1;
  dlgOpen.InitialDir := gPath;
  dlgOpen.Title := 'Open the Consyst input file';

end;

procedure TFormElemedit.btnIGClick(Sender: TObject);
begin
  dlgOpen.Options := [ofFileMustExist];
  dlgOpen.Filter := 'inp-files|*.inp|All files|*.*';
  dlgOpen.FilterIndex := 1;
  dlgOpen.InitialDir := gPath;
  dlgOpen.Title := 'Open the Getera input file';
  dlgSelect.InitialDir := gPath;
  dlgSelect.Title := 'Point out on bin directory with mtr files';
end;

procedure TFormElemedit.BtnloadClick(Sender: TObject);
begin

end;


procedure TFormElemedit.BtnmodClick(Sender: TObject);
begin
if (ElementTree.Selected <> nil) then
  if ((ElementTree.Selected.Level = 1) and (ElementTree.Selected.Data <> nil)) then
     begin
       Excludeelement(ElementTree.Selected.Data);
       Clearmodform;
       Editing_element.ClearListbyNone;
       UpdateExpanded(ElementTree.Selected.Parent);

     end;
end;

procedure TFormElemedit.btnQueClick(Sender: TObject);
begin
   SendChanges;
end;

procedure TFormElemedit.BtnSaveClick(Sender: TObject);
begin
  dlgSave.Filter := 'txt-files|*.txt|All files|*.*';
  dlgSave.FilterIndex := 1;
  dlgSave.InitialDir := gPath;
  dlgSave.Title := 'Save the CONSYST input file';
end;

procedure TFormElemedit.btnunwrapClick(Sender: TObject);
begin

end;

procedure TFormElemedit.btnwrapClick(Sender: TObject);
begin

end;

procedure TFormElemedit.ComboTypeMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
   current_element.ChangeStatus(Modified);
end;


procedure TFormElemedit.DBGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (ssShift in Shift) and (Key = VK_LEFT) then BtnAddnuclClick(Sender);
end;

procedure TFormElemedit.DBLookupComboBox1Change(Sender: TObject);
begin
     QueryGeom.Locate('ID',DBLookupComboBox1.KeyValue,[]);
  //if (current_compnumber > 0) then
  //begin
  //  Grid.Cells[2,current_compnumber + 1] := QueryMat.FieldByName('NAME').ASString;
  //end;
end;

procedure TFormElemedit.DBLookupComboBox1Select(Sender: TObject);
begin
    QueryGeom.Locate('ID',DBLookupComboBox1.KeyValue,[]);
end;


procedure TFormElemedit.EditdescKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  current_element.ChangeStatus(Modified);
end;

 // class TFormElemedit
 procedure TFormElemedit.Delcomp(number : Integer);                              // Delete nuclid from form
 begin
   try
     current_element.Compositions[nuclgrid.Values[number]].ChangeStatus(Deleted);
     nuclgrid.Delete(number);
     current_element.ClearcompbyNone;
    except on e : Exception do
            begin{e - новый дескриптор ошибки}
             MessageDlg(e.message,mtError,[mbOK],0);
             Exit;
            end;
   end;
 end;
  // class TFormElemedit
  procedure TFormElemedit.Inscomp();                                             // Insert nuclid to form
  begin
    try
    current_element.AddComp(GetGeometrybyIndex(QueryGeom.FieldByName('ID').AsInteger));
    current_element.Compositions[current_element.NumComp - 1].ChangeStatus(Inserted);
    current_element.Compositions[current_element.NumComp - 1].Number := nuclGrid.Len + 1;
    current_element.Compositions[current_element.NumComp - 1].Material := GetMaterialByIndex(QueryMat.FieldByName('ID').AsInteger);
    current_element.Compositions[current_element.NumComp - 1].ReadID([current_element.ID,current_element.Compositions[current_element.NumComp - 1].IDg]);
    current_element.Compositions[current_element.NumComp - 1].ChangeStatus(Inserted);
    except on e : Exception do
            begin{e - новый дескриптор ошибки}
             MessageDlg(e.message,mtError,[mbOK],0);
             Exit;
            end;
   end;
  end;

 // Procedures of class TFormElemedit
 function TFormElemedit.Fillclassinfo(id : Integer): Boolean;                    // Fill the entity of a class
 var
  pElem : PTElement;
begin
    Result := False;
    try
       pElem := Fillelementinfo(id);
       if (pElem <> nil) then
         begin
          current_element := pElem^;
          current_element.ChangeStatus(Selected);
          Editing_element.Append(pElem^);
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
  // Procedures of class TFormElemedit
 procedure TFormElemedit.Refreshelem(id : Integer;const newStatus : TInStatus);   // Refresh form status
 begin
     if Fillclassinfo(id) then
     begin
     //
     //Editing_element.Append(current_element);
     //
     current_element.ChangeStatus(newStatus);
    if (newStatus <> Deleted) then
    begin
    Refreshcompdb;
     Fillnuclgrid;
     //;
     Fillmodform;

    end;
     Filltree;
     end;
 end;
// class TFormElemedit
 procedure TFormElemedit.Fillnuclgrid;
 var
    i : Integer;
 begin
     nuclGrid.Clear;
     for i:=0 to current_element.NumComp - 1 do
        if (current_element.Compositions[i].Status <> Deleted) and
        (current_element.Compositions[i].Status <> None) then
         nuclGrid.Append(i);
 end;
  //  class TFormElemedit
 procedure TFormElemedit.Refreshelem(element : Pointer);                         // Refresh form status
 var
    pElem : PTElement;
 begin
    pElem := element;
    if (pElem <> nil) then
    begin
    if (pElem^.Status = None) then
     Fillclassinfo(pElem^.id)
    else
     current_element := pElem^;
    if (current_element.Status <> Deleted) then
    begin
       Refreshcompdb;
       Fillnuclgrid;
       //DecGridCol;
       Fillmodform;

    end;

    end;

    Filltree;
 end;
 //  class TFormElemedit
  procedure TFormElemedit.elementacc;                                           // Accept all changes in element form
  begin
     //
      current_element.Name := Editname.Text;
      current_element.Description := Editdesc.Text;
      current_element.ETYPE := ComboType.ItemIndex;
  end;

  procedure TFormElemedit.Compacc;
  begin

  end;

  //  class TFormElemedit
   procedure TFormElemedit.BeforeAddelem;                                         // Reset a generator
   begin
      if (QTables[6].GetGeneratorValue < 0 ) then
         QTables[6].ActuateGen(ExecGenerator(6));
      QTables[6].IncGenerator;
   end;
   //
   function TFormElemedit.GetBeforeAddcomp:Integer;                             // Reset a composition generator
   begin

   end;
    //  class TFormElemedit
  procedure  TFormElemedit.Newelement;                                         // Create inserted element
  var
     pElem :PTElement;
  begin
     New(pElem);
     pElem^ := TElement.Create(Qtables[6].GetGeneratorValue(),
     'element_' + Inttostr(Qtables[6].GetGeneratorValue()));
     pElem^.ChangeStatus(Inserted);
     Editing_element.Add(pElem);
  end;

  //  class TFormElemedit
  procedure TFormElemedit.Deleteelement(element : Pointer);                    // Change element status on deleted
  var
     pElem :PTElement;
  begin
     pElem := element;
     pElem^.ChangeStatus(Deleted);
     Updatecompstatus(element,None);
  end;
  //  class TFormElemedit
  procedure TFormElemedit.Excludeelement(element : Pointer);                   // Delete a element reference from list
  var
     pElem :PTElement;
  begin
     pElem := element;
     pElem^.ChangeStatus(None);
     Updatecompstatus(element,None);
  end;
  //  class TFormElemedit
  procedure TFormElemedit.Updatecompstatus (element : Pointer;newStatus: TInstatus);// Update Compositions status
  var
     pElem :PTElement;
     iSurf : Integer;
  begin
     pElem := element;
     for iSurf := 0 to pElem^.NumComp - 1 do
     begin
          pElem^.Compositions[iSurf].ChangeStatus(newStatus);
     end;
  end;

      procedure TFormElemedit.SaveMod(number : Integer);                         // Save all modifications
      var
      pMat : PTMatter;
      begin
         current_element.Compositions[nuclGrid.Values[number]].Material := nil;
         New(pMat);
         pMat^ := GetMaterialbyIndex(QueryMat.FieldByName('ID').AsInteger);
         current_element.Compositions[nuclGrid.Values[number]].Material := pMat^;
         current_element.Compositions[nuclGrid.Values[number]].ChangeStatus(Modified);
         Dispose(pMat);
      end;

  //  class TFormElemedit
      procedure TFormElemedit.MakePattern;                                       // pattern for element
      begin
           if pattern_element = nil then
              pattern_element := TElement.Create('pattern');
           pattern_element.Copy(current_element);

      end;

  //  class TFormElemedit
    procedure TFormElemedit.ByPattern;                                           // Fill the form by pattern of element
    var
       i : Integer;
    begin
       if pattern_element <> nil then
          current_element.Copy(pattern_element);
       //For element only instance//
       // for i := 0 to current_element.NumComp - 1 do
       //     current_element.Compositions[i].IDp := GetBeforeAddcomp;

       //For element only instance//
    end;

  //  class TFormElemedit
  procedure TFormElemedit.Writeelemtoqueue(P:Pointer);                            // Write changes from element class to queue changes
  var
     pElem : PTElement;
     i : Integer;
     iBind : Integer;
  begin
     pElem := nil;
     iBind := -1;
     pElem := P;
     if (pElem^.Status <> Selected) and (pElem^.Status <> None) then Queue.FormChangetext(6,pElem^.Getproperties,-1,pElem^);
     for i := 0 to pElem^.NumComp - 1 do
         if (pElem^.Compositions[i].Status <> Selected) and (pElem^.Compositions[i].Status <> None) then
           if (pElem^.Status = Inserted) then
              Queue.FormChangetext(7,pElem^.GetCompositionproperties(i),pElem^,pElem^.Compositions[i])
           else
              Queue.FormChangetext(7,pElem^.GetCompositionproperties(i),iBind,pElem^.Compositions[i]);
  end;
  // class TFormElemedit
  procedure TFormElemedit.SendChanges();                                         // Execute the query with changed instance
  var
     pElem : PTElement;
     pComp : PTComposition;
     ExportList : TInstList;
     i,j : Integer;
  begin
     ExportList := TInstList.Create;
     pElem := nil;
     pComp := nil;
     for i := 0 to Editing_element.Len - 1 do
         begin
          pElem := Editing_element.Items[i];
          if ((pElem^.Status <> None) and (pElem^.Status <> Selected) and pElem^.GetQueord()) then ExportList.Add(pElem);
          for j := 0 to pElem^.NumComp - 1 do
              begin
                New(pComp);
                pComp^ := pElem^.Compositions[j];
                if ((pComp^.Status <> None) and (pComp^.Status <> Selected) and pComp^.GetQueord()) then ExportList.Add(pComp);
              end;
         end;
       FormHeader.ExecuteExported(ExportList);
  end;
  // TREEVIEW PROCEDURES
  //  class TFormElemedit
   procedure TFormElemedit.Filltree;                                              // Fill tree by nodes
   var
      selected_node : TTreeNode;
   begin
      if (Editing_element.Count > 0)  then
       if (ElementTree.Items.Count < 1) then
         //UpdateExpanded(ElementTree.Items.AddChild(nil,'Editing geometrys'))
        ElementTree.Items.AddChild(nil,'Editing elements')
       else
         if (ElementTree.Items[0].Expanded) then
          begin
               UpdateExpanded(ElementTree.Items[0]);
               if (current_element <> nil) and (current_element.Status <> None) then
                begin
                     selected_node := ElementTree.Items[0].FindNode(current_element.Name);
                   if (selected_node <> nil) then selected_node.Selected := True;
                end;
          end;
   end;

   //  class TFormElemedit
    procedure TFormElemedit.UpdateExpanded(Node : TTreeNode);                    // Update data for expanded nodes
    var
       i : Integer;
    begin
              case Node.Level of
                   0 :  UpElemnode(Node);
                   1 :  UpCompnode(Node);
                   2 :  Upmatgeom(Node);
                   3 :  Upmgdetail(Node,ElementTree);
              end;
              for i := 0 to Node.Count - 1 do
                  if (Node.Items[i].Expanded) then  UpdateExpanded(Node.Items[i]);
    end;

    //  class TFormElemedit
    procedure TFormElemedit.UpElemnode(Node : TTreeNode);                         // Update data for element
    var
       i: Integer;
       pElem : PTElement;
       Child : TTreeNode;
       pt : Pointer;
    begin

       ElementTree.BeginUpdate;
       try
             i := 0;
             for i:=Node.Count - 1 downto 0 do
                 begin
                   pt := Node.Items[i].Data;

                   if (pt <> nil) then
                    begin
                   pElem := pt;
                   // Change name
                   if (Node.Items[i].Text <> pElem^.Name) then
                    begin

                         Node.Items[i].Text := pElem^.Name;

                    end;
                   case pElem^.Status of
                        None : Node.Items[i].Delete;
                        Selected : Node.Items[i].ImageIndex:=-1;
                        Modified : Node.Items[i].ImageIndex:=3;
                        Deleted : Node.Items[i].ImageIndex:=0;
                        Inserted : Node.Items[i].ImageIndex:=4;
                   end;

                 end;

                 end;
             for i:=Node.Count to Editing_element.Count - 1 do
                 begin
                 pElem := Editing_element.Items[i];
                 if (pElem^.Status <> None) then
                 begin
                    Child := ElementTree.Items.AddChildObject(Node,pElem^.Name,Editing_element.Items[i]);
                 end;

                 end;

       except
          ShowMessage('Strange message');
       end;

       ElementTree.EndUpdate;

    end;

    //  class TFormElemedit
   procedure TFormElemedit.UpCompnode(Node : TTreeNode);                        // Update data for nculids
    var
       i: Integer;
       pElem : PTElement;
       pComp : PTComposition;
       Child : TTreeNode;
    begin
       ElementTree.BeginUpdate;
       try
       pElem := Node.Data;
        i := 0;
        if (pElem <> nil) then
        begin
            for i:=Node.Count - 1 downto 0 do
                 begin
                   pComp := Node.Items[i].Data;
                   if (pComp <> nil) then
                   begin
                   // Change name
                   if (Node.Items[i].Text <> pComp^.Textrepr) then
                    begin
                         //Node.EditText := True;
                         Node.Items[i].Text := pComp^.Textrepr;
                         //Node.EditText := False;
                    end;
                   case pComp^.Status of
                        //Deleted : Node.Items[i].Delete;
                        None : Node.Items[i].Delete;
                        Selected : Node.Items[i].ImageIndex:=-1;
                        Modified : Node.Items[i].ImageIndex:=3;
                        Deleted : Node.Items[i].ImageIndex:=0;
                        Inserted : Node.Items[i].ImageIndex:=4;
                   end;

                   end;

                 end;
             for i := Node.Count to pElem^.NumComp - 1 do
                 if (pElem^.Status <> None) then
                 begin
                    New(pComp);
                    pComp^ :=  pElem^.Compositions[i];
                    if (pComp^.Status <> None) then Child := ElementTree.Items.AddChildObject(Node,pElem^.Compositions[i].Textrepr, pComp);
                 end;
        end;


       except
          ShowMessage('Strange message');
       end;


       ElementTree.EndUpdate;
    end;

    procedure TFormElemedit.Upmatgeom(Node: TTreeNode);                        // Update data for Compostion material and geometry
    var
       i : Integer;
       pElem : PTElement;
       pComp : PTComposition;
    begin
       pElem := Node.Parent.Data;
       pComp := Node.Data;
       ElementTree.BeginUpdate;
       if (pComp <> nil) then
       // For Modified
       if (pComp^.Status = Modified) then
          if (Node.Expanded) and (Node.Count > 1) then Node.Items[1].Delete;
       // For Inserted
       if (pComp^.Status = Inserted) then
          if (Node.Expanded) and (Node.Count > 1) then
              if (Node.Items[0].Data <> @(pComp^.Geometry)) then
               begin
                Node.Items[0].Delete;
                Node.Items[1].Delete;
               end
              else
               if (Node.Items[1].Data <> @(pComp^.Material)) then
                  Node.Items[1].Delete;
       // For deleted and None
       if ((pComp^.Status = None) or (pComp^.Status = Deleted)) then
          begin
           if Node.Expanded then Node.Collapse(True)
          end


       else
           if Node.Count = 0 then
              begin
                 if (pComp^.Geometry <> nil) then ElementTree.Items.AddChildObject(Node,pComp^.Geometry.Name,@(pComp^.Geometry));
                 if (pComp^.Material <> nil) then ElementTree.Items.AddChildObject(Node,pComp^.Material.Name,@(pComp^.Material));

              end
           else
             if Node.Count = 1 then
                if (pComp^.Material <> nil) then ElementTree.Items.AddChildObject(Node,pComp^.Material.Name,@(pComp^.Material));
         ElementTree.EndUpdate;

    end;



    // TREE VIEW DESCRIPTION at the TOP
      function  TFormElemedit.GetElembyInstance(inst : TInstanceConstr) : PTElement; //
      var
         p: Pointer;
         pElem: PTElement;
      begin
         pElem := @inst;
         Result := pElem;
      end;
    //  class TFormElemedit
    procedure TFormElemedit.OnInsert;                                            // Execute insertion chain
    begin
      BeforeAddelem;
      Newelement;
      Refreshelem(Editing_element.Items[Editing_element.Count - 1]);
    end;

    //  class TFormElemedit
    procedure TFormElemedit.OnAccept(element : Pointer);                        // Execute acception chain
    begin
      elementacc;
      Compacc;
      Writeelemtoqueue(element);
      FormHeader.FullRefreshQueue;
    end;

    //  class TFormElemedit
    procedure TFormElemedit.OnDelete(element : Pointer);                        // Execute removing chain
    begin
        Deleteelement(element);
        Writeelemtoqueue(element);
        FormHeader.FullRefreshQueue;
        Clearmodform;
    end;

  //  class TFormElemedit
  procedure TFormElemedit.Refreshcompdb;                                          // ReSelect Compositions from database
  begin
       RefreshGeomdb;
       RefreshMatdb;
  end;
  //  class TFormElemedit
  procedure TFormElemedit.RefreshGeomdb;                             // Refresh Geometry List
  begin
            if (QueryGeom.Active=True) then QueryGeom.Close;
           QueryGeom.Prepare;

  try
         QueryGeom.Open;
         QueryGeom.Fetchall;
  except
    on
      E: Exception do
    begin
      TransactionGeom.Rollback;
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end;
  end;

  //  class TFormElemedit
  procedure TFormElemedit.RefreshMatdb;                              // Refresh material List
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
      TransactionGeom.Rollback;
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end;
  end;

end.

