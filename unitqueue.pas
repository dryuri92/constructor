unit unitqueue;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, ComCtrls,DataModule,
  ExtCtrls, StdCtrls,unit_classes,system_info,qtable_class,instance_class,Dialogs,thread_process;

type

  { TFormQueue }

  TFormQueue = class(TForm)
    ImageList1: TImageList;
    List: TListBox;
    dlgOpen: TOpenDialog;
    Panel: TPanel;
    dlgSave: TSaveDialog;
    ToolBar: TToolBar;
    BtnDel: TToolButton;
    BtnRefresh: TToolButton;
    BtnSave: TToolButton;
    BtnRead: TToolButton;
    BtnMulti: TToolButton;
    procedure BtnDelClick(Sender: TObject);
    procedure BtnMultiClick(Sender: TObject);
    procedure BtnReadClick(Sender: TObject);
    procedure BtnRefreshClick(Sender: TObject);
    procedure BtnSaveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    procedure FullRefreshQueue;                                                 // Reopen a list of queue records in according to main queue
    function ReadlogFile(filename: String) : Boolean;                           // Read a text file
    function WritelogFile(filename: String) : Boolean;                          // Write to a text file
    { public declarations }
  end;

var
  FormQueue: TFormQueue;

implementation
 uses unit_db;
{$R *.lfm}

{ TFormQueue }
// class TFormQueue
procedure TFormQueue.FormCreate(Sender: TObject);
begin
  List.Items.Clear;
  _threads := TList.Create;
end;
// class TFormQueue
procedure TFormQueue.BtnDelClick(Sender: TObject);
begin
  if List.ItemIndex > -1 then
     begin
          Queue.Delete(List.ItemIndex);
     end;
  FullRefreshQueue;
end;

procedure TFormQueue.BtnMultiClick(Sender: TObject);
var
  l_material : Boolean;
  l_all : Boolean;
  pG :PTThreagG;
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
       if WritelogFile(VI._vdir + Inttostr(VI._vid) + '\log.txt') then
          WS._db_wexec := True;
       pG^.Resume();

     except on E: Exception  do
        MessageDlg('Thread not load ' + e.message, mtError, [mbOK], 0);
     end;
     end;


     Queue.Clear;
     FullRefreshQueue;
     unit_db.DBmod.RefreshallWindow;
end;

procedure TFormQueue.BtnReadClick(Sender: TObject);
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

// class TFormQueue
procedure TFormQueue.BtnRefreshClick(Sender: TObject);
begin
  FullRefreshQueue;
end;

procedure TFormQueue.BtnSaveClick(Sender: TObject);
begin
  //dlgSave.Options := [ofFileMustExist];
  dlgSave.Filter := 'txt-files|*.txt|All files|*.*';
  dlgSave.FilterIndex := 1;
  dlgSave.InitialDir := gPath;
  dlgSave.Title := 'Save the log file';
  if (dlgSave.Execute) then
    if not WritelogFile(dlgSave.FileName) then
      MessageDlg('Unsuccesfull opening a text file check the existing',mtError,[mbOK],0);
end;

// class TFormQueue
procedure TFormQueue.FullRefreshQueue;                                                  // Reopen a list of queue records in according to main queue
var
  i : Integer;
  msg : String;
begin
   List.Items.Clear;
   Queue.ClearbyInstance;
   for i := 0 to Queue.Len - 1 do
       begin
         msg := '';
         if (Queue.GetInstance(i) <> nil) then
           begin
         case Queue.GetInstance(i).Status of
              Modified: msg := msg + 'Modifiying';
              Inserted: msg := msg + 'Inserting';
              Deleted:  msg := msg + 'Deleting';
              Selected: msg := msg + '';
              None:     msg := msg + '';
         end;


         msg := msg + ' ' + Queue.GetInstance(i).Textrepr();
           end
         else
             msg := msg + Queue.Changes[i];
         //List.Items.Append(Queue.Changes[i]);
         List.Items.Append(msg);
       end;
end;
// class TFormQueue
function TFormQueue.ReadlogFile(filename: String) : Boolean;                           // Read a text file
var
  f : TextFile;
begin
  Result := False;
  if  FileExists(FileName) then
    begin
     try
      AssignFile(f, FileName); Reset(f);
      Result := Queue.LoadQueueFromFile(f);
     finally
       CloseFile(f);
     end;
    end;
end;

// class TFormQueue
function TFormQueue.WritelogFile(filename: String) : Boolean;                          // Write to a text file
var
  f : TextFile;
begin
    Result := False;
     try
      AssignFile(f, FileName); Rewrite(f);
      Result := Queue.SaveQueuetoFile(f);
     finally
       closeFile(f);
     end;
end;


end.

