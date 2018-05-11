unit system_info;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, StdCtrls, IniFiles,ExtCtrls,Windows,Dialogs,unit_classes,QTable_class,Instance_class,
  Controls;

const
  // System constant
  MAX_MEMORY_LOC=200000; // Max memory allocation
  LOG_FILE='db.log';     // Changes in data base station
  INI_FILE='config.ini'; // Files with main properties
  // Math constant
  PI=3.1415;
  NA=0.6022;
  type
  Twindow_state=record   // Status of window states
   _o_material: Boolean;
   _o_geometry: Boolean;
   _o_cell: Boolean;
   _o_element: Boolean;
   _o_sub: Boolean;
   _o_ass :Boolean;
   _db_wexec : Boolean;

   end;

  Version_info = record
   _vnumber : Integer;
   _vdesc : String;
   _vid : Integer;
   _vdir : String;
   end;
    //type TchangeRecords = array of Tchange;
   //TStringArray = array of string;
   procedure ini_programm;// Program initialization
   procedure Get_sys_info;// Get main information about systemp properties
   procedure Initialization_query;
   function Check_materialinst : Boolean; //Scaning material list for not a queue instance


   var                               // Common global variables for all modules
     gPath: String;                  // Global path to working directory
     dbPath: String;                 // Constructor data base path
     bPath: String;                  // Path to backup file of database
     _os_type: String = 'windows';   // Type of OS
     _user_name: String = 'user';    // Name of user
     _threads : TList;
     WS:Twindow_state;
     VI : Version_info;
     QTables : array of TTable;
     Editing_material , Editing_geometry, Editing_element,Editing_subassembly: TInstList;
     Changelist: Tlist;
     InserSQLs,UpdateSQLs,DeleteSQLs: array [1..10] of String; // Query text
     //
       Queue: TQueue;
     //
implementation
procedure ini_programm;
begin
   with WS do
   begin
     _o_material:=False;
     _o_geometry:=False;
     _o_cell:=False;
     _o_element:=False;
     _o_sub:=False;
     _o_ass:=False;
     _db_wexec := False;


   end;
   // _threads := TList.Create;
    Get_sys_info;
    Initialization_query;
end;

procedure Get_sys_info;
var
  i:integer;
  dwUserNameLen : DWord;
  begin
  // Get OS Type
  {$IFDEF WIN32 OR WIN64}
    _os_type:='Windows';
  {$ENDIF}

  {$IFDEF linux}
    _os_type:='Linux';
  {$ENDIF}

  {$IFDEF BSD}
    _os_type:='Mac_OS';
  {$ENDIF}
  // Get user name
  if (_os_type='Windows') then
     begin
     Win32Check(GetUserName( PChar(_user_name), dwUserNameLen ));
     _user_name:=PChar(_user_name);

     end;

  // Get working directory
     gPath:=GetCurrentDir();
     VI._vdir := gPath + '\save\';
    end;

function Check_materialinst : Boolean;                                          //Scaning material list for not a queue instance
var
  pMat : PTMatter;
  i : Integer;
  msg : String;
begin
    Result := False;
    for i := 0 to Editing_material.Len - 1 do
        begin
          pMat := Editing_material.Items[i];
          if (not pMat^.GetQueord()) then
             begin
                  msg := pMat^.Textrepr();
                  msg := msg + ' are not in queue for database record, do you want to continue?';
                  Result := True;
                  if (MessageDlg(msg,mtConfirmation,[mbYes,mbNo],0) =  mrYes) then
                     Result := False;
                  if (Result) then Exit;
             end;
        end;

end;

  {//}
  {$INCLUDE ..\Source\qtables.inc}


end.

