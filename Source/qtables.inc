procedure Initialization_query();
 var
 i: Integer;
 NameofTable: String;
 fields: array of TField;
 id_table: String;
 fkeys,ftables : array of String;
 begin
     //////////TEMP//////////////////////////
     //Editing_material := TInstanceList.Create();
     Editing_material := TInstList.Create;
     Editing_geometry := TInstList.Create;
     Editing_element := TInstList.Create;
     Editing_subassembly := TInstList.Create;
     ////////////////////////////////////////
     SetLength(QTables, 0);
     //
     SetLength(fkeys, 0);
     SetLength(ftables, 0);
     SetLength(fields, 0);
     // Table NUCLID    0
     NameofTable := 'NUCLID';
     id_table := 'ID';
     SetLength(fields, 4);
     fields[3].Fname := 'ID';
     fields[3].FType := 'I';

     fields[0].Fname := 'MASS';
     fields[0].FType := 'F';

     fields[1].Fname := 'NAME';
     fields[1].FType := 'S';
     fields[1].FLen := 8;

     fields[2].Fname := 'DESCRIPTION';
     fields[2].FType := 'S';
     fields[2].FLen := 80;
     SetLength(QTables, Length(QTables) + 1);
     QTables[Length(QTables) - 1] := TTable.Create(NameofTable,id_table,['ID'],
     ftables);
     QTables[Length(QTables) - 1].isGenerator:=False;
     for i:=0 to Length(fields) - 1 do
         QTables[Length(QTables) - 1].Fields[i] := fields[i];
     // Table MATERIAL     1
     NameofTable := 'MATERIAL';
     id_table := 'ID';
     SetLength(fields, 6);
     fields[5].Fname := 'ID';
     fields[5].FType := 'I';

     fields[0].Fname := 'DENSITY';
     fields[0].FType := 'F';

     fields[1].Fname := 'NAME';
     fields[1].FType := 'S';
     fields[1].FLen  := 256;

     fields[2].Fname := 'DESCRIPTION';
     fields[2].FType := 'S';
     fields[2].FLen  := 256;

     fields[3].Fname := 'TEMPERATURE';
     fields[3].FType := 'F';

     fields[4].Fname := 'MASSA';
     fields[4].FType := 'F';

     SetLength(QTables, Length(QTables) + 1);
     QTables[Length(QTables) - 1] := TTable.Create(NameofTable,id_table,['ID'],
     ftables);
     QTables[Length(QTables) - 1].isGenerator:=True;
     for i:=0 to Length(fields) - 1 do
         QTables[Length(QTables) - 1].Fields[i] := fields[i];
     //
     // Table NUCLID_LIST    2
     NameofTable := 'NUCLID_LIST';
     id_table := '';
     SetLength(fields, 6);
     fields[0].Fname := 'CONC';
     fields[0].FType := 'F';

     fields[1].Fname := 'FRAC';
     fields[1].FType := 'F';

     fields[2].Fname := 'MASS';
     fields[2].FType := 'F';

     fields[3].Fname := 'NUMATOM';
     fields[3].FType := 'I';

     fields[4].Fname := 'ID_M';
     fields[4].FType := 'I';

     fields[5].Fname := 'ID_N';
     fields[5].FType := 'I';
    { SetLength(fkeys, 2);
     SetLength(ftables, 2);

     fkeys[0] := 'ID_M';
     ftables[0] := 'MATERIAL';

     fkeys[1] := 'ID_N';
     ftables[1] := 'NUCLID';}

     SetLength(QTables, Length(QTables) + 1);
     QTables[Length(QTables) - 1] := TTable.Create(NameofTable,id_table,['ID_M','ID_N'],
     ftables);
     QTables[Length(QTables) - 1].isGenerator:=False;
     for i:=0 to Length(fields) - 1 do
         QTables[Length(QTables) - 1].Fields[i] := fields[i];
     QTables[Length(QTables) - 1].LinkParent(1,4);
	
     // TABLE GEOMETRYSURF   3
     NameofTable := 'GEOMETRYSURF';
     id_table := 'ID';
     SetLength(fields, 4);
     fields[3].Fname := 'ID';
     fields[3].FType := 'I';

     fields[0].Fname := 'NDIM';
     fields[0].FType := 'I';

     fields[1].Fname := 'NAME';
     fields[1].FType := 'S';
     fields[1].FLen := 60;

     fields[2].Fname := 'DESCRIPTION';
     fields[2].FType := 'S';
     fields[2].FLen := 8;
     SetLength(QTables, Length(QTables) + 1);
     QTables[Length(QTables) - 1] := TTable.Create(NameofTable,id_table,['ID'],
     ftables);
     QTables[Length(QTables) - 1].isGenerator:=False;
     for i:=0 to Length(fields) - 1 do
         QTables[Length(QTables) - 1].Fields[i] := fields[i];
     // Table GEOMETRY    4
     NameofTable := 'GEOMETRY';
     id_table := 'ID';
     SetLength(fields, 4);
     fields[3].Fname := 'ID';
     fields[3].FType := 'I';

     fields[0].Fname := 'AREA';
     fields[0].FType := 'F';

     fields[1].Fname := 'NAME';
     fields[1].FType := 'S';
     fields[1].FLen  := 80;

     fields[2].Fname := 'DESCRIPTION';
     fields[2].FType := 'S';
     fields[2].FLen  := 256;

     SetLength(QTables, Length(QTables) + 1);
     QTables[Length(QTables) - 1] := TTable.Create(NameofTable,id_table,['ID'],
     ftables);
     QTables[Length(QTables) - 1].isGenerator:=True;
     for i:=0 to Length(fields) - 1 do
         QTables[Length(QTables) - 1].Fields[i] := fields[i];
     //
     // Table GEOMETRYSURF_LIST   5
     NameofTable := 'GEOMETRYSUFR_LIST';
     id_table := 'ID';
     SetLength(fields, 11);
     fields[0].Fname := 'DIM1';
     fields[0].FType := 'F';

     fields[1].Fname := 'DIM2';
     fields[1].FType := 'F';

     fields[2].Fname := 'DIM3';
     fields[2].FType := 'F';

     fields[3].Fname := 'ANGLE';
     fields[3].FType := 'F';

     fields[4].Fname := 'POS1';
     fields[4].FType := 'F';

     fields[5].Fname := 'POS2';
     fields[5].FType := 'F';

     fields[6].Fname := 'POS3';
     fields[6].FType := 'F';

     fields[7].Fname := 'RTYPE';
     fields[7].FType := 'I';

     fields[8].Fname := 'ID_G';
     fields[8].FType := 'I';

     fields[9].Fname := 'ID_F';
     fields[9].FType := 'I';

     fields[10].Fname := 'ID';
     fields[10].FType := 'I';
    { SetLength(fkeys, 2);
     SetLength(ftables, 2);

     fkeys[0] := 'ID_M';
     ftables[0] := 'MATERIAL';

     fkeys[1] := 'ID_N';
     ftables[1] := 'NUCLID';}

     SetLength(QTables, Length(QTables) + 1);
     QTables[Length(QTables) - 1] := TTable.Create(NameofTable,id_table,['ID_G','ID_F','ID'],
     ftables);
     QTables[Length(QTables) - 1].isGenerator:=True;
     for i:=0 to Length(fields) - 1 do
         QTables[Length(QTables) - 1].Fields[i] := fields[i];
     QTables[Length(QTables) - 1].LinkParent(4,8);// (to table,from field)

     // Table ELEMENT   6
     NameofTable := 'ELEMENT';
     id_table := 'ID';
     SetLength(fields, 4);
     fields[3].Fname := 'ID';
     fields[3].FType := 'I';

     //fields[0].Fname := 'AREA';
     //fields[0].FType := 'F';

     fields[0].Fname := 'NAME';
     fields[0].FType := 'S';
     fields[0].FLen  := 80;

     fields[1].Fname := 'DESCRIPTION';
     fields[1].FType := 'S';
     fields[1].FLen  := 256;
     
     fields[2].Fname := 'ETYPE';
     fields[2].FType := 'I';

     SetLength(QTables, Length(QTables) + 1);
     QTables[Length(QTables) - 1] := TTable.Create(NameofTable,id_table,['ID'],
     ftables);
     QTables[Length(QTables) - 1].isGenerator:=True;
     for i:=0 to Length(fields) - 1 do
         QTables[Length(QTables) - 1].Fields[i] := fields[i];
     
     // Table COMPOSITION_LIST  7
     NameofTable := 'COMPOSITION_LIST';
     id_table := '';
     SetLength(fields, 4);
     fields[0].Fname := 'NUMBER';
     fields[0].FType := 'I';

     fields[2].Fname := 'ID_E';
     fields[2].FType := 'I';

     fields[3].Fname := 'ID_G';
     fields[3].FType := 'I';
    
     fields[1].Fname := 'ID_M';
     fields[1].FType := 'I';

     SetLength(QTables, Length(QTables) + 1);
     QTables[Length(QTables) - 1] := TTable.Create(NameofTable,id_table,['ID_E','ID_G'],
     ftables);
     QTables[Length(QTables) - 1].isGenerator:=False;
     for i:=0 to Length(fields) - 1 do
         QTables[Length(QTables) - 1].Fields[i] := fields[i];
     QTables[Length(QTables) - 1].LinkParent(6,2);
        // Table ELEMENT_LIST  8
      NameofTable := 'ELEMENT_LIST';
     id_table := 'ID';
     SetLength(fields, 6);
     fields[5].Fname := 'ID';
     fields[5].FType := 'I';

     fields[0].Fname := 'ANGLE';
     fields[0].FType := 'F';

     fields[1].Fname := 'POSX';
     fields[1].FType := 'F';

     fields[2].Fname := 'POSY';
     fields[2].FType := 'F';

     fields[3].Fname := 'POSZ';
     fields[3].FType := 'F';

     fields[4].Fname := 'ID_E';
     fields[4].FType := 'I';

     SetLength(QTables, Length(QTables) + 1);
     QTables[Length(QTables) - 1] := TTable.Create(NameofTable,id_table,['ID_E','ID'],
     ftables);
     QTables[Length(QTables) - 1].isGenerator:=True;
     for i:=0 to Length(fields) - 1 do
         QTables[Length(QTables) - 1].Fields[i] := fields[i];
    //
     //
      // Table MESH    9
     NameofTable := 'MESH';
     id_table := '';
     SetLength(fields, 4);

     fields[0].Fname := 'NUMPOSITIONS';
     fields[0].FType := 'I';

     fields[1].Fname := 'PITCH';
     fields[1].FType := 'F';

     fields[2].Fname := 'ITYPE';
     fields[2].FType := 'I';

     fields[3].Fname := 'ID_EL';
     fields[3].FType := 'I';

     SetLength(QTables, Length(QTables) + 1);
     QTables[Length(QTables) - 1] := TTable.Create(NameofTable,id_table,['ID_EL'],
     ftables);
     QTables[Length(QTables) - 1].isGenerator:=FALSE;
     for i:=0 to Length(fields) - 1 do
         QTables[Length(QTables) - 1].Fields[i] := fields[i];
     QTables[Length(QTables) - 1].LinkParent(8,3);
     //

    // Table Position 10
    NameofTable := 'POSITIONLIST';
     id_table := '';
     SetLength(fields, 3);
     fields[2].Fname := 'IPOS';
     fields[2].FType := 'I';

     fields[1].Fname := 'ID_EL';
     fields[1].FType := 'I';

     fields[0].Fname := 'ID_E';
     fields[0].FType := 'I';

     SetLength(QTables, Length(QTables) + 1);
     QTables[Length(QTables) - 1] := TTable.Create(NameofTable,id_table,['ID_EL','IPOS'],
     ftables);
     QTables[Length(QTables) - 1].isGenerator:=False;
     for i:=0 to Length(fields) - 1 do
         QTables[Length(QTables) - 1].Fields[i] := fields[i];
     QTables[Length(QTables) - 1].LinkParent(8,1);

     SetLength(fkeys, 0);
     SetLength(ftables, 0);
     SetLength(fields, 0);
     Queue := TQueue.Create();

 end;
