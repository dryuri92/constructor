//class TFormstater
procedure TFormHeader.ReadStates;
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
                Writelog(E.Message);
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
procedure TFormHeader.AddStatetoGrid(id: Integer);
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
procedure TFormHeader.NewState;                                               // Create new state for save
begin
 if CreateDir(VI._vdir + Inttostr(Grid.RowCount)) then
 begin
   Grid.RowCount := Grid.RowCount + 1;
   Grid.Cells[0,Grid.RowCount - 1] := Inttostr(Grid.RowCount - 1);
 end;

end;
//class TFormstater
procedure TFormHeader.DelState(id : Integer);                                 // Delete marked state
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
procedure TFormHeader.SaveState(id : Integer;desc : String);                                 // Delete marked state
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
procedure TFormHeader.LoadState(id : Integer);                                          // Load state from current position
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

//
