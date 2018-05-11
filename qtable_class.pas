unit Qtable_class;
// record TField and class QTable forms queries for database
// classes TChange,TQueueEntity forming queue in class TQueue
{$mode objfpc}{$H+}

interface

uses
 Classes, SysUtils,Dialogs,Instance_class;
type
   //
  TStringArray = array of string;
  // class TField
  TField = record
    FName : String;                   // Name of field in db
    FType : String;                   // Type i - integer; r - float;
                                      //      d - double; s - string;
                                      //      b - blob spec format; l - boolean;
    FValue: String;                   // Value of current property
    FLen:   Integer;                  // Length of VARCHAR type variable
  end;
  // class TTable
  TTable = class
    protected
    // Attributes
      fName : String;                // Name of table in db
      ffields : array of TField;     // Fields in table
      fid : String;                  // Current id of table
      fpid : TStringArray;           // Foreign parent id for current table
      fkey : Integer;                // Foreign key for table
      fTables : TStringArray;        // Parent tables for current
      fGenerator : Integer;          // Current value of generator field
      fParentTable : Integer;         // Parent table
   // Procedures
    function GetField(index: Integer): TField;
    function GetID(index: Integer) : String;
    procedure SetField(index: Integer; Fld:TField);
   //
    public
    // Attributes
      isGenerator: Boolean;
    // Procedures
      //constructor Create(name,id: String;keys:TStringArray; tables : TStringArray);overload;
      constructor Create(name,genid: String;Const ids: Array of String; tables : TStringArray);overload;
      function GetGenerator(Const Shift:Integer=0): String;                       // Get generator of a table query
      function GetSelect(): String; overload;                                    // Get selection query
      function GetSelect(where: TStringarray): String; overload;                 // Get selection query
      function GetUpdate(): String;overload;                                     // Get update query
      function GetUpdate(where: TStringarray): String;overload;                  // Get update query
      function GetInsert(): String;                                              // Get insertion query
      function GetDelete(): String;overload;                                     // Get delete query
      function GetDelete(where: TStringarray): String;overload;                  // Get delete query
      function GetSelect(numid: Integer): String; overload;                      // Get selection query
      function GetUpdate(numid: Integer): String;overload;                       // Get update query
      function GetDelete(numid: Integer): String;overload;                       // Get delete query
      procedure LinkParent(ParentTable: Integer;number : Integer);                // Link a parent table to self
      function  GetParent : Integer;                                              // Get parent table to link
      procedure IncGenerator;                                                    // Increase a value of generator
      procedure ActuateGen(valuefrombase : Integer);                             // Get the value from database
      function GetGeneratorValue(): Integer;                                     // Get the current generator state
    // Properties
     property  Fields[index:integer]:TField    read GetField     write SetField;
     property  IDs[index:integer]: String read GetID;
     property  genID : String read fID;
     property  Foreignkey : Integer read fkey;
end;
  //
  TChange = class
    protected
    // Attributes
     fBindNumber : Integer;
     FNumQTable : Integer;
     fChainLast : Integer;
     fChangeID: Integer;
     fInstance: TInstanceConstr;
     fTextChange : String;
    // Procedures
     procedure Copy(text: String;iLast : Integer;iBind : Integer);              //Copy information from another change
     //procedure WriteLast();
    public
    // Procedures
     constructor Create(); overload;
     constructor Create(text : String);overload;
     constructor Create(text : String; iLast : Integer);overload;
     constructor Create(text : String; iLast : Integer; iBind : Integer);overload;
     constructor Create(text : String; iLast : Integer; iBind : Integer;cInstance : TInstanceConstr);overload;
     procedure ReadInstance(cInstance : TInstanceConstr);                       // Read an instance of the object in queue
     procedure LinkTable(number : Integer);                                     // Link a table number to current change
     destructor Destroy(); override;
    // Properties
    property cInstance : TInstanceConstr read  fInstance;
    property QTableNum : Integer read FNumQTable;
    property Text : String read fTextChange write fTextChange;
    end;
  //
   TQueueEntity = class
    protected
     // Attributes
     fLength : Integer;
     fChanges : array of TChange;
     // Procedures
     function GetChange(index: Integer): String;
    procedure SetChange(index: Integer; str:String);
    public
     // Procedures
     constructor Create(); overload;
     destructor Destroy(); override;
     procedure Append(text: String); virtual;                                   // Add change to the end of list
     procedure Insert(pos : Integer; text: String);virtual;                     // Insert change to the position of list
     procedure Exchange(pos1,pos2  : Integer);                                  // Exchange two changes in the list
     procedure Delete(pos : Integer);virtual;                                   // Delete changes from list by position
   // Properties
     property Changes[index:integer]: String   read GetChange     write SetChange;
     property Len : Integer     read fLength;
   end;

   TQueue = class(TQueueEntity)
    private
     function GetPosbyInstance(inst : TInstanceConstr): Integer;                // Get position in queue of Instance
    public
    // Procedures
     procedure Append(text: String;iBind : Integer);                            // Add change to the end of list
     procedure Insert(pos : Integer; text: String;iBind : Integer);             // Insert change to the position of list
     procedure Delete(pos : Integer);                                           // Delete changes from list by position
     procedure CheckState();                                                    // Check an instance state
     procedure SubstText(pos : Integer;Text : String);                          // Exchange a text of change on another
     function GetInstance(number : Integer):TInstanceConstr;                    // Get instance by own queue number
     procedure FormChangetext(numoftable: Integer;command: String
       ;properties:TStringArray;iBind: Integer); overload;                      // Forming change record
     procedure FormChangetext(numoftable: Integer;
       properties:TStringArray;iBind: Integer;pInstance : TInstanceConstr); overload;// Forming change record
     procedure FormChangetext(numoftable: Integer;
       properties:TStringArray;InstBind: TInstanceConstr;pInstance : TInstanceConstr); overload;// Forming change record
     function SaveQueuetoFile(var f : TextFile) : Boolean;                      // Write queue log to the text file
     function LoadQueueFromFile(var f : TextFile) : Boolean;                    // Read the queue log from text file
     procedure CopyfromQueue(aQueue : TQueue);                                  // Copy changes from another queue
     procedure Clear;                                                           // Clear the list of changes
     procedure ClearbyInstance;                                                 // Clear queue from None Instance

   end;


implementation
    // Procedure of Class TTable
  { constructor TTable.Create(name,id: String;keys:TStringArray; tables : TStringArray);
   begin
      fName := name;
      fid := id;
      if (Length(tables) > 0 ) then
      begin
           SetLength(fpid, Length(keys));
           SetLength(fTables, Length(keys));
           fpid := keys;
           fTables := tables;
      end;
      fGenerator := -1;
      //fTables : array of TTable;
      if Length(keys) <> Length(tables) then
         raise Exception.Create('Dimension of parent keys section not equal dimension of tables section');
   end; }
   //Class TTable
   constructor TTable.Create(name,genid: String;Const ids: Array of String; tables : TStringArray);
   var
      i : Integer;
   begin
      fName := name;
      fid := genid;
      if (Length(tables) > 0 ) then
      begin
           SetLength(fTables, Length(tables));
           fTables := tables;
      end;
      if (Length(ids) > 0 ) then
      begin
           SetLength(fpid, Length(ids));
           for i:= 0 to Length(ids) - 1 do
               fpid[i] := ids[i];
      end;
      fGenerator := -1;
      fkey := -1;
      fParentTable := -1;
   end;

   //Class TTable// Propery Fields
   function TTable.GetField(index: Integer): TField;
   begin
      //Result  :=  nil;
   try
    Result :=  ffields[index];
   except
    ShowMessage('Exception');
    Exit;
   end;
   end;
   //Class TTable
   function TTable.GetID(index: Integer) : String;
   begin
      Result := self.fpid[index];
   end;

   //Class TTable// Propery Fields
   procedure TTable.SetField(index: Integer; Fld:TField);
   var
     len : Integer;
   begin
      len := Length(ffields);
      if index > len-1 then
         begin
              index := len;
              SetLength(ffields,index + 1);
         end;
      ffields[index] := Fld;
   end;
   //Class TTable
   function TTable.GetSelect(): String; overload; // Get selection query
   var
     str: String;
     i : Integer;
   begin
      str := 'SELECT * FROM';
      str := str + ' ' + fName;
      // where section
      str := str + ' ' + 'WHERE';
      str := str + ' ' + fid + '=:' + fid;
      if length(fpid) > 0 then
         for i:= 0 to Length(fpid) - 1 do
         begin
            str := str + ' ' + 'AND' + ' ';
            str := str + fTables[i] + '.' + fpid[i] + '=:' + fpid[i] ;
         end;
      Result := str;
   end;
   //Class TTable
   function TTable.GetSelect(where:TStringArray): String; overload; // Get selection query
   var
     str,del: String;
     i : Integer;
   begin
      str := 'SELECT * FROM';
      str := str + ' ' + fName;
      // where section
      str := str + ' ' + 'WHERE';
      del := ' ';
      if length(where) > 0 then
         for i:= 0 to Length(where) - 1 do
         begin
            str := str + del;
            str := str + where[i] + '=:' + where[i] ;
            del := ' ' + 'AND' + ' ';
         end;
      Result := str;
   end;
   //Class TTable
   function TTable.GetUpdate(): String; overload; // Get update query
    var
     str,del: String;
     i : Integer;
   begin
      str := 'UPDATE';
      str := str + ' ' + fName;
      str := str + ' ' + 'Set';
      del := ' ';
      for i:= 0 to Length(ffields) - 1 do
      begin
          str := str + del + ffields[i].FName + '=:' +ffields[i].FName;
          del := ',';
      end;
      // where section
      str := str + ' ' + 'WHERE';
      str := str + ' ' + fid + '=:' + fid;
      if length(fpid) > 0 then
         for i:= 0 to Length(fpid) - 1 do
         begin
            str := str + ' ' + 'AND' + ' ';
            str := str + fTables[i] + '.' + fpid[i] + '=:' + fpid[i] ;
         end;
      Result := str;
   end;
   //Class TTable
   function TTable.GetUpdate(where:TStringArray): String; overload; // Get update query
    var
     str,del: String;
     i,j : Integer;
     isIN : Boolean;
   begin
      str := 'UPDATE';
      str := str + ' ' + fName;
      str := str + ' ' + 'Set';
      del := ' ';
      for i:= 0 to Length(ffields) - 1 do
      begin
          isIn:=True;
          for j:=0 to Length(where) - 1 do

             isIn:=(ffields[i].FName  <> where[j]) and (isIN);

              if (isIn) then
              begin
                  str := str + del + ffields[i].FName + '=:' +ffields[i].FName;
                  del := ',';
              end;
      end;
      // where section
      str := str + ' ' + 'WHERE';
      del := ' ';
      if length(where) > 0 then
         for i:= 0 to Length(where) - 1 do
         begin
            str := str + del;
            str := str + where[i] + '=:' + where[i] ;
            del := ' ' + 'AND' + ' ';
         end;
      Result := str;
   end;
   //Class TTable
   function TTable.GetInsert(): String;  // Get insertion query
    var
     str,del: String;
     i : Integer;
   begin
      str := 'INSERT INTO';
      str := str + ' ' + fName;
      del := ' (';
      for i:= 0 to Length(ffields) - 1 do
      if (not self.isGenerator) or (ffields[i].FName <> self.fid) then
      begin
          str := str + del + ffields[i].FName;
          del := ',';
      end;
      str := str + ') ';
      str := str + 'VALUES';
      del := ' (';
      for i:= 0 to Length(ffields) - 1 do
      if (not self.isGenerator) or (ffields[i].FName <> self.fid) then
      begin
          str := str + del + ':' + ffields[i].FName;
          del := ','
      end;
      str := str + ')';
      Result := str;
   end;
   //Class TTable
   function TTable.GetDelete(): String;overload;  // Get delete query
    var
     str: String;
     i : Integer;
   begin
      str := 'DELETE FROM';
      str := str + ' ' + fName;
      // where section
      str := str + ' ' + 'WHERE';
      str := str + ' ' + fid + '=:' + fid;
      if length(fpid) > 0 then
         for i:= 0 to Length(fpid) - 1 do
         begin
            str := str + ' ' + 'AND' + ' ';
            str := str + fTables[i] + '.' + fpid[i] + '=:' + fpid[i] ;
         end;
      Result := str;
   end;
   //Class TTable
   function TTable.GetDelete(where:TStringArray): String; overload;  // Get delete query
    var
     str,del: String;
     i : Integer;
   begin
      str := 'DELETE FROM';
      str := str + ' ' + fName;
      // where section
      str := str + ' ' + 'WHERE';
      del := ' ';
      if length(where) > 0 then
         for i:= 0 to Length(where) - 1 do
         begin
            str := str + del;
            str := str + where[i] + '=:' + where[i] ;
            del := ' ' + 'AND' + ' ';
         end;
      Result := str;
   end;
   //Class TTable
   function TTable.GetSelect(numid: Integer): String;                           // Get selection query
   var
     str,del: String;
     i : Integer;
   begin
      str := 'SELECT * FROM';
      str := str + ' ' + fName;
      // where section
      str := str + ' ' + 'WHERE';
      del := ' ';
      if length(self.fpid) > 0 then
         for i:= 0 to numid - 1 do
         begin
            str := str + del;
            str := str + self.fpid[i] + '=:' + self.fpid[i] ;
            del := ' ' + 'AND' + ' ';
         end;
      Result := str;
   end;
   //Class TTable
   function TTable.GetUpdate(numid: Integer): String;                           // Get update query
    var
     str,del: String;
     i,j : Integer;
     isIN : Boolean;
   begin
      str := 'UPDATE';
      str := str + ' ' + fName;
      str := str + ' ' + 'Set';
      del := ' ';
      for i:= 0 to Length(ffields) - 1 do
      begin
          isIn:=True;
          for j:=0 to numid - 1 do

             isIn:=(ffields[i].FName  <> self.fpid[j]) and (isIN);

              if (isIn) then
              begin
                  str := str + del + ffields[i].FName + '=:' +ffields[i].FName;
                  del := ',';
              end;
      end;
      // where section
      str := str + ' ' + 'WHERE';
      del := ' ';
      if numid > 0 then
         for i:= 0 to numid - 1 do
         begin
            str := str + del;
            str := str + self.fpid[i] + '=:' + self.fpid[i] ;
            del := ' ' + 'AND' + ' ';
         end;
      Result := str;
   end;
   //Class TTable
   function TTable.GetDelete(numid: Integer): String;                           // Get delete query
  var
     str,del: String;
     i : Integer;
   begin
      str := 'DELETE FROM';
      str := str + ' ' + fName;
      // where section
      str := str + ' ' + 'WHERE';
      del := ' ';
      if numid > 0 then
         for i:= 0 to numid - 1 do
         begin
            str := str + del;
            str := str + self.fpid[i] + '=:' + self.fpid[i] ;
            del := ' ' + 'AND' + ' ';
         end;
      Result := str;
   end;
   //Class TTable
   function TTable.GetGenerator(Const Shift:Integer=0): String;                        // Get generator of a table query
   var
     str: String;
   begin
     if (isGenerator) then
        begin
            str := 'SELECT gen_id(';
            str := str + 'GEN' + '_' + fname + '_' + fid + ',' + Inttostr(Shift) + ') FROM rdb$database ';
            Result:=str;
        end
     else
         Result:='';
   end;
   //Class TTable
   procedure TTable.IncGenerator;                                               // Increase a value of generator
   begin
      fGenerator := fGenerator + 1;
   end;
   //Class TTable
   procedure TTable.ActuateGen(valuefrombase : Integer);                        // Get the value from database
   begin
      fGenerator := valuefrombase;
   end;

   //Class TTable
   function TTable.GetGeneratorValue(): Integer;                                // Get the current generator state
   begin
     Result :=  fGenerator;
   end;
   //
   procedure TTable.LinkParent(ParentTable: Integer;number : Integer);           // Link a parent table to self
   begin
      fParentTable := ParentTable;
      fkey := number;
   end;

   function  TTable.GetParent : Integer;                                         // Get parent table to link
   begin
      Result := fParentTable;
   end;

//
// Procedures of class Tchange
// class TChange
 constructor TChange.Create();
 begin
     fChainLast := -1;
     fTextChange := '';
     fBindNumber := -1;
     fChangeID   := -2;
 end;
 // class TChange
 constructor TChange.Create(text : String);
 begin
     fChainLast := -1;
     fTextChange := text;
     fBindNumber := -1;
     fChangeID   := -2;
 end;
 // class TChange
 constructor TChange.Create(text : String; iLast : Integer);
 begin
     fChainLast := iLast;
     fTextChange := text;
     fBindNumber := -1;
     fChangeID   := -2;
 end;
 // class TChange
 constructor TChange.Create(text : String; iLast : Integer;iBind : Integer);
 begin
     fChainLast  := iLast;
     fTextChange := text;
     fBindNumber := iBind;
     fChangeID   := -2;
 end;
 // class TChange
 constructor TChange.Create(text : String; iLast : Integer; iBind : Integer;cInstance : TInstanceConstr);
 begin
     fChainLast  := iLast;
     fTextChange := text;
     fBindNumber := iBind;
     fInstance   := cInstance;
 end;
 // class TChange
 destructor TChange.Destroy;
begin
try
  inherited Destroy;
except
    On E : Exception do
       ShowMessage('TChange.Destroy - Error: '+E.Message);
end;
end;

 // class TChange
 procedure TChange.Copy(text: String;iLast : Integer;iBind : Integer);          //Copy information from another change
 begin
     fChainLast  := iLast;
     fTextChange := text;
     fBindNumber := iBind;
 end;
 // class TChange
 procedure TChange.ReadInstance(cInstance : TInstanceConstr);                   // Read an instance of the object in queue
 begin
   fInstance := cInstance;
 end;
 // class TChange
 procedure TChange.LinkTable(number : Integer);                                 // Link a table number to current change
 begin
   FNumQTable := number;
 end;

 //
 // procedure of class TQueueEntity
 // class TQueueEntity
 constructor TQueueEntity.Create();
 begin
      fLength := 0;
      fChanges := nil;
 end;
 // class TQueueEntity
 procedure TQueueEntity.Append(text: String);                                   // Add change to the end of list
 begin
      SetLength(fChanges, Length(fChanges) + 1);
      fChanges[Length(fChanges) - 1] := TChange.Create(text);
      fChanges[Length(fChanges) - 1].fChainLast := fLength - 1;
      fLength := fLength + 1;
 end;
 // class TQueueEntity
 procedure TQueueEntity.Insert(pos : Integer; text: String);          // Insert change to the position of list
 var
   i : Integer;
 begin
      if (pos > fLength - 1)  then
         raise Exception.Create('Exception TQueueEntity: the Insert operation are not allowed')
      else
      begin
      SetLength(fChanges, Length(fChanges) + 1);
      for i := Length(fChanges) - 2 downto pos do
          begin
             fChanges[i+1] := fChanges[i];
             fChanges[i+1].fChainLast := i;
          end;
      fChanges[pos] := TChange.Create(text,pos - 1);
      fLength := fLength + 1;

      end;
 end;
 // class TQueueEntity
 procedure TQueueEntity.Exchange(pos1,pos2  : Integer);               // Exchange two changes in the list
 var
   temp : TChange;
 begin
      if (pos1 = pos2) or (pos1 > fLength - 1) or (pos2 > fLength - 1) then
         raise Exception.Create('Exception TQueueEntity: the Exchange operation are not allowed')
      else
            begin
               temp := TChange.Create();
               temp.Copy(fChanges[pos2].fTextChange,fChanges[pos2].fChainLast,fChanges[pos2].fBindNumber);
               fChanges[pos2] := fChanges[pos1];
               fChanges[pos2].fChainLast := pos2 - 1;
               fChanges[pos1] := temp;
               fChanges[pos1].fChainLast := pos1 - 1;
            end;
 end;
// class TQueueEntity
procedure TQueueEntity.Delete(pos : Integer);                         // Delete changes from list by position
var
   i : Integer;
 begin
      if (fLength <= 0) or (pos > fLength - 1) then
         raise Exception.Create('Exception TQueueEntity: the delete operation are not allowed')
      else
            for i := pos to Length(fChanges) - 2 do
            begin
             fChanges[i] := fChanges[i+1];
             fChanges[i].fChainLast := i + 1;
            end;
      SetLength(fChanges, Length(fChanges) - 1);
      fLength := fLength - 1;
 end;
// class TQueueEntity
procedure TQueueEntity.SetChange(index: Integer; str:String);
begin
   if (index < fLength) then fChanges[index].fTextChange := str;
end;
// class TQueueEntity
function TQueueEntity.GetChange(index: Integer): String;
begin
     Result := '';
     if (index < fLength) then Result := fChanges[index].fTextChange;
end;
// class TQueueEntity
 destructor TQueueEntity.Destroy;
begin
try
  fChanges:=nil;
  FreeandNil(fChanges);
//  Finalize(fChanges);
  inherited Destroy;
except
    On E : Exception do
       ShowMessage('TChange.Destroy - Error: '+E.Message);
end;
end;
 //
 // procedure of class TQueue
 // class TQueue
 procedure TQueue.Append(text: String;iBind : Integer);                 // Add change to the end of list
 begin
      inherited Append(text);
      fChanges[fLength - 1].fBindNumber := iBind;
 end;
  // class TQueue
 procedure TQueue.Insert(pos : Integer; text: String;iBind : Integer);  // Insert change to the position of list
 var
    i: Integer;
 begin
      if (pos > iBind) then
      begin
        inherited Insert(pos,text);
        fChanges[pos].fBindNumber := iBind;
        for i:= pos + 1 to Length(fChanges) - 1 do
            if (fChanges[i].fBindNumber >= pos) then
               fChanges[i].fBindNumber := fChanges[i].fBindNumber + 1;
      end
      else
          raise Exception.Create('Exception TQueue: the delete operation are not allowed');
 end;
  // class TQueue
 procedure TQueue.Delete(pos : Integer);                                // Delete changes from list by position
 var
    i: Integer;
 begin
      if (fChanges[pos].cInstance <> nil) then fChanges[pos].cInstance.Dispose();
      inherited Delete(pos);
      for i:= pos to Length(fChanges) - 1 do
          if (fChanges[i].fBindNumber >= pos) then
            if (fChanges[i].fBindNumber = pos) then
               fChanges[i].fBindNumber := -2
            else
               fChanges[i].fBindNumber := fChanges[i].fBindNumber - 1;
     for i:= pos to Length(fChanges) - 1 do
         if (fChanges[i].fBindNumber = -2) then Delete(i);
 end;
 // class TQueue
  procedure TQueue.Clear;                                                // Clear the list of changes
  var
     i : Integer;
  begin
      for i := 0 to self.Len - 1 do
          if (fChanges[i].cInstance <> nil) then fChanges[i].cInstance.Dispose();
      fChanges := nil;
      self.fLength := 0;
  end;
  // class TQueue
  procedure TQueue.CheckState();
  var
    i:Integer;
  begin
       for i:=Length(fChanges)-1 downto 0 do
           if (fChanges[i].fInstance <> nil) then
           if not (fChanges[i].fInstance.GetQueord) then
              Delete(i);
  end;
  // class TQueue
 procedure TQueue.SubstText(pos : Integer;Text : String);                          // Exchange a text of change on another

   begin
        self.fChanges[pos].Text := Text;
   end;

  // class TQueue
  procedure TQueue.FormChangetext(numoftable: Integer;command: String
       ;properties:TStringArray;iBind: Integer); overload;                      // Forming change record
  var
    txt : String;
    i : Integer;
  begin
        txt := '';
        txt := txt + Inttostr(numoftable) + #9;
        txt := txt + command +#9;
        for i:= Low(properties) to High(properties) do
            txt := txt + properties[i] + ';';
        //fChanges[fLength - 1].LinkTable(numoftable);
        Append(txt,iBind);


  end;

  // class TQueue
  procedure TQueue.FormChangetext(numoftable: Integer;
       properties:TStringArray;iBind: Integer;pInstance : TInstanceConstr);     // Forming change record
  var
    txt : String;
    command: String;
    pos : Integer;
    i : Integer;
  begin
        txt := '';
        pos := -1;
        txt := txt + Inttostr(numoftable) + #9;
        case pInstance.Status of
             Inserted : command := 'i';
             Modified : command := 'u';
             Deleted  : command := 'd';
        end;
        txt := txt + command + #9;
        if (pInstance.Status <> Inserted) then txt := txt + pInstance.RepresentID() + #9; //??
        if pInstance.GetQueord() then pos:=GetPosbyInstance(pInstance);

        if (pInstance.Status <> Deleted) then                                    //??
        for i:= Low(properties) to High(properties) do
            txt := txt + properties[i] + ';';
        if pos < 0 then
           begin
           if (iBind < 0) or (iBind = fLength - 1) then
              begin
              Append(txt,iBind);pos := fLength - 1;
              end
           else
               begin
               pos := ibind + 1;Insert(pos,txt,iBind);
               end;
           end
        else
           begin
             //Delete(pos);
             //if (pos <> fLength) then
             //   Insert(pos,txt,iBind)
             //else
             //   Append(txt,iBind);
            SubstText(pos,txt);
           end;

        fChanges[pos].ReadInstance(pInstance);
        fChanges[pos].LinkTable(numoftable);
        pInstance.InQueue();
  end;
  // class TQueue
  procedure TQueue.FormChangetext(numoftable: Integer;
       properties:TStringArray;InstBind: TInstanceConstr;pInstance : TInstanceConstr); // Forming change record
  begin
      self.FormChangetext(numoftable,properties,self.GetPosbyInstance(InstBind),pInstance);
  end;

  // class TQueue
  procedure TQueue.ClearbyInstance;                                             // Clear queue from None Instance
  var
    i : Integer;
  begin
      for i:=0 to Length(fChanges)-1 do
          if (fChanges[i].cInstance <> nil) then
           if (fChanges[i].cInstance.Status = Selected) or (fChanges[i].cInstance.Status = None)  then
              fChanges[i].cInstance.Dispose;
      CheckState;
  end;
 // class TQueue
 function TQueue.GetPosbyInstance(inst : TInstanceConstr): Integer;             // Get position in queue of Instance
 var
   i : Integer;
 begin
    for i:=0 to Length(fChanges)-1 do
        if (fChanges[i].cInstance = inst) then
        begin
           Result := i;
           Exit;
        end;
 end;
  // class TQueue
      function TQueue.SaveQueuetoFile(var f : TextFile) : Boolean;                  // Write queue log to the text file
      var
        i : Integer;
      begin

      Result := False;
      for i := 0 to self.Len - 1 do
          Writeln(f,self.Changes[i]);
      Result := True;
      end;

   // class TQueue
     function TQueue.LoadQueueFromFile(var f : TextFile) : Boolean;             // Read the queue log from text file
     var
     txt : String;
      begin
      Result := False;
      while not EOF(f) do
      begin
        Readln(f,txt);
        Self.Append(txt,-1);
      end;
      Result := True;
      end;
   // class TQueue
  function TQueue.GetInstance(number : Integer):TInstanceConstr;                // Get instance by own queue number
  begin
       Result := self.fChanges[number].cInstance;
  end;
   // class TQueue
      procedure TQueue.CopyfromQueue(aQueue : TQueue);                          // Copy changes from another queue
      var
         i: Integer;
      begin
           for i := 0 to aQueue.Len - 1 do
           begin
             self.Append(aQueue.Changes[i],-1);
             self.fChanges[self.Len - 1].ReadInstance(aQueue.fChanges[i].cInstance);
           end;
      end;

 //
end.

