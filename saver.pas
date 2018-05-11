unit saver;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Graphics, Dialogs, Menus,
  system_info,Controls,datamodule,service_bd,service,Grids,Header;

type

  { TFormstater }

  TFormstater = class(TForm)
    MainMenu1: TMainMenu;
    Itemload: TMenuItem;
    Itsave: TMenuItem;
    Grid: TStringGrid;
    Itmod: TMenuItem;
    Itnew: TMenuItem;
    Itdel: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure ItdelClick(Sender: TObject);
    procedure ItemloadClick(Sender: TObject);
    procedure ItnewClick(Sender: TObject);
    procedure ItsaveClick(Sender: TObject);
  private
    procedure ReadStates;                                                       // Read information about existing states
    procedure AddStatetoGrid(id: Integer);                                      // Add finded direcory properties to grid
    procedure NewState;                                                         // Create new state for save
    procedure DelState(id : Integer);                                           // Delete marked state
    procedure SaveState(id : Integer;desc : String);                            // Save state in current position
    procedure LoadState(id : Integer);                                          // Load state from current position
    { private declarations }
  public
    { public declarations }
  end;

var
  Formstater: TFormstater;

implementation
uses unit_db;
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

procedure TFormstater.ItemloadClick(Sender: TObject);
begin
 if (MessageDlg('Do you want to load a state',mtConfirmation,[mbYes,mbNo],0) =  mrYes) then
     if (Grid.Row > 0) then self.LoadState(Grid.Row);
  Header.FormHeader.Writelog('State with a number' + INttostr(VI._vid) + ' been loaded');
  unit_db.DBmod.RefreshallWindow;
end;

procedure TFormstater.ItdelClick(Sender: TObject);
begin
  Header.FormHeader.Writelog('Delete State number ' + Inttostr(Grid.Row));
  if (MessageDlg('Do you want to delete state',mtConfirmation,[mbYes,mbNo],0) =  mrYes) then
     self.DelState(Grid.Row);
  if Grid.RowCount < 2 then
  begin
       Itdel.Enabled := False;
       Itmod.Enabled := False;
  end;
end;

procedure TFormstater.FormCreate(Sender: TObject);
begin
  ReadStates;
end;

procedure TFormstater.ItnewClick(Sender: TObject);
begin
  Header.FormHeader.Writelog('Create new state');
  NewState;
  if Grid.RowCount > 1 then
  begin
     Itdel.Enabled := True;
     Itmod.Enabled := True;
  end;
end;

procedure TFormstater.ItsaveClick(Sender: TObject);
begin
  if (MessageDlg('Do you want to save state',mtConfirmation,[mbYes,mbNo],0) =  mrYes) then
     if (Grid.Row > 0) then self.SaveState(Grid.Row,Grid.Cells[1,Grid.Row]);
  Header.FormHeader.Writelog('State with number' + INttostr(VI._vid) + ' been saved');
end;

//class TFormstater
procedure TFormstater.ReadStates;
var
  i: Integer;
  ids : array of Integer;
  description : array of String;
  searchResult : TSearchRec;

begin
  //
  // SetCurrentDir('..');
    Chdir(VI._vdir);
    Grid.RowCount := 1;
  if FindFirst('*', faDirectory, searchResult) = 0 then
  begin
    repeat
      //
      if (searchResult.attr and faDirectory) = faDirectory then
      begin
          try
           if (searchResult.Name <> '.') and (searchResult.Name <> '..') then AddStatetoGrid(Strtoint(searchResult.Name));
          except on E: Exception do
                 FormHeader.Writelog(E.Message);
          end;
      end;
    until FindNext(searchResult) <> 0;

    //
    FindClose(searchResult);
    Chdir(gpath);
  end;
  if Grid.RowCount > 1 then
  begin
     Itdel.Enabled := True;
     Itmod.Enabled := True;
  end
  else
  begin
       Itdel.Enabled := False;
       Itmod.Enabled := False;
  end;
end;
//class TFormstater
procedure TFormstater.AddStatetoGrid(id: Integer);
var
  f : TextFile;
  s : String;
  fileDate : Integer;
  begin
    Grid.RowCount := Grid.RowCount + 1;
    Grid.Cells[0,Grid.RowCount - 1] := Inttostr(id);
    if FileExists(VI._vdir + Inttostr(id) + '\' + 'CONSTRUCTOR.fbk') then
    begin
      if FileExists(VI._vdir + Inttostr(id) + '\' + '.desc') then
      begin
           Assignfile(f,VI._vdir + Inttostr(id) + '\' + '.desc');
           Reset(f);
           Readln(f,s);
           //VI._vdesc := s;

           Grid.Cells[1,Grid.RowCount - 1] := s;
           fileDate := FileAge(VI._vdir + Inttostr(id) + '\' + 'CONSTRUCTOR.fbk');
           Grid.Cells[2,Grid.RowCount - 1] := DateToStr(FileDateToDateTime(fileDate));
           Grid.Cells[3,Grid.RowCount - 1] := TimeToStr(FileDateToDateTime(fileDate));
           CLoseFile(f);
      end;


    //DateToStr(FileDateToDateTime(fileDate));
    end
       else
           //raise Exception.Create('backup file not found');
           Grid.Cells[1,Grid.RowCount - 1] := '';




  end;
//class TFormstater
procedure TFormstater.NewState;                                               // Create new state for save
begin
  if CreateDir(VI._vdir + Inttostr(Grid.RowCount)) then
  begin
    Grid.RowCount := Grid.RowCount + 1;
    Grid.Cells[0,Grid.RowCount - 1] := Inttostr(Grid.RowCount - 1);
  end;

end;
//class TFormstater
procedure TFormstater.DelState(id : Integer);                                 // Delete marked state
begin
   if ( id <= Grid.RowCount) then
    if DeleteFile(VI._vdir + Inttostr(id) + '\' + 'CONSTRUCTOR.fbk') then
       if DeleteFile(VI._vdir + Inttostr(id) + '\' + '.desc') then
         if (id = Grid.RowCount - 1) then
         begin
            Grid.RowCount:= Grid.RowCount - 1;
            Removedir(VI._vdir + Inttostr(id));
       end;

end;
//class TFormstater
procedure TFormstater.SaveState(id : Integer;desc : String);                                 // Delete marked state
var
  f : TextFile;

begin
   Assignfile(f,VI._vdir + Inttostr(id) + '\' + '.desc');
   Rewrite(f);

   // backup
   if Writebackupinfo(desc) then
   begin
      DM.Getbackup();
      Sleep(100);
//       FileCopy(bPath,VI._vdir + Inttostr(id) + '\' + 'CONSTRUCTOR.fbk');
       if CopyFile(bPath,VI._vdir + Inttostr(id) + '\' + 'CONSTRUCTOR.fbk',false) then
      //attrs := FileGetAttr(bPath);

         Writeln(f,desc);

   end;
   CloseFile(f);
   VI._vid := id;
   DM.Write_ini;
end;
//class TFormstater
procedure TFormstater.LoadState(id : Integer);                                          // Load state from current position
begin
   if not WS._db_wexec then
   if CopyFile(VI._vdir + Inttostr(id) + '\' + 'CONSTRUCTOR.fbk',bPath,false) then
   begin
      DM.Getrestore();
      VI._vid := id;
      VI._vnumber := Getversioninfo();
      DM.Write_ini;
   end;
end;

end.

