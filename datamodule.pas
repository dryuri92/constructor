unit DataModule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, IBDatabase, IBQuery,IBSQL,system_info,thread_process,Header,IniFiles,ShellAPI,Windows,Dialogs,QTable_class;

type
      Tconnection=record           //Parametres of SQL database connection
       _user_name: String;
       _user_password: String;
       _sql_dialect: String;
       _lc_ctype: String;
      end;
type

  { TDM }

  TDM = class(TDataModule)
    rDatabase: TIBDatabase;//read only connection to database
    wDatabase: TIBDatabase;//write only connection to database
  private
    { private declarations }
  public
    function rReConnect(FileName: string) : Boolean;// Connection establish with  database
    function wReConnect(FileName: string) : Boolean;// Connection establish with  database
    procedure Read_ini;// Read the connection parametres from ini-file
    procedure Write_ini;// Write data base parametres to ini-file
    procedure Getrestore();// Fulfill a restore of stored backup file of a database
    procedure Getbackup(); // Create a reserve copy of a database
    function restorelog(nameoflog: String): Boolean; // Analysis of a restore.log file searching an errors returns True in case of success
     procedure AssignIBTransaction(var Query : TIBQuery; var Trans : TIBTransaction;const write_key: Boolean=False); overload;// Create a query-transaction link with IBQUERY entity
    procedure AssignIBTransaction(var Query : TIBSQL; var Trans : TIBTransaction;Const write_key: Boolean=False); overload;  // Create a query-transaction link with IBSQL entity
    procedure ExecSQL(var Query: TIBQuery;const SQLTText : string);                           // Execute a SQL statement
    procedure OpenSQL(var Query: TIBQuery; const SQLTText: string); overload;                 // Reopen a connection with IBQUERY entity
    procedure OpenSQL(var SQL: TIBSQL; const SQLTText: string);   overload;                   // Reopen a connection with IBSQL entity
    { Public declarations }
    { public declarations }
  end;

var
  DM: TDM;
  Connect:Tconnection;
implementation

{$R *.lfm}
{Work with ini-file}
// Read the connection parametres from ini-file
procedure  TDM.Read_ini;
var
  IniFile : TIniFile;
begin
   IniFile := TIniFile.Create(gPath+'/Data/'+INI_FILE);
      dbPath:=IniFile.ReadString('Common','dbpath','');
      VI._vid :=Strtoint(IniFile.ReadString('Common','current_number',''));
      bPath:=IniFile.ReadString('Backup','bckpname','');
      Connect._user_name:=IniFile.ReadString('Connect_info','username','');
      Connect._user_password:=IniFile.ReadString('Connect_info','password','');
      Connect._sql_dialect:=IniFile.ReadString('Connect_info','dialect','');
      Connect._lc_ctype:=IniFile.ReadString('Connect_info','lc_ctype','');
    IniFile.Free;
end;
// Write data base parametres to ini-file
procedure  TDM.Write_ini;
var
  IniFile : TIniFile;
begin
   IniFile := TIniFile.Create(gPath+'/Data/'+INI_FILE);
      IniFile.WriteString('Common','dbpath',dbPath);
      IniFile.WriteString('Common','current_number',Inttostr(VI._vid));
      IniFile.WriteString('Backup','bckpname',bPath);
      IniFile.WriteString('Connect_info','username',Connect._user_name);
      IniFile.WriteString('Connect_info','password',Connect._user_password);
      IniFile.WriteString('Connect_info','dialect',Connect._sql_dialect);
      IniFile.WriteString('Connect_info','lc_ctype',Connect._lc_ctype);
    IniFile.Free;
end;
{//}
{Connection functions}
// Connection establish with  database
function TDM.rReConnect(FileName: string) : Boolean;
begin
  Result := False;
  {if not FileExists(FileName) then
  begin
    Exit;
  end;}
  rDataBase.Close;
  try
    rDataBase.DatabaseName := FileName;
    rDataBase.SQLDialect:=Strtoint(Connect._sql_dialect);
    rDataBase.Params.Clear;
    rDataBase.Params.Append('user_name='+Connect._user_name);
    rDataBase.Params.Append('password='+Connect._user_password);
    rDataBase.Params.Append('lc_ctype='+Connect._lc_ctype);
    rDataBase.Connected := True;
  except
    Result := false;
    //WriteLog('Не удалось подключиться к базе: '+FileName);
    Exit;
  end;
  Result := True;
  //WriteLog('Подключена база данных: '+FileName);
end;
// Connection establish with  database
function TDM.wReConnect(FileName: string) : Boolean;
begin
  Result := False;
  {if not FileExists(FileName) then
  begin
    Exit;
  end;}
  wDataBase.Close;
  try
    wDataBase.DatabaseName := FileName;
    wDataBase.SQLDialect:=Strtoint(Connect._sql_dialect);
    wDataBase.Params.Clear;
    wDataBase.Params.Append('user_name='+Connect._user_name);
    wDataBase.Params.Append('password='+Connect._user_password);
    wDataBase.Params.Append('lc_ctype='+Connect._lc_ctype);
    wDataBase.Connected := True;
  except
    Result := false;
    //WriteLog('Не удалось подключиться к базе: '+FileName);
    Exit;
  end;
  Result := True;
  //WriteLog('Подключена база данных: '+FileName);
end;
{//}

{Transaction option}
// Create a query-transaction link with IBQUERY entity
 procedure TDM.AssignIBTransaction(var Query : TIBQuery; var Trans : TIBTransaction;Const write_key: Boolean=False);
begin
  Query := TIBQuery.Create(nil); Trans := TIBTransaction.Create(nil);
  if not (write_key) then
  begin
       Trans.DefaultDatabase := DM.rDataBase;
       Trans.Params.Add('read_committed');
       Trans.Params.Add('rec_version');
       Trans.Params.Add('nowait');
       Query.Database := DM.rDataBase;
  end
  else
      begin
        Trans.DefaultDatabase := DM.wDataBase;
        Trans.Params.Add('read_committed');
        Trans.Params.Add('rec_version');
        Trans.Params.Add('nowait');
        Query.Database := DM.wDataBase;
      end;
  Query.Transaction := Trans;
end;
 //
 // Create a query-transaction link with IBSQL entity
procedure TDM.AssignIBTransaction(var Query : TIBSQL; var Trans : TIBTransaction;Const write_key: Boolean=False);
begin
  Query := TIBSQL.Create(nil); Trans := TIBTransaction.Create(nil);
  if not (write_key) then
  begin
       Trans.DefaultDatabase := DM.rDataBase;
       Trans.Params.Add('read_committed');
       Trans.Params.Add('rec_version');
       Trans.Params.Add('nowait');
       Query.Database := DM.rDataBase;
  end
  else
      begin
        Trans.DefaultDatabase := DM.wDataBase;
        Trans.Params.Add('read_committed');
        Trans.Params.Add('rec_version');
        Trans.Params.Add('nowait');
        Query.Database := DM.wDataBase;
      end;
  Query.Transaction := Trans;
end;
// Execute a SQL statement
procedure TDM.ExecSQL(var Query: TIBQuery; const SQLTText: string);
begin
  Query.Close;
  Query.SQL.Text := SQLTText;
  Query.ExecSQL;
end;
// Reopen a connection with IBQUERY entity
procedure TDM.OpenSQL(var Query: TIBQuery; const SQLTText: string);
begin
  Query.Close;
  Query.SQL.Text := SQLTText;
  Query.Open();
end;
// Reopen a connection with IBSQL entity
procedure TDM.OpenSQL(var SQL: TIBSQL; const SQLTText: string);
begin
  SQL.Close;
  SQL.Transaction.StartTransaction;
  SQL.SQL.Text := SQLTText;
  SQL.ExecQuery;
  SQL.Transaction.Active := False;
end;

{//}
//
{Backup/restrore functions}
// Create a reserve copy of a database
procedure TDM.Getbackup;
var
  IniFile : TIniFile;
  msg,cmd: String;
  begin

    try

      cmd:=gPath+'\Data\backupdb.bat';
      thread_process.ShellExecute(0, '', cmd, ExtractFileName(dbPath)+' '+ExtractFileName(bPath), '', SW_SHOW);
//      thread_process.ShellExecute(0, '', 'cmd','/c '+cmd+' '+bPath+' '+Extractfilename(oldname), '', SW_SHOW);
    except on E:exception
    do
    begin
      MessageDlg(e.message,mtError,[mbOK],0);
      FormHeader.Writelog('Ошибка возникла в процессе резервного копирования');
    end;
    end;


  end;
//
// Analysis of a restore.log file searching an errors
  function TDM.restorelog(nameoflog: String): Boolean;
  var
  f : TextFile;
  pos,iter : Integer;
  str : String;
  fstr: String;
  begin
    try
      AssignFile(f,nameoflog);
      Reset(f);
      FormHeader.Writelog('Анализ лога восстановления данных backup.log ');
      Result:=True;
      pos:=0;
      iter:=0;
      while not EOF(f) do
        begin
          iter:=iter+1;
          Readln(f,str);
          pos:=AnsiPos('error',str);
          pos:=AnsiPos('Error',str)+pos;
          pos:=pos+AnsiPos('ERROR',str)+pos;
          if pos>0  then
          begin
            Result:=False;
            FormHeader.Writelog('Возникла ошибка в процессе восстановления базы данных backup.log строка:'+Inttostr(iter));
            Exit;
          end;

        end;
    Except
        Result:=False;
        FormHeader.Writelog('Ошибка при открытии/чтении файла лога');
        Exit;
        CloseFile(F);
    end;
    fstr:='gbak:finishing, closing, and going home';
    if Trim(str)<>fstr then
      begin
        Result:=False;
        FormHeader.Writelog('Исходная база данных не была установлена');
      end;
    CloseFile(F);
  end;
  //
  // Fulfill a restore of stored backup file of a database
 procedure TDM.Getrestore();
var
   IniFile : TIniFile;
  msg,cmd: String;
  newname,str,oldname: String;
  attrs    : Integer;
  begin
    try
      if DM.rDataBase.Connected then DM.rDataBase.Connected:=False;// Switch out connection to existing db
      if DM.wDataBase.Connected then DM.wDataBase.Connected:=False;
      //
      oldname:=ExtractFilename(dbpath);// Extract a filename of db
      oldname:=Copy(oldname,1,Length(oldname)-4);
      str:=ExtractFilepath(dbpath);
      oldname:=str+oldname+ '_r'+ ExtractFileext(dbpath); // Name of restored one with a "r" postfix
      //
          FormHeader.Writelog('выполнение восстановления резервной копии из '+bPath);
          cmd:=gPath+'\Data\restoredb.bat';
          // Restore
          thread_process.ShellExecute(0, '', 'cmd','/c '+cmd+' '+Extractfilename(bPath)+' '+Extractfilename(oldname), '', SW_SHOW);
          //
          // Analysis of a restore log
          if restorelog(gPath+'\Data\backup.log') then
            //
            begin // Reconnection
              if DM.rReconnect(dbPath) then
                begin
                  DM.rDataBase.Connected:=True;
                  FormHeader.Writelog('Данные восстановлены успешно');

                end;
            end;

    finally
      msg := '';

    end;
  end;


end.

