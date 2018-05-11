unit Header;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
  Forms, StdCtrls, DBGrids, Classes, Windows, SysUtils, FileUtil, system_info,
  qtable_class, thread_process, unit_classes, instance_class, service_bd,
  IBQuery, IBCustomDataSet, IBDatabase, IBDynamicGrid, db, Dialogs, ComCtrls,
  Menus, Grids, Controls, ExtCtrls, DbCtrls, ComboEx;

type

  { TFormHeader }

  TFormHeader = class(TForm)
    BtnDel: TToolButton;
    btnElementEdit: TToolButton;
    btnmod: TToolButton;
    btnGopen: TToolButton;
    BtnMulti: TToolButton;
    btnopen: TToolButton;
    btnopen1: TToolButton;
    btnfreshelmnt: TToolButton;
    BtnRead: TToolButton;
    BtnRefresh: TToolButton;
    BtnSave: TToolButton;
    ComboType: TComboBoxEx;
    DataSourceElmnt: TDataSource;
    DataSourceMat: TDataSource;
    DataSourceGeom: TDataSource;
    DBLookupGeom: TDBLookupComboBox;
    DBLookupMat: TDBLookupComboBox;
    dlgOpen: TOpenDialog;
    dlgSave: TSaveDialog;
    Grid: TStringGrid;
    Gridmat: TIBDynamicGrid;
    IBDynamicGrid1: TIBDynamicGrid;
    IBDynamicGridelmnt: TIBDynamicGrid;
    ImageList1: TImageList;
    Itdel: TMenuItem;
    Itemload: TMenuItem;
    Itmod: TMenuItem;
    Itnew: TMenuItem;
    Itsave: TMenuItem;
    List: TListBox;
    MainMenu1: TMainMenu;
    Memo1: TMemo;
    mi1: TMenuItem;
    PageControl1: TPageControl;
    PageControl2: TPageControl;
    Panel1: TPanel;
    Panel2: TPanel;
    QueryElmnt: TIBQuery;
    QueryElmntDATETIME: TDateTimeField;
    QueryElmntDESCRIPTION: TIBStringField;
    QueryElmntETYPE: TIntegerField;
    QueryElmntID: TIntegerField;
    QueryElmntNAME: TIBStringField;
    QueryElmntUSERNAME: TIBStringField;
    QueryGeomAREA: TFloatField;
    QueryGeomDATETIME: TDateTimeField;
    QueryGeomDESCRIPTION: TIBStringField;
    QueryGeomID: TIntegerField;
    QueryGeomNAME: TIBStringField;
    QueryGeomUSERNAME: TIBStringField;
    QueryMat: TIBQuery;
    QueryGeom: TIBQuery;
    QueryMatDATETIME: TDateTimeField;
    QueryMatDENSITY: TFloatField;
    QueryMatDESCRIPTION: TIBStringField;
    QueryMatID: TIntegerField;
    QueryMatMASSA: TFloatField;
    QueryMatNAME: TIBStringField;
    QueryMatTEMPERATURE: TFloatField;
    QueryMatUSERNAME: TIBStringField;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    TabSheet6: TTabSheet;
    TabSheet7: TTabSheet;
    ToolBar: TToolBar;
    ToolBar1: TToolBar;
    ToolBar2: TToolBar;
    ToolBar3: TToolBar;
    ToolButton1: TToolButton;
    TransactionElmnt: TIBTransaction;
    TransactionMat: TIBTransaction;
    TransactionGeom: TIBTransaction;
    procedure BtnDelClick(Sender: TObject);
    procedure btnElementEditClick(Sender: TObject);
    procedure btnGopenClick(Sender: TObject);
    procedure btnmodClick(Sender: TObject);
    procedure BtnMultiClick(Sender: TObject);
    procedure btnopenClick(Sender: TObject);
    procedure BtnReadClick(Sender: TObject);
    procedure BtnRefreshClick(Sender: TObject);
    procedure BtnSaveClick(Sender: TObject);
    procedure ComboTypeSelect(Sender: TObject);
    procedure DBLookupGeomSelect(Sender: TObject);
    procedure DBLookupMatSelect(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure ItdelClick(Sender: TObject);
    procedure ItemloadClick(Sender: TObject);
    procedure ItnewClick(Sender: TObject);
    procedure ItsaveClick(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure PageControl2Change(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
  private
    // Window Saver Section
    procedure ReadStates;                                                       // Read information about existing states
    procedure AddStatetoGrid(id: Integer);                                      // Add finded direcory properties to grid
    procedure NewState;                                                         // Create new state for save
    procedure DelState(id : Integer);                                           // Delete marked state
    procedure SaveState(id : Integer;desc : String);                            // Save state in current position
    procedure LoadState(id : Integer);                                          // Load state from current position
    //
    // From MTtable
    procedure Clearall;                                                         // All components are disabled
    //
    { Private declarations }
  public
    procedure Writelog(text: String);
    procedure RefreshallWindow;                                                 // Update all active windows with data
    // From MTtable
    procedure RefreshMatTable;                                                  // Refresh material table
    procedure Editmaterial(id : Integer);                                       // Call material editor
    procedure RefreshMTForm(Const ClearEditform : Boolean);                     // Refresh form Material table
    //
    // From GeomTable
    procedure RefreshGeomTable;                                                 // Refresh geometry table
    procedure Editgeometry(id : Integer);                                       // Call editing geometry form
    procedure RefreshGTForm(Const ClearEditform : Boolean);                     // Refresh form Geometry table
    //
    // From ElmntTable
    procedure RefreshElmntTable(Const indtype : Integer);                             // Refresh element table
    procedure EditElement(id : Integer);                                        // Call editing element form
    procedure RefreshETForm(Const ClearEditform : Boolean);                     // Refresh form element table
    procedure EditSubassembly(id : Integer);                                    // Call editing subassembly form
    procedure RefreshSABTForm(Const ClearEditform : Boolean);                   // Refresh form subassembly table
    // From TQUEUE
    procedure FullRefreshQueue;                                                 // Reopen a list of queue records in according to main queue
    function ReadlogFile(filename: String) : Boolean;                           // Read a text file
    function WritelogFile(filename: String) : Boolean;                          // Write to a text file
    //
    procedure RefreshactTable(index : Integer);                                 // Refresh actual window with db Table
    procedure ExecuteExported(ExportedList : TinstList);                        // Execute only exported instatnce
    procedure ClearQueuebyNumber(var numbers : array of Integer);                   // Clear List by pointed numbers
    //procedure ClearQueuebyNumber(number : Pointer);                   // Clear List by pointed numbers
    procedure ExecuteQueue(lq : TQueue);                                        // Execute local queue records
    { Public declarations }
  end;

var
  FormHeader: TFormHeader;
  myNuclids: TList;
  Nuclid: TNuclid;

implementation
 uses
 DataModule,Material_editor,geometry_editor,element_editor,subassembly_editor;

{$R *.lfm}
 procedure FileCopy(const SourceFileName, TargetFileName: string);
 var
   S, T : TFileStream;
 begin
   S := TFileStream.Create(sourcefilename, fmShareDenyWrite );
   try
     T := TFileStream.Create(targetfilename, fmOpenWrite or fmCreate);
     try
       T.CopyFrom(S, S.Size ) ;
       FileSetDate(T.Handle, FileGetDate(S.Handle));
     finally
       T.Free;
     end;
   finally
     S.Free;
   end;
 end;

procedure TFormHeader.FormActivate(Sender: TObject);
begin
  AlphaBlendValue := 255;
end;

procedure TFormHeader.Writelog(Text: String);
var
DateTime : TDateTime;
S: String;
begin
  S:='';
  DateTime := Now;
  S:=S+_user_name;
  S:=S+' ';
  S:=S+DatetoStr(DateTime);
  S:=S+' ';
  S:=S+TimeToStr(DateTime);
  S:=S+' '+Text;
  Memo1.Lines.Append(S);
end;

procedure TFormHeader.FormCreate(Sender: TObject);

begin
   // From saver
   //ReadStates;
   // From QUEUE
   List.Items.Clear;
  _threads := TList.Create;
end;

procedure TFormHeader.FormResize(Sender: TObject);
var
 i,curwidtch,adwidtch,sum:Integer;
begin
  if (pagecontrol1.ActivePageIndex = 1) then
    begin
  curwidtch:=Trunc(Grid.Width/Grid.ColCount);
  adwidtch:=Grid.Width-curwidtch*Grid.ColCount;
  for i := 0 to Grid.ColCount-2 do
         Grid.ColWidths[i]:=curwidtch;
  Grid.ColWidths[Grid.ColCount - 1]:=curwidtch+adwidtch;

    end;
  if (pagecontrol1.ActivePageIndex = 3) then
    begin
    sum:=0;
    for i := 1 to Gridmat.Columns.Count-1 do
    sum:=sum+Gridmat.Columns[i-1].Width;
    Gridmat.Columns[Gridmat.Columns.Count-1].Width:=Gridmat.Width-sum;


end;

end;

procedure TFormHeader.ItdelClick(Sender: TObject);
begin
  Writelog('Delete State number ' + Inttostr(Grid.Row));
  if (MessageDlg('Do you want to delete state',mtConfirmation,[mbYes,mbNo],0) =  mrYes) then
     self.DelState(Grid.Row);
  if Grid.RowCount < 2 then
  begin
       Itdel.Enabled := False;
       Itmod.Enabled := False;
  end;
end;

procedure TFormHeader.ItemloadClick(Sender: TObject);
begin
  if (MessageDlg('Do you want to load a state',mtConfirmation,[mbYes,mbNo],0) =  mrYes) then
     if (Grid.Row > 0) then self.LoadState(Grid.Row);
  Writelog('State with a number' + INttostr(VI._vid) + ' been loaded');
  RefreshallWindow;
end;

procedure TFormHeader.ItnewClick(Sender: TObject);
begin
  Writelog('Create new state');
  NewState;
  if Grid.RowCount > 1 then
  begin
     Itdel.Enabled := True;
     Itmod.Enabled := True;
  end;
end;

procedure TFormHeader.ItsaveClick(Sender: TObject);
begin
   if (MessageDlg('Do you want to save state',mtConfirmation,[mbYes,mbNo],0) =  mrYes) then
     if (Grid.Row > 0) then self.SaveState(Grid.Row,Grid.Cells[1,Grid.Row]);
        Writelog('State with number' + INttostr(VI._vid) + ' been saved');
end;

procedure TFormHeader.PageControl1Change(Sender: TObject);
begin

   if PageControl1.ActivePageIndex = 1 then
   begin
     mi1.Enabled := True;
     ReadStates;
   end
  else
     mi1.Enabled := False;
   if PageControl1.ActivePageIndex = 3 then
     RefreshactTable(pagecontrol2.ActivePageIndex);

end;

procedure TFormHeader.PageControl2Change(Sender: TObject);
begin
  Refreshacttable(pagecontrol2.ActivePageIndex);
end;

procedure TFormHeader.ToolButton1Click(Sender: TObject);
begin
   if not (Assigned(FormSubedit)) then
    FormSubedit := TFormSubedit.Create(FormHeader);
    FormSubedit.Show;
    EditSubassembly(QueryElmnt.FieldByName('ID').AsInteger);
    WS._o_sub := True;
end;

procedure TFormHeader.RefreshallWindow;                                         // Update all active windows with data
begin
  if (WS._o_material) then RefreshMTForm(True);
  if (WS._o_geometry) then RefreshGTForm(True);
  if (WS._o_element) then RefreshETForm(True);
  if (WS._o_sub) then RefreshSABTForm(True);
end;

procedure TFormHeader.FormDeactivate(Sender: TObject);
begin
  AlphaBlendValue := 100;
end;

procedure TFormHeader.btnmodClick(Sender: TObject);
begin
   if not (Assigned(FormMatedit)) then
    FormMatedit := TFormMatedit.Create(FormHeader);
    FormMatedit.Show;
    EditMaterial(QueryMat.FieldByName('ID').AsInteger);
    WS._o_material := True;
end;

procedure TFormHeader.BtnDelClick(Sender: TObject);
begin
   if List.ItemIndex > -1 then
     begin
          Queue.Delete(List.ItemIndex);
     end;
  FullRefreshQueue;
end;

procedure TFormHeader.btnElementEditClick(Sender: TObject);
begin
  if not (Assigned(FormElemedit)) then
    FormElemedit := TFormElemedit.Create(FormHeader);
    FormElemedit.Show;
    Editelement(QueryElmnt.FieldByName('ID').AsInteger);
    WS._o_element := True;
end;

procedure TFormHeader.btnGopenClick(Sender: TObject);
begin
  if not (Assigned(FormGeomedit)) then
    FormGeomedit := TFormGeomedit.Create(FormHeader);
    FormGeomedit.Show;
    Editgeometry(Querygeom.FieldByName('ID').AsInteger);
    WS._o_geometry := True;
end;

procedure TFormHeader.BtnMultiClick(Sender: TObject);
var
  l_material : Boolean;
  l_all : Boolean;
  pG :PTThreagG;
  S : String;
  DateTime : TDateTime;
begin
   FullRefreshQueue;
  l_material := Check_materialInst;
  l_all := (not l_material);
  if (l_all) and (DM.wReConnect(dbpath)) then
     begin
     try
       New(pG);
       _threads.Add(pG);
       pG^ := ThreadGenerator.Create(True);
       pG^.ReadQueue(Queue);
       pG^.FreeOnTerminate := True;
        S:= '';
       //S:=S+DatetoStr(DateTime);
       //S:=S+'_';
       //S:=S+TimeToStr(DateTime);
       if WritelogFile(VI._vdir + Inttostr(VI._vid) + '\log' + S +'.txt') then
          WS._db_wexec := True;
       pG^.Resume();

     except on E: Exception  do
        MessageDlg('Thread not load ' + e.message, mtError, [mbOK], 0);
     end;
     end;


     Queue.Clear;
     FullRefreshQueue;
     RefreshallWindow;
end;

procedure  TFormHeader.ExecuteQueue(lq : TQueue);                               // Execute local queue records
var
  pG :PTThreagG;
  S : String;
  DateTime : TDateTime;
begin
  if (DM.wReConnect(dbpath)) then
     begin
     try
       New(pG);
       _threads.Add(pG);
       pG^ := ThreadGenerator.Create(True);
       pG^.ReadQueue(lq);
       pG^.FreeOnTerminate := True;
       DateTime:=Now;
       S:= '';
       //S:=S+DatetoStr(DateTime);
       //S:=S+'_';
       //S:=S+TimeToStr(DateTime);
       if WritelogFile(VI._vdir + Inttostr(VI._vid) + '\log' + S +'.txt') then
          WS._db_wexec := True;
       pG^.Resume();

     except on E: Exception  do
        MessageDlg('Thread not load ' + e.message, mtError, [mbOK], 0);
     end;
     end;


end;

procedure TFormHeader.ExecuteExported(ExportedList : TinstList);                // Execute only exported instatnce
var
  pI : PTInstanceConstr;
  i,j : Integer;
  oarr : array of Integer;
  localQueue : TQueue;
begin
  oarr := nil;
  //SetLength(oarr, Length(oarr) + 1);
  //oarr[0] := 1;
  pi := nil;
  localQueue := TQueue.Create();
  for j := 0 to Queue.Len - 1 do
  for i := 0 to ExportedList.Len - 1 do
      begin
          pi :=  ExportedList.Items[i];
          if (pi^.GetQueord() and (Queue.GetInstance(j) = pi^)) then
            begin
                 SetLength(oarr, Length(oarr) + 1);
                 oarr[Length(oarr) - 1] := j;
                 localQueue.Append(Queue.Changes[j],-1);

                 Continue;
            end;
      end;
  ExecuteQueue(localQueue);
 // ExportedList := nil;

  ClearQueuebyNumber(oarr);
  FullRefreshQueue;
  RefreshallWindow;
end;

procedure TFormHeader.ClearQueuebyNumber(var numbers : array of Integer);           // Clear List by pointed numbers
var
  i : Integer;
  j : Integer;
begin
   for j := Queue.Len - 1 downto 0 do
   begin
       for i := low(numbers) to high(numbers) do
           if (numbers[i] <> -1) and (j = numbers[i]) then
             begin
               numbers[i] := -1;
               Queue.Delete(j);
             end;
   end;
   //FreeandNil(numbers);
end;

procedure TFormHeader.btnopenClick(Sender: TObject);
begin
     RefreshMTForm(False);
end;

procedure TFormHeader.BtnReadClick(Sender: TObject);
begin
  dlgOpen.Options := [ofFileMustExist];
  dlgOpen.Filter := 'txt-files|*.txt|All files|*.*';
  dlgOpen.FilterIndex := 1;
  dlgOpen.InitialDir := gPath;
  dlgOpen.Title := 'Open the log file';
  if (dlgOpen.Execute) then
    if not ReadlogFile(dlgOpen.FileName) then
      MessageDlg('Unsuccesfull opening a text file check the existing',mtError,[mbOK],0);
end;

procedure TFormHeader.BtnRefreshClick(Sender: TObject);
begin
  FullRefreshQueue;
end;

procedure TFormHeader.BtnSaveClick(Sender: TObject);
begin
  dlgSave.Filter := 'txt-files|*.txt|All files|*.*';
  dlgSave.FilterIndex := 1;
  dlgSave.InitialDir := gPath;
  dlgSave.Title := 'Save the log file';
  if (dlgSave.Execute) then
    if not WritelogFile(dlgSave.FileName) then
      MessageDlg('Unsuccesfull opening a text file check the existing',mtError,[mbOK],0);
end;


procedure TFormHeader.ComboTypeSelect(Sender: TObject);
begin
     RefreshElmntTable(ComboType.ItemIndex);
end;


procedure TFormHeader.DBLookupGeomSelect(Sender: TObject);
begin
  QueryGeom.Locate('ID',DBLookupGeom.KeyValue,[]);
end;



procedure TFormHeader.DBLookupMatSelect(Sender: TObject);
begin
  QueryMat.Locate('ID',DBLookupMat.KeyValue,[]);
end;

// TFormHeader
procedure TFormHeader.RefreshactTable(index : Integer);                         // Refresh actual window with db Table
begin
    case index of
         0: RefreshMTForm(False);
         1: RefreshGTForm(False);
         2: RefreshETForm(False);
    end;
end;
//
// From ElmntTable
   procedure TFormHeader.RefreshElmntTable(Const indtype : Integer);                  // Refresh element table
   var
     txt : String;
  begin
   if (Queryelmnt.Active=True) then Queryelmnt.Close;

      QueryElmnt.SQL.Clear;


   //   QueryElmnt.SQL.Text := 'Select A.ID, A.NAME, A.DESCRIPTION, A.USERNAME, A.DATETIME,A.NUMBERCOMPOSITION, A.ETYPE From ELEMENT A';
       QueryElmnt.SQL.Add('SELECT A.ID, A.NAME, A.DESCRIPTION, A.USERNAME, A.DATETIME,A.NUMBERCOMPOSITION, A.ETYPE');

          QueryElmnt.SQL.Add('From ELEMENT A');

          QueryElmnt.SQL.Add('WHERE A.ETYPE = :ETYPE');

          QueryElmnt.Prepare;

          QueryElmnt.ParamByName('ETYPE').AsInteger := 0;


          QueryElmnt.ParamByName('ETYPE').AsInteger := indtype;

          ComboType.ItemIndex:=indtype;

  try
         Queryelmnt.Open;
         Queryelmnt.Fetchall;
  except
    on
      E: Exception do
    begin
      Transactionelmnt.Rollback;
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end;
end;
   // From ElmntTable
   procedure TFormHeader.EditElement(id : Integer);                                        // Call editing element form
   var
  temp : TInstanceConstr;
  begin
  temp := nil;
  if (id > 0) then
    if Editing_element.IsIn([id]) then
       begin
            temp := Editing_element.SearchbyID([id]);
            FormElemedit.Refreshelem(@temp);
       end
    else
       FormElemedit.Refreshelem(id,Selected);
  end;
   // From ElmntTable
   procedure TFormHeader.RefreshETForm(Const ClearEditform : Boolean);                     // Refresh form element table
   var
  i : Integer;
  pElmnt : PTElement;
begin
   RefreshElmntTable(0);
   if QueryElmnt.RecordCount > 0 then
      begin
           ToolBar3.Enabled := True;
           Tabsheet7.Enabled := True;
      end
   else
       Clearall;
   if ClearEditform then
     if Assigned(FormElemedit) then
          begin

          for i := Editing_element.Len - 1 downto 0  do
              begin
                   pElmnt := Editing_element.Items[i];
                   if ((pElmnt^.Status = None) or not(pElmnt^.GetQueord())) then FormElemedit.Excludeelement(Editing_element.Items[i]);
              end;

          FormElemedit.UpdateExpanded(FormElemedit.ElementTree.Items[0]);
          FormElemedit.Clearmodform;
          Editing_element.ClearListbyNone;
          end;
end;

//
 // From ElmntTable
   procedure TFormHeader.EditSubassembly(id : Integer);                                    // Call editing subassembly form
   var
   temp : TInstanceConstr;
   begin
   temp := nil;
   if (id > 0) then
    if Editing_subassembly.IsIn([id]) then
       begin
            temp := Editing_subassembly.SearchbyID([id]);
            FormSubedit.Refreshassembly(@temp);
       end
    else
       FormSubedit.Refreshassembly(id,Selected);
  end;

 // From ElmntTable
   procedure TFormHeader.RefreshSABTForm(Const ClearEditform : Boolean);                   // Refresh form subassembly table
   var
   i : Integer;
   pElmnt : PTElement_list;
   begin
        RefreshElmntTable(0);
         if QueryElmnt.RecordCount > 0 then
      begin
           ToolBar3.Enabled := True;
           Tabsheet7.Enabled := True;
      end
   else
       Clearall;
   if ClearEditform then
     if Assigned(FormSubedit) then
          begin

          for i := Editing_subassembly.Len - 1 downto 0  do
              begin
                   pElmnt := Editing_subassembly.Items[i];
                   if ((pElmnt^.Status = None) or not(pElmnt^.GetQueord())) then FormSubedit.Excludesub(Editing_subassembly.Items[i]);
              end;

          FormSubedit.UpdateExpanded(FormSubedit.SubassTree.Items[0]);
          FormSubedit.Clearmodform;
          Editing_subassembly.ClearListbyNone;
          end;
   end;

//
// From geometry table
{$INCLUDE ..\Source\formgeomtable.inc}
// From window saver
{$INCLUDE ..\Source\formsaver.inc}
// From MTtable
{$INCLUDE ..\Source\formmattable.inc}
// FROM QUEUE
{$INCLUDE ..\Source\formqueue.inc}
end.
