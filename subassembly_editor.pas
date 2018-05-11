unit Subassembly_editor;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TreeFilterEdit, Forms, Controls,
  Graphics, ExtCtrls, StdCtrls, Buttons, ComCtrls,
  Grids, service_bd, unit_classes, system_info, instance_class,
  db, IBQuery, IBDatabase, IBCustomDataSet,  Dialogs,
  DBGrids, DbCtrls, Menus, ActnList,Fillinstinfo,Math,
  Service,ExportImport,header,windows;


type

  { TFormSubedit }

  TFormSubedit = class(TForm)
    Bitaccelem: TBitBtn;
    BtnClear: TBitBtn;
    Btndelelem: TToolButton;
    Btnaddelem: TToolButton;
    BtnChange: TToolButton;
    chkMsh: TCheckBox;
    ComboNumber: TComboBox;
    DataSourceElem: TDataSource;
    dbgrid: TDBGrid;
    DBLookupComboBox: TDBLookupComboBox;
    EditAngle: TEdit;
    btnQue: TMenuItem;
    btnaddpos: TMenuItem;
    btndelpos: TMenuItem;
    btnaccpos: TMenuItem;
    btnwtq: TMenuItem;
    btnexecpos: TMenuItem;
    btnAccept: TMenuItem;
    btnexsub: TMenuItem;
    Editdesc: TEdit;
    Editname: TEdit;
    EditPitch: TEdit;
    EditX: TEdit;
    EditY: TEdit;
    EditZ: TEdit;
    Grid: TStringGrid;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Memo: TMemo;
    MIInsertpattern: TMenuItem;
    MIcreatepattern: TMenuItem;
    dlgOpen: TOpenDialog;
    pnlMsh: TPanel;
    Panelpos: TPanel;
    Panelelemlist: TPanel;
    pnlVisual: TPanel;
    PanelGraph: TPanel;
    PopupMenu1: TPopupMenu;
    MenuEI: TPopupMenu;
    PopupMenu2: TPopupMenu;
    dlgSave: TSaveDialog;
    dlgSelect: TSelectDirectoryDialog;
    QueryElem: TIBQuery;
    QueryElemDESCRIPTION: TIBStringField;
    QueryElemID: TIntegerField;
    QueryElemNAME: TIBStringField;
    rbHex: TRadioButton;
    rbRect: TRadioButton;
    rbRound: TRadioButton;
    ImageList1: TImageList;
    Paneltree: TPanel;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    ToolBar1: TToolBar;
    BtnAdd: TToolButton;
    Btndel: TToolButton;
    Btnmod: TToolButton;
    Btnacc: TToolButton;
    BtnSave: TToolButton;
    Btnload: TToolButton;
    ToolBar2: TToolBar;
    btnaccnumbers: TToolButton;
    TransactionElem: TIBTransaction;
    SubassTree: TTreeView;
    TreeFilterEdit1: TTreeFilterEdit;
    TreeFilterEdit2: TTreeFilterEdit;
    procedure BitaccelemClick(Sender: TObject);
    procedure btnAcceptClick(Sender: TObject);
    procedure btnaccnumbersClick(Sender: TObject);
    procedure btnaccposClick(Sender: TObject);
    procedure BtnAddClick(Sender: TObject);
    procedure btnaddposClick(Sender: TObject);
    procedure BtnClearClick(Sender: TObject);
    procedure BtndelelemClick(Sender: TObject);
    procedure BtnaddnuclClick(Sender: TObject);
    procedure BtnaddplaceClick(Sender: TObject);
    procedure BtndelClick(Sender: TObject);
    procedure BtnChangeClick(Sender: TObject);
    procedure btndelposClick(Sender: TObject);
    procedure btnexsubClick(Sender: TObject);
    procedure btnICClick(Sender: TObject);
    procedure btnIGClick(Sender: TObject);
    procedure BtnloadClick(Sender: TObject);
    procedure BtnmodClick(Sender: TObject);
    procedure btnQueClick(Sender: TObject);
    procedure BtnSaveClick(Sender: TObject);
    procedure chkMshKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure chkMshMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure chkMshMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ComboNumberMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DBLookupComboBoxChange(Sender: TObject);
    procedure EditPitchKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditXKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure GridKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure rbHexClick(Sender: TObject);
    procedure SubassTreeAdvancedCustomDrawItem(Sender: TCustomTreeView;
      Node: TTreeNode; State: TCustomDrawState; Stage: TCustomDrawStage;
      var PaintImages, DefaultDraw: Boolean);
    procedure SubassTreeDblClick(Sender: TObject);
    procedure SubassTreeExpanded(Sender: TObject; Node: TTreeNode);
    procedure GridSelectCell(Sender: TObject; aCol, aRow: Integer;
      var CanSelect: Boolean);
    procedure MIcreatepatternClick(Sender: TObject);
    procedure MIInsertpatternClick(Sender: TObject);
    procedure PopupMenu2Popup(Sender: TObject);
  private
    function  Fillclassinfo(id : Integer): Boolean;     // Fill the entity of a class
    function  GetElembyInstance(inst : TInstanceConstr) : PTElement; //
    function  CheckInMesh(elementID : Integer) : Boolean;            // Check if an element in list
    procedure Fillnuclgrid;                             // Fill the array nuclgrid
    procedure MakePattern;                              // pattern for element
    procedure ByPattern;                                // Fill the form by pattern of element
    procedure Delplacement(number : Integer);             // Delete element from positioninst
    procedure Insplacement();                             // Insert element to positioninst
    procedure ChangePlacement(number : Integer);          // Change an element in pointed position
    procedure placeacc;                                  // Accept all changes in element form
    procedure Posacc;                                   // Accept all changes in nuclgrid
    procedure meshacc;                                  // Accept all changes in current mesh
    function GetBeforeAddPos:Integer;                   // Reset a composition generator
    procedure Changeplacementstatus(eID:Integer);       // Change the instance status of TPlacement class with dependency of index reading
    function GetPosArray: TIntegerArray ;               // Get an array of element indicies in positioninst
    procedure Filltree;                                 // Fill tree by nodes
    procedure Updateposstatus (positioninst : Pointer;newStatus: TInstatus);// Update Compositions status

    procedure Upsubnode(Node : TTreeNode);            // Update data for subassembly
    procedure UpPosnode(Node : TTreeNode);            // Update data for Positions
    procedure Upmshplace(Node: TTreeNode);              // Update data for Position Places and mesh
    procedure Upplacedetail(Node: TTreeNode);           // Update element for current placement

    procedure Writesubasstoqueue(P:Pointer);             // Write changes from element class to queue changes
    procedure RefreshElemdb;                           // Refresh Element List
    { private declarations }
  public
    current_subassembly : TElement_List;

    { public declarations }
    procedure Refreshposdb;                           // ReSelect Compositions from database
    procedure UpdateExpanded(Node : TTreeNode);        // Update data for expanded nodes
    procedure NewPosition;                              // Create inserted positioninst
    procedure DeletePosition(positioninst : Pointer);        // Change positioninst status on deleted
    procedure Excludesub(subassembly : Pointer);       // Delete a positioninst reference from list
    procedure NewMesh;                                   // Create mesh for current positioninst
    procedure BeforeAddpos;                           // Reset a generator
    procedure DefaultForm;                            // Default filling form
    procedure Clearmodform;                            // Clear all text field
    procedure Fillmodform;                             // Get info from base and fill all text field
    procedure Fillmodtable;                            // Get info from base and fill all text field
    procedure FillPositionfield;                       // Get info from base and fill all text field
    procedure Refreshassembly(id : Integer;const newStatus : TInStatus); overload;// Refresh form status
    procedure Refreshassembly(element : Pointer); overload;// Refresh form status
    procedure OnRowSelection(nRow : Integer);              // Refresh current row of the Grid
    procedure OnInsert;                                // Execute insertion chain
    procedure OnAccept(subassembly : Pointer);             // Execute acception chain
    procedure OnDelete(positioninst : Pointer);             // Execute removing chain
    procedure SendChanges();                           // Execute the query with changed instance
    procedure SaveMod(number : Integer);               // Save all modifications


  end;

var
  FormSubedit: TFormSubedit;
  elemental :  TInstList;
  pattern_subassembly: TElement_List;
  pcurrent_position : PTPosition;
  pcurrent_place: PTPlacement;
  pcurrent_element: PTElement;
  pcurrent_mesh : PTMesh;
  nuclGrid : TSortList;
  elemGrid : TSortList;
  current_compnumber : Integer;

implementation
{$R *.lfm}
// Procedures of class TFormSubedit
 procedure TFormSubedit.Clearmodform;                                           // Clear all text field
 begin
      Editname.Text := '';
      Editdesc.Text := '';
      DefaultForm;
      //
      Grid.RowCount := 1;
      current_compnumber := -1;
      //
      if (QueryElem.Active=True) then QueryElem.Close;
      //
      Panelelemlist.Enabled := False;
      //
      Memo.Enabled := False;
      BtnClear.Enabled := False;
      //


 end;
 //
 procedure TFormSubedit.DefaultForm;                                            // Default filling form
 begin
    EditX.Text := '0.0';
    EditY.Text := '0.0';
    EditZ.Text := '0.0';
    EditAngle.Text := '0.0';
    EditPitch.Text := '0.0';
    Combonumber.Items.Clear;
    chkMsh.Checked := False;
    PanelPos.Enabled := False;
 end;

 //
 //class TFormSubedit
 procedure TFormSubedit.Fillmodform;                                            // Get info from base and fill all text field

 begin

      Editname.Text := current_subassembly.Name;
      Editdesc.Text := current_subassembly.Description;
      //
      //
      Fillmodtable;
      //
      Panelelemlist.Enabled := True;

      if (QueryElem.RecordCount > 0) then
         ToolBar2.Enabled := True
      else
         ToolBar2.Enabled := False;
      if Grid.RowCount < 2 then
         begin
           BtnChange.Enabled := False;
           Btndelelem.Enabled := False;
         end
      else
          begin
           BtnChange.Enabled := True;
           Btndelelem.Enabled := True;

          end;
      FillPositionfield;

      //

 end;
  //class TFormSubedit
 procedure TFormSubedit.FillPositionfield;                                      // Get info from base and fill all text field
 var
   i : Integer;
 begin
      if (pcurrent_position <> nil) then
        begin
           EditX.Text := Floattostring(pcurrent_position^.X);
           EditY.Text := Floattostring(pcurrent_position^.Y);
           EditZ.Text := Floattostring(pcurrent_position^.Z);
           EditAngle.Text := Floattostring(pcurrent_position^.Angle);
           panelPos.Enabled := True;
      if (pcurrent_position^.Msh <> nil) then
        begin
        if (pcurrent_position^.Msh.Status <> Deleted) and (pcurrent_position^.Msh.Status <> None) then
             begin
               pnlMsh.Enabled := True;
               chkMsh.Checked := True;
               chkMsh.Enabled := False;
               if (pcurrent_position^.Msh.mtype = 1) then rbHex.Checked := True;
               if (pcurrent_position^.Msh.mtype = 2) then rbRect.Checked := True;
               if (pcurrent_position^.Msh.mtype = 3) then rbRound.Checked := True;
               EditPitch.Text := Floattostring(pcurrent_position^.Msh.Pitch);

               ComboNumber.Text := Inttostr(pcurrent_position^.Msh.Number);
               Memo.Lines.Clear;
               Memo.Enabled := True;
               BtnClear.Enabled := True;
               if (pcurrent_element <> nil) then
               for i := 0 to pcurrent_position^.NumPlacement - 1 do
                   begin
                     if ( pcurrent_position^.Placements[i].elementID = pcurrent_element^.ID) then
                      if ( pcurrent_position^.Placements[i].Status <> Deleted) and ( pcurrent_position^.Placements[i].Status <> None) then
                        Memo.Append(InttoStr(pcurrent_position^.Placements[i].Index));

                   end;

             end;
        end
        else
        begin
          if (pcurrent_position^.unique_number > -1) then
             pnlMsh.Enabled := False
          else
             begin
                  pnlMsh.Enabled := True;
                  chkMsh.Enabled := True;
             end;
          chkMsh.Checked := False;
          EditPitch.Text := '0.0';
          Combonumber.Items.Clear;
          Combonumber.Text:='1';
          rbHex.Checked := False;
          rbRect.Checked := False;
          rbRound.Checked := False;
          Memo.Lines.Clear;
          Memo.Enabled := False;
          BtnClear.Enabled := False;
        end;
        end
        else
            panelPos.Enabled := False;
 end;

 //class TFormSubedit
  procedure TFormSubedit.Fillmodtable;                                          // Get info from base and fill all text field
   var
   i,j : Integer;
   ptE : PTElement;
   begin
      i := nuclGrid.Len + 1;
      Grid.RowCount := nuclGrid.Len + 1;
      for i:=0 to nuclGrid.Len - 1 do
       begin
            Grid.Cells[0,i + 1] := Inttostr(i + 1);
            Grid.Cells[1,i + 1] := Floattostring(current_subassembly.Positions[nuclGrid.Values[i]].X);
            Grid.Cells[2,i + 1] := Floattostring(current_subassembly.Positions[nuclGrid.Values[i]].Y);
            Grid.Cells[3,i + 1] := Floattostring(current_subassembly.Positions[nuclGrid.Values[i]].Z);
            Grid.Cells[4,i + 1] := Floattostring(current_subassembly.Positions[nuclGrid.Values[i]].Angle);
            if (current_subassembly.Positions[nuclGrid.Values[i]].Msh <> nil ) then
              Grid.Cells[6,i + 1] := current_subassembly.Positions[nuclGrid.Values[i]].Msh.Textrepr()
            else
              Grid.Cells[6,i + 1] := 'No mesh';

              ptE := nil;
              ptE := elemental.Items[i];
            if (ptE^ <> nil) then
           begin
              Grid.Cells[5,i + 1] := ptE^.Name;
           end
           else
             Grid.Cells[5,i + 1] := 'Insert element!';
       end;
    end;




procedure TFormSubedit.FormCreate(Sender: TObject);
begin

   nuclGrid := TSortList.Create();

   elemGrid := TSortList.Create();

   elemental :=  TInstList.Create();

   Clearmodform;
end;

procedure TFormSubedit.FormDestroy(Sender: TObject);
begin

    nuclGrid.Destroy();

    elemGrid.Destroy();

    elemental.Destroy;
end;




procedure TFormSubedit.GridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  //if (ssShift in Shift) and (Key = VK_RIGHT) then BtnDelsurfClick(Sender);
end;

procedure TFormSubedit.rbHexClick(Sender: TObject);
var
   i : Integer;
begin
             Combonumber.Items.Clear;
             if (not rbHex.Checked) or (not rbRect.Checked) or (not rbRound.Checked) then
              begin
               for i := 2 to 31 - 1 do
                begin
                     if  (Sender = rbHex) then Combonumber.Items.Append(Inttostr(3*i*(i-1)+1));
                     if  (Sender = rbRect) then Combonumber.Items.Append(Inttostr(i*i));
                     if  (Sender = rbRound) then Combonumber.Items.Append(Inttostr(i));
                end;

              end;
end;

procedure TFormSubedit.SubassTreeAdvancedCustomDrawItem(
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

procedure TFormSubedit.SubassTreeDblClick(Sender: TObject);
begin

 if (SubassTree.Selected <> nil) then
 begin
    UpdateExpanded(SubassTree.Selected);
    if (SubassTree.Selected.Level = 1) then Refreshassembly(SubassTree.Selected.Data);
 end;

end;

procedure TFormSubedit.SubassTreeExpanded(Sender: TObject; Node: TTreeNode);
begin
  UpdateExpanded(Node);
end;

procedure TFormSubedit.GridSelectCell(Sender: TObject; aCol, aRow: Integer;
  var CanSelect: Boolean);
begin
 if (nuclGrid.Len > 0) and (elemental.Len > 0) then
 begin
    //if (Sender <> Grid) then
       OnRowSelection(aRow);

 end;

end;


procedure TFormSubedit.MIcreatepatternClick(Sender: TObject);
begin
  if (current_subassembly <> nil) then
     if (current_subassembly.Status <> None) then MakePattern();
end;

procedure TFormSubedit.MIInsertpatternClick(Sender: TObject);
begin
  ByPattern;
  Refreshassembly(@current_subassembly);
end;

procedure TFormSubedit.PopupMenu2Popup(Sender: TObject);
begin
  if not (SubassTree.Selected = nil) then
     case SubassTree.Selected.Level of
         1:
         begin

              btnaddpos.Enabled := False;

              btndelpos.Enabled := False;

              btnaccpos.Enabled := False;

              btnexsub.Enabled := True;

              btnwtq.Enabled := True;

              btnexecpos.Enabled := True;
         end;
         2:
         begin
              btnaddpos.Enabled := True;

              btndelpos.Enabled := True;

              btnaccpos.Enabled := True;

              btnexsub.Enabled := False;

              btnwtq.Enabled := False;

              btnexecpos.Enabled := False;
         end;
         3:
         begin
             btnaddpos.Enabled := False;

             btndelpos.Enabled := False;

             btnaccpos.Enabled := False;

             btnexsub.Enabled := False;

             btnwtq.Enabled := False;

             btnexecpos.Enabled := False;
         end;
     end
     else
        begin
             btnaddpos.Enabled := False;

             btndelpos.Enabled := False;

             btnaccpos.Enabled := False;

             btnexsub.Enabled := False;

             btnwtq.Enabled := False;

             btnexecpos.Enabled := False;
        end;
end;


procedure TFormSubedit.BitaccelemClick(Sender: TObject);
begin

  OnAccept(@current_subassembly);
  if (current_compnumber > -1) then Grid.Row := current_compnumber;
  FillTree;
end;

procedure TFormSubedit.btnAcceptClick(Sender: TObject);
begin
  BitaccelemClick(Sender);
end;

procedure TFormSubedit.btnaccnumbersClick(Sender: TObject);
begin
  Savemod(0);
  current_compnumber := -1;
  Fillnuclgrid;
  if (nuclGrid.Len > 0) then
     OnRowSelection(current_compnumber);
end;

procedure TFormSubedit.btnaccposClick(Sender: TObject);
begin
  BitaccelemClick(Sender);
end;

procedure TFormSubedit.BtnAddClick(Sender: TObject);
begin
   OnInsert;
   if (Grid.RowCount > 1) then Grid.Row := Grid.RowCount - 1;
end;

procedure TFormSubedit.btnaddposClick(Sender: TObject);
begin
  BtnAddClick(Sender);
end;

procedure TFormSubedit.BtnClearClick(Sender: TObject);
begin
     Memo.Clear;
end;

procedure TFormSubedit.BtndelelemClick(Sender: TObject);
begin
  if (Grid.Row > 0) then
   begin

        Memo.Clear;
        Savemod(0);
        Delplacement(Grid.Row - 1);
        Fillnuclgrid;
        Fillmodtable;

        if Grid.RowCount < 2 then
         begin
           BtnChange.Enabled := False;
           Btndelelem.Enabled := False;
         end;

   end;
end;

procedure TFormSubedit.BtnaddnuclClick(Sender: TObject);
begin

end;

procedure TFormSubedit.BtnaddplaceClick(Sender: TObject);
var
  loc : Integer;
begin
  Savemod(0);
  if (chkMsh.Checked) or (pcurrent_position^.NumPlacement = 0)
  or (pcurrent_element = nil) or ((pcurrent_element <> nil) and (pcurrent_element^ = nil)) then
  if (pcurrent_position^.Msh = nil) or ((pcurrent_position^.Msh <> nil) and not (CheckInMesh(QueryElem.FieldByName('ID').AsInteger))) then
  begin
    Insplacement();

    //Fillnuclgrid;

    loc := current_compnumber;

    current_compnumber := Grid.Row;

    Fillmodtable;

    current_compnumber := loc;

    Grid.Row := current_compnumber;

    Memo.Clear;
  end;
  //else
  //    OnInsert();

  //Memo.Clear;
  if Grid.RowCount > 1 then
   begin
      begin
           BtnChange.Enabled := True;
           Btndelelem.Enabled := True;
         end;
   end;
end;



procedure TFormSubedit.BtndelClick(Sender: TObject);
begin
  if (SubassTree.Selected <> nil) then
   if ((SubassTree.Selected.Level = 2) and (SubassTree.Selected.Data <> nil)) then
      begin
        OnDelete(SubassTree.Selected.Data);
        SubassTree.Selected.Expanded := False;
        //Clearmodform;
        //Editing_element.ClearListbyNone;
        Filltree;
      end;
end;

procedure TFormSubedit.BtnChangeClick(Sender: TObject);
begin
  if (Grid.Row > 0) then
   begin
       ChangePlacement(Grid.Row - 1);

       Savemod(0);

       FillmodForm;
   end;
end;

procedure TFormSubedit.btndelposClick(Sender: TObject);
begin
   //
   OnDelete(pcurrent_position);
end;


procedure TFormSubedit.btnexsubClick(Sender: TObject);
begin
  BtnmodClick(Sender);
end;

procedure TFormSubedit.btnICClick(Sender: TObject);
begin
  dlgOpen.Options := [ofFileMustExist];
  dlgOpen.Filter := 'cst-files|*.cst|All files|*.*';
  dlgOpen.FilterIndex := 1;
  dlgOpen.InitialDir := gPath;
  dlgOpen.Title := 'Open the Consyst input file';

end;

procedure TFormSubedit.btnIGClick(Sender: TObject);
begin
  dlgOpen.Options := [ofFileMustExist];
  dlgOpen.Filter := 'inp-files|*.inp|All files|*.*';
  dlgOpen.FilterIndex := 1;
  dlgOpen.InitialDir := gPath;
  dlgOpen.Title := 'Open the Getera input file';
  dlgSelect.InitialDir := gPath;
  dlgSelect.Title := 'Point out on bin directory with mtr files';
end;

procedure TFormSubedit.BtnloadClick(Sender: TObject);
begin

end;


procedure TFormSubedit.BtnmodClick(Sender: TObject);
begin
if (SubassTree.Selected <> nil) then
  if ((SubassTree.Selected.Level = 1) and (SubassTree.Selected.Data <> nil)) then
     begin
       Excludesub(SubassTree.Selected.Data);
       Clearmodform;
       Editing_subassembly.ClearListbyNone;
       UpdateExpanded(SubassTree.Selected.Parent);

     end;
end;

procedure TFormSubedit.btnQueClick(Sender: TObject);
begin
   SendChanges;
end;

procedure TFormSubedit.BtnSaveClick(Sender: TObject);
begin
  dlgSave.Filter := 'txt-files|*.txt|All files|*.*';
  dlgSave.FilterIndex := 1;
  dlgSave.InitialDir := gPath;
  dlgSave.Title := 'Save the CONSYST input file';
end;

procedure TFormSubedit.chkMshKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

end;

procedure TFormSubedit.chkMshMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin

end;

procedure TFormSubedit.chkMshMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
   if chkMsh.Checked then
     begin
      if (pcurrent_position^.Msh = nil) then
        NewMesh
      else
        pcurrent_position^.Msh.ChangeStatus(pcurrent_position^.Msh.oldStatus);

     // if (pcurrent_position^.Msh <> nil) then chkMsh.Checked:= True;

      //SaveMod(0);
      Meshacc;

      FillnuclGrid;

      Fillmodform;
     end
  else
      begin
        if (pcurrent_position <> nil) then
        begin
          if (pcurrent_position^.Msh <> nil) then pcurrent_position^.Msh.ChangeStatus(Deleted);
          pcurrent_position^.ClearposbyNone();
        end;
      end;
end;

procedure TFormSubedit.ComboNumberMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if pcurrent_position <> nil then
     if (pcurrent_position^.Msh <> nil) then pcurrent_position^.Msh.ChangeStatus(Modified);
end;



procedure TFormSubedit.EditPitchKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     if pcurrent_position <> nil then
     if (pcurrent_position^.Msh <> nil) then pcurrent_position^.Msh.ChangeStatus(Modified);
end;



procedure TFormSubedit.DBLookupComboBoxChange(Sender: TObject);
begin
  QueryElem.Locate('ID',DBLookupComboBox.KeyValue,[]);
end;



procedure TFormSubedit.EditXKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    pcurrent_position^.ChangeStatus(Modified);
end;

 // class TFormSubedit
 procedure TFormSubedit.Delplacement(number : Integer);                              // Delete nuclid from form
 begin
   try
     if (Assigned(pcurrent_element)) then pcurrent_element := nil;

     //elemental.Delete(number);

     elemental.Insert(number,nil);

     elemental.Delete(number + 1);

     if (pcurrent_position^ <> nil) then
     begin

       pcurrent_position^.GetFirstU;

       if (pcurrent_position^.unique_number > -1) and (pcurrent_position^.Msh = nil) then

           pcurrent_position^.Placements[0].ChangeStatus(Deleted);

       if (pcurrent_position^.unique_number = -1) and (pcurrent_position^.Msh <> nil) then

          //OnDelete(current_subassembly);

       pcurrent_position^.ClearposbyNone();

     end;

    except on e : Exception do
            begin{e - новый дескриптор ошибки}
             MessageDlg(e.message,mtError,[mbOK],0);
             Exit;
            end;
   end;
 end;
 // class TFormSubedit
     function  TFormSubedit.CheckInMesh(elementID : Integer) : Boolean;            // Check if an element in list
     var
       i : Integer;

     begin

       Result := False;

       if (pcurrent_position^ <> nil) then

       for i := 0 to pcurrent_position^.NumPlacement - 1 do
         if (pcurrent_position^.Placements[i].Element <> nil) then
            if (pcurrent_position^.Placements[i].Element.ID = elementID) then
            begin

             Result := True;
             Exit;

            end;


     end;

  // class TFormSubedit
  procedure TFormSubedit.Insplacement();                                              // Insert nuclid to form
  var
   i : Integer;
  begin
    try
    if (Assigned(pcurrent_element)) then pcurrent_element := nil;
    if (pcurrent_position <> nil) then
    begin

         pcurrent_element := Fillelementinfo(QueryElem.FieldByName('ID').AsInteger);   //get an element

         if (pcurrent_position^.NumPlacement = 0) or (pcurrent_position^.unique_number = -1) then // if not an element at position
         begin

          elemental.Insinst(current_compnumber - 1,pcurrent_element^);                 // insert an element instance

          elemental.Delete(current_compnumber);                                        // delete  an empty instance

          pcurrent_element := elemental.Items[current_compnumber - 1];                 // get a current_element value

          //current_compnumber := nuclGrid.Len;
          if (current_compnumber < 1) then

            current_compnumber := 1

          //else

          //  current_compnumber := nuclGrid.Len;

         end
         else
         begin
            current_compnumber := current_compnumber + 1;

            if (current_compnumber < nuclGrid.Len + 1) then                            // Insertion new element at middle of a list
            begin
                 elemental.Insinst(current_compnumber - 1,pcurrent_element^);

                 nuclGrid.Insert(current_compnumber - 1,nuclGrid.Values[current_compnumber - 1]);

                 pcurrent_element := elemental.Items[current_compnumber - 1];
            end
            else                                                                       // Insertion to the end of list
            begin

                elemental.Append(pcurrent_element^);

                nuclGrid.Append(nuclGrid.Values[current_compnumber - 2]);

                pcurrent_element := elemental.Items[elemental.Len - 1];

            end;
         end;

    end;
    except on e : Exception do
            begin{e - новый дескриптор ошибки}
             MessageDlg(e.message,mtError,[mbOK],0);
             Exit;
            end;
   end;
  end;

 procedure TFormSubedit.ChangePlacement(number : Integer);                       // Change an element in pointed position
 begin
   if (Assigned(pcurrent_element)) then pcurrent_element := nil;
    if (pcurrent_position <> nil) then
    begin

         pcurrent_element := Fillelementinfo(QueryElem.FieldByName('ID').AsInteger);   //get an element

         elemental.Insinst(number,pcurrent_element^);                 // insert an element instance

         elemental.Delete(number + 1);                                        // delete  an empty instance

         pcurrent_element := elemental.Items[number];                 // get a current_element value

         pcurrent_position^.unique_number := -1;

    end;
 end;

 // Procedures of class TFormSubedit
 function TFormSubedit.Fillclassinfo(id : Integer): Boolean;                    // Fill the entity of a class
 var
  pElem : PTElement_list;
begin
    Result := False;
    try
       pElem := Fillsubassemblyinfo(id);
       if (pElem <> nil) then
         begin
          current_subassembly := pElem^;
          current_subassembly.ChangeStatus(Selected);
          Editing_subassembly.Append(pElem^);
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
  // Procedures of class TFormSubedit
 procedure TFormSubedit.Refreshassembly(id : Integer;const newStatus : TInStatus);   // Refresh form status
 begin
     if Fillclassinfo(id) then
     begin
     //current_subassembly.ChangeStatus(newStatus);
     current_compnumber := -1;
     pcurrent_position := nil;
     pcurrent_element := nil;
     pcurrent_mesh := nil;
     if (newStatus <> Deleted) then
      begin
      Refreshposdb;
      Fillnuclgrid;
      Fillmodform;
      if (nuclGrid.Len > 0) then
       begin
          Grid.Row := 1;
          OnRowselection(1);
       end;

    end;
     Filltree;
     end;
 end;
// class TFormSubedit
 procedure TFormSubedit.Fillnuclgrid;
 var
    i : Integer;
    pos : Integer;
 begin
     nuclGrid.Clear;
     elemental.Clear;
     for i:=0 to current_subassembly.PositionNumber - 1 do
        if (current_subassembly.Positions[i].Status <> Deleted) and
        (current_subassembly.Positions[i].Status <> None) then
         begin
              pos := current_subassembly.Positions[i].GetFirstU;
              if (pos = -1) then
                 begin
                   nuclGrid.Append(i);
                   elemental.Append(nil);
                 end;
              while pos <> -1 do
              begin
                   nuclGrid.Append(i);
                   elemental.Append(current_subassembly.Positions[i].Placements[pos].Element);
                   pos := current_subassembly.Positions[i].GetNextU;
              end;
         end;
 end;
  //  class TFormSubedit
 procedure TFormSubedit.Refreshassembly(element : Pointer);                         // Refresh form status
 var
    pElem : PTElement_list;
 begin
    pElem := element;
    current_compnumber := -1;
    pcurrent_position := nil;
    pcurrent_element := nil;
    pcurrent_mesh := nil;
    if (pElem <> nil) then
    begin
    if (pElem^.Status = None) then
     Fillclassinfo(pElem^.id)
    else
      begin
           current_subassembly := pElem^;

      end;
    if (current_subassembly.Status <> Deleted) then
    begin
       Refreshposdb;
       Fillnuclgrid;
       Fillmodform;
       if (nuclGrid.Len > 0) then
       begin
          Grid.Row := 1;
          OnRowselection(1);
       end;
    end;
    end;
    Filltree;
 end;
 //  class TFormSubedit
 procedure TFormSubedit.Changeplacementstatus(eID:Integer);                     // Change the instance status of TPlacement class with dependency of index reading
 var
     i,j,tempID : Integer;
     indicies : TIntegerArray;
     isFind : Boolean;
     localElement : TElement;
     localPlacement : TPlacement;
 begin
     indicies := GetPosArray();
     if pcurrent_element <> nil then
        begin
            localElement := TElement.Create(pcurrent_element^.ID,pcurrent_element^.Name);
            localElement.Copy(pcurrent_element^);
            localPlacement := TPlacement.Create(localElement);
        end;
      for i := Low(indicies) to High(indicies) do
       if indicies[i] > 0 then
       begin
         isFind := False;
         for j := 0 to pcurrent_position^.NumPlacement - 1 do
          begin
             if (pcurrent_position^.Placements[j].elementID = eID) and (i + 1 = pcurrent_position^.Placements[j].Index) then
                begin
                     isFind := True;
                     if (pcurrent_position^.Placements[j].Status = Deleted) then
                       pcurrent_position^.Placements[j].ChangeStatus(pcurrent_position^.Placements[j].oldStatus);
                end;
             if (pcurrent_position^.Placements[j].elementID <> eID) and (i + 1 = pcurrent_position^.Placements[j].Index) then
                begin
                  isFind := True;
                  //pcurrent_position^.Placements[j].ReadID([pcurrent_position^.ID,i+1]);
                  pcurrent_position^.Placements[j].ChangeStatus(Modified);
                  pcurrent_position^.Placements[j].ReadElement(pcurrent_element^);
                end;
          end;
         if not (isFind) then
            begin

              pcurrent_position^.AddPlace(localPlacement);
              pcurrent_position^.Placements[pcurrent_position^.NumPlacement - 1].ReadID([pcurrent_position^.ID,i+1]);
              pcurrent_position^.Placements[pcurrent_position^.NumPlacement - 1].ChangeStatus(Inserted);

            end;
       end;
      for j := 0 to pcurrent_position^.NumPlacement - 1 do
          begin
             isFind := False;
              if (pcurrent_position^.Placements[j].elementID = eID) then
              begin
                   for i := Low(indicies) to High(indicies) do
                       if (indicies[i] >0) and (i + 1 = pcurrent_position^.Placements[j].Index) then isFind := True;
                   if not (isFind) then
                   begin
                     pcurrent_position^.Placements[j].ChangeStatus(Deleted);

                   end;
              end;

          end;pcurrent_position^.ClearposbyNone;
     end;


   //  class TFormSubedit
     function TFormSubedit.GetPosArray: TIntegerArray ;                         // Get an array of element indicies in positioninst
     var
        i,j,k,pos1,pos2,inind,outind,maxnum : Integer;
        str,Substr : String;
        indexout : array of Integer;
        s : TStringarray;
     begin
        Result := nil;
        indexout := nil;
        maxnum := Strtoint(Combonumber.Text);
        SetLength(Result, maxnum);
        for j := 0 to Length(Result) - 1 do
            Result[j] := 0;
        for i := 0 to Memo.Lines.Count - 1  do
         if (length(Memo.Lines[i]) > 0) then
         if (Memo.Lines[i][1] = ':') then//? from 0 or 1
             begin
                  str := Memo.Lines[i];
                  pos1 := 2;
                  pos2 := 2;
                  for j := 2 to Length(str) do
                      if (str[j] = '_') then
                         begin
                              pos2 := j;
                              Substr := Copy(str,pos1,pos2-pos1);
                              inind := Strtoint(substr);
                              pos1 := pos2 + 1;
                              pos2 := Length(str) + 1;
                         end
                      else if (str[j] = '-') then
                              //pos2 := j-1;
                              pos2 := j;
                  Substr := Copy(str,pos1,pos2-pos1);
                  outind := Strtoint(substr);

                  if (pos2 < Length(str)) then
                     begin
                          Substr := Copy(str,pos2 + 1,Length(str) - pos2 + 1);
                          s := Workstr(Substr,',');
                          for j := 0 to Length(s) - 1 do
                           if Inrange(Strtoint(s[j]),1,maxnum) then
                              begin
                                SetLength(indexout, Length(indexout) + 1);
                                indexout[Length(indexout) - 1] := Strtoint(s[j]);
                              end;
                     end;
                  for j := inind to outind do
                   if InRange(j,1,maxnum) then
                   begin
                      Result[j - 1] := 1;
                      for k := 0 to Length(indexout) - 1 do
                            if (indexout[k]=j) then  Result[j-1] := -1;
                   end;
                  Indexout := nil;
             end
     else
     begin
        str := Memo.Lines[i];
        s := Workstr(str,',');
        for j := 0 to Length(s) - 1 do
            if Inrange(Strtoint(s[j]),1,maxnum) then
        begin
             Result[Strtoint(s[j]) - 1] := 1;
        end;


     end;

     end;

 //  class TFormSubedit
  procedure TFormSubedit.placeacc;                                               // Accept all changes in element form
  begin
     //
     if (pcurrent_position <> nil) then
     if not (chkMsh.Checked) then
     begin
        if (pcurrent_element <> nil) and
        ((pcurrent_position^.NumPlacement = 0) or (pcurrent_position^.unique_number = -1)) then
        if (pcurrent_element^ <> nil) then
           begin
              if (pcurrent_position^.NumPlacement = 0) then
                begin
                     pcurrent_position^.AddPlace(TPLacement.Create(pcurrent_element^));
                     pcurrent_position^.Placements[pcurrent_position^.NumPlacement - 1].ReadID([pcurrent_position^.ID,1]);
                     pcurrent_position^.Placements[pcurrent_position^.NumPlacement - 1].ChangeStatus(Inserted);
                end
                else
                    if (pcurrent_element^.ID = pcurrent_position^.Placements[pcurrent_position^.NumPlacement - 1].elementID) then

                       pcurrent_position^.Placements[pcurrent_position^.NumPlacement - 1].ChangeStatus(pcurrent_position^.Placements[pcurrent_position^.NumPlacement - 1].oldStatus)

                    else

                      begin
                       pcurrent_position^.Placements[pcurrent_position^.NumPlacement - 1].ReadElement(pcurrent_element^);
                       pcurrent_position^.Placements[pcurrent_position^.NumPlacement - 1].ChangeStatus(Modified);
                      end;

                pcurrent_position^.GetFirstU;

           end;
     end
     else
     begin
     if (pcurrent_element <> nil) then
        if (pcurrent_element^ <> nil) then Changeplacementstatus(pcurrent_element^.ID);

     end;
     //
  end;

  procedure TFormSubedit.Posacc;
  begin
     if pcurrent_position <> nil then
     begin
      try
       pcurrent_position^.X := Strtofloat(EditX.Text);
      except
       EditX.Text := '0.0';
      end;
      try
       pcurrent_position^.Y := Strtofloat(EditY.Text);
      except
       EditY.Text := '0.0';
      end;
      try
       pcurrent_position^.Z := Strtofloat(EditZ.Text);

      except
       EditZ.Text := '0.0';
      end;
      try
       pcurrent_position^.Angle := Strtofloat(EditAngle.Text);
      except
       EditAngle.Text := '0.0';
      end;
     end;
  end;
 //  class TFormSubedit
  procedure TFormSubedit.meshacc;                                               // Accept all changes in current mesh
  begin
     if (chkMsh.Checked) and (pcurrent_position <> nil) then
     begin
     if (pcurrent_position^.Msh <> nil) then
     begin
     try
      pcurrent_position^.Msh.Pitch := Strtofloat(EditPitch.Text);
     except
       EditPitch.Text := '0.0';
     end;
     try
      pcurrent_position^.Msh.Number := Strtoint(Combonumber.Text);
     except
      Combonumber.Text := '0';
     end;
     if (rbHex.Checked) then  pcurrent_position^.Msh.mtype := 1;
     if (rbRect.Checked) then  pcurrent_position^.Msh.mtype := 2;
     if (rbRound.Checked) then  pcurrent_position^.Msh.mtype := 3;

     end;
     end;
  end;

  //  class TFormSubedit
   procedure TFormSubedit.BeforeAddpos;                                         // Reset a generator
   begin
      if (QTables[8].GetGeneratorValue < 0 ) then
         QTables[8].ActuateGen(ExecGenerator(8));
      QTables[8].IncGenerator;
   end;
   //
   function TFormSubedit.GetBeforeAddPos:Integer;                             // Reset a composition generator
   begin

   end;
    //  class TFormSubedit
  procedure  TFormSubedit.NewPosition;                                          // Create inserted positioninst
  var
     pPos :PTPosition;
  begin
     New(pPos);

     pcurrent_element := nil;

     pPos^ := TPosition.Create(Qtables[8].GetGeneratorValue());

     pPos^.ReadID([current_subassembly.ID,Qtables[8].GetGeneratorValue()]);

     current_subassembly.AddPos(pPos^);

     current_subassembly.Positions[current_subassembly.PositionNumber - 1].ChangeallStatus(Inserted);

     current_subassembly.Positions[current_subassembly.PositionNumber - 1].ChangeStatus(Inserted);

     if (Assigned(pcurrent_position)) then pcurrent_position := nil;//??

     New(pcurrent_position);

     pcurrent_position^ := current_subassembly.Positions[current_subassembly.PositionNumber - 1];

  end;
  //  class TFormSubedit
  procedure TFormSubedit.NewMesh;                                               // Create mesh for current positioninst

  begin
     if pcurrent_position <> nil then
        begin
     if not Assigned(pcurrent_mesh) then
        begin

             New(pcurrent_mesh);
             pcurrent_mesh^ := TMesh.Create(1);
               //Meshacc;
           if  pcurrent_position^.AddMesh(pcurrent_mesh^) then begin
               //Dispose(pcurrent_mesh);
               pcurrent_position^.Msh.ChangeStatus(Inserted);
           end;
        end;

        end;
  end;

  //  class TFormSubedit
  procedure TFormSubedit.DeletePosition(positioninst : Pointer);                    // Change positioninst status on deleted
  var
      pPos :PTPosition;
  begin
     pPos := positioninst;
     pPos^.ChangeStatus(Deleted);
     Updateposstatus(positioninst,None);
  end;
  //  class TFormSubedit
  procedure TFormSubedit.Excludesub(subassembly : Pointer);                   // Delete a element reference from list
  var
     pElem :PTElement_list;
     i : Integer;
  begin
     pElem := subassembly;

     pElem^.ChangeStatus(None);

     for i := 0 to pElem^.PositionNumber - 1 do

         begin

            pElem^.Positions[i].ChangeallStatus(None);

            pElem^.Positions[i].ChangeStatus(None);

         end;

     FormHeader.FullRefreshQueue;

  end;
  //  class TFormSubedit
  procedure TFormSubedit.Updateposstatus (positioninst : Pointer;newStatus: TInstatus);// Update Compositions status
  var
     pPos :PTPosition;
     iPlace : Integer;
  begin
     pPos := positioninst;
     for iPlace := 0 to pPos^.NumPlacement - 1 do
     begin
          pPos^.Placements[iPlace].ChangeStatus(newStatus);
     end;
     if (pPos^.Msh <> nil) then pPos^.Msh.ChangeStatus(newStatus);
  end;

      procedure TFormSubedit.SaveMod(number : Integer);                         // Save all modifications
      begin

        Posacc;

        Meshacc;

        placeacc;
      end;

  //  class TFormSubedit
      procedure TFormSubedit.MakePattern;                                       // pattern for element
      begin
           if pattern_subassembly = nil then

              pattern_subassembly := TElement_List.Create(TElement.Create('pattern'))

           else

              begin

                   pattern_subassembly.Destroy();

                   pattern_subassembly := TElement_List.Create(TElement.Create('pattern'));
              end;


           pattern_subassembly.Copy(current_subassembly);

      end;

  //  class TFormSubedit
    procedure TFormSubedit.ByPattern;                                           // Fill the form by pattern of element
    var
       i : Integer;
    begin
       if pattern_subassembly <> nil then

       begin
          current_subassembly.Copy(pattern_subassembly);

          for i := 0 to current_subassembly.PositionNumber - 1 do

              begin

                   current_subassembly.Positions[i].ChangeallStatus(Inserted);

                   current_subassembly.Positions[i].ChangeStatus(Inserted);

              end;

       end;

    end;

  //  class TFormSubedit
  procedure TFormSubedit.Writesubasstoqueue(P:Pointer);                            // Write changes from element class to queue changes
  var
     pElem : PTElement_list;
     i,j : Integer;
     iBind : Integer;
  begin
     pElem := nil;
     iBind := -1;
     pElem := P;
    // if (pElem^.Status <> Selected) and (pElem^.Status <> None) then Queue.FormChangetext(6,pElem^.Getproperties,-1,pElem^);
     for i := 0 to pElem^.PositionNumber - 1 do
     begin

         // positioninst Change
         if (pElem^.Positions[i].Status <> Selected) and (pElem^.Positions[i].Status <> None) then

            Queue.FormChangetext(8,pElem^.Positions[i].Getproperties,-1,pElem^.Positions[i]);

         // Mesh Change
         if  (pElem^.Positions[i].Msh <> nil) then
         if  (pElem^.Positions[i].Msh.Status <> Selected) and (pElem^.Positions[i].Msh.Status <> None) then
               if (pElem^.Positions[i].Status = Inserted) then
                  Queue.FormChangetext(9,pElem^.Positions[i].GetMshProperty(),pElem^.Positions[i],pElem^.Positions[i].Msh)
               else
                  Queue.FormChangetext(9,pElem^.Positions[i].GetMshProperty(),iBind,pElem^.Positions[i].Msh);

         // Placement Change
         for  j := pElem^.Positions[i].NumPlacement - 1 downto 0  do
              if  (pElem^.Positions[i].Placements[j].Status <> Selected) and (pElem^.Positions[i].Placements[j].Status <> None) then
               if (pElem^.Positions[i].Status = Inserted) then
                  Queue.FormChangetext(10,pElem^.Positions[i].GetPlaceproperties(j),pElem^.Positions[i],pElem^.Positions[i].Placements[j])
               else
                  Queue.FormChangetext(10,pElem^.Positions[i].GetPlaceproperties(j),iBind,pElem^.Positions[i].Placements[j]);

     end;
  end;
  // class TFormSubedit
  procedure TFormSubedit.SendChanges();                                         // Execute the query with changed instance
  var
     pPos : PTPosition;
     pMsh : PTMesh;
     pPlace : PTPlacement;
     ExportList : TInstList;
     i,j : Integer;
  begin
     ExportList := TInstList.Create;
     pPos := nil;
     pMsh := nil;
     pPlace := nil;
     for i := 0 to current_subassembly.PositionNumber - 1 do
         begin
          New(pPos);
          pPos^ := current_subassembly.Positions[i];
          if ((pPos^.Status <> None) and (pPos^.Status <> Selected) and pPos^.GetQueord()) then ExportList.Add(pPos); // Export positioninst

          if (pPos^.Msh <> nil) then

             if ((pPos^.Msh.Status <> None) and (pPos^.Msh.Status <> Selected) and pPos^.Msh.GetQueord()) then // Export Mesh
                begin
                     New(pMsh);
                     pMsh^ := pPos^.Msh;
                     ExportList.Add(pMsh);
                end;

          // Export Placement

          for j := pPos^.NumPlacement - 1 downto 0  do
              begin
                New(pPlace);
                pPlace^ := pPos^.Placements[j];
                if ((pPlace^.Status <> None) and (pPlace^.Status <> Selected) and pPlace^.GetQueord()) then ExportList.Add(pPlace);
              end;
         end;
       FormHeader.ExecuteExported(ExportList);
  end;
  // TREEVIEW PROCEDURES
  //  class TFormSubedit
   procedure TFormSubedit.Filltree;                                              // Fill tree by nodes
   var
      selected_node : TTreeNode;
   begin
      if (Editing_subassembly.Count > 0)  then
       if (SubassTree.Items.Count < 1) then
         //UpdateExpanded(SubassTree.Items.AddChild(nil,'Editing geometrys'))
        SubassTree.Items.AddChild(nil,'Editing subassembly')
       else
         if (SubassTree.Items[0].Expanded) then
          begin
               UpdateExpanded(SubassTree.Items[0]);
               if (current_subassembly <> nil) and (current_subassembly.Status <> None) then
                begin
                     selected_node := SubassTree.Items[0].FindNode(current_subassembly.Name);
                   if (selected_node <> nil) then selected_node.Selected := True;
                end;
          end;
   end;

   //  class TFormSubedit
    procedure TFormSubedit.UpdateExpanded(Node : TTreeNode);                    // Update data for expanded nodes
    var
       i : Integer;
    begin
              case Node.Level of
                   0 :  Upsubnode(Node);
                   1 :  UpPosnode(Node);
                   2 :  Upmshplace(Node);
                   3 :  Upplacedetail(Node);
                   4 :  UpelementL(Node,SubassTree);
                   5 :  UpcompositionL(Node,SubassTree);
                   6 :  Upmgdetail(Node,SubassTree);
              end;
              for i := 0 to Node.Count - 1 do
                  if (Node.Items[i].Expanded) then  UpdateExpanded(Node.Items[i]);
    end;

    //  class TFormSubedit
    procedure TFormSubedit.Upsubnode(Node : TTreeNode);                         // Update data for element
    var
       i: Integer;
       pElem : PTElement_list;
       Child : TTreeNode;
       pt : Pointer;
    begin

       SubassTree.BeginUpdate;
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
                   end;

                 end;

                 end;
             for i:=Node.Count to Editing_subassembly.Count - 1 do
                 begin
                 pElem := Editing_subassembly.Items[i];
                 if (pElem^.Status <> None) then
                 begin
                    Child := SubassTree.Items.AddChildObject(Node,pElem^.Name,Editing_subassembly.Items[i]);
                 end;

                 end;

       except
          ShowMessage('Strange message');
       end;

       SubassTree.EndUpdate;

    end;

    //  class TFormSubedit
   procedure TFormSubedit.UpPosnode(Node : TTreeNode);                        // Update data for nculids
    var
       i: Integer;
       pElem : PTElement_list;
       pPos : PTPosition;
       Child : TTreeNode;
    begin
       SubassTree.BeginUpdate;
       try
       pElem := Node.Data;
        i := 0;
        if (pElem <> nil) then
        begin
            for i:=Node.Count - 1 downto 0 do
                 begin
                   pPos := Node.Items[i].Data;
                   if (pPos <> nil) then
                   begin
                    if (Node.Items[i].Text <> pPos^.Textrepr) then
                    begin

                         Node.Items[i].Text := pPos^.Textrepr;

                    end;
                   case pPos^.Status of

                        None : Node.Items[i].Delete;
                        Selected : Node.Items[i].ImageIndex:=-1;
                        Modified : Node.Items[i].ImageIndex:=3;
                        Deleted : Node.Items[i].ImageIndex:=0;
                        Inserted : Node.Items[i].ImageIndex:=4;
                   end;

                   end;

                 end;
             for i := Node.Count to pElem^.PositionNumber - 1 do
                 if (pElem^.Status <> None) then
                 begin
                    New(pPos);
                    pPos^ :=  pElem^.Positions[i];
                    if (pPos^.Status <> None) then Child := SubassTree.Items.AddChildObject(Node,pElem^.Positions[i].Textrepr, pPos);
                 end;
        end;


       except
          ShowMessage('Strange message');
       end;


       SubassTree.EndUpdate;
    end;

    procedure TFormSubedit.Upmshplace(Node: TTreeNode);                        // Update data for Compostion material and geometry
    var
       i : Integer;
       pPos : PTPosition;
       pMsh : PTMesh;
       pPlace : PTPlacement;
       Child : TTreeNode;
    begin
       SubassTree.BeginUpdate;
       try
       pPos := Node.Data;
        i := 0;
        if (pPos <> nil) then
        begin
            for i:=Node.Count - 1 downto 0 do
                if (i > 0) or (pPos^.Msh = nil) then
                 begin
                   pPlace := Node.Items[i].Data;
                   if (pPlace <> nil) then
                   begin
                    if (Node.Items[i].Text <> pPlace^.Textrepr) then
                    begin

                         Node.Items[i].Text := pPlace^.Textrepr;

                    end;
                   case pPlace^.Status of

                        None : Node.Items[i].Delete;
                        Selected : Node.Items[i].ImageIndex:=-1;
                        Modified : Node.Items[i].ImageIndex:=3;
                        Deleted : Node.Items[i].ImageIndex:=0;
                        Inserted : Node.Items[i].ImageIndex:=4;
                   end;

                   end;

                 end
                 else
                 begin

                    pMsh := Node.Items[i].Data;
                   if (pMsh <> nil) then
                   //if Node.Count > 0 then
                   begin
                    if (Node.Items[i].Text <> pMsh^.Textrepr) then
                    begin

                         Node.Items[i].Text := pMsh^.Textrepr;

                    end;
                   case pMsh^.Status of

                        None : Node.Items[i].Delete;
                        Selected : Node.Items[i].ImageIndex:=-1;
                        Modified : Node.Items[i].ImageIndex:=3;
                        Deleted : Node.Items[i].ImageIndex:=0;
                        Inserted : Node.Items[i].ImageIndex:=4;
                   end;

                   end;
                 end;
             if (Node.Count = 0) and (pPos^.Msh <> nil) then

                if (pPos^.Msh.Status <> None) then
                   begin
                        New(pMsh);
                        pMsh^ := pPos^.Msh;
                        Child := SubassTree.Items.AddChildObject(Node,pPos^.Msh.Textrepr(), pMsh);

                   end;

             for i := Node.Count to pPos^.NumPlacement - 1 do
                 if (pPos^.Status <> None) then
                 begin
                    New(pPlace);
                    pPlace^ :=  pPos^.Placements[i];
                    if (pPlace^.Status <> None) then Child := SubassTree.Items.AddChildObject(Node,pPos^.Placements[i].Textrepr(), pPlace);
                 end;
        end;


       except
          ShowMessage('Strange message');
       end;


       SubassTree.EndUpdate;



    end;

        procedure TFormSubedit.Upplacedetail(Node: TTreeNode);                  // Update element for current placement
        var
           i : Integer;
           pPlace : PTPlacement;
            pPos : PTPosition;
            pMsh : PTMesh;
        begin

             pPos := Node.Parent.Data;

       if (pPos <> nil) then
          if (pPos^.Msh = nil) or (Node.Index > 0) then
          begin

               SubassTree.BeginUpdate;

               pPlace := Node.Data;

               // For Modified
               if (pPlace^.Status = Modified) then
                  if (Node.Expanded) and (Node.Count > 0) then Node.Items[0].Delete;
               // For Inserted
               if (pPlace^.Status = Inserted) then
               if (Node.Expanded) and (Node.Count > 0) then
                  Node.Items[0].Delete;

               if ((pPlace^.Status = None) or (pPlace^.Status = Deleted)) then

               begin

                    if Node.Expanded then Node.Collapse(True)

               end
               else
                  if Node.Count = 0 then
                  begin
                     if (pPlace^.Element <> nil) then SubassTree.Items.AddChildObject(Node,pPlace^.Element.Name,@(pPlace^.Element));
                  end;

               SubassTree.EndUpdate;
          end;


        end;



    // TREE VIEW DESCRIPTION at the TOP
      function  TFormSubedit.GetElembyInstance(inst : TInstanceConstr) : PTElement; //
      var
         p: Pointer;
         pElem: PTElement;
      begin
         pElem := @inst;
         Result := pElem;
      end;

    procedure TFormSubedit.OnRowSelection(nRow : Integer);                      // Refresh current row of the Grid
    begin
        if (nRow <> current_compnumber) and (nRow > 0) then

           begin

             if (current_compnumber > -1) then Savemod(current_compnumber);

             if (Assigned(pcurrent_position)) then pcurrent_position := nil;

             if (Assigned(pcurrent_element)) then pcurrent_element := nil;

             if (pcurrent_position = nil) then New(pcurrent_position);

             if (pcurrent_element = nil) then New(pcurrent_element);

             pcurrent_position^ := current_subassembly.Positions[nuclGrid.Values[nRow-1]];

             if elemental.Items[nRow-1] <> nil then

               pcurrent_element := elemental.Items[nRow-1]

             else
               pcurrent_element := nil;

             Fillnuclgrid;

             current_compnumber := nRow;

             FillmodForm;

          end;

    end;

    //  class TFormSubedit
    procedure TFormSubedit.OnInsert;                                            // Execute insertion chain
    begin

      BeforeAddpos;                                                             // Define a generator value

      NewPosition;                                                              // Create a new position

      Savemod(0);                                                               // Save changes

      FillnuclGrid;                                                             // Update form

      Fillmodform;
    end;

    //  class TFormSubedit
    procedure TFormSubedit.OnAccept(subassembly : Pointer);                         // Execute acception chain
    begin

      Savemod(0);

      FillnuclGrid;

      Fillmodform;

      Writesubasstoqueue(subassembly);

      FormHeader.FullRefreshQueue;
    end;

    //  class TFormSubedit
    procedure TFormSubedit.OnDelete(positioninst : Pointer);                     // Execute removing chain
    begin
        Savemod(0);

        DeletePosition(positioninst);

        Memo.Clear;

        elemental.Delete(current_compnumber - 1);

        FillnuclGrid;

        Fillmodform;

        if (nuclGrid.Len = 0) then
          begin
               pcurrent_position := nil;

               pcurrent_element := nil;

               pcurrent_mesh := nil;

               DefaultForm;
          end
        else
            if (current_compnumber - 1) < nuclGrid.Len then

               Grid.Row := current_compnumber
            else
               Grid.Row := 1;
    end;

  //  class TFormSubedit
  procedure TFormSubedit.Refreshposdb;                                          // ReSelect Compositions from database
  begin
       RefreshElemdb;
  end;
  //  class TFormSubedit
  procedure TFormSubedit.RefreshElemdb;                                         // Refresh Geometry List
  begin
            if (QueryElem.Active=True) then QueryElem.Close;
           QueryElem.Prepare;

  try
         QueryElem.Open;
         QueryElem.Fetchall;
  except
    on
      E: Exception do
    begin
      TransactionElem.Rollback;
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end;
  end;





end.

