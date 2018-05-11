unit Service_bd;
// Bind between database and class entity
{$mode objfpc}{$H+}

interface

uses
  StdCtrls, DBGrids, Classes,Windows,SysUtils,qtable_class,Dialogs,IBQuery,IBDatabase,unit_classes,System_info,Service,Instance_class;


  type TNuclidLists = array of TNuclidList;
  TGeneratorSQL = class
    private
    fSourceText : String;
    fisSuccess : Boolean;
    function ExecInsert(num : Integer;params : TStringArray) : Boolean;         // Execute an insertion statement
    function ExecUpdate(num : Integer;ids,params : TStringArray) : Boolean;     // Execute modifying statement
    function ExecDelete(num : Integer;ids: TStringArray) : Boolean;             // Execute a removing statement
    public
    //TGeneratorSQL
    Constructor Create(Const txt : String);                                     //
    procedure Readtext(Const txt : String);                                     // Read a text with change
    function Parse : Boolean;                                                   // parse a string and call executive
    Destructor Destroy; override;
   end;
  //
  function ExecSelect(var Query:TIBQuery;var Trans:TIBTransaction;numberofQtable: integer;const pIDs : array of Integer) : Boolean;// Fullfil a selection query
  function ExecGenerator (numberofQtable: integer;Const Shift : Integer = 0): Integer;                     //Function ExecGenetator
  function WriteBackupInfo(desc : String) : Boolean;                             // Wirte current database into backup version
  function GetVersionInfo() : Integer;                                           // Get a number of current database version
  function GetNuclidByIndex(index : Integer): TNuclid;                           //Get the TNuclid Instance by ID
  function GetNuclidByName(name : String): TNuclid;                              //Get the TNuclid Instance by name of nuclid
  function GetMaterialByIndex(ID : Integer): TMatter;                            //Get the TMatter Instance by ID
  procedure GetNuclidListByIndex(var nucl : TNuclidLists;where: array of Integer);//Get the TMatter Instance by ID
  function GetGSurfbyIndex(index : Integer): TGSurf;                             // Get GSurf instance by ID
  function GetGeometrybyIndex(ID : Integer):TGeometry ;                          // Get geometry by index
  function GetListofFaces(where: array of Integer):TGFaces;                      // Get faces of geometry
  function GetElementByIndex(ID : Integer): Telement;                           // Get Element instance by ID
  function GetCompositionList(where : array of Integer): TComposes;             // Get an array of Compositions
  function GetMshbyIndex(index : Integer) : TMesh;                              // Get a mesh instance by ID
  function GetPositionListbyIndex(where : array of Integer):TPositions;         // Get a list of positions by ID
  function GetPlacementListbyIndex(where : array of Integer): TPlacements ;     // Get a placement list by ID

implementation
uses DataModule;
function ExecSelect(var Query:TIBQuery;var Trans:TIBTransaction;numberofQtable:integer;const pIDs : array of Integer): Boolean;   // Fullfil a selection query
var

  isWrite : Boolean;
    name : String;
    i: Integer;
begin
   isWrite:=False;
   Result := False;
//   DM.AssignIBTransaction(Query, Trans, isWrite);
  try
    if (Query.Transaction.Active) then Query.Transaction.Active := False;
      Query.Transaction.StartTransaction();
      if (Length(pIDs) > 0) then
         Query.SQL.Text := QTables[numberofQtable].GetSelect(Length(pIDs))
      else
         Query.SQL.Text := QTables[numberofQtable].GetSelect();
      Query.Prepare();
      if (Length(pIDs) > 0) then
         for i:= 0 to Length(pIDs)-1 do
             Query.ParamByName(QTables[numberofQtable].IDs[i]).AsInteger := pIDs[i];
      Query.Open();
      Query.FetchAll();
      Query.First();
      if (Query.RecordCount > 0) then
         Result:=True;
    except on e : Exception do
    begin{e - новый дескриптор ошибки}
      MessageDlg(e.message,mtError,[mbOK],0);
      Query.Transaction.Rollback;
      Query.Free;
      Trans.Free;
      Exit;
    end;
  end;
  //Query.Free();
  //Trans.Free();
end;
  //
  function ExecGenerator (numberofQtable: integer;Const Shift : Integer = 0): Integer;
  var
       Query:TIBQuery;
       Trans:TIBTransaction;
  begin
    Result := -1;
    Query := nil;
    Trans := nil;
    DM.AssignIBTransaction(Query, Trans, False);
     try
    if (Query.Transaction.Active) then Query.Transaction.Active := False;
      Query.Transaction.StartTransaction();
      Query.SQL.Text := QTables[numberofQtable].GetGenerator(Shift);
      Query.Prepare();
      Query.Open();
      Query.FetchAll();
      Query.First();
      if (Query.RecordCount > 0) then
         Result:=Query.Fields[0].AsInteger;
      Query.Free;
      Trans.Free;
    except on e : Exception do
    begin{e - новый дескриптор ошибки}
      Result:=-1;
      MessageDlg(e.message,mtError,[mbOK],0);
      Query.Transaction.Rollback;
      Query.Free;
      Trans.Free;
      Exit;
    end;
  end;
  end;

  //
  function GetNuclidByIndex(index : Integer): TNuclid;                          //Get the TNuclid Instance by ID
  var
    Query:TIBQuery;
    Trans:TIBTransaction;
  begin
    Query := nil;
    Trans := nil;
    DM.AssignIBTransaction(Query, Trans, False);
    if (ExecSelect(Query,Trans,0,[index])) then
       try
          Result := TNuclid.Create(Query.FieldbyName('ID').ASInteger,
          Query.FieldbyName('MASS').ASFloat,Query.FieldbyName('NAME').ASString);

       except on e : Exception do {e - новый дескриптор ошибки}
          MessageDlg(e.message,mtError,[mbOK],0);
       end;
    Query.Free();
    Trans.Free();
  end;
  //
    function GetNuclidByName(name : String): TNuclid;                              //Get the TNuclid Instance by name of nuclid
    var
  SQLText : string;
  Query   : TIBQuery;
  Trans   : TIBTransaction;
begin
  Query := nil;
  Trans := nil;
  DM.AssignIBTransaction(Query, Trans);
  Result := nil;
  try
    if (Query.Transaction.Active) then Query.Transaction.Active := False;
    Query.Transaction.StartTransaction();
    SQLText := 'select * from NUCLID where NAME=:NAME';
    Query.SQL.Text := SQLText;
    Query.Prepare();
    Query.ParamByName('NAME').AsString := UpperCase(name);
    Query.Open();
    Query.FetchAll();
    Query.First();
    if (Query.RecordCount > 0) then
    Result := TNuclid.Create(Query.FieldbyName('ID').ASInteger,
          Query.FieldbyName('MASS').ASFloat,Query.FieldbyName('NAME').ASString);
    Query.Transaction.Commit();

  except on e : Exception do
    begin {e - новый дескриптор ошибки}
      MessageDlg(e.message, mtError, [mbOK], 0);
      Query.Transaction.Rollback();
      Query.Free();
      Result := nil;
      Trans.Free();
      Exit;
    end;
  end;
  Query.Free();
  Trans.Free();
end;
  //
  function GetMaterialByIndex(ID : Integer): TMatter;                            //Get the TMatter Instance by ID
  var
    Query:TIBQuery;
    Trans:TIBTransaction;
  begin
     Query := nil;
     Trans := nil;
     DM.AssignIBTransaction(Query, Trans, False);
     if (ExecSelect(Query,Trans,1,[ID])) then
       try

          Result := TMatter.Create(Query.FieldbyName('ID').ASInteger,Query.FieldbyName('NAME').ASString);
          Result.Description := Query.FieldbyName('DESCRIPTION').ASString;
          Result.Density := Query.FieldbyName('DENSITY').ASFloat;
          Result.Weight := Query.FieldbyName('MASSA').ASFloat;
          Result.Temperature := Query.FieldbyName('TEMPERATURE').ASFloat;
          Result.ReadID([ID]);
       except on e : Exception do {e - новый дескриптор ошибки}
          MessageDlg(e.message,mtError,[mbOK],0);
       end
     else
         begin
              raise Exception.Create('Error: Material was not found');
              Result := nil;
              Exit;

         end;
    Query.Free();
    Trans.Free();
  end;
  //
  procedure GetNuclidListByIndex(var nucl : TNuclidLists;where: array of Integer);//Get the TMatter Instance by ID
  var
    nuclid : TNuclid;
    i,idn : Integer;
    Query:TIBQuery;
    Trans:TIBTransaction;
    ids: array of Integer;
  begin
     SetLength(nucl, 0);
     SetLength(ids, Length(where) + 1);
     Query := nil;
     Trans := nil;
     DM.AssignIBTransaction(Query, Trans, False);
     if (ExecSelect(Query,Trans,2,where)) then
       begin
            i:=0;
       try
          //for i:= 0 to Query.RecordCount - 1 do
          while not Query.EOF do
              begin
                   SetLength(nucl, Length(nucl) + 1);
                   idn := Query.FieldbyName('ID_N').ASInteger;
                   nuclid  := GetNuclidByIndex(idn);
                   nucl[i] :=   TNuclidList.Create(nuclid);
                   ids[0] := where[0];
                   ids[1] := idn;
                   nucl[i].ReadID(ids);
                   nucl[i].Fraction := Query.FieldbyName('FRAC').ASFloat;
                   nucl[i].Weight   := Query.FieldbyName('MASS').ASFloat;
                   nucl[i].Concentration := Query.FieldbyName('CONC').ASFloat;
                   nucl[i].NumAtom  := Query.FieldbyName('NUMATOM').ASInteger;
                   Query.Next();
                   i:=i+1;
                   //Result := TMatter.Create(Query.FieldbyName('ID').ASInteger,Query.FieldbyName('NAME').ASString,1);
              end;
       except on e : Exception do {e - новый дескриптор ошибки}
          MessageDlg(e.message,mtError,[mbOK],0);
       end;

       end;
       //ptn := @nucl;
       Query.Free();
       Trans.Free();
       ids := nil;
  end;
  //
    function GetGSurfbyIndex(index : Integer):TGSurf;                           // Get GSurf instance by ID
    var
    Query:TIBQuery;
    Trans:TIBTransaction;
  begin
    Query := nil;
    Trans := nil;
    DM.AssignIBTransaction(Query, Trans, False);
    if (ExecSelect(Query,Trans,3,[index])) then
       try
          Result := TGSurf.Create(Query.FieldbyName('ID').ASInteger,
          Query.FieldbyName('NAME').ASString,Query.FieldbyName('NDIM').ASInteger,Query.FieldbyName('DESCRIPTION').ASString);

       except on e : Exception do {e - новый дескриптор ошибки}
          MessageDlg(e.message,mtError,[mbOK],0);
       end;
    Query.Free();
    Trans.Free();
  end;
//
  function GetGeometrybyIndex(ID : Integer):TGeometry;                          // Get geometry by index
   var
    Query:TIBQuery;
    Trans:TIBTransaction;
  begin
     Query := nil;
     Trans := nil;
     DM.AssignIBTransaction(Query, Trans, False);
     if (ExecSelect(Query,Trans,4,[ID])) then
       try
          Result := TGeometry.Create(Query.FieldbyName('ID').ASInteger,Query.FieldbyName('NAME').ASString);
          Result.Description := Query.FieldbyName('DESCRIPTION').ASString;
          Result.AREA := Query.FieldbyName('AREA').ASFloat;
          Result.ReadID([ID]);
       except on e : Exception do {e - новый дескриптор ошибки}
          MessageDlg(e.message,mtError,[mbOK],0);
       end
     else
         begin
              raise Exception.Create('Error: Material was not found');
              Result := nil;
              Exit;

         end;
    Query.Free();
    Trans.Free();
  end;
  //
function GetListofFaces(where: array of Integer):TGFaces;                      // Get faces of geometry
var
   face : TGSurf;
   i,j,idg : Integer;
   Query:TIBQuery;
   Trans:TIBTransaction;
   ids: array of Integer;
 begin
    Result := nil;
    SetLength(Result, 0);
    SetLength(ids, Length(ids) + 2);
    Query := nil;
    Trans := nil;
    DM.AssignIBTransaction(Query, Trans, False);
    if (ExecSelect(Query,Trans,5,where)) then
      begin
           i:=0;
      try
         while not Query.EOF do
             begin
                  SetLength(Result, Length(Result) + 1);
                  idg := Query.FieldbyName('ID_F').ASInteger;
                  face  := GetGSurfbyIndex(idg);
                  if face.Numberdim > 0 then face.Dimension[0] := Query.FieldbyName('DIM1').ASFloat;
                  if face.Numberdim > 1 then face.Dimension[1] := Query.FieldbyName('DIM2').ASFloat;
                  if face.Numberdim > 2 then face.Dimension[2] := Query.FieldbyName('DIM3').ASFloat;
                  face.Angle := Query.FieldbyName('ANGLE').ASFloat;
                  if not (Query.FieldbyName('POS1').IsNull) then face.Position[0] := Query.FieldbyName('POS1').AsFloat;
                  if not (Query.FieldbyName('POS2').IsNull) then face.Position[1] := Query.FieldbyName('POS2').AsFloat;
                  if not (Query.FieldbyName('POS3').IsNull) then face.Position[2] := Query.FieldbyName('POS3').AsFloat;
                  face.RTYPE := Query.FieldbyName('RTYPE').ASInteger;
                  face.IDp := Query.FieldbyName('ID').ASInteger;
                  ids[0] := where[0];
                  ids[1] := idg;
                  ids[2] := Query.FieldbyName('ID').ASInteger;
                  face.ReadID(ids);
                  Result[Length(Result) - 1] := face;
                  Query.Next();
                  i:=i+1;

             end;
      except on e : Exception do {e - новый дескриптор ошибки}
         MessageDlg(e.message,mtError,[mbOK],0);
      end;

      end;
      Query.Free();
      Trans.Free();
 end;
  //

  function GetElementByIndex(ID : Integer): Telement;                           // Get Element instance by ID
  var
    Query:TIBQuery;
    Trans:TIBTransaction;
  begin
     Query := nil;
     Trans := nil;
     DM.AssignIBTransaction(Query, Trans, False);
     if (ExecSelect(Query,Trans,6,[ID])) then
       try
          Result := TElement.Create(Query.FieldbyName('ID').ASInteger,Query.FieldbyName('NAME').ASString);
          Result.Description := Query.FieldbyName('DESCRIPTION').ASString;
          Result.ETYPE := Query.FieldbyName('ETYPE').ASInteger;
          Result.ReadID([ID]);
       except on e : Exception do {e - новый дескриптор ошибки}
          MessageDlg(e.message,mtError,[mbOK],0);
       end
     else
         begin
              raise Exception.Create('Error: Element was not found');
              Result := nil;
              Exit;

         end;
    Query.Free();
    Trans.Free();
  end;
  function GetCompositionList(where : array of Integer): TComposes;             // Get an array of Compositions
  var
   Compos : array of TComposition;
   i,j,idg : Integer;
   Query:TIBQuery;
   Trans:TIBTransaction;
   ids: array of Integer;
 begin
    Result := nil;
    SetLength(ids, 2);
    Query := nil;
    Trans := nil;
    Compos := nil;
    DM.AssignIBTransaction(Query, Trans, False);
    if (ExecSelect(Query,Trans,7,where)) then
      begin
           i:=0;
      try
         while not Query.EOF do
             begin
                  SetLength(Compos, Length(Compos) + 1);
                  idg := Query.FieldByName('ID_G').AsInteger;
                  Compos[Length(Compos) - 1] := TComposition.Create(GetgeometrybyIndex(idg));
                  Compos[Length(Compos) - 1].Number := Query.FieldbyName('NUMBER').ASInteger;
                  Compos[Length(Compos) - 1].Material := GetmaterialbyIndex(Query.FieldByName('ID_M').AsInteger);
                  ids[0] := where[0];
                  ids[1] := Query.FieldByName('ID_G').AsInteger;
                  //ids[2] := Query.FieldByName('ID_M').AsInteger;
                  Compos[Length(Compos) - 1].ReadID(ids);
                  Query.Next();
                  i:=i+1;

             end;
         Result := Compos;
      except on e : Exception do {e - новый дескриптор ошибки}
         MessageDlg(e.message,mtError,[mbOK],0);
      end;

      end;
      Query.Free();
      Trans.Free();
 end;
  //
   function GetPlacementListbyIndex(where : array of Integer): TPlacements ;                              // Get an element list by ID
    var
   i,j,idg : Integer;
   Query:TIBQuery;
   Trans:TIBTransaction;
   ids: array of Integer;
 begin
    Result := nil;
    SetLength(ids, 2);
    Query := nil;
    Trans := nil;
    DM.AssignIBTransaction(Query, Trans, False);
    if (ExecSelect(Query,Trans,10,where)) then
      begin
           i:=0;
      try
         while not Query.EOF do
             begin
                  SetLength(Result, Length(Result) + 1);
                  idg := Query.FieldByName('IPOS').AsInteger;
                  Result[Length(Result) - 1] := TPlacement.Create(GetElementByIndex(Query.FieldByName('ID_E').AsInteger));
                  ids[0] := where[0];
                  ids[1] := idg;
                  Result[Length(Result) - 1].ReadID(ids);
                  Query.Next();
                  i:=i+1;

             end;
      except on e : Exception do {e - новый дескриптор ошибки}
         MessageDlg(e.message,mtError,[mbOK],0);
      end;

      end;
      Query.Free();
      Trans.Free();
 end;
  //
  function GetMshbyIndex(index : Integer):TMesh;                                      // Get a mesh instance by ID
  var
    Query:TIBQuery;
    Trans:TIBTransaction;
  begin
     Query := nil;
     Trans := nil;

     DM.AssignIBTransaction(Query, Trans, False);
     if (ExecSelect(Query,Trans,9,[index])) then
       try
          Result := TMesh.Create(Query.FieldbyName('ITYPE').ASInteger);
          Result.Number := Query.FieldbyName('NUMPOSITIONS').ASInteger;
          Result.Pitch := Query.FieldbyName('PITCH').ASFloat;
          Result.ReadID([index]);
          Result.ChangeStatus(Selected);
       except on e : Exception do {e - новый дескриптор ошибки}
          MessageDlg(e.message,mtError,[mbOK],0);
       end
     else
         begin
             // raise Exception.Create('Error: Mesh was not found');
              Result := nil;
              //Exit;

         end;
    Query.Free();
    Trans.Free();
  end;
  //
  function GetPositionListbyIndex(where : array of Integer):TPositions;                             // Get a list of positions by ID
   var
   i,j,idg : Integer;
   Query:TIBQuery;
   Trans:TIBTransaction;
   ids: array of Integer;
 begin
    Result := nil;
    SetLength(ids, 2);
    Query := nil;
    Trans := nil;
    DM.AssignIBTransaction(Query, Trans, False);
    if (ExecSelect(Query,Trans,8,where)) then
      begin
           i:=0;
      try
         while not Query.EOF do
             begin
                  SetLength(Result, Length(Result) + 1);
                  idg := Query.FieldByName('ID').AsInteger;
                  Result[Length(Result) - 1] := TPosition.Create(idg);
                  Result[Length(Result) - 1].X := Query.FieldbyName('POSX').ASFloat;
                  Result[Length(Result) - 1].Y := Query.FieldbyName('POSY').ASFloat;
                  Result[Length(Result) - 1].Z := Query.FieldbyName('POSZ').ASFloat;
                  Result[Length(Result) - 1].Angle := Query.FieldbyName('ANGLE').ASFloat;
                  ids[0] := where[0];
                  ids[1] := idg;
                  Result[Length(Result) - 1].ReadID(ids);
                  Result[Length(Result) - 1].ReadPlacements(GetPlacementListbyIndex(idg));
                  Result[Length(Result) - 1].AddMesh(GetMshbyIndex(Query.FieldByName('ID').AsInteger));
                  Query.Next();
                  i:=i+1;

             end;
      except on e : Exception do {e - новый дескриптор ошибки}
         MessageDlg(e.message,mtError,[mbOK],0);
      end;

      end;
      Query.Free();
      Trans.Free();
 end;
  //

  function WriteBackupInfo(desc : String) : Boolean;                             // Wirte current database into backup version
    var
    Query:TIBQuery;
    Trans:TIBTransaction;
    SQLText : string;
    begin
     Result := False;
     Query := nil;
     Trans := nil;
     DM.AssignIBTransaction(Query, Trans, False);
     try
     if (Query.Transaction.Active) then Query.Transaction.Active := False;
      Query.Transaction.StartTransaction();
      SQLText := 'insert into VERSIONS (DESCRIPTION,OLDID) values (:DESCRIPTION,:OLDID)';
      Query.SQL.Text := SQLText;
      Query.Prepare();
      Query.ParamByName('DESCRIPTION').AsString := desc;
      Query.ParamByName('OLDID').AsInteger := VI._vnumber;
      Query.ExecSQL;
      Query.Transaction.Commit();
      Result := True;
     except on e : Exception do
    begin {e - новый дескриптор ошибки}
      MessageDlg(e.message, mtError, [mbOK], 0);
      Query.Transaction.Rollback();
      Query.Free();
      Trans.Free();
      Exit;
    end;
     end;
     Query.Free();
     Trans.Free();
    end;

    //
  function GetVersionInfo() : Integer;                                           // Get a number of current database version
  var
  SQLText : string;
  Query   : TIBQuery;
  Trans   : TIBTransaction;
begin
  Query := nil;
  Trans := nil;
  DM.AssignIBTransaction(Query, Trans);
  Result := -1;
  try
    if (Query.Transaction.Active) then Query.Transaction.Active := False;
    Query.Transaction.StartTransaction();
    SQLText := 'select * from VERSIONS';
    Query.SQL.Text := SQLText;
    Query.Prepare();
    Query.Open();
    Query.FetchAll();
    Query.Last();
    Result := Query.FieldByName('ID').ASInteger;
    Query.Transaction.Commit();

  except on e : Exception do
    begin {e - новый дескриптор ошибки}
      MessageDlg(e.message, mtError, [mbOK], 0);
      Query.Transaction.Rollback();
      Query.Free();
      Result := -1;
      Trans.Free();
      Exit;
    end;
  end;
  Query.Free();
  Trans.Free();
end;

   // Procedure of class TGeneratorSQL
   function TGeneratorSQL.Parse : Boolean;                                      // parse a string and call executive
   var
   s,ids,params : TStringArray;
   num : Integer;
   begin
      s := WorkStr(self.fSourceText,#9);
      num := StrtoInt(s[0]);
      case s[1] of
         'u':

                Result :=  self.ExecUpdate(num,WorkStr(s[2],';'),WorkStr(s[3],';'));

         'i':

                Result :=  self.ExecInsert(num,WorkStr(s[2],';'));

         'd':

                Result :=  self.ExecDelete(num,WorkStr(s[2],';'));

      end;
   end;
   // Procedure of class TGeneratorSQL
    Constructor TGeneratorSQL.Create(Const txt : String);                       //
    begin
      self.fSourceText := txt;
      self.fisSuccess := False;
    end;
    // Procedure of class TGeneratorSQL
    procedure TGeneratorSQL.Readtext(Const txt : String);                       // Read a text with change
    begin
      self.fSourceText := txt;
      self.fisSuccess := False;
    end;
    // Procedure of class TGeneratorSQL
    function TGeneratorSQL.ExecInsert(num : Integer;params : TStringArray) : Boolean;// Execute an insertion statement
    var
        Query   : TIBQuery;
        Trans   : TIBTransaction;
        i : Integer;
    begin
      DM.AssignIBTransaction(Query, Trans,True);
      Result := False;
    try
      if (Query.Transaction.Active) then Query.Transaction.Active := False;
      Query.Transaction.StartTransaction();

      Query.SQL.Text := QTables[num].GetInsert();
      Query.Prepare();
      for i:= 0 to Length(params) - 1 do
          if (not QTables[num].isGenerator) or (QTables[num].Fields[i].FName <> QTables[num].genID) then
            if (QTables[num].Foreignkey = i) and (Strtoint(params[i]) = 0) then
               Query.ParamByName(QTables[num].Fields[i].FName).AsInteger := ExecGenerator(QTables[num].GetParent)
            else
                Query.ParamByName(QTables[num].Fields[i].FName).AsString := params[i];
      Query.ExecSQL;
      Query.Transaction.Commit();
      Result := True;
    except on e : Exception do
      begin {e - новый дескриптор ошибки}
        MessageDlg(e.message, mtError, [mbOK], 0);
        Query.Transaction.Rollback();
        Query.Free();
        Trans.Free();
        Exit;
      end;
    end;
    Query.Free();
    Trans.Free();
    end;
    // Procedure of class TGeneratorSQL
    function TGeneratorSQL.ExecUpdate(num : Integer;ids,params : TStringArray) : Boolean;// Execute modifying statement
     var
        Query   : TIBQuery;
        Trans   : TIBTransaction;
        i : Integer;
    begin
      DM.AssignIBTransaction(Query, Trans,True);
      Result := False;
    try
      if (Query.Transaction.Active) then Query.Transaction.Active := False;
      Query.Transaction.StartTransaction();

      Query.SQL.Text := QTables[num].GetUpdate(Length(ids));
      Query.Prepare();
      for i:= 0 to Length(params) - 1 do
            Query.ParamByName(QTables[num].Fields[i].FName).AsString := params[i];
      for i:= 0 to Length(ids) - 1 do
            Query.ParamByName(QTables[num].IDs[i]).AsString := ids[i];
      Query.ExecSQL;
      Query.Transaction.Commit();
      Result := True;
    except on e : Exception do
      begin {e - новый дескриптор ошибки}
        MessageDlg(e.message, mtError, [mbOK], 0);
        Query.Transaction.Rollback();
        Query.Free();
        Trans.Free();
        Exit;
      end;
    end;
    Query.Free();
    Trans.Free();
    end;
    // Procedure of class TGeneratorSQL
    function TGeneratorSQL.ExecDelete(num : Integer;ids: TStringArray) : Boolean;// Execute a removing statement
    var
        Query   : TIBQuery;
        Trans   : TIBTransaction;
        i : Integer;
    begin
      DM.AssignIBTransaction(Query, Trans,True);
      Result := False;
    try
      if (Query.Transaction.Active) then Query.Transaction.Active := False;
      Query.Transaction.StartTransaction();
      Query.SQL.Text := QTables[num].GetDelete(Length(ids));
      Query.Prepare();
      for i:= 0 to Length(ids) - 1 do
            Query.ParamByName(QTables[num].IDs[i]).AsString := ids[i];
      Query.ExecSQL;
      Query.Transaction.Commit();
      Result := True;
    except on e : Exception do
      begin {e - новый дескриптор ошибки}
        MessageDlg(e.message, mtError, [mbOK], 0);
        Query.Transaction.Rollback();
        Query.Free();
        Trans.Free();
        Exit;
      end;
    end;
    Query.Free();
    Trans.Free();
    end;
    // Procedure of class TGeneratorSQL
     Destructor TGeneratorSQL.Destroy;
     begin
     try
     inherited Destroy;
     except
     On E : Exception do
       ShowMessage('TGeneratorSQL.Destroy - Error: '+E.Message);
end;
end;

end.

