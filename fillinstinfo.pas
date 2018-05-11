unit Fillinstinfo;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,unit_classes,service_bd,Instance_class,ComCtrls;

type
  TStrinarray = array of String;

  function Fillmaterialinfo(id : Integer) : Pointer;                            // Fill the instance of class material from database
  function Fillgeometryinfo(id : Integer) : Pointer;                            // Fill the instance of class geometry from database
  function Fillelementinfo(id : Integer) : Pointer;                             // Fill the instance of class element from database
  function Fillsubassemblyinfo(id : Integer):Pointer;                           // Fill the instance of class element_list
  function Fillcurposition(id : Integer):Pointer;                               // Fill the instance of class position
  procedure Fillnuclids(P : Pointer);                                           // Fill material by list of nuclid
  procedure Fillsurfaces(P : Pointer);                                          // Fill geometry by list of surfaces

  // TREE PROCEDURES

   procedure Upmgdetail(Node: TTreeNode;TV : TTreeView);             // Update detail data for Compostion material and geometry
   procedure Upnuclnode(Node: TTreeNode;TV : TTreeView);             // Updata data for Compostion material nuclids
   procedure Upsurfnode(Node: TTreeNode;TV : TTreeView);             // Updata data for Compostion geometry surfaces
   procedure UpelementL(Node: TTreeNode;TV : TTreeView);             // Update data for Element level
   procedure UpcompositionL(Node: TTreeNode;TV : TTreeView);         // Update data for Composition Level

implementation

function Fillmaterialinfo(id : Integer) : Pointer;                            // Fill the instance of class material from database
var
  mat : TMatter;
  i : Integer;
  Pnuclids : TNuclidLists;
begin
    Pnuclids := nil;
    Result := nil;
    mat := GetMaterialByIndex(id);
    if mat <> nil then
    begin
       Fillnuclids(@mat);
    end;
    Result := @mat;
end;


function Fillgeometryinfo(id : Integer) : Pointer;                              // Fill the instance of class geometry from database
var
  geom : TGeometry;
  Faces : TGFaces;
  i : integer;
begin
    Faces := nil;
    Result := nil;
    geom := GetGeometrybyIndex(id);
    if (geom <> nil) then
    begin
       Fillsurfaces(@geom);
    end;
    Result := @geom;
end;

function Fillelementinfo(id : Integer) : Pointer;                               // Fill the instance of class element from database
var
  elem : TElement;
  i : Integer;

begin
    Result := nil;
    elem := GetElementByIndex(id);
    if (elem <> nil) then
    begin
       elem.ReadCompositions(GetCompositionList([id]));
    end;
    Result := @elem;
end;

function Fillsubassemblyinfo(id : Integer):Pointer;                             // Fill the instance of class element_list
var
  elem : TElement_list;
begin
    Result := nil;
    elem := TElement_list.Create(GetElementByIndex(id));
    if (elem <> nil) then
    begin
       elem.ReadPositions(GetPositionListbyIndex([id]));
    end;
    elem.ChangePositionsStatus(Selected);
    Result := @elem;
end;

function Fillcurposition(id : Integer):Pointer;                                 // Fill the instance of class position
begin

end;

procedure Fillnuclids(P : Pointer);                                             // Fill material by list of nuclid
var
  pMat: PTMatter;
  i : Integer;
  Pnuclids : TNuclidLists;
begin
  pMat := P;
  GetNuclidListByIndex(Pnuclids,[pMat^.ID]);
    for i:=0 to Length(Pnuclids) - 1 do
       begin
         pMat^.AddNuclid(Pnuclids[i]);
         pMat^.Nuclids[i].ChangeStatus(Selected);
       end;


end;

procedure Fillsurfaces(P : Pointer);                                          // Fill geometry by list of surfaces
var
  Faces : TGFaces;
  i : integer;
  pgeom : PTGeometry;
begin
   pgeom := P;
   Faces := GetListofFaces([pgeom^.ID]);
       for i:=0 to Length(Faces) - 1 do
       begin
         pgeom^.AddSurf(Faces[i]);
         pgeom^.Faces[i].ChangeStatus(Selected);
       end;

end;

// TREE VIEW PROCEDURE

//  TREE VIEW

    //  TREE VIEW
  procedure Upnuclnode(Node: TTreeNode;TV : TTreeView);                       // Updata data for Compostion material nuclids
  var
     pMat : PTMatter;
     pNucl : PTNuclidList;
     i : Integer;
  begin
     TV.BeginUpdate;
     pMat := Node.Data;
     if (pMat <> nil) then
        begin

        if (Node.Count < 1) then
               begin
           if (pMat^.NumNuclid < 1) then Fillnuclids(pMat);
          if (pMat^.NumNuclid > 0) then


                for i := 0 to pMat^.NumNuclid - 1 do
                    begin
                         New(pNucl);
                         pNucl^ := pMat^.Nuclids[i];
                         TV.Items.AddChildObject(Node,pNucl^.Name, pNucl);

                    end;
               end;

        end;
     TV.EndUpdate;
  end;
   //  TREE VIEW
  procedure Upsurfnode(Node: TTreeNode;TV : TTreeView);                       // Updata data for Compostion geometry surfaces
  var
     pGeom : PTGeometry;
     pSurf : PTGSurf;
     i : Integer;
  begin
     TV.BeginUpdate;
     pGeom := Node.Data;
     if (pGeom <> nil) then

        begin
         if (Node.Count < 1) then
               begin
          if (pGeom^.NumSurf < 1) then Fillsurfaces(pGeom);
          if (pGeom^.NumSurf > 0) then


                for i := 0 to pGeom^.NumSurf - 1 do
                    begin
                         New(pSurf);
                         pSurf^ := pGeom^.Faces[i];
                         TV.Items.AddChildObject(Node,pSurf^.Name, pSurf);
                    end;
               end;

        end;
     TV.EndUpdate;
  end;

  procedure UpcompositionL(Node: TTreeNode;TV : TTreeView);             // Update data for Element level
   var
     pMat : PTMatter;
     pGeom : PTGeometry;
     pComp : PTComposition;
     i : Integer;
  begin
     TV.BeginUpdate;
     pComp := Node.Data;
     if (pComp <> nil) then

        begin
         if (Node.Count < 1) then
               begin
           if (pComp^.Geometry <> nil) then
             begin

             New(pGeom);

             pGeom^ := pComp^.Geometry;

             TV.Items.AddChildObject(Node,pGeom^.Name, pGeom);

             end;

          if (pComp^.Material <> nil) then
             begin

             New(pMat);

             pMat^ := pComp^.Material;

             TV.Items.AddChildObject(Node,pMat^.Name, pMat);

             end;


        end;
     TV.EndUpdate;
  end;

  end;

  procedure UpelementL(Node: TTreeNode;TV : TTreeView);         // Update data for Composition Level
  var
     pElement : PTElement;
     pComp : PTComposition;
     i : Integer;
  begin
     TV.BeginUpdate;
     pElement := Node.Data;
     if (pElement <> nil) then

        begin
         if (Node.Count < 1) then
               begin
          if (pElement^.NumComp < 1) then
             begin

                  //New(pElement);

                  pElement^.ReadCompositions(GetCompositionList([pElement^.id]));

             end;
          if (pElement^.NumComp > 0) then


                for i := 0 to pElement^.NumComp - 1 do
                    begin
                         New(pComp);
                         pComp^ := pElement^.Compositions[i];
                         TV.Items.AddChildObject(Node,pComp^.Textrepr(), pComp);
                    end;
               end;

        end;
     TV.EndUpdate;
  end;
  //  TREE VIEW
  procedure Upmgdetail(Node: TTreeNode;TV : TTreeView);                       // Update detail data for Compostion material and geometry
  var
     pComp : PTComposition;
     p : Pointer;
     i,j : Integer;

  begin
     pComp := Node.Parent.Data;
       j := -1;
       if (pComp <> nil) then
       begin
          for i := 0 to Node.Parent.Count - 1 do
              if (Node.Parent.Items[i] = Node) then j := i;
          if (j = 0) then
            Upsurfnode(Node,TV)
          else
            if (j = 1) then Upnuclnode(Node,TV) ;
       end;

  end;




//

end.

