unit unit_classes;

{$mode delphi}

interface

uses
  Classes, SysUtils,Dialogs,QTable_class,Instance_class,Service;
type

  TStringArray = array of string;
  // Class of basis nuclids TNuclid
  TNuclid = class(TInstanceConstr)
  protected
    // Attributes
    fIndex: integer;
    fName: string;
    fMass: real;
    fDefaultTemp: real;
  public
    // Procedures
    constructor Create(ind: integer; m: real; nam: string);
    destructor Destroy; override;
    function   Textrepr(): String; override;               // Get a text representation of a class
    // Properties
    property Index: integer read fIndex;
    property Name: string read fName;
    property Mass: real read fMass;
    property DefaultTemp: real read fDefaultTemp;
  end;
  // Class of material containing nuclids TNuclidList
  TNuclidList = class(TNuclid)
    protected
      // Attributes
      fTemp : real;
      fFrac : Real;
      fMasvol : Real;
      fConc : Real;
      fNumAtom : Integer;
    public
    // Procedures
    constructor Create(ind: integer; m: real; nam: string);overload;
    constructor Create(nuclid : Tnuclid);overload;

    // Properties
    property Temperature : real read fTemp write fTemp;
    property Fraction : real read fFrac write fFrac;
    property Weight : real read fMasvol write fMasvol;
    property Concentration : real read fConc write fConc;
    property NumAtom : Integer read fNumAtom write fNumAtom;
  end;
  PTnuclidlist = ^TNuclidList;
  PTNuclid = ^TNuclid;
//
  TGSurf = class(TInstanceConstr)
  protected
    // Attributes
    fDesc: String;
    fName: string;
    fID: integer;
    fpID : integer;
    fNDim : integer;
    fDimension: array of real;
    fPosition: array of real;
    fRType : integer;
    fRAngle : real;
    fparsedesc : array of String;
  private
     function  Getgeomertydesc(index : Integer) : String;
     function  GetDIM(index : Integer) : Real;
     function  GetPOS(index : Integer) : Real;
     procedure SetDIM(index : Integer; value : Real);
     procedure SetPOS(index : Integer; value : Real);
     procedure ParseDescription;
  public
    // Procedures
    constructor Create(ind: integer; nam: string;ndim: Integer; desc : String);
    destructor Destroy; override;
    function   Textrepr(): String; override;               // Get a text representation of a class
    // Properties
    property Name: string read fName;
    property Numberdim : integer read fNDIm ;
    property IDg : integer read fID;
    property IDp : integer read fpID write fpID;
    property FullDesc : String read fDesc;
    property Description[index : Integer]: String read Getgeomertydesc;
    property Dimension[index:Integer]:Real read GetDIM write SetDIM;
    property Position[index:Integer]:Real read GetPOS write SetPOS;
    property RTYPE: Integer read fRType write fRType;
    property Angle: Real read fRAngle write fRAngle;
  end;
  PTGSurf = ^TGSurf;

// Class of material
  TMatter = class(TInstanceConstr)
  protected
  // Attributes
    FNuclidNumber: integer;
    FName: string;
    FDesc: string;
    FDensity: Real;
    FMassvalue: Real;
    FTemperature : Real;
    // Attributes
    fNuclids: TList;
    function  GetNuclid(index : Integer) : TNuclidList;                         // Get the instance of Nuclid
    function  GetMatID() : Integer;                                             // Get Instance ID of Material
    // GET
  public
  // Procedures
    constructor Create(Const Name : String); overload;
    constructor Create(pID : Integer); overload;
    constructor Create(pID : Integer; Name : String);
    destructor Destroy; override;
    function   Textrepr(): String; override;                                    // Get a text representation of a class
    function   Getproperties(): TStringArray; override;                         // get the properties list from class
    function   GetNuclidproperties(idn : Integer): TStringArray;                // get the properties list from TNuclidList class
    function   GetNuclidAddr(index : Integer) : Pointer;                        // Get address of nuclid
    procedure AddNuclid(nucl : TNuclidList); overload;                          // Add nuclid to material
    procedure AddNuclid(nucl : TNuclid); overload;                              // Add nuclid to material with Change ID
    function  FindposbyIndex(nuclid_index : Integer) : Integer;                 // Check a nuclid index in material

    procedure DelNuclidbyName(name: String);                                    // Delete nuclid from material by name of nuclide
    procedure DelNuclidbyIndex(index: Integer);                                 // Delete nuclid from material by Change ID
    procedure Copy(pattern : TMatter);                                          // Copy all field value from pattern
    procedure ClearnuclidbyNone();                                              // Clear nuclidlist if status is None
    // Properties
    property Name : String read FName write FName;
    property Density : real read FDensity write FDensity;
    property Weight : real read FMassvalue write FMassvalue;
    property Temperature : real read FTemperature write FTemperature;
    property Description : String read FDesc write FDesc;
    property ID : integer read GetMatID;
    property Nuclids [index : Integer] : TNuclidList  Read GetNuclid;
    property NumNuclid : Integer Read FNuclidNumber;
  end;
  PTMatter = ^TMatter;
  // Class of Geometry object
  TGeometry = class(TInstanceConstr)
  protected
  // Attributes
    FSurfNumber: integer;
    FName: string;
    FDesc: string;
    FArea: Real;
  // Attributes
    fSurface: TList;
    function  GetSurface(index : Integer) : TGSurf;                             // Get the instance of Nuclid
    function  GetGeomID() : Integer;                                            // Get Instance ID of Material
    // GET
  public
  // Procedures
    constructor Create(Const Name : String); overload;
    constructor Create(pID : Integer); overload;
    constructor Create(pID : Integer; Name : String);
    destructor Destroy; override;
    function   Textrepr(): String; override;                                    // Get a text representation of a class
    function   Getproperties(): TStringArray; override;                         // get the properties list from class
    function   GetSurfaceproperties(idn : Integer): TStringArray;               // get the properties list from TGSurf class
    procedure AddSurf(gsurf : TGSurf);                                          // Add nuclid to material
    procedure DelSurfbyIndex(index: Integer);                                   // Delete nuclid from material by Change ID
    procedure Copy(pattern : TGeometry);                                        // Copy all field value from pattern
    procedure ClearsurfbyNone();                                                // Clear nuclidlist if status is None
    // Properties
    property Name : String read FName write FName;
    property AREA : real read FArea write FArea;
    property Description : String read FDesc write FDesc;
    property ID : integer read GetGeomID;
    property Faces [index : Integer] : TGSurf  Read GetSurface;
    property NumSurf : Integer Read FSurfNumber;
  end;
  TGFaces = array of TGSurf;
  PTGeometry = ^TGeometry;
  //
  // Class of composition = geometry + material TComposition
   TComposition = class(TInstanceConstr)
   protected
     // Attributes
     fCurrentNumber: integer;
     fGeometry : TGeometry;
   public
     Material : TMatter;
     // Procedures
     constructor Create(geom : TGeometry);
     destructor Destroy; override;
     function   Textrepr(): String; override;                                    // Get a text representation of a class
     function GetgeometryID : Integer;                                           // Get id of current geometry
     function GetmaterialID : Integer;                                           // Get id of current material
     // Properties
     property Number: integer read fCurrentNumber write fCurrentNumber;
     property Geometry: TGeometry read fGeometry;
     property IDg: Integer read GetgeometryID;
     property IDm: Integer read GetmaterialID;
     end;
     TComposes = array of TComposition;
     PTComposition = ^TComposition;
  // Class of Element object
  TElement = class(TInstanceConstr)
  protected
  // Attributes
    FComposNumber: integer;
    fID : integer;
    FName: string;
    fNumPosition : Integer;// Property of subassembly
    FDesc: string;
    FETYPE: Integer;
  // Attributes
    fComp: TList;
    function  GetComposition(index : Integer) : TComposition;                   // Get the instance of a Composition
    function  GetElmntID() : Integer;                                           // Get Instance ID of Element
    // GET
  public
  // Procedures
    constructor Create(Const Name : String); overload;
    constructor Create(pID : Integer); overload;
    constructor Create(pID : Integer; Name : String);
    destructor Destroy; override;
    function   Textrepr(): String; override;                                    // Get a text representation of a class
    function   Getproperties(): TStringArray; override;                         // get the properties list from class
    function   GetCompositionproperties(idn : Integer): TStringArray;           // get the properties list from TGComposition class
    procedure AddComp(comp : TComposition);overload;                            // Add composition to element
    procedure AddComp(geom : TGeometry);overload;                               // Add new composition based on pointed geometry
    procedure DelCompbyIndex(index: Integer);                                   // Delete composition from element by Change ID
    procedure Copy(pattern : TElement);                                         // Copy all field value from pattern
    procedure ClearcompbyNone();                                                // Clear Composition list if status is None
    procedure ReadCompositions(compositiones : array of TComposition);         // Read an array of compositions
    // Properties
    property Name : String read FName write FName;
    property ETYPE : Integer read FETYPE write FETYPE;
    property Description : String read FDesc write FDesc;
    property ID : integer read GetElmntID;
    property Compositions [index : Integer] : TComposition  Read GetComposition;
    property NumComp : Integer Read FComposNumber;
    // Property of subassembly
    property NumPosition : Integer Read fNumPosition write fNumPosition;
  end;
   PTElement = ^TElement;
   TElements = array of TElement;
  //end;
  // Class of Mesh
   TMesh = class(TInstanceConstr)
   protected
     // Attributes
     fNumber: integer;
     fPitch : real;
     ftype : integer;
     fDesc : string;
   public
     // Procedures
     constructor Create(mtype: Integer);
     destructor Destroy; override;
     function   Textrepr(): String; override;                                    // Get a text representation of a class
     function Getdesc : String;                                                  // Get text representation of mesh
     function GetmeshID : Integer;                                               // Get id of current mesh
     // Properties
     property Number: integer read fNumber write fNumber;
     property Pitch: Real read fPitch write fPitch;
     property mtype : Integer read ftype write ftype;
     property Description : String read Getdesc;
     property ID : Integer read GetmeshID;
     end;

     PTMesh = ^TMesh;
     // Class TPlacement declaration
     TPlacement = class (TInstanceConstr)
       protected
         // Attributes
         fIndex : Integer;
         felementID : Integer;
         fElement : TElement ;
       public
       // Procedures
       constructor Create(eID : Integer;Const eName : String); overload;
       constructor Create(Element : TElement);overload;
       destructor Destroy; override;
       function   Textrepr(): String; override;                                 // Get a text representation of a class
       function Getdesc : String;                                               // Get text representation of placement
       function GetIndex : Integer;                                             // Get a placement index
       function GetelementID : Integer;                                         // Get an ID of containing element
       function GetelpID(): Integer;                                               // Get an ID of position
       procedure ReadElement(element : TElement);                               // Read an external element
       procedure FreeElement;                                                   // Free an existing element
       // Properties
       property Index : integer read GetIndex;
       property elementID : integer read GetelementID;
       property Element : TElement read fElement;
       property epID : integer read GetelpID;

     end;
     PTPlacement = ^TPlacement;
     TPlacements = array of TPlacement;
     // Class TPosition declaration
     TPosition = class(TInstanceConstr)
  protected
  // Attributes
    FPlacementNumber: integer;
    fMsh : TMesh;
    fAngle : Real;
    fX : Real;
    fY : Real;
    fZ :Real;
    fPlace: TList;
    // GET
    function  GetPlacement(index : Integer) : TPlacement;                            // Get the instance of a Placement
    function  GetPosID() : Integer;                                              // Get Instance ID of Position
  public
    unique_number : Integer;
  // Procedures
    constructor Create(pID : Integer); overload;
    constructor Create(pID : Integer;Placements : array of TPlacement;Mesh:TMesh);overload;
    destructor Destroy; override;
   // function Compareby(Item1,Item2: Pointer): Integer;                        // Sorted function by Placement ID
    function GetFirstU : Integer;                                               // Get the first unique number
    function GetNextU : Integer;                                                // Get an another unique number,nil otherwise
    function   Textrepr(): String; override;                                    // Get a text representation of a class
    function   Getproperties(): TStringArray; override;                         // get the properties list from class
    function   GetPlaceproperties(idn : Integer): TStringArray;                 // get the properties list from TPlacement class
    function   GetMshProperty(): TStringArray;                                  // get a text representation of msh class
    function  AddMesh(msh : TMesh):Boolean;                                     // Add msh to current position
    procedure DelMesh();                                                        // Delete reference on Mesh from position
    procedure AddPlace(place : TPlacement);                                     // Add placement to position
    procedure DelPlacebyIndex(index: Integer);                                  // Delete placement from position by Change ID
    procedure Copy(pattern : TPosition);                                        // Copy all field value from pattern
    procedure ClearposbyNone();                                                 // Clear Placement list if status is None
    procedure ReadPlacements(Placements : array of TPlacement);                 // Read an array of Placements
    procedure ChangeallStatus(newStatus : TInStatus);                           // Change status of all components
    // Properties
    property ID : integer read GetPosID;

    property Placements [index : Integer] : TPlacement  Read GetPlacement;
    property NumPlacement : Integer Read FPlacementNumber;
    property Msh : TMesh read fMsh;
    property X : real read fX write fX;
    property Y: real read fY write fY;
    property Z : real read fZ write fZ;
    property Angle : real read fAngle write fAngle;
  end;
  PTPosition = ^TPosition;
  Tpositions = array of TPosition;

  TElement_list = class(TElement)
  private
  fPosition_list: TList;
  fPosNumber : Integer;
  //procedures
  function GetPosition(index : Integer): TPosition;                             // Get postion index by Integer
  public

  constructor Create(elem : TElement);                                          // TElement_list
  destructor Destroy();override;
  procedure AddPos(pos : TPosition);                                            // Add position to element_list
  procedure DelPosbyIndex(index: Integer);                                      // Delete position from element_list by Change ID
  procedure Copy(pattern : TElement_list);                                      // Copy all field value from pattern
  procedure ClearelistbyNone();                                                 // Clear Placement list if status is None
  procedure ReadPositions(Positions : array of TPosition);                       // Read an array of postion
  procedure ChangePositionsStatus(newStatus : TInStatus);                       // Change status of poisitions

  //properties
  property Positions[index : Integer]: TPosition read GetPosition;
  property PositionNumber : Integer read  fPosNumber;

  end;

  PTElement_list = ^TElement_list;
  function Compareby(Item1,Item2: Pointer): Integer;                 // Sorted function by Placement ID
implementation
// Procedure of Class TNuclid
// Class TNuclid
constructor TNuclid.Create(ind: integer; m: real; nam: string);
begin
  fIndex := ind;
  fName := nam;
  fMass := m;
  //fDefaultTemp := temp;
end;
// Class TNuclid
destructor TNuclid.Destroy;
begin
  inherited;
end;
// Class TNuclid
function   TNuclid.Textrepr(): String;
begin
  Result := '';
  Result := Result + 'Nuclid name' + ' ' + self.Name;
end;

//
// Procedure of Class TNuclidList
// Class TNuclidList
constructor TNuclidList.Create(ind: integer; m: real; nam: string);
begin
   inherited Create(ind,m,nam);
end;
// Class TNuclidList
constructor TNuclidList.Create(nuclid : Tnuclid);
begin
   inherited Create(nuclid.Index,nuclid.Mass,nuclid.Name);
end;
//
// Procedures of Class TGSurf
// class TGSurf
   constructor TGSurf.Create(ind: integer; nam: string;ndim: Integer; desc : String);
   begin
      self.fID := ind;
      self.fName := nam;
      self.fNDim := ndim;
      self.fDesc := desc;
      self.fDimension := nil;
      self.fPosition := nil;
      self.fparsedesc := nil;
      SetLength(self.fDimension,self.fNDim);
      SetLength(self.fparsedesc,self.fNDim);
      SetLength(self.fPosition,3);
      self.ParseDescription;
   end;

// class TGSurf
   destructor TGSurf.Destroy;
   begin
   self.fDimension := nil;
   self.fPosition := nil;
   self.fparsedesc := nil;
   FreeandNil(self.fDimension);//??
   FreeandNil(self.fPosition); //??
   FreeandNil(self.fparsedesc);//??
   inherited;
   end;
// class TGSurf
   function   TGSurf.Textrepr(): String;
   begin
        Result := '';
        Result := Result + 'Geometry surface name' + ' ' + self.Name;
   end;
   // class TGSurf
   function  TGSurf.Getgeomertydesc(index : Integer) : String;
   begin
     Result := self.fparsedesc[index];
   end;

   // class TGSurf
   function  TGSurf.GetDIM(index : Integer) : Real;
   begin
      Result := self.fDimension[index];
   end;

   // class TGSurf
   function  TGSurf.GetPOS(index : Integer) : Real;
   begin
      Result := self.fPosition[index];
   end;

   // class TGSurf
   procedure TGSurf.SetDIM(index : Integer; value : Real);
   begin
       self.fDimension[index] := value;
   end;

   // class TGSurf
   procedure TGSurf.SetPOS(index : Integer; value : Real);
   begin
        self.fPosition[index] := value;
   end;

   // class TGSurf
   procedure TGSurf.ParseDescription;
   begin
        self.fparsedesc := WorkStr(self.fDesc,';');
   end;

   // Procedure of Class TComposition
   // Class TComposition
   constructor TComposition.Create(geom : TGeometry);
   begin
     fGeometry := geom;
     self.fCurrentNumber := -1;
     //fDefaultTemp := temp;
   end;
   // Class TComposition
   destructor TComposition.Destroy;
   begin
     fGeometry := nil;
     Material := nil;
     inherited;
   end;
   // Class TComposition
   function   TComposition.Textrepr(): String;                                        // Get a text representation of class instance
   begin
     Result := '';
     Result := Result + 'Composition with material name' + ' ' + self.Material.Name + ' and geometry name ' + self.fGeometry.Name;

   end;
   // Class TComposition
   function TComposition.GetgeometryID : Integer;                               // Get id of current geometry
   begin
      Result := self.Geometry.ID;
   end;
   // Class TComposition
   function TComposition.GetmaterialID : Integer;                               // Get id of current material
   begin
       Result := self.Material.ID;
   end;
//
// Procedures of class TMatter
// class TMatter
    constructor TMatter.Create(Const Name : String);
    begin
      FNuclidNumber := 0;
      FName := Name;
      fNuclids := TList.Create();
    end;
// class TMatter
    constructor TMatter.Create(pID : Integer);
    begin
      FNuclidNumber := 0;
      FName := 'Matter_with_id' + Inttostr(pID);
      self.ReadID([pID]);
      fNuclids := TList.Create();
    end;
// class TMatter
    constructor TMatter.Create(pID : Integer; Name : String);
     begin
      FNuclidNumber := 0;
      FName := Name;
      self.ReadID([pID]);
      fNuclids := TList.Create();
    end;
// class TMatter
    destructor TMatter.Destroy;
    begin
    try
       fNuclids.Free;
       inherited Destroy;
    except
          On E : Exception do
          ShowMessage('TMatter.Destroy - Error: '+E.Message);
    end;
    end;
// class TMatter
    function  TMatter.FindposbyIndex(nuclid_index : Integer) : Integer;         // Check a nuclid index in material
    var
      iNucl : Integer;
      pNucl : PTNuclidList;
    begin
        Result := -1;
        for iNucl:=0 to FNuclidNumber - 1 do
         begin
             pNucl := fNuclids.Items[iNucl];
             if (nuclid_index = pNucl^.Index) then
                begin
                    Result := iNucl;
                    Exit;
                end;
         end;
    end;

// class TMatter
    procedure TMatter.AddNuclid(nucl : TNuclidList);                            // Add nuclid to material
    var
      pNucl : PTNuclidList;
    begin
    if nucl <> nil then
         begin
        if (FindposbyIndex(nucl.Index) > -1) then
                begin
                    raise Exception.Create('TMatter Exception: Nuclid with index:' + Inttostr(nucl.Index) + 'is already exist');
                    Exit;
                end;
         New(pNucl);

         pnucl^ := TNuclidList.Create(nucl.Index,nucl.Mass,nucl.Name);
         pnucl^.Weight := nucl.Weight;
         pnucl^.Concentration := nucl.Concentration;
         pnucl^.Temperature := nucl.Temperature;
         pnucl^.Fraction := nucl.Fraction;
         pnucl^.NumAtom := nucl.NumAtom;
         pnucl^.ReadID([self.ID,nucl.Index]);
         fNuclids.Add(pNucl);
         FNuclidNumber := FNuclidNumber + 1;

         end;
    end;
// class TMatter
    procedure TMatter.AddNuclid(nucl : TNuclid);                                 // Add nuclid to material with Change ID
    var
      pNucl : PTNuclidList;
    begin
    if nucl <> nil then
         begin
         if (FindposbyIndex(nucl.Index) > -1) then
                begin
                    raise Exception.Create('TMatter Exception: Nuclid with index:' + Inttostr(nucl.Index) + 'is already exist');
                    Exit;
                end;

            New(pnucl);
            pnucl^ := TNuclidList.Create(nucl);
            pnucl^.ReadID([self.ID,nucl.Index]);
            fNuclids.Add(pNucl);
            FNuclidNumber := FNuclidNumber + 1;
         end;
    end;
// class TMatter
    function  TMatter.GetNuclid(index : Integer) : TNuclidList;                 // Get the instance of Nuclid
    var
      pNucl : PTNuclidList;
    begin
         pNucl := fNuclids.Items[index];
         Result := pNucl^;
    end;
// class TMatter
    function  TMatter.GetMatID() : Integer;                                     // Get Instance ID of Material
    begin
    if self.GetID() <> nil then Result := self.GetID()[0];
    end;

// class TMatter
    procedure TMatter.DelNuclidbyName(name: String);                            // Delete nuclid from material by name of nuclide
    var
      iNucl : Integer;
      pNucl : PTNuclidList;
    begin
    if (FNuclidNumber > 0) then
       begin
        for iNucl:=FNuclidNumber - 1 downto 0 do
           begin
           pNucl := fNuclids.Items[iNucl];
           if (pNucl^.Name = name) then
               fNuclids.Delete(iNucl);
           end;
       FNuclidNumber := FNuclidNumber - 1;
    end;
    end;

// class TMatter
    procedure TMatter.DelNuclidbyIndex(index: Integer);                         // Delete nuclid from material by Change ID
    var
      iNucl,jNucl : Integer;
      pNucl : PTNuclidList;
      begin
    if (FNuclidNumber > 0) then
       begin
       for iNucl:=FNuclidNumber - 1 downto 0 do
           begin
           pNucl := fNuclids.Items[iNucl];
           if (pNucl^.Index = index) then
               fNuclids.Delete(iNucl);
           end;
       FNuclidNumber := FNuclidNumber - 1;
    end;
    end;
// class TMatter
function   TMatter.Textrepr(): String;                                          // Get a text representation of a class
    begin
      Result := '';
      Result := Result + 'Material name' + ' ' + self.Name;
    end;
// class TMatter
function  TMatter.Getproperties(): TStringArray;                                // get the properties list from class
    begin
       Result := nil;
       SetLength(Result, 5);
       Result[0] := Floattostr(self.Density);
       Result[1] := ' ';
       if (self.Name <> '') then Result[1] := self.Name;
       Result[2] := ' ';
       if (self.Description <> '') then Result[2] := self.Description;
       Result[3] := Floattostr(self.Temperature);
       Result[4] := Floattostr(self.Weight);
    end;
// class TMatter
function   TMatter.GetNuclidproperties(idn : Integer): TStringArray;            // get the properties list from TNuclidList class
var
   pNucl : PTNuclidList;
begin
       Result := nil;
       pNucl  := self.fNuclids.Items[idn];
       SetLength(Result, 6);
       Result[0] := Floattostr(pNucl^.Concentration);
       Result[1] := Floattostr(pNucl^.Fraction);
       Result[2] := Floattostr(pNucl^.Weight);
       Result[3] := Inttostr(pNucl^.fNumAtom);
             if (self.Status <> Inserted) then
        Result[4] := Inttostr(self.ID)
        else
         Result[4] := '0';
       Result[5] := Inttostr(pNucl^.Index);
end;
// class TMatter
function   TMatter.GetNuclidAddr(index : Integer) : Pointer;                    // Get address of nuclid
begin
     Result := fNuclids.Items[index];
end;
// class TMatter
    procedure TMatter.Copy(pattern : TMatter);                                  // Copy all field value from pattern
    var
       i,ind: Integer;
       pnucl,ppnucl : PTNuclidList;
    begin

                 for i:=0 to self.fNuclids.Count-1 do
                     begin
                     pnucl := self.fNuclids.Items[i];
                     pnucl^.ChangeStatus(None);
                     end;
                 for i:=0 to pattern.NumNuclid - 1 do
                     begin
                          ppnucl := pattern.fNuclids.Items[i];
                          ind := FindposbyIndex(ppnucl^.Index);
                          if (ind > -1) then
                             begin
                                  pnucl := self.fNuclids.Items[ind];
                                  pnucl^.NumAtom := ppnucl^.NumAtom;
                                  pnucl^.Weight := ppnucl^.Weight;
                                  pnucl^.Concentration := ppnucl^.Concentration;
                                  pnucl^.Fraction := ppnucl^.Fraction;
                                  pnucl^.ChangeStatus(Modified);
                             end
                          else
                              begin
                                   self.AddNuclid(ppnucl^);
                                   pnucl := self.fNuclids.Items[self.fNuclids.Count - 1];
                                   pnucl^.ChangeStatus(Inserted);
                               end;

                       end;

                  self.Temperature := pattern.Temperature;
                  //self.Name := 'pattern_' + pattern.Name;
                  self.Description := pattern.Description;
                  self.Weight := pattern.Weight;
                  self.Density := pattern.Density;
                  self.ChangeStatus(Modified);
    end;

// class TMatter
    procedure TMatter.ClearnuclidbyNone();                                      // Clear nuclidlist if status is None
    var
      iNucl: Integer;
      pNucl : PTNuclidList;
      begin
      if (FNuclidNumber > 0) then
      for iNucl := FNuclidNumber - 1 downto 0 do
           begin
                pNucl := fNuclids.Items[iNucl];
                if (pNucl^.Status = None) then  self.DelNuclidbyIndex(pNucl^.Index);
           end;
      end;

//
// Procedures of class TGeometry
// class TGeometry
  constructor TGeometry.Create(Const Name : String);
  begin
       self.FSurfNumber := 0;
       self.FName := Name;
       self.fSurface := TList.Create;
  end;

// class TGeometry
  constructor TGeometry.Create(pID : Integer);
  begin
       self.FSurfNumber := 0;
       self.FName := 'Geometry_with_id' + Inttostr(pID);
       self.ReadID([pID]);
       self.fSurface := TList.Create;
  end;

  // class TGeometry
  constructor TGeometry.Create(pID : Integer; Name : String);
  begin
       self.FSurfNumber := 0;
       self.FName := Name;
       self.ReadID([pID]);
       self.fSurface := TList.Create;

  end;

  // class TGeometry
  destructor TGeometry.Destroy;
  begin
   try
       fSurface.Free;
       inherited Destroy;
    except
          On E : Exception do
          ShowMessage('TGeometry.Destroy - Error: '+E.Message);
    end;
  end;

  // class TGeometry
  function   TGeometry.Textrepr(): String;                                      // Get a text representation of a class
  begin
      Result := '';
      Result := Result + 'Geometry name' + ' ' + self.FName;
  end;
  // class TGeometry
  function   TGeometry.Getproperties(): TStringArray;                           // get the properties list from class
  begin
       Result := nil;
       SetLength(Result, 3);
       Result[0] := Floattostr(self.FArea);
       Result[1] := ' ';
       if (self.Name <> '') then Result[1] := self.Name;
       Result[2] := ' ';
       if (self.Description <> '') then Result[2] := self.Description;
    end;
  // class TGeometry
  function   TGeometry.GetSurfaceproperties(idn : Integer): TStringArray;       // get the properties list from TGSurf class
  var
   pSurf : PTGSurf;
   i : Integer;
   begin
       Result := nil;
       pSurf  := self.fSurface.Items[idn];
       SetLength(Result, 11);
       for i := 0 to pSurf^.Numberdim - 1 do
             Result[i] := Floattostr(pSurf^.Dimension[i]);
       for i := pSurf^.Numberdim to 2 do
             Result[i] := '0.0';
       Result[3] := Floattostr(pSurf^.Angle);
       for i := 4 to 6 do
             Result[i] := '0.0';
       Result[7] := Inttostr(pSurf^.RTYPE);
       if (self.Status <> Inserted) then
        Result[8] := Inttostr(self.ID)
        else
         Result[8] := '0';
       Result[9] := Inttostr(pSurf^.IDg);
       Result[10] := Inttostr(pSurf^.IDp);
   end;

  // class TGeometry
  procedure TGeometry.AddSurf(gsurf : TGSurf);                                            // Add nuclid to material
  var
      pSurf : PTGSurf;
      i : Integer;
  begin
      if gsurf <> nil then
      begin
       New(pSurf);
       pSurf^ := TGSurf.Create(gsurf.IDg,gsurf.Name,gsurf.Numberdim,gsurf.Fulldesc);
       for  i := 0 to gsurf.Numberdim - 1 do
           pSurf^.Dimension[i] := gsurf.Dimension[i];
       for  i := 0 to 2 do
           pSurf^.Position[i] := gsurf.Position[i];
       pSurf^.IDp:=gsurf.IDp;
       pSurf^.RTYPE:=gsurf.RTYPE;
       pSurf^.ReadID([self.ID,gsurf.IDg,gsurf.IDp]);
       self.fSurface.Add(pSurf);
       self.FSurfNumber:= self.FSurfNumber + 1;
      end;
  end;

  // class TGeometry
  procedure TGeometry.DelSurfbyIndex(index: Integer);                            // Delete nuclid from material by Change ID
  var
      pSurf : PTGSurf;
      i : Integer;
  begin

   if self.NumSurf > 0 then
      for i := self.NumSurf - 1 downto 0 do
          begin
             pSurf := self.fSurface[i];
             if (pSurf^.IDp = index) then
              begin
                self.fSurface.Delete(i);
                self.FSurfNumber := self.FSurfNumber - 1;
              end;
          end;

  end;

  // class TGeometry
  procedure TGeometry.Copy(pattern : TGeometry);                                        // Copy all field value from pattern
  var
      pSurf,ppSurf : PTGSurf;
      i : Integer;
  begin
      for i := self.NumSurf - 1 downto 0 do
          begin
           pSurf := self.fSurface.Items[i];
           pSurf^.ChangeStatus(None);
          end;
      ClearsurfbyNone;
      for i := 0 to pattern.NumSurf - 1 do
          begin
               ppSurf := pattern.fSurface.Items[i];
               self.AddSurf(ppSurf^);
               pSurf := self.fSurface.Items[self.fSurface.Count - 1];
               pSurf^.ChangeStatus(Inserted);
          end;
      self.FArea:= pattern.AREA;
      self.Description := pattern.Description;
      self.ChangeStatus(Modified);
  end;
  // class TGeometry
  function  TGeometry.GetSurface(index : Integer) : TGSurf;                             // Get the instance of GSurf
  var
    pSurf : PTGSurf;
  begin
    pSurf := self.fSurface.Items[index];
    Result := pSurf^;
  end;

  // class TGeometry
  function  TGeometry.GetGeomID() : Integer;                                            // Get Instance ID of Geometry
  begin
    if (self.GetID() <> nil) then Result := GetID()[0];
  end;

  // class TGeometry
  procedure TGeometry.ClearsurfbyNone();                                                // Clear nuclidlist if status is None
  var
    pSurf : PTGSurf;
    i : Integer;
  begin
    if (self.FSurfNumber > 0) then
       for i := self.FSurfNumber - 1 downto 0 do
           begin
              pSurf := self.fSurface.Items[i];
              if (pSurf^.Status = None) then self.DelSurfbyIndex(pSurf^.IDp);
           end;
  end;
////

  // Procedures of class TElement
  // class TElement
    constructor TElement.Create(Const Name : String);
    begin
       self.fid := -1;
       self.FComposNumber := 0;
       self.FName := Name;
       self.fComp := TList.Create;
   end;
    // class TElement
    constructor TElement.Create(pID : Integer);
     begin
       self.FComposNumber := 0;
       self.fiD := pid;
       self.FName := 'Element_with_id' + Inttostr(pID);
       self.ReadID([pID]);
       self.fComp := TList.Create;
    end;
    // class TElement
    constructor TElement.Create(pID : Integer; Name : String);
    begin
       self.FComposNumber := 0;
       self.fiD := pid;
       self.FName := Name;
       self.ReadID([pID]);
       self.fComp := TList.Create;

   end;
    // class TElement
    destructor TElement.Destroy;
    begin
   try
       fComp.Free;
       inherited Destroy;
    except
          On E : Exception do
          ShowMessage('TElement.Destroy - Error: '+E.Message);
    end;
  end;
    // class TElement
    function   TElement.Textrepr(): String;                                    // Get a text representation of a class
    begin
      Result := '';
      Result := Result + 'Element name' + ' ' + self.FName;
    end;
    // class TElement
    function   TElement.Getproperties(): TStringArray;                          // get the properties list from class
    begin
       Result := nil;
       SetLength(Result, 3);
       Result[2] := Inttostr(self.FETYPE);
       Result[0] := ' ';
       if (self.Name <> '') then Result[0] := self.Name;
       Result[1] := ' ';
       if (self.Description <> '') then Result[1] := self.Description;
    end;
    // class TElement
    function   TElement.GetCompositionproperties(idn : Integer): TStringArray;           // get the properties list from TGComposition class
    var
     pComp : PTComposition;
     i : Integer;
    begin
       Result := nil;
       pComp  := self.fComp.Items[idn];
       SetLength(Result, 4);
       Result[0] := Inttostr(pComp^.Number);
       if (self.Status <> Inserted) then
        Result[2] := Inttostr(self.ID)
        else
         Result[2] := '0';
       Result[3] := Inttostr(pComp^.IDg);
       Result[1] := Inttostr(pComp^.IDm);
    end;
    // class TElement
    procedure TElement.AddComp(comp : TComposition);                                     // Add composition to element
    var
      pComp : PTComposition;
      i : Integer;
    begin
      if comp <> nil then
      begin
       New(pComp);
       pComp^ := TComposition.Create(comp.Geometry);
       pComp^.Material := Comp.Material;
       pComp^.Number := Comp.Number;
       pComp^.ReadID([self.ID,comp.IDg]);
       self.fComp.Add(pComp);
       self.FComposNumber:= self.FComposNumber + 1;
      end;
    end;
    //
    procedure TElement.AddComp(geom : TGeometry);                               // Add new composition based on pointed geometry
    var
      pComp : PTComposition;
      i : Integer;
      isIn : Boolean;
    begin
    if geom <> nil then
       begin
         isIn := False;
         for i := 0 to self.NumComp - 1 do
             begin
                  pComp := self.fComp[i];
                  isIn := (isIn) or (geom.ID = pComp.IDg)
             end;
         if not IsIn then
          begin
               New(pComp);
               pComp^ := TComposition.Create(geom);
               self.fComp.Add(pComp);
               self.FComposNumber:= self.FComposNumber + 1;
          end;

       end;
    end;

    // class TElement
    procedure TElement.DelCompbyIndex(index: Integer);                                   // Delete composition from element by Change ID
     var
      pComp : PTComposition;
      i : Integer;
     begin

     if self.FComposNumber > 0 then
      for i := self.FComposNumber - 1 downto 0 do
          begin
             pComp := self.fComp[i];
             if (pComp^.IDg = index) then
              begin
                self.fComp.Delete(i);
                self.FComposNumber := self.FComposNumber - 1;
              end;
          end;

     end;
    // class TElement
    procedure TElement.Copy(pattern : TElement);                                         // Copy all field value from pattern
    var
      pComp,ppComp : PTComposition;
      i : Integer;
     begin
      for i := self.FComposNumber - 1 downto 0 do
          begin
           pComp := self.fComp.Items[i];
           pComp^.ChangeStatus(None);
          end;
      ClearcompbyNone;
      for i := 0 to pattern.NumComp - 1 do
          begin
               ppComp := pattern.fComp.Items[i];
               self.AddComp(ppComp^);
               pComp := self.fComp.Items[self.fComp.Count - 1];
               pComp^.ChangeStatus(Inserted);
          end;
      self.FETYPE:= pattern.ETYPE;
      self.Description := pattern.Description;
      self.ChangeStatus(Modified);
    end;
    // class TElement
    function  TElement.GetComposition(index : Integer) : TComposition;          // Get the instance of a Composition
    var
    pComp : PTComposition;
    begin
    pComp := self.fComp.Items[index];
    Result := pComp^;
    end;
    // class TElement
    function  TElement.GetElmntID() : Integer;                                  // Get Instance ID of Element
    begin
       if (self.GetID() <> nil) then Result := GetID()[0]
    end;
    // class TElement
    procedure TElement.ClearcompbyNone();
    var
    pComp : PTComposition;
    i : Integer;
    begin
    if (self.FComposNumber > 0) then
       for i := self.FComposNumber - 1 downto 0 do
           begin
              pComp := self.fComp.Items[i];
              if (pComp^.Status = None) then self.DelCompbyIndex(pComp^.IDg);
           end;
     end;
    // class TElement
    procedure TElement.ReadCompositions(compositiones : array of TComposition); // Read an array of compositions
    var
    pComp,eComp : PTComposition;

    i : Integer;
    begin
        self.fComp.Clear;
        for i := 0 to Length(compositiones) - 1 do
            begin
                 self.AddComp(compositiones[i]);
                 pComp := self.fComp[self.fComp.Count - 1];
                 pComp^.ChangeStatus(Selected);
            end;

    end;
////
// Procedures of class TMesh

 //class TMesh
 constructor TMesh.Create(mtype: Integer);
 begin
      self.ftype := mtype;
      self.fNumber:= 0 ;
      self.fPitch := 0.0;
 end;

 //class TMesh
 destructor TMesh.Destroy;
 begin
 try
       inherited Destroy;
    except
          On E : Exception do
          ShowMessage('TMesh.Destroy - Error: '+E.Message);
    end;
 end;

 //class TMesh
 function   TMesh.Textrepr(): String;                                           // Get a text representation of a class
 begin
    Result := self.Description + ' pitch = ' + Floattostr(self.fPitch) + ' number '
    + Inttostr(self.fNumber);
 end;

 //class TMesh
 function TMesh.Getdesc : String;                                                  // Get text representation of mesh
 begin
 case self.ftype of
                 1: Result := 'hexogonal lattice';

                 2: Result := 'square lattice';
                 3: Result := 'round lattice';
 end;
 end;
 //class TMesh
 function TMesh.GetmeshID : Integer;                                               // Get id of current mesh
   begin
        if (self.GetID() <> nil) then Result := GetID()[0];
   end;
 ////
 // Procedures of class TPlacement
 //class TPlacement
       constructor TPlacement.Create(eID : Integer;Const eName : String);
       begin
            self.ReadElement(TElement.Create(eID,eName));
       end;
 //class TPlacement
       constructor TPlacement.Create(Element : TElement);
       begin
            self.Create(element.ID,element.Name);
            self.fElement.Copy(element);
       end;
 //class TPlacement
       destructor TPlacement.Destroy;
       begin
       try
          FreeElement;
       inherited Destroy;
       except
          On E : Exception do
          ShowMessage('TPlacement.Destroy - Error: '+E.Message);
       end;
 end;
 //class TPlacement
       function   TPlacement.Textrepr(): String;                                           // Get a text representation of a class
       begin
            Result := 'Placement of element ' + self.fElement.Name + ' in position ' + Inttostr(self.GetIndex()) ;
       end;
 //class TPlacement
       function TPlacement.Getdesc : String;                                               // Get text representation of placement
       begin
            Result := 'Placement of element ' + self.fElement.Name + ' in position ' + Inttostr(self.GetIndex()) ;
       end;
 //class TPlacement
       function TPlacement.GetIndex : Integer;                                             // Get a placement index
       begin
            Result := -1;
            if (Length(self.GetID()) > 1) then Result := self.GetID()[1];
       end;
 //class TPlacement
       function TPlacement.GetelementID : Integer;                                         // Get an ID of containing element
       begin
            Result := -1;
            //if (Length(self.GetID()) > 0) then Result := self.GetID()[0];
            if (self.Element <> nil) then Result := self.Element.ID;
       end;

       function TPlacement.GetelpID(): Integer;                                               // Get an ID of position
       begin
            Result := -1;
            if (Length(self.GetID()) > 0) then Result := self.GetID()[0];
       end;

 //class TPlacement
       procedure TPlacement.ReadElement(element : TElement);                               // Read an external element
       begin
            self.FreeElement;
            self.fElement := TElement.Create(element.ID,element.Name);
       end;
 //class TPlacement
       procedure TPlacement.FreeElement;                                                   // Free an existing element
       begin
            if self.fElement <> nil then
             begin
               //?
               FreeandNil(self.fElement);
               self.fElement := nil;
             end;
       end;

////
// Procedures of class TPosition


  // Procedures
// class TPosition
    constructor TPosition.Create(pID : Integer);
    begin
       self.FPlacementNumber := 0;
       self.fPlace := TList.Create;
       self.fMsh := nil;
       unique_number := -1;
    end;
    // class TPosition
    constructor TPosition.Create(pID : Integer;Placements : array of TPlacement;Mesh:TMesh);
    begin
       self.FPlacementNumber := 0;
       self.fPlace := TList.Create;
       if Mesh = nil then
           self.fMsh := nil
       else
           self.AddMesh(Mesh);
       self.ReadPlacements(Placements);
       unique_number := -1;
    end;
    // class TPosition
    destructor TPosition.Destroy;
    begin
    try
    //??
       fPlace.Free;
       self.fMsh := nil;
       inherited Destroy;
    except
          On E : Exception do
          ShowMessage('TPosition.Destroy - Error: '+E.Message);
    end;
    end;
    // class TPosition
    function   TPosition.Textrepr(): String;                                     // Get a text representation of a class
    begin
         Result := 'Position with coordinate :' + Floattostring(self.X) + ' , '
         + Floattostring(self.Y) + ' , ' + Floattostring(self.Z);
    end;
    // class TPosition
    function   TPosition.Getproperties(): TStringArray;                          // get the properties list from class
    begin
       Result := nil;
       SetLength(Result, 5);
       Result[0] := Floattostring(self.Angle);
       Result[1] := Floattostring(self.X);
       Result[2] := Floattostring(self.Y);
       Result[3] := Floattostring(self.Z);
       Result[4] := Inttostr(self.GetID()[0]);

    end;
    // class TPosition
    function   TPosition.GetPlaceproperties(idn : Integer): TStringArray;        // get the properties list from TPlacement class
     var
     pPlace : PTPlacement;
    begin
       Result := nil;
       pPlace := self.fPlace.Items[idn];
       SetLength(Result, 3);
       Result[0] := Inttostr(pPlace^.elementID);
       if (self.Status <> Inserted) then
        Result[1] := Inttostr(self.ID)
        else
         Result[1] := '0';
       Result[2] := Inttostr(pPlace^.Index);
    end;
    // class TPosition
    procedure TPosition.AddPlace(place : TPlacement);                               // Add placement to position
     var
      pPlace : PTPlacement;
      i : Integer;
    begin
      if place <> nil then
      begin
       New(pPlace);
       pPlace^ := TPlacement.Create(place.elementID,place.Element.Name);
       pPlace^.ReadElement(place.Element);
       pPlace^.ReadID([self.ID,place.Index]);
       self.fPlace.Add(pPlace);
       self.FPlacementNumber:= self.FPlacementNumber + 1;
      end;
    end;
    // class TPosition
    procedure TPosition.DelPlacebyIndex(index: Integer);                                   // Delete placement from position by Change ID
     var
      pPlace : PTPlacement;
      i : Integer;
     begin

     if self.FPlacementNumber > 0 then
      for i := self.FPlacementNumber - 1 downto 0 do
          begin
             pPlace := self.fPlace[i];
             if (pPlace^.Index = index) then
              begin
                self.fPlace.Delete(i);
                self.FPlacementNumber := self.FPlacementNumber - 1;
              end;
          end;

     end;
    // class TPosition
    function   TPosition.GetMshProperty(): TStringArray;                                  // get a text representation of msh class
    begin
    if (Msh <> nil) then
     begin
       Result := nil;
       SetLength(Result, 4);
       Result[0] := Inttostr(fMsh.Number);
       Result[1] := Floattostr(fMsh.Pitch);
       Result[2] := Inttostr(fMsh.mtype);
       if (self.Status <> Inserted) then
        Result[3] := Inttostr(self.ID)
        else
         Result[3] := '0';
     end;
    end;
    // class TPosition
    function  TPosition.AddMesh(msh : TMesh):Boolean;                                              // Add msh to current position
    begin
         if (self.fMsh <> nil) then
          Result := False
         else
          begin
            Result := False;
            if Msh <> nil then
             begin
             self.fMsh := TMesh.Create(msh.mtype);
             self.fMsh.fNumber := msh.Number;
             self.fMsh.Pitch := msh.Pitch;
             self.fMsh.ReadID([self.ID]);
             //self.fMsh.ChangeStatus(Selected);

             end;
            Result := True;
          end;
    end;

    // class TPosition
    procedure TPosition.DelMesh();                                                         // Delete reference on Mesh from position
    begin
    if (self.fMsh <> nil) then
     begin
          self.fMsh.Free;//??
          self.fMsh := nil;
     end;

    end;

    // class TPosition
    procedure TPosition.Copy(pattern : TPosition);                                        // Copy all field value from pattern
     var
      pPlace,ppPlace : PTPlacement;
      i : Integer;
     begin
      for i := self.FPlacementNumber - 1 downto 0 do
          begin
           pPlace := self.fPlace.Items[i];
           pPlace^.ChangeStatus(None);
          end;
      ClearposbyNone;
      for i := 0 to pattern.NumPlacement - 1 do
          begin
               ppPlace := pattern.fPlace.Items[i];
               self.AddPlace(ppPlace^);
               pPlace := self.fPlace.Items[self.fPlace.Count - 1];
               //pPlace^.ChangeStatus(Selected);
          end;

      if (pattern.Msh <> nil) then
       begin
       self.AddMesh(pattern.Msh);
       self.fMsh.ReadID([self.ID]);
       //self.fMsh.ChangeStatus(Selected);

       end;
      self.X:= pattern.X;
      self.Y:= pattern.Y;
      self.Z:= pattern.Z;
      self.Angle := pattern.Angle;
     // self.ChangeStatus(Modified);
    end;
    // class TPosition
    procedure TPosition.ClearposbyNone();                                                 // Clear Placement list if status is None
    var
    pPlace : PTPlacement;
    i : Integer;
    begin
    if (self.FPlacementNumber > 0) then
       for i := self.FPlacementNumber - 1 downto 0 do
           begin
              pPlace := self.fPlace.Items[i];
              if (pPlace^.Status = None) then self.DelPlacebyIndex(pPlace^.Index);
           end;
    if (self.fMsh <> nil) then
       if (self.fMsh.Status = None) then self.DelMesh();

     end;
    // class TPosition

    function  TPosition.GetPlacement(index : Integer) : TPlacement;                            // Get the instance of an Element
    var
    pPlace : PTPlacement;
    begin
    pPlace := self.fPlace.Items[index];
    Result := pPlace^;
    end;

    // class TPosition
    function  TPosition.GetPosID() : Integer;                                              // Get Instance ID of Position
    begin
         Result := -1;
         if (Length(self.GetID()) > 1) then Result := GetID()[1];
    end;
    // class TPosition
    procedure TPosition.ReadPlacements(Placements : array of TPlacement);                       // Read an array of Placements
    var
    pPlace : PTPlacement;

    i : Integer;
    begin
        self.fPlace.Clear;
        for i := 0 to Length(Placements) - 1 do
            begin
                 self.AddPlace(Placements[i]);
                 pPlace := self.fPlace[self.fPlace.Count - 1];
                 //pPlace^.ChangeStatus(Selected);
            end;

    end;
    // class TPosition
    function Compareby(Item1,Item2: Pointer): Integer;                 // Sorted function by Placement ID
    var
       pElem1,pElem2 : PTPlacement;
    begin
        pElem1 := Item1;
        pElem2 := Item2;
        if pElem2^.elementID > pElem1^.elementID then
         Result := 1
        else
            if pElem2^.elementID = pElem1^.elementID then
               Result := 0
            else
                Result := -1;
        if (pElem1^.Status = Deleted) or (pElem1^.Status = None) then Result :=1;
        if (pElem2^.Status = Deleted) or (pElem2^.Status = None) then Result :=-1;
        if (pElem1^.Status = Deleted) or (pElem1^.Status = None) then
           if (pElem2^.Status = Deleted) or (pElem2^.Status = None) then
              Result := 0;
    end;

    // class TPosition
    function TPosition.GetFirstU : Integer;                                               // Get the first unique number
    var
       pPlace : PTPlacement;
    begin
    if (self.FPlacementNumber > 0) then
     begin
        self.fPlace.Sort(Compareby);
        unique_number := 0;
        New(pPlace);
        pPlace^ := self.Placements[unique_number];
        if (pPlace^.Status = Deleted) or (pPlace^.Status = None) then
            unique_number := -1;

        Result := unique_number;
     end
        else
            begin
                unique_number := -1;
                Result := unique_number;
            end;
    end;

    // class TPosition
    function TPosition.GetNextU : Integer;                                                // Get an another unique number,nil otherwise
    var
       pElem1,pElem2: PTPlacement;
       i : Integer;
    begin
        Result := -1;
        if self.FPlacementNumber > 0 then
         begin
           pElem1 := self.fPlace[unique_number];
           for i := unique_number + 1 to self.FPlacementNumber - 1 do
               begin
                  pElem2 := self.fPlace[i];
                  if (pElem2^.elementID <> pElem1.elementID) and ((pElem2^.Status <> None) and (pElem2^.Status <> Deleted)) then
                     begin
                       unique_number := i;
                       Result := unique_number;
                       Exit;
                     end;
               end;
         end;
    end;

    procedure TPosition.ChangeallStatus(newStatus : TInStatus);                 // Change status of all components
    var
       i : Integer;
    begin
       for i := 0 to self.NumPlacement - 1 do
           begin
           self.Placements[i].ChangeStatus(newStatus);

           end;
       if self.fMsh <> nil then
          self.fMsh.ChangeStatus(newStatus);
       self.ChangeStatus(newStatus);
    end;

    // Procedures of class TElement_list
  //class TElement_list
  constructor TElement_list.Create(elem : TElement);                                          // TElement_list
  begin
       inherited create(elem.ID,elem.Name);
       inherited Copy(elem);
       self.fPosition_list := TList.Create;
       self.fPosNumber := 0;
  end;
   //class TElement_list
  destructor TElement_list.Destroy();
   begin
   try
       fPosition_list.Free;
       inherited Destroy;
    except
          On E : Exception do
          ShowMessage('TElement_List.Destroy - Error: '+E.Message);
    end;
  end;
  procedure TElement_list.AddPos(pos : TPosition);                                            // Add position to element_list
  var
      pPos : PTPosition;
      i : Integer;
    begin
      if pos <> nil then
      begin
       New(pPos);
       pPos^ := Tposition.Create(pos.ID);
       pPos^.ReadID([self.ID,pos.ID]);
       pPos^.Copy(pos);
       if (pPos^.Msh <> nil) then
       begin
        pPos^.Msh.ReadID([pos.ID]);
       // pPos^.Msh.ChangeStatus(Inserted);
       end;
       self.fPosition_list.Add(pPos);
       self.fPosNumber:= self.fPosNumber + 1;
      end;
    end;
   //class TElement_list
  procedure TElement_list.DelPosbyIndex(index: Integer);                                      // Delete position from element_list by Change ID
   var
      pPos : PTPosition;
      i : Integer;
     begin

     if self.fPosNumber > 0 then
      for i := self.fPosNumber - 1 downto 0 do
          begin
             pPos := self.fPosition_list[i];
             if (pPos^.ID = index) then
              begin
                self.fPosition_list.Delete(i);
                self.fPosNumber := self.fPosNumber - 1;
              end;
          end;

     end;
   //class TElement_list
  procedure TElement_list.Copy(pattern : TElement_list);                                      // Copy all field value from pattern
   var
      pPos,ppPos: PTPosition;
      i : Integer;
     begin
      for i := self.fPosNumber - 1 downto 0 do
          begin
           pPos := self.fPosition_list.Items[i];
           pPos^.ChangeStatus(None);
          end;
      ClearelistbyNone;
      for i := 0 to pattern.PositionNumber - 1 do
          begin
               ppPos := pattern.fPosition_list.Items[i];
               self.AddPos(ppPos^);
               pPos := self.fPosition_list.Items[self.fPosition_list.Count - 1];
          end;
      //self.ChangeStatus(Modified);
    end;
   //class TElement_list
  function TElement_list.GetPosition(index : Integer): TPosition;                             // Get postion index by Integer
   var
    pPos : PTPosition;
    begin
    pPos := self.fPosition_list.Items[index];
    Result := pPos^;
    end;
   //class TElement_list
  procedure TElement_list.ClearelistbyNone();                                                 // Clear Placement list if status is None
  var
    pPos : PTPosition;
    i : Integer;
    begin
    if (self.fPosNumber > 0) then
       for i := self.fPosNumber - 1 downto 0 do
           begin
              pPos := self.fPosition_list.Items[i];
              if (pPos^.Status = None) then self.DelCompbyIndex(pPos^.ID);
           end;
     end;
   //class TElement_list
  procedure TElement_list.ReadPositions(Positions : array of TPosition);                       // Read an array of postion
  var
    pPos,ePos : PTPosition;

    i : Integer;
    begin
        self.fPosition_list.Clear;
        for i := 0 to Length(Positions) - 1 do
            begin
                 self.AddPos(Positions[i]);
                 pPos := self.fPosition_list[self.fPosition_list.Count - 1];
                 //pPos^.ChangeStatus(Selected);
            end;

    end;
    procedure TElement_list.ChangePositionsStatus(newStatus : TInStatus);                       // Change status of poisitions
    var
      i : Integer;
    begin
       for i := 0 to self.fPosNumber - 1 do
           begin
                self.Positions[i].ChangeallStatus(newStatus);
                self.Positions[i].ChangeStatus(newStatus);
           end;
    end;

end.
