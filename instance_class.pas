unit Instance_class;
// Basis class for all entities of constructor
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,Dialogs,FGL,contnrs;

type
   // Status of a class object
   TInStatus = (None,Modified,Selected,Inserted,Deleted);
   TInteger = array of Integer;
   TStringArray = array of string;
   //
   TInstanceConstr = class
   private
   // Attributes
     fID : array of Integer;
     fStatus : TInStatus;
     foldStatus :TInStatus;//none usefull attribute
     finOrder : Boolean;   // attribute shown the bind between class example and queue
   public
   //Procedure
   constructor Create();
   destructor Destroy();override;
   function   Textrepr(): String; virtual;
   function   Getproperties(): TStringArray; virtual;
   procedure  ReadID(pID: array of Integer);                                    // read id key field from database
   function   GetID() : TInteger;                                               // get the instance identifier
   procedure  Dispose();                                                        // exlude class example from queue
   procedure  ChangeStatus(newStatus : TInStatus);                              // change the current status
   procedure  InQueue();                                                        // include the class example into queue
   function   GetQueord() : Boolean;                                            // define is class example in queue
   function   RepresentID(): String;                                            // Represent an id of instance
   property   Status : TInStatus read fStatus;
   property  oldStatus : TInStatus read foldStatus;
   end;
   PTInstanceConstr = ^TInstanceConstr;
   // Auxilary class Sorted list of Integer
   TSortList = class
   private
   // Attributes
      fArray : array of Integer;
      fLen : Integer;
   // Procedures
   function GetVal(index : Integer) : Integer;
   public
   // Procedures
   constructor Create();
   procedure GetArr(pArray : array of Integer);                                 // Fill the list by array
   procedure Append(value: Integer);                                            // Add change to the end of list
   procedure Insert(pos : Integer; value: Integer);                             // Insert change to the position of list
   procedure Delete(pos : Integer);                                             // Delete changes from list by position
   function GetIndexByValue(value : Integer) : TInteger;                        // Get the array of indexes by value
   procedure Clear;                                                             // Clear a list
   destructor Destroy();override;
   property Values[index : Integer] : Integer read GetVal;
   property Len : Integer read fLen;
   end;
   //
   // Auxilary class Sorted list of Instance class
   TInstanceList = class
   private
   // Attributes
      fArray : array of TInstanceConstr;
      fLen : Integer;
   // Procedures
   function GetVal(index : Integer) : TInstanceConstr;
   public
   // Procedures
   function GetAddr(index : Integer) : Pointer;                                 // Get address of element
   constructor Create();
   procedure Append(value: TInstanceConstr);                                    // Add change to the end of list
   procedure Insert(pos : Integer; value: TInstanceConstr);                     // Insert change to the position of list
   procedure Delete(pos : Integer);                                             // Delete changes from list by position
   procedure Clear;                                                             // Clear a list
   function IsIn(ids : array of Integer): Boolean;                              // True if the instance in a list
   function SearchbyID(ids : array of Integer) : TInstanceConstr;               // Search an instance by own id
   destructor Destroy();override;
   property Values[index : Integer] : TInstanceConstr read GetVal;
   property Len : Integer read fLen;
   end;
   //
   TInstList = class(TList)
   private
   function GetVal(index : Integer) : TInstanceConstr;
   function GetLen() : Integer;
   public
   function  IsIn(pid : array of Integer) : Boolean;                            // True if the instance in a list
   function SearchbyID(ids : array of Integer) : TInstanceConstr;               // Search an instance by own id
   procedure Append(value: TInstanceConstr);overload;                                    // Add change to the end of list
   procedure InsInst(index: Integer; value:TInstanceConstr);                    // Inserting an instance
   procedure ClearListbyNone;                                                   // Clear list by none status
   property Values[index : Integer] : TInstanceConstr read GetVal;
   property Len : Integer read GetLen;
   end;

implementation
// procedures of class  TInstanceConstr
//   class  TInstanceConstr
   constructor TInstanceConstr.Create();
   begin
        fID := nil;
        fOldStatus := None;
   end;
//   class  TInstanceConstr
   destructor TInstanceConstr.Destroy();
   begin
   try
      fID := nil;
      FreeandNil(fID);
      inherited Destroy;
    except
          On E : Exception do
          ShowMessage('TMatter.Destroy - Error: '+E.Message);
    end;
   end;
   //   class  TInstanceConstr
   function    TInstanceConstr.GetID() : TInteger;                    // get the instance identifier
   begin
        Result := fID;
   end;

//   class  TInstanceConstr
   procedure  TInstanceConstr.ReadID(pID: array of Integer);          // read id key field from database
   var
     i: Integer;
   begin
        SetLength(self.fID, Length(pID));
        for i:= 0 to Length(pID) - 1 do
            self.fID[i]:=pID[i];
        finOrder := False;
        fStatus := None;
   end;

//   class  TInstanceConstr
   procedure  TInstanceConstr.Dispose();                              // exlude class example from queue
   begin
      finOrder := False;
    end;
//   class  TInstanceConstr
    procedure  TInstanceConstr.InQueue();
    begin
      finOrder := True;
    end;
//   class  TInstanceConstr
   procedure  TInstanceConstr.ChangeStatus(newStatus : TInStatus);    // change the current status
   begin
   // Inserted status be unchanged before deleted
    if (fStatus <> Inserted) then
       if (fStatus = None) and (foldStatus <> None) then
          fStatus := foldStatus
       else
         begin
           foldStatus := fStatus;
           fStatus := newStatus;
         end
    else
    // Delete the inserted data proceed by excluding from queue
        if (newStatus = Deleted) or (newStatus = None) then
           begin
                fStatus := None;
                foldStatus := fStatus;
                finOrder := False;
           end;

    end;
//   class  TInstanceConstr
    function  TInstanceConstr.GetQueord() : Boolean;                            // define is class example in queue
    begin
         Result := finOrder;
    end;
    function   TInstanceConstr.Textrepr(): String;
    begin
    end;
    function   TInstanceConstr.Getproperties(): TStringArray;
    begin
    end;
//   class  TInstanceConstr
    function   TInstanceConstr.RepresentID(): String;                            // Represent an id of instance
    var
      Text,del : String;
      i : Integer;
    begin
      Text := '';
      del := '';
      for i := 0 to Length(fID) - 1 do
          begin
               Text := Text + del + Inttostr(fID[i]);
               del := ';';
          end;
      Result := Text;
    end;

//
// procedures of class  TSortList
//   class  TSortList
   constructor TSortList.Create();
   begin
        fArray := nil;
        fLen := 0;
   end;
//   class  TSortList
   destructor TSortList.Destroy();
   begin
   try
      fArray := nil;
      FreeandNil(fArray);
      fLen := 0;
      inherited Destroy;
    except
          On E : Exception do
          ShowMessage('TSortList.Destroy - Error: '+E.Message);
    end;
   end;
   //   class  TSortList
   procedure TSortList.GetArr(pArray : array of Integer);                               // Fill the list by array
   var
     i : Integer;
   begin
    for i:= Low(pArray) to High(pArray) do
               begin
                SetLength(fArray,Length(fArray) + 1);
                fArray[Length(fArray) - 1] := pArray[i];
               end;
   end;
   //   class  TSortList
   procedure TSortList.Append(value: Integer);                                          // Add change to the end of list
   begin
      SetLength(fArray, Length(fArray) + 1);
      fArray[Length(fArray) - 1] := value;
      fLen := fLen + 1;
   end;
   //   class  TSortList
   procedure TSortList.Insert(pos : Integer; value: Integer);                           // Insert change to the position of list
   var
   i : Integer;
 begin
      if (pos > fLen - 1)  then
         raise Exception.Create('Exception TSortList: the Insert operation are not allowed')
      else
      begin
      SetLength(fArray, Length(fArray) + 1);
      for i := Length(fArray) - 2 downto pos do
          begin
             fArray[i+1] := fArray[i];
          end;
      fArray[pos] := value;
      fLen := fLen + 1;

      end;
 end;
   //   class  TSortList
   procedure TSortList.Delete(pos : Integer);                                           // Delete changes from list by position
   var
   i : Integer;
 begin
      if (fLen <= 0) or (pos > fLen - 1) then
         raise Exception.Create('Exception TSortList: the delete operation are not allowed')
      else
            for i := pos to Length(fArray) - 2 do
                fArray[i] := fArray[i+1];
      SetLength(fArray, Length(fArray) - 1);
      fLen := fLen - 1;
 end;
   //   class  TSortList
   function TSortList.GetIndexByValue(value : Integer) : TInteger;              // Get the array of indexes by value
   var
      i: Integer;
   begin
        Result := nil;
        for i:= Low(fArray) to High(fArray) do
            if (fArray[i] = value) then
               begin
                SetLength(Result, Length(Result) + 1);
                Result[Length(Result) - 1] := i;
               end;
   end;
   //   class  TSortList
   procedure TSortList.Clear;                                                    // Clear a list
   begin
      fArray := nil;
      fLen := 0;

   end;

   //   class  TSortList
   function TSortList.GetVal(index : Integer) : Integer;                         // Get a value from list by Index
   begin
     if (fLen <= 0) or (index > fLen - 1) then
         raise Exception.Create('Exception TSortList: index out of range')
      else
      Result := fArray[index];
   end;
//


// procedures of class  TInstanceList
  constructor TInstanceList.Create();
  begin
        fArray := nil;
        fLen := 0;
   end;
  //class  TInstanceList
  procedure TInstanceList.Append(value: TInstanceConstr);                                          // Add change to the end of list
   begin
      SetLength(fArray, Length(fArray) + 1);
      fArray[Length(fArray) - 1] := value;
      fLen := fLen + 1;
   end;
  //class  TInstanceList
  procedure TInstanceList.Insert(pos : Integer; value: TInstanceConstr);                           // Insert change to the position of list
   var
   i : Integer;
  begin
      if (pos > fLen - 1)  then
         raise Exception.Create('Exception TInstanceList: the Insert operation are not allowed')
      else
      begin
      SetLength(fArray, Length(fArray) + 1);
      for i := Length(fArray) - 2 downto pos do
          begin
             fArray[i+1] := fArray[i];
          end;
      fArray[pos] := value;
      fLen := fLen + 1;

      end;
  end;
  //class  TInstanceList
  procedure TInstanceList.Delete(pos : Integer);                                           // Delete changes from list by position
   var
   i : Integer;
  begin
      if (fLen <= 0) or (pos > fLen - 1) then
         raise Exception.Create('Exception TInstanceList: the delete operation are not allowed')
      else
            for i := pos to Length(fArray) - 2 do
                fArray[i] := fArray[i+1];
      SetLength(fArray, Length(fArray) - 1);
      fLen := fLen - 1;
  end;
  //class  TInstanceList
  procedure TInstanceList.Clear;                                                           // Clear a list
   begin
      fArray := nil;
      fLen := 0;

   end;
  //class  TInstanceList
  function TInstanceList.GetVal(index : Integer) : TInstanceConstr;
   begin
     if (fLen <= 0) or (index > fLen - 1) then
         raise Exception.Create('Exception TInstanceList: index out of range')
      else
      Result := fArray[index];
   end;
  //class  TInstanceList
  destructor TInstanceList.Destroy();
   begin
   try
      fArray := nil;
      FreeandNil(fArray);
      fLen := 0;
      inherited Destroy;
    except
          On E : Exception do
          ShowMessage('TInstanceList.Destroy - Error: '+E.Message);
    end;
   end;
   //   class  TInstanceList
   function TInstanceList.IsIn(ids : array of Integer): Boolean;                             // True if the instance in a list
   var
      i,j : Integer;
   begin
      Result := False;
      if (Length(ids) = 0) then Exit;

      for i := low(fArray) to High(fArray) do
             begin
             if (Length(ids) <> Length(fArray[i].GetID())) then
               Result := False
             else
               Result := True;
              if Result then
                begin
                 for j := low(ids) to High(ids) do
                     if (ids[j] <> fArray[i].GetID()[j]) then Result := False;
                if Result then Exit;
                end;
             end;
   end;
   //   class  TInstanceList
   function TInstanceList.SearchbyID(ids : array of Integer) : TInstanceConstr;                        // Search an instance by own id
   var
      i,j : Integer;
   begin
      Result := nil;
      if (Length(ids) = 0) then Exit;

      for i := low(fArray) to High(fArray) do
             begin
             if (Length(ids) <> Length(fArray[i].GetID())) then
               Result := nil
             else
                begin
                 for j := low(ids) to High(ids) do
                     if (ids[j] <> fArray[i].GetID()[j]) then
                       Result := nil
                     else
                       begin
                        Result := fArray[i];
                        Exit;
                       end;
                end;
             end;
   end;
  //
  function TInstanceList.GetAddr(index : Integer) : Pointer;                                  // Get address of element
  begin
       Result := @fArray[0];

  end;
  // Procedure of class TInstList
  // TInstList
  function  TInstList.IsIn(pid : array of Integer) : Boolean;                  // True if the instance in a list
  var
     i,j:Integer;
     pt : PTInstanceConstr;
  begin

      Result := False;
      if (Length(pid) = 0) or (self.Count < 1) then Exit;

      for i := 0 to self.Count - 1 do
             begin
              pt := self.Items[i];
             if (Length(pid) <> Length(pt^.GetID())) then
               Result := False
             else
               Result := True;
              if Result then
                begin
                 for j := low(pid) to High(pid) do
                     if (pid[j] <> pt^.GetID()[j]) then Result := False;
                if Result then Exit;
                end;
             end;
  end;
  // TInstList
  function TInstList.GetVal(index : Integer) : TInstanceConstr;
  var
   pt : PTInstanceConstr;
  begin
       pt := self.Items[index];
       Result := pt^;
  end;

  // TInstList
   function TInstList.GetLen() : Integer;
   begin
        Result := self.Count;
   end;

   // TInstList
   function TInstList.SearchbyID(ids : array of Integer) : TInstanceConstr;     // Search an instance by own id
   var
      i,j : Integer;
      pt : PTInstanceConstr;
   begin
      Result := nil;
      if (Length(ids) = 0) or (self.Count < 1) then Exit;

      for i := 0 to self.Count - 1 do
             begin
              pt := self.Items[i];
             if (Length(ids) <> Length(pt^.GetID())) then
               Result := nil
             else
                begin
                 for j := low(ids) to High(ids) do
                     if (ids[j] <> pt^.GetID()[j]) then
                       Result := nil
                     else
                       begin
                        Result := pt^;
                        Exit;
                       end;
                end;
             end;
   end;
   // TInstList
   procedure TInstList.Append(value: TInstanceConstr);                          // Add change to the end of list
   var
      i,j : Integer;
      pt : PTInstanceConstr;
   begin
       New(pt);
       pt^ := value;
       self.Add(pt);
   end;
   // TInstList
   procedure TInstList.InsInst(index: Integer; value:TInstanceConstr);                    // Inserting an instance
   var
      pt : PTInstanceConstr;
   begin
       New(pt);
       pt^ := value;
       self.Insert(index,pt);
   end;
   // TInstList
   procedure TInstList.ClearListbyNone;                                         // Clear list by none status
   var
      i : Integer;
      pt : PTInstanceConstr;
   begin
      for i := self.Count - 1 downto 0 do
             begin
              pt := self.Items[i];
              if pt^.Status = None then
                self.Delete(i);
             end;
   end;

end.

