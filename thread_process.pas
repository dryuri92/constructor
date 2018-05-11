unit thread_process;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,Windows,ShellApi,service, iniform,QTable_class,system_info,service_bd,ExportImport,SyncObjs, unit_classes,Instance_class;
 type
   ThreadGenerator = class (TThread)
    private
    fFileOfError : string;
    fGenerator : TGeneratorSQL;
    flocalQueue : TQueue;
    fIniForm1 : TIniForm;
    fShow : Boolean;
    fCriticalSection: TCriticalSection;
   protected
     procedure Execute(); override;                                             // Main proceed function
     procedure WriteErrortoFile(msg : String);                                  // Write in case of eception catch
     procedure Init();                                                          // Initialize a form
     //
     procedure sync;                                                            // Synchronize process
     procedure OnThreadClose;                                                   // Send an information about thread execution
     procedure CloseThread();                                                         // Finalize all pointers
     procedure DoWork(num : Integer);                                                        // Execute the main function
   public
    constructor Create(Const IsShow: Boolean);
    procedure ReadQueue(gQueue : TQueue);                                       // Read a main queue
    //destructor Destroy;
  end;
   ThreadFileLoad = class (TThread)
   private
          fIniForm1 : TIniForm;
          fShow : Boolean;
          ftempList : TInstList;
          fCriticalSection: TCriticalSection;
          fConsystfile :TCONSYSTfile;
   public
       procedure Execute(); override;                                             // Main proceed function

       procedure Init();                                                          // Initialize a form
     //
       procedure sync;                                                            // Synchronize process
       procedure OnThreadClose;                                                   // Send an information about thread execution
       procedure Linklist (llist : TInstList);                                        // Link list of object to export
       procedure CloseThread();                                                   // Finalize all pointers
       procedure DoWork();                                                        // Execute the main function
       constructor Create(Filename : String;Const IsShow: Boolean);

   end;

   PTThreagG = ^ThreadGenerator;
   PTThreadL = ^ThreadFileLoad;
//Windows executer
   procedure ShellExecute(const AWnd: HWND; const AOperation, AFileName: String; const AParameters: String = ''; const ADirectory: String = ''; const AShowCmd: Integer = SW_SHOWNORMAL);
implementation
uses Header;
//Windows executer
{ Procedure can call in a view of command-line for Windows cmd.exe
cmd.exe
}
procedure ShellExecute(const AWnd: HWND; const AOperation, AFileName: String; const AParameters: String = ''; const ADirectory: String = ''; const AShowCmd: Integer = SW_SHOWNORMAL);
var
  ExecInfo: TShellExecuteInfo;
  WaitCode: DWORD;
  ExitCode: DWORD;
  ErrorCode: Integer;
begin
  Assert(AFileName <> '');

  //CoInitializeEx(nil, COINIT_APARTMENTTHREADED or COINIT_DISABLE_OLE1DDE);
  try
    FillChar(ExecInfo, SizeOf(ExecInfo), 0);
    ExecInfo.cbSize := SizeOf(ExecInfo);

    ExecInfo.Wnd := AWnd;
    ExecInfo.lpVerb :='open';// Pointer(AOperation);
    ExecInfo.lpFile := PAnsiChar(AFileName);
    ExecInfo.lpParameters := Pointer(AParameters);
    ExecInfo.lpDirectory := Pointer(ADirectory);
    ExecInfo.nShow := AShowCmd;
    ExecInfo.fMask := SEE_MASK_NOCLOSEPROCESS;// SEE_MASK_NOASYNC { = SEE_MASK_FLAG_DDEWAIT для старых версий Delphi }
                   //or SEE_MASK_FLAG_NO_UI;
    // Необязательно, см. http://www.transl-gunsmoker.ru/2015/01/what-does-SEEMASKUNICODE-flag-in-ShellExecuteEx-actually-do.html
    //ExecInfo.fMask := ExecInfo.fMask or SEE_MASK_UNICODE;

    Win32Check(ShellExecuteExA(@ExecInfo));
    if  ( ExecInfo.hProcess <> 0)then
    try
      WaitCode := WaitForSingleObjectEx(ExecInfo.hProcess, INFINITE, false);
      if WaitCode = WAIT_TIMEOUT then
        begin
        ErrorCode := -1;
        if not TerminateProcess(ExecInfo.hProcess,ExitCode) then
          FormHeader.Writelog('Не удалось завершить программу по тайм-ауту')
        else
         FormHeader.Writelog('Программа завершена по тайм-ауту');
        end
      else
        GetExitCodeProcess(ExecInfo.hProcess, ExitCode);
      //FResultCode := ExitCode;
    finally
      CloseHandle(ExecInfo.hProcess);
      end;
  finally
    // A thread must call CoUninitialize once for each successful call it has made to the CoInitialize or CoInitializeEx function, including any call that returns S_FALSE.
    //CoUninitialize;
  end;
end;

{ThreadGenerator}
// procedure of class ThreadGenerator
//class ThreadGenerator
constructor ThreadGenerator.Create(Const IsShow: Boolean);
begin
   self.fShow := IsShow;
   self.flocalQueue := TQueue.Create();
   self.fGenerator  := TGeneratorSQL.Create('');
   fCriticalSection := TCriticalSection.Create;
   inherited Create(True);
  // fFileOfError := 'ErrorGenerator.log'
end;
//class ThreadGenerator
procedure ThreadGenerator.Execute();                                             // Main proceed function
var
  i : Integer;
begin
  Synchronize(@self.Init);
  if (self.flocalQueue <> nil) then
   for i := 0 to self.flocalQueue.Len - 1 do
       begin
         self.DoWork(i);
       end;
   CloseThread;
end;

//class ThreadGenerator
procedure ThreadGenerator.WriteErrortoFile(msg : String);                                  // Write in case of eception catch
   var
     f : TextFile;
begin
     self.fFileOfError := 'ErrorGenerator.log';
     Assign(f,self.fFileOfError);
     Rewrite(f);
     Writeln(f,msg);
     Close(f);
end;
//class ThreadGenerator
procedure ThreadGenerator.OnThreadClose;                                        // Send an information about thread execution
begin
  header.FormHeader.Writelog('Thread ' + Inttostr(self.Handle) + ' is finished');
  WS._db_wexec := False;
  FormHeader.RefreshallWindow;
end;

//class ThreadGenerator
procedure ThreadGenerator.Init();                                                          // Initialize a form
begin
   self.fIniForm1 := TIniForm.Create(nil);
   header.FormHeader.Writelog('Thread ' + Inttostr(self.Handle) + ' is proceeding');
   self.fIniForm1.Show;
   //self.fIniForm1.Update(0,0);
end;

//class ThreadGenerator
procedure ThreadGenerator.sync();                                                          // Synchronize process
begin
    self.fIniForm1.Refresh;
end;

//class ThreadGenerator
procedure ThreadGenerator.CloseThread();                                                         // Finalize all pointers
begin
   Synchronize(@OnThreadClose);
   if Assigned( self.flocalQueue) then  FreeandNil(self.flocalQueue);
   if Assigned( self.fGenerator) then  FreeandNil(self.fGenerator);
   //if not (fIniForm1.Cl) then fIniForm1.Release;
   if Assigned( self.fIniForm1) then
   begin
        fIniForm1.Close;
        fIniForm1.Release;

   end;
   fCriticalSection.Free;
end;

//class ThreadGenerator
procedure ThreadGenerator.DoWork(num : Integer);                                                        // Execute the main function
var
  pt : PTInstanceConstr;
  msg : String;
  p : Pointer;
begin
  msg := '';
  self.fGenerator.Readtext(self.flocalQueue.Changes[num]);
  fCriticalSection.Enter;
  if (not self.fGenerator.Parse) then
     begin
      msg := msg + 'Changes not accepted by database.Exception with  ';
      fCriticalSection.Leave;
      if (self.flocalQueue.GetInstance(num) <> nil) then
         msg := msg + self.flocalQueue.GetInstance(num).Textrepr();
      self.WriteErrortoFile(msg);
     end
     else
     begin
         fCriticalSection.Leave;
         self.fIniForm1.Update(self.flocalQueue.Len,num);
         Synchronize(@sync);
     end;

end;

//class ThreadGenerator
procedure ThreadGenerator.ReadQueue(gQueue : TQueue);                                       // Read a main queue
begin

   self.flocalQueue.CopyfromQueue(gQueue);

end;
// Procedure of class ThreadFileLoad
   //class ThreadFileLoad
   procedure ThreadFileLoad.Execute();                                                     // Main proceed function
          begin
          Synchronize(@self.Init);
          // Do something
          DoWork;
          CloseThread;
          end;

//class ThreadFileLoad
       procedure ThreadFileLoad.Init();                                                          // Initialize a form
       begin
          self.fIniForm1 := TIniForm.Create(nil);
          header.FormHeader.Writelog('Thread load ' + Inttostr(self.Handle) + ' is proceeding');
          self.fIniForm1.Show;
       end;

     //
       //class ThreadFileLoad
       procedure ThreadFileLoad.sync;                                                            // Synchronize process
       begin
         self.fIniForm1.Refresh;
       end;

       //class ThreadFileLoad
       procedure ThreadFileLoad.OnThreadClose;                                                   // Send an information about thread execution
       begin
         header.FormHeader.Writelog('Thread load ' + Inttostr(self.Handle) + ' is finished');
       end;

       //class ThreadFileLoad
       procedure ThreadFileLoad.CloseThread();                                                   // Finalize all pointers
       begin
          Synchronize(@OnThreadClose);
   //if not (fIniForm1.Cl) then fIniForm1.Release;
        if Assigned(self.ftempList) then FreeandNil(self.ftempList);
        if Assigned( self.fIniForm1) then
        begin
             fIniForm1.Close;
             fIniForm1.Release;

        end;
        fCriticalSection.Free;
       end;

       //class ThreadFileLoad
       procedure ThreadFileLoad.DoWork();                                           // Execute the main function
       var
     Nuclids :TStringarray;
     pNucl : PTNuclidList;
     pMat : PTMatter;
     i,j,k : Integer;
     concentration : array of array of Real;
     temperature : array of Real;
  begin

       Nuclids := nil;
       pNucl := nil;
       concentration := nil;
       temperature := nil;
       pMat := nil;
       concentration := nil;
       temperature := nil;
      try
         for i := 0 to self.ftempList.Count - 1 do
         begin
              pMat := self.ftempList.Items[i];
              SetLength(concentration,Length(concentration)+1);
              SetLength(temperature,Length(temperature)+1);
              temperature[Length(temperature)-1] := pMat^.Temperature;

              for j := 0 to pMat^.NumNuclid - 1 do
                      if not IsInStr(Nuclids,pMat^.Nuclids[j].Name) then
                      begin
                          SetLength(Nuclids,Length(Nuclids)+1);
                          Nuclids[Length(Nuclids)-1] := pMat^.Nuclids[j].Name;
                      end;

              //filecons.;
         end;
         for i := 0 to self.ftempList.Count - 1 do
         begin
              pMat := self.ftempList.Items[i];
              SetLength(concentration[i],Length(Nuclids));
                  for j := 0 to pMat^.NumNuclid - 1 do
                      for k := 0 to Length(Nuclids) - 1 do
                      if pMat^.Nuclids[j].Name = Nuclids[k] then
                         concentration[i][k] := pMat^.Nuclids[j].Concentration;
              //filecons.;
         end;
         self.fConsystfile.SetUP(Nuclids,concentration,temperature);
         self.fConsystfile.WriteFile;
      finally
        self.fConsystfile.Free;
      end;

       end;
       //class ThreadFileLoad
       procedure ThreadFileLoad.Linklist (llist : TInstList);                                        // Link list of object to export
       begin
        self.ftempList := llist;
       end;

       //class ThreadFileLoad
       constructor ThreadFileLoad.Create(Filename : String;Const IsShow: Boolean);
       begin
          self.fShow := IsShow;
          self.fConsystfile := TCONSYSTfile.Create(FileName);
          fCriticalSection := TCriticalSection.Create;
          self.ftempList := TInstList.Create;
          inherited Create(True);
       end;

end.

