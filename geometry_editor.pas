unit geometry_editor;

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

  { TFormGeomedit }

  TFormGeomedit = class(TForm)
    Bitaccgeom: TBitBtn;
    DataSourceSurf: TDataSource;
    DBLookupListBox1: TDBLookupListBox;
    Editname: TEdit;
    Editdesc: TEdit;
    btnQue: TMenuItem;
    btnaddgeom: TMenuItem;
    btndelgeom: TMenuItem;
    btnaccgeom: TMenuItem;
    btnwtq: TMenuItem;
    btnexecgeom: TMenuItem;
    btnAccept: TMenuItem;
    btnexgeom: TMenuItem;
    miChangeSign: TMenuItem;
    MIInsertpattern: TMenuItem;
    MIcreatepattern: TMenuItem;
    dlgOpen: TOpenDialog;
    PopupMenu1: TPopupMenu;
    MenuEI: TPopupMenu;
    PopupMenu2: TPopupMenu;
    dlgSave: TSaveDialog;
    dlgSelect: TSelectDirectoryDialog;
    ppMenuGrid: TPopupMenu;
    QuerySurfDESCRIPTION: TIBStringField;
    QuerySurfID: TIntegerField;
    QuerySurfNAME: TIBStringField;
    QuerySurfNDIM: TSmallintField;
    ToolBar2: TToolBar;
    Btnaddp: TToolButton;
    Btnaddm: TToolButton;
    Btndelface: TToolButton;
    TransactionSurf: TIBTransaction;
    QuerySurf: TIBQuery;
    ImageList1: TImageList;
    Label1: TLabel;
    Label2: TLabel;
    Paneltree: TPanel;
    Panelgeom: TPanel;
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
    GeometryTree: TTreeView;
    TreeFilterEdit2: TTreeFilterEdit;
    procedure BitaccgeomClick(Sender: TObject);
    procedure btnAcceptClick(Sender: TObject);
    procedure btnaccgeomClick(Sender: TObject);
    procedure BtnAddClick(Sender: TObject);
    procedure btnaddgeomClick(Sender: TObject);
    procedure BtnaddmClick(Sender: TObject);
    procedure BtnaddnuclClick(Sender: TObject);
    procedure BtnaddpClick(Sender: TObject);
    procedure BtndelClick(Sender: TObject);
    procedure BtndelfaceClick(Sender: TObject);
    procedure btndelgeomClick(Sender: TObject);
    procedure btnexgeomClick(Sender: TObject);
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
    procedure DBLookupListBox1Click(Sender: TObject);
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
    procedure GeometryTreeAdvancedCustomDrawItem(Sender: TCustomTreeView;
      Node: TTreeNode; State: TCustomDrawState; Stage: TCustomDrawStage;
      var PaintImages, DefaultDraw: Boolean);
    procedure GeometryTreeDblClick(Sender: TObject);
    procedure GeometryTreeExpanded(Sender: TObject; Node: TTreeNode);
    procedure miChangeSignClick(Sender: TObject);
    procedure MIcreatepatternClick(Sender: TObject);
    procedure MIInsertpatternClick(Sender: TObject);
    procedure PopupMenu2Popup(Sender: TObject);
  private
    procedure IncGridCol(number : Integer);
    procedure DecGridCol();
    function  Fillclassinfo(id : Integer): Boolean;     // Fill the entity of a class
    function  GetGeombyInstance(inst : TInstanceConstr) : PTGeometry; //
    procedure Fillnuclgrid;                             // Fill the array nuclgrid
    procedure MakePattern;                              // pattern for geometry
    procedure ByPattern;                                // Fill the form by pattern of geometry
    procedure Delsurf(number : Integer);                // Delete surface from form
    procedure Inssurf(ind: INteger;Const typ : Integer);// Insert surface to form
    procedure geometryacc;                              // Accept all changes in geometry form
    procedure Surfacc;                                  // Accept all changes in nuclgrid
    function GetBeforeAddsurf:Integer;                  // Reset a surface generator

    procedure Filltree;                                 // Fill tree by nodes
    procedure UpdateFacestatus (geometry : Pointer;newStatus: TInstatus);// Update Faces status

    procedure UpGeomnode(Node : TTreeNode);              // Update data for geometry
    procedure UpSurfnode(Node : TTreeNode);             // Update data for surfaces
    procedure Writegeomtoqueue(P:Pointer);               // Write changes from geometry class to queue changes
    { private declarations }
  public
    { public declarations }
    procedure Refreshsurfdb;                             // ReSelect Faces from database
    procedure UpdateExpanded(Node : TTreeNode);         // Update data for expanded nodes
    procedure Newgeometry;                              // Create inserted geometry
    procedure Deletegeometry(geometry : Pointer);       // Change geometry status on deleted
    procedure Excludegeometry(geometry : Pointer);      // Delete a geometry reference from list
    procedure BeforeAddgeom;                             // Reset a generator
    procedure Clearmodform;                             // Clear all text field
    procedure Fillmodform;                              // Get info from base and fill all text field
    procedure Fillmodtable;                             // Get info from base and fill all text field
    procedure Refreshgeom(id : Integer;const newStatus : TInStatus); overload;// Refresh form status
    procedure Refreshgeom(geometry : Pointer); overload; // Refresh form status
    procedure OnInsert;                                 // Execute insertion chain
    procedure OnAccept(geometry : Pointer);             // Execute acception chain
    procedure OnDelete(geometry : Pointer);             // Execute removing chain
    procedure SendChanges();                            // Execute the query with changed instance
  end;

var
  FormGeomedit: TFormGeomedit;
  current_geometry,pattern_geometry: TGeometry;
  nuclGrid : TSortList;

implementation
{$R *.lfm}
// Procedures of class TFormGeomedit
 procedure TFormGeomedit.Clearmodform;                                           // Clear all text field
 begin
      Editname.Text := '';
      Editdesc.Text := '';

      //
      Grid.RowCount := 1;
      //
      if (QuerySurf.Active=True) then QuerySurf.Close;
      //
      Panelgeom.Enabled := False;

 end;
 //
 //class TFormGeomedit
 procedure TFormGeomedit.Fillmodform;                                            // Get info from base and fill all text field

 begin

      Editname.Text := current_geometry.Name;
      Editdesc.Text := current_geometry.Description;
      //
      //
      DecGridCol;
      Fillmodtable;
      //
      Panelgeom.Enabled := True;
      //

 end;
 //class TFormGeomedit
     procedure TFormGeomedit.IncGridCol(number : Integer);
     begin
        if number > Grid.ColCount then Grid.ColCount := number;
     end;

 //class TFormGeomedit
    procedure TFormGeomedit.DecGridCol();
    var
      pSurf : TGSurf;
      i,maxval : Integer;
    begin
       maxval := 0;
       for i := 0 to current_geometry.NumSurf - 1 do
       begin
          psurf := current_geometry.Faces[i];
          if (psurf.Status <> None) and (psurf.Status <> Deleted) then
             if (psurf.Numberdim > maxval) then maxval :=  psurf.Numberdim;
       end;
       Grid.ColCount := 2 + maxval*2;

    end;

 //class TFormGeomedit
  procedure TFormGeomedit.Fillmodtable;                                          // Get info from base and fill all text field
   var
   i,j : Integer;
   begin
      i := nuclGrid.Len + 1;
      Grid.RowCount := nuclGrid.Len + 1;
    //  Grid.RowCount := nuclGrid.Len + 1;
      for i:=0 to nuclGrid.Len - 1 do
       begin
         //IncGridCol(2*(current_geometry.Faces[nuclGrid.Values[i]].Numberdim + 1));
         if (current_geometry.Faces[nuclGrid.Values[i]].RTYPE = 1) then
            Grid.Cells[0,i + 1] := '-'
         else
            Grid.Cells[0,i + 1] := '+';
         Grid.Cells[1,i + 1] := current_geometry.Faces[nuclGrid.Values[i]].Name;
         for j := 0 to current_geometry.Faces[nuclGrid.Values[i]].Numberdim - 1 do
          begin
               Grid.Cells[2 + 2*j,i + 1] := current_geometry.Faces[nuclGrid.Values[i]].Description[j]
              + ' = ';
               Grid.Cells[3 + 2*j,i + 1] := Floattostring(current_geometry.Faces[nuclGrid.Values[i]].Dimension[j]);
          end;

         end;
    end;

procedure TFormGeomedit.EditnameChange(Sender: TObject);
begin
    current_geometry.ChangeStatus(Modified);
end;

procedure TFormGeomedit.EditnameKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  current_geometry.ChangeStatus(Modified);
end;

procedure TFormGeomedit.EdittemperatureChange(Sender: TObject);
begin

end;

procedure TFormGeomedit.EdittemperatureKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

end;

procedure TFormGeomedit.FormCreate(Sender: TObject);
begin
   nuclGrid := TSortList.Create();
   Clearmodform;
end;

procedure TFormGeomedit.FormDestroy(Sender: TObject);
begin
    nuclGrid.Destroy();
end;

procedure TFormGeomedit.GridDblClick(Sender: TObject);
begin
   if ((Grid.Col > 2) and ((Grid.Col - 3) Mod 2 = 0)) then
   begin
    Grid.Options := Grid.Options - [goRangeSelect];
    Grid.Options := Grid.Options + [goEditing];
   end;
end;

procedure TFormGeomedit.GridEditingDone(Sender: TObject);
begin
    Grid.Options := Grid.Options - [goEditing];
    Grid.Options := Grid.Options + [goRangeSelect];
    if (nuclgrid.Len > 0) then current_geometry.Faces[nuclgrid.Values[Grid.Row - 1]].ChangeStatus(Modified);

end;

procedure TFormGeomedit.GridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  //if (ssShift in Shift) and (Key = VK_RIGHT) then BtnDelsurfClick(Sender);
end;

procedure TFormGeomedit.GeometryTreeAdvancedCustomDrawItem(
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

procedure TFormGeomedit.GeometryTreeDblClick(Sender: TObject);
begin

 if (GeometryTree.Selected <> nil) then
 begin
    UpdateExpanded(GeometryTree.Selected);
    if (GeometryTree.Selected.Level = 1) then Refreshgeom(GeometryTree.Selected.Data);
 end;

end;

procedure TFormGeomedit.GeometryTreeExpanded(Sender: TObject; Node: TTreeNode);
begin
  UpdateExpanded(Node);
end;

procedure TFormGeomedit.miChangeSignClick(Sender: TObject);
begin
     if (current_geometry <> nil) then
     begin

          if current_geometry.Faces[nuclGrid.Values[Grid.Row - 1]].RTYPE = 1 then

             current_geometry.Faces[nuclGrid.Values[Grid.Row - 1]].RTYPE := 2

          else

             current_geometry.Faces[nuclGrid.Values[Grid.Row - 1]].RTYPE := 1;

          current_geometry.Faces[nuclGrid.Values[Grid.Row - 1]].ChangeStatus(Modified);

          FillmodForm;
     end;

end;

procedure TFormGeomedit.MIcreatepatternClick(Sender: TObject);
begin
  if (current_geometry <> nil) then
     if (current_geometry.Status <> None) then MakePattern();
end;

procedure TFormGeomedit.MIInsertpatternClick(Sender: TObject);
begin
  ByPattern;
  Refreshgeom(@current_geometry);
end;

procedure TFormGeomedit.PopupMenu2Popup(Sender: TObject);
begin
  if not (GeometryTree.Selected = nil) then
     if (GeometryTree.Selected.Level = 1) then
     begin
        btndelgeom.Enabled := True;
        btnaccgeom.Enabled := True;
        btnexgeom.Enabled := True;
        btnwtq.Enabled := True;
        btnexecgeom.Enabled := True;
     end
     else
     begin
        btndelgeom.Enabled := False;
        btnaccgeom.Enabled := False;
        btnexgeom.Enabled := False;
        btnwtq.Enabled := False;
        btnexecgeom.Enabled := False;
     end
     else
        begin
        btndelgeom.Enabled := False;
        btnaccgeom.Enabled := False;
        btnexgeom.Enabled := False;
        btnwtq.Enabled := False;
        btnexecgeom.Enabled := False;
        end;
end;


procedure TFormGeomedit.BitaccgeomClick(Sender: TObject);
begin
  OnAccept(@current_geometry);
  FillTree;
end;

procedure TFormGeomedit.btnAcceptClick(Sender: TObject);
begin
  BitaccgeomClick(Sender);
end;

procedure TFormGeomedit.btnaccgeomClick(Sender: TObject);
begin
  BitaccgeomClick(Sender);
end;

procedure TFormGeomedit.BtnAddClick(Sender: TObject);
begin
   OnInsert;
end;

procedure TFormGeomedit.btnaddgeomClick(Sender: TObject);
begin
  BtnAddClick(Sender);
end;

procedure TFormGeomedit.BtnaddmClick(Sender: TObject);
begin
  Surfacc;
  Inssurf(QuerySurf.FieldByName('ID').AsInteger,1);
  Fillnuclgrid;
  DecGridCol;
  Fillmodtable;
  if Grid.RowCount > 1 then BtndelFace.Enabled := True;
end;

procedure TFormGeomedit.BtnaddnuclClick(Sender: TObject);
begin

end;


procedure TFormGeomedit.BtnaddpClick(Sender: TObject);
begin
  Surfacc;
  Inssurf(QuerySurf.FieldByName('ID').AsInteger,2);
  Fillnuclgrid;
  DecGridCol;
  Fillmodtable;
  if Grid.RowCount > 1 then BtndelFace.Enabled := True;
end;



procedure TFormGeomedit.BtndelClick(Sender: TObject);
begin
  if (GeometryTree.Selected <> nil) then
   if ((GeometryTree.Selected.Level = 1) and (GeometryTree.Selected.Data <> nil)) then
      begin
        OnDelete(GeometryTree.Selected.Data);
        GeometryTree.Selected.Expanded := False;
        Clearmodform;
        //unitqueue.FormQueue.FullRefreshQueue;
        Editing_geometry.ClearListbyNone;
        Filltree;
      end;
end;

procedure TFormGeomedit.BtndelfaceClick(Sender: TObject);
begin
  if (Grid.Row > 0) then
   begin
        Surfacc;
        Delsurf(Grid.Row - 1);
        Fillnuclgrid;
        DecGridCol;
        Fillmodtable;

        if Grid.RowCount < 2 then Btndelface.Enabled := False;

   end;
end;

procedure TFormGeomedit.btndelgeomClick(Sender: TObject);
begin
   //
end;


procedure TFormGeomedit.btnexgeomClick(Sender: TObject);
begin
  BtnmodClick(Sender);
end;

procedure TFormGeomedit.btnICClick(Sender: TObject);
begin
  dlgOpen.Options := [ofFileMustExist];
  dlgOpen.Filter := 'cst-files|*.cst|All files|*.*';
  dlgOpen.FilterIndex := 1;
  dlgOpen.InitialDir := gPath;
  dlgOpen.Title := 'Open the Consyst input file';

end;

procedure TFormGeomedit.btnIGClick(Sender: TObject);
begin
  dlgOpen.Options := [ofFileMustExist];
  dlgOpen.Filter := 'inp-files|*.inp|All files|*.*';
  dlgOpen.FilterIndex := 1;
  dlgOpen.InitialDir := gPath;
  dlgOpen.Title := 'Open the Getera input file';
  dlgSelect.InitialDir := gPath;
  dlgSelect.Title := 'Point out on bin directory with mtr files';
end;

procedure TFormGeomedit.BtnloadClick(Sender: TObject);
begin

end;


procedure TFormGeomedit.BtnmodClick(Sender: TObject);
begin
if (GeometryTree.Selected <> nil) then
  if ((GeometryTree.Selected.Level = 1) and (GeometryTree.Selected.Data <> nil)) then
     begin
       Excludegeometry(GeometryTree.Selected.Data);
       Clearmodform;
       //unitqueue.FormQueue.FullRefreshQueue;
       Editing_geometry.ClearListbyNone;
       //Filltree;
        UpdateExpanded(GeometryTree.Selected.Parent);

     end;
end;

procedure TFormGeomedit.btnQueClick(Sender: TObject);
begin
   SendChanges;
end;

procedure TFormGeomedit.BtnSaveClick(Sender: TObject);
begin
  dlgSave.Filter := 'txt-files|*.txt|All files|*.*';
  dlgSave.FilterIndex := 1;
  dlgSave.InitialDir := gPath;
  dlgSave.Title := 'Save the CONSYST input file';
end;

procedure TFormGeomedit.btnunwrapClick(Sender: TObject);
begin

end;

procedure TFormGeomedit.btnwrapClick(Sender: TObject);
begin

end;


procedure TFormGeomedit.DBGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (ssShift in Shift) and (Key = VK_LEFT) then BtnAddnuclClick(Sender);
end;

procedure TFormGeomedit.DBLookupListBox1Click(Sender: TObject);
begin
  QuerySurf.Locate('ID',DBLookupListBox1.KeyValue,[]);
end;


procedure TFormGeomedit.EditdescKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  current_geometry.ChangeStatus(Modified);
end;

 // class TFormGeomedit
 procedure TFormGeomedit.Delsurf(number : Integer);                              // Delete nuclid from form
 begin
   try
     current_geometry.Faces[nuclgrid.Values[number]].ChangeStatus(Deleted);
     nuclgrid.Delete(number);
     current_geometry.ClearsurfbyNone;
    except on e : Exception do
            begin{e - новый дескриптор ошибки}
             MessageDlg(e.message,mtError,[mbOK],0);
             Exit;
            end;
   end;
 end;
  // class TFormGeomedit
  procedure TFormGeomedit.Inssurf(ind: INteger;Const typ : Integer);                                // Insert nuclid to form
  begin
    try
    current_geometry.AddSurf(GetGSurfbyIndex(ind));
    current_geometry.Faces[current_geometry.NumSurf - 1].ChangeStatus(Inserted);
    current_geometry.Faces[current_geometry.NumSurf - 1].RTYPE := typ;
    current_geometry.Faces[current_geometry.NumSurf - 1].IDp := GetBeforeAddSurf;
    except on e : Exception do
            begin{e - новый дескриптор ошибки}
             MessageDlg(e.message,mtError,[mbOK],0);
             Exit;
            end;
   end;
  end;

 // Procedures of class TFormGeomedit
 function TFormGeomedit.Fillclassinfo(id : Integer): Boolean;                    // Fill the entity of a class
 var
  pGeom : PTGeometry;
begin

    Result := False;
    try
       pGeom := Fillgeometryinfo(id);
       if (pGeom <> nil) then
         begin
              current_geometry := pGeom^;
              current_geometry.ChangeStatus(Selected);
              Editing_geometry.Append(pGeom^);
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
  // Procedures of class TFormGeomedit
 procedure TFormGeomedit.Refreshgeom(id : Integer;const newStatus : TInStatus);   // Refresh form status
 begin
     if Fillclassinfo(id) then
     begin
     //
     //Editing_geometry.Append(current_geometry);
     //
     current_geometry.ChangeStatus(newStatus);
    if (newStatus <> Deleted) then
    begin
     Fillnuclgrid;
     //;
     Fillmodform;
     Refreshsurfdb;
    end;
     Filltree;
     end;
 end;
// class TFormGeomedit
 procedure TFormGeomedit.Fillnuclgrid;
 var
    i : Integer;
 begin
     nuclGrid.Clear;
     for i:=0 to current_geometry.NumSurf - 1 do
        if (current_geometry.Faces[i].Status <> Deleted) and
        (current_geometry.Faces[i].Status <> None) then
         nuclGrid.Append(i);
 end;
  //  class TFormGeomedit
 procedure TFormGeomedit.Refreshgeom(geometry : Pointer);                         // Refresh form status
 var
    pGeom : PTGeometry;
 begin
    pGeom := geometry;
    if (pGeom <> nil) then
    begin
    if (pGeom^.Status = None) then
     Fillclassinfo(pGeom^.id)
    else
     current_geometry := pGeom^;
    if (current_geometry.Status <> Deleted) then
    begin
       Fillnuclgrid;
       //DecGridCol;
       Fillmodform;
       Refreshsurfdb;
    end;

    end;

    Filltree;
 end;
 //  class TFormGeomedit
  procedure TFormGeomedit.geometryacc;                                           // Accept all changes in geometry form
  begin
     //
      current_geometry.Name := Editname.Text;
      current_geometry.Description := Editdesc.Text;
  end;
  //  class TFormGeomedit
  procedure TFormGeomedit.Surfacc;                                                // Accept all changes in nuclgrid
  var
     i,j : Integer;
  begin
     for i:=0 to nuclGrid.Len - 1 do
      if (current_geometry.Faces[nuclGrid.Values[i]].Status <> Selected) then
       with current_geometry do
       begin

            for j := 0 to Faces[nuclGrid.Values[i]].Numberdim - 1 do
            try
                Faces[nuclGrid.Values[i]].Dimension[j] := Strtofloat(Grid.Cells[2*j + 3,i + 1]);
            except
                  Grid.Cells[2*j + 3,i + 1] := '0.0';
            end;
         end;
  end;
  //  class TFormGeomedit
   procedure TFormGeomedit.BeforeAddgeom;                                         // Reset a generator
   begin
      if (QTables[4].GetGeneratorValue < 0 ) then
         QTables[4].ActuateGen(ExecGenerator(4));
      QTables[4].IncGenerator;
   end;
   //
   function TFormGeomedit.GetBeforeAddsurf:Integer;                             // Reset a surface generator
   begin
      if (QTables[5].GetGeneratorValue < 0 ) then
         QTables[5].ActuateGen(ExecGenerator(5));
      QTables[5].IncGenerator;
      Result := Qtables[5].GetGeneratorValue();
   end;
    //  class TFormGeomedit
  procedure  TFormGeomedit.Newgeometry;                                         // Create inserted geometry
  var
     pGeom :PTGeometry;
  begin
     New(pGeom);
     pGeom^ := TGeometry.Create(Qtables[4].GetGeneratorValue(),
     'geometry_' + Inttostr(Qtables[4].GetGeneratorValue()));
     pGeom^.ChangeStatus(Inserted);
     Editing_geometry.Add(pGeom);
  end;

  //  class TFormGeomedit
  procedure TFormGeomedit.Deletegeometry(geometry : Pointer);                    // Change geometry status on deleted
  var
     pGeom :PTGeometry;
  begin
     pGeom := geometry;
     pGeom^.ChangeStatus(Deleted);
     UpdateFacestatus(geometry,None);
  end;
  //  class TFormGeomedit
  procedure TFormGeomedit.Excludegeometry(geometry : Pointer);                   // Delete a geometry reference from list
  var
     pGeom :PTGeometry;
  begin
     pGeom := geometry;
     pGeom^.ChangeStatus(None);
     UpdateFacestatus(geometry,None);
  end;
  //  class TFormGeomedit
  procedure TFormGeomedit.UpdateFacestatus (geometry : Pointer;newStatus: TInstatus);// Update Faces status
  var
     pGeom :PTGeometry;
     iSurf : Integer;
  begin
     pGeom := geometry;
     for iSurf := 0 to pGeom^.NumSurf - 1 do
     begin
          pGeom^.Faces[iSurf].ChangeStatus(newStatus);
     end;
  end;

  //  class TFormGeomedit
      procedure TFormGeomedit.MakePattern;                                       // pattern for geometry
      begin
           if pattern_geometry = nil then
              pattern_geometry := TGeometry.Create('pattern');
           pattern_geometry.Copy(current_geometry);

      end;

  //  class TFormGeomedit
    procedure TFormGeomedit.ByPattern;                                           // Fill the form by pattern of geometry
    var
       i : Integer;
    begin
       if pattern_geometry <> nil then
          current_geometry.Copy(pattern_geometry);
       //For geometry only instance//
        for i := 0 to current_geometry.NumSurf - 1 do
            current_geometry.Faces[i].IDp := GetBeforeAddsurf;

       //For geometry only instance//
    end;

  //  class TFormGeomedit
  procedure TFormGeomedit.Writegeomtoqueue(P:Pointer);                            // Write changes from geometry class to queue changes
  var
     pGeom : PTGeometry;
     i : Integer;
     iBind : Integer;
  begin
     pGeom := nil;
     iBind := -1;
     pGeom := P;
     if (pGeom^.Status <> Selected) and (pGeom^.Status <> None) then Queue.FormChangetext(4,pGeom^.Getproperties,-1,pGeom^);
     for i := 0 to pGeom^.NumSurf - 1 do
         if (pGeom^.Faces[i].Status <> Selected) and (pGeom^.Faces[i].Status <> None) then
           if (pGeom^.Status = Inserted) then
              Queue.FormChangetext(5,pGeom^.GetSurfaceproperties(i),pGeom^,pGeom^.Faces[i])
           else
              Queue.FormChangetext(5,pGeom^.GetSurfaceproperties(i),iBind,pGeom^.Faces[i]);
  end;
  // class TFormGeomedit
  procedure TFormGeomedit.SendChanges();                                         // Execute the query with changed instance
  var
     pGeom : PTGeometry;
     pSurf : PTGSurf;
     ExportList : TInstList;
     i,j : Integer;
  begin
     ExportList := TInstList.Create;
     pGeom := nil;
     pSurf := nil;
     for i := 0 to Editing_geometry.Len - 1 do
         begin
          pGeom := Editing_geometry.Items[i];
          if ((pGeom^.Status <> None) and (pGeom^.Status <> Selected) and pGeom^.GetQueord()) then ExportList.Add(pGeom);
          for j := 0 to pGeom^.NumSurf - 1 do
              begin
                New(pSurf);
                pSurf^ := pGeom^.Faces[j];
                if ((pSurf^.Status <> None) and (pSurf^.Status <> Selected) and pSurf^.GetQueord()) then ExportList.Add(pSurf);
              end;
         end;
       FormHeader.ExecuteExported(ExportList);
  end;

  //  class TFormGeomedit
   procedure TFormGeomedit.Filltree;                                              // Fill tree by nodes
   var
      selected_node : TTreeNode;
   begin
      if (Editing_geometry.Count > 0)  then
       if (GeometryTree.Items.Count < 1) then
         //UpdateExpanded(GeometryTree.Items.AddChild(nil,'Editing geometrys'))
        GeometryTree.Items.AddChild(nil,'Editing geometrys')
       else
         if (GeometryTree.Items[0].Expanded) then
          begin
               UpdateExpanded(GeometryTree.Items[0]);
               if (current_geometry <> nil) and (current_geometry.Status <> None) then
                begin
                     selected_node := GeometryTree.Items[0].FindNode(current_geometry.Name);
                   if (selected_node <> nil) then selected_node.Selected := True;
                end;
          end;
   end;

   //  class TFormGeomedit
    procedure TFormGeomedit.UpdateExpanded(Node : TTreeNode);                    // Update data for expanded nodes
    var
       i : Integer;
    begin
              case Node.Level of
                   0 :  UpGeomnode(Node);
                   1 :  UpSurfnode(Node);
              end;
              for i := 0 to Node.Count - 1 do
                  if (Node.Items[i].Expanded) then  UpdateExpanded(Node.Items[i]);
    end;

    //  class TFormGeomedit
    procedure TFormGeomedit.UpGeomnode(Node : TTreeNode);                         // Update data for geometry
    var
       i: Integer;
       pGeom : PTGeometry;
       Child : TTreeNode;
       pt : Pointer;
    begin

       GeometryTree.BeginUpdate;
       try
             i := 0;
             for i:=Node.Count - 1 downto 0 do
                 begin
                   pt := Node.Items[i].Data;

                   if (pt <> nil) then
                    begin
                   pGeom := pt;
                   // Change name
                   if (Node.Items[i].Text <> pGeom^.Name) then
                    begin
                         //Node.EditText := True;
                         Node.Items[i].Text := pGeom^.Name;
                         //Node.EditText := False;
                    end;
                   case pGeom^.Status of
                        //Deleted : Node.Items[i].Delete;
                        None : Node.Items[i].Delete;
                        Selected : Node.Items[i].ImageIndex:=-1;
                        Modified : Node.Items[i].ImageIndex:=3;
                        Deleted : Node.Items[i].ImageIndex:=0;
                        Inserted : Node.Items[i].ImageIndex:=4;
                   end;

                 end;

                 end;
             for i:=Node.Count to Editing_geometry.Count - 1 do
                 begin
                 pGeom := Editing_geometry.Items[i];
                 if (pGeom^.Status <> None) then
                 begin
                    //pt := Editing_geometry.GetAddr(i);
                    //pGeom := pt;// GetGeombyInstance(Editing_geometry.Values[i]);
                    Child := GeometryTree.Items.AddChildObject(Node,pGeom^.Name,Editing_geometry.Items[i]);
                 end;

                 end;

       except
          ShowMessage('Strange message');
       end;

       GeometryTree.EndUpdate;

    end;

    //  class TFormGeomedit
   procedure TFormGeomedit.UpSurfnode(Node : TTreeNode);                        // Update data for nculids
    var
       i: Integer;
       pGeom : PTGeometry;
       pSurf : PTGSurf;
       Child : TTreeNode;
    begin
       GeometryTree.BeginUpdate;
       try
       pGeom := Node.Data;
        i := 0;
        if (pGeom <> nil) then
        begin
            for i:=Node.Count - 1 downto 0 do
                 begin
                   pSurf := Node.Items[i].Data;
                   if (pSurf <> nil) then
                   begin
                   // Change name
                   if (Node.Items[i].Text <> pSurf^.Name) then
                    begin
                         //Node.EditText := True;
                         Node.Items[i].Text := pSurf^.Name;
                         //Node.EditText := False;
                    end;
                   case pSurf^.Status of
                        //Deleted : Node.Items[i].Delete;
                        None : Node.Items[i].Delete;
                        Selected : Node.Items[i].ImageIndex:=-1;
                        Modified : Node.Items[i].ImageIndex:=3;
                        Deleted : Node.Items[i].ImageIndex:=0;
                        Inserted : Node.Items[i].ImageIndex:=4;
                   end;

                   end;

                 end;
             for i := Node.Count to pGeom^.NumSurf - 1 do
                 if (pGeom^.Status <> None) then
                 begin
                    New(pSurf);
                    pSurf^ :=  pGeom^.Faces[i];
                    if (pSurf^.Status <> None) then Child := GeometryTree.Items.AddChildObject(Node,pGeom^.Faces[i].Name, pSurf);
                 end;
        end;


       except
          ShowMessage('Strange message');
       end;


       GeometryTree.EndUpdate;
    end;
      function  TFormGeomedit.GetGeombyInstance(inst : TInstanceConstr) : PTGeometry; //
      var
         p: Pointer;
         pGeom: PTGeometry;
      begin
         pGeom := @inst;
         Result := pGeom;
      end;
    //  class TFormGeomedit
    procedure TFormGeomedit.OnInsert;                                            // Execute insertion chain
    begin
      BeforeAddgeom;
      Newgeometry;
      Refreshgeom(Editing_geometry.Items[Editing_geometry.Count - 1]);
    end;

    //  class TFormGeomedit
    procedure TFormGeomedit.OnAccept(geometry : Pointer);                        // Execute acception chain
    begin
      geometryacc;
      Surfacc;
      Writegeomtoqueue(geometry);
      FormHeader.FullRefreshQueue;
    end;

    //  class TFormGeomedit
    procedure TFormGeomedit.OnDelete(geometry : Pointer);                        // Execute removing chain
    begin
        Deletegeometry(geometry);
        Writegeomtoqueue(geometry);
        FormHeader.FullRefreshQueue;
        Clearmodform;
    end;

  //  class TFormGeomedit
  procedure TFormGeomedit.Refreshsurfdb;                                          // ReSelect Faces from database
  begin
           if (QuerySurf.Active=True) then QuerySurf.Close;
           QuerySurf.Prepare;

  try
         QuerySurf.Open;
         QuerySurf.Fetchall;
  except
    on
      E: Exception do
    begin
      TransactionSurf.Rollback;
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end;
  end;


end.

