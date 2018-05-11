unit ExportImport;

{$mode objfpc}{$H+}

interface

uses
  RegexpR,Classes, SysUtils,Instance_class,unit_classes;
type
  TStringarray = array of String;
  TRealArray = array of Real;
  TRealArray2 = array of array of Real;
 //
  Tgeterafile = class

  private
         fnummaterial : Integer;
         fcurrentnumber : Integer;
         fGetfile : TextFile;
         fneedreopen : Boolean;
         fConc : TRealArray2;
         fident : array of Integer;
         fname : array of array of String;
         fMaterial : array of String;
         fDescription : array of String;
         fDensity : array of Real;
         fTemperature : array of Real;
         fbinPath : String;
         localmatname : String;
         localdens : Real;
         localtemp : Real;
         function  GetMatName(index: Integer) : String;
         function  GetMatDesc(index: Integer) : String;
         function  GetMatDens(index: Integer) : Real;
         function GetMatTemp(index: Integer) : Real;
         function GetIdent(index: Integer) : Integer;
  procedure IncNumber;
  public

  constructor Create(filename : String;binPath: String);overload;
  constructor Create(filename : String);overload;
  procedure ReadMtr(filename : String);
  procedure ParseFile(filename : String);
  procedure ParseInput;
  procedure Free;
  function GetMaterialnuclidname(ind : Integer):TStringarray;
  function GetMaterialnuclidconc(ind : Integer):TRealArray;
  property material_name[index: Integer] : String  read GetMatName;
  property material_desc[index: Integer] : String  read GetMatDesc;
  property material_density[index: Integer] : Real  read GetMatDens;
  property material_temp[index: Integer] : Real  read GetMatTemp;
  property material_identificator[index: Integer] : Integer  read GetIdent;
  property material_number: Integer read fnummaterial;
end;
  //
  TCONSYSTfile = class
    private
     fcons : TextFile;
     finz : Integer;
     fizt : Integer;
     fRegExp : TRegExpr;
     current_izt : Integer;
     current_inz : Integer;
     conc : array of array of Real;
     temp : array of Real;
     Name : array of String;
     function ReadINZT(str : String):Integer;
     procedure WriteINZ(num : Integer);
     procedure WriteIZT(num : Integer);
     procedure ReadRo;
     procedure WriteRO;
     procedure ReadTemp;
     procedure WriteTemp;
     Procedure ReadName;
     Procedure WriteName;
    public
     Procedure WriteFile;
     Procedure ParseFile;
     procedure Free;
     procedure SetUP(Nuclids :  TStringarray; concentration :TRealArray2; temperature : array of Real );
     function GetMaterialtemp(ind : Integer) : Real;
     function GetMaterialnuclidname(ind : Integer):TStringarray;
     function GetMaterialnuclidconc(ind : Integer):TRealArray;
     constructor Create(filename : String);
     property IZT : Integer Read fizt;
     property IZN : Integer Read finz;
  end;

implementation
// Procedures of class TCONSYSTfile
     //class TCONSYSTfile
     function TCONSYSTfile.ReadINZT(str : String):Integer;
     var
       RegExp : TRegExpr;
     begin
          RegExp := TRegExpr.Create;
          try
            RegExp.Expression := '\d+';
            if RegExp.Exec(str) then  Result := Strtoint(RegExp.Match[0]);
          finally
            RegExp.Free;
          end;

     end;

     //class TCONSYSTfile
     procedure TCONSYSTfile.WriteINZ(num : Integer);
     begin

     end;

     //class TCONSYSTfile
     procedure TCONSYSTfile.WriteIZT(num : Integer);
     begin

     end;

//class TCONSYSTfile
     procedure TCONSYSTfile.ReadRo;
     var
       RegExp : TRegExpr;
       str : String;
     begin
          RegExp := TRegExpr.Create;
          self.current_izt := 0;
          self.current_inz := 0;
          SetLength(self.conc,1);
          while ((self.current_izt < self.fizt - 1) or (self.current_inz < self.finz)) and not EOF(self.fcons) do
          begin
          Readln(self.fcons,str);
          try
          RegExp.Expression := '\d+[.eE0-9+-]+\d+';
          RegExp.Compile;
          if (RegExp.Exec(str)) then
          begin
            repeat
             self.current_inz := self.current_inz + 1;
             if (self.current_inz > self.finz) then
             begin
                self.current_izt := self.current_izt + 1;
                SetLength(self.conc,Length(self.conc) + 1);
                self.current_inz := 1;
             end;

             SetLength(self.conc[current_izt],Length(self.conc[current_izt]) + 1);
             self.conc[self.current_izt][self.current_inz - 1] := Strtofloat(RegExp.Match[0]);
            until not RegExp.ExecNext  ;

          end;
          except on E : ERegExpr do
            RegExp.Free;
          end;

          end;
          RegExp.Free;
     end;

//class TCONSYSTfile
     procedure TCONSYSTfile.WriteRO;
     var
      ipos,maxpos,i,j : Integer;
      str : String;
     begin
        str := ' ';
        ipos := 0;
        maxpos := 6;
        for i := 0 to self.fizt - 1 do
        begin
        self.current_izt := i;

        for j := 0 to self.finz - 1 do
        begin
        self.current_inz := j;

            str := str + ' ' + Floattostrf(self.conc[self.current_izt][self.current_inz],ffExponent,8,2);
            ipos := ipos + 1;
            if (ipos >= maxpos ) or (self.current_inz = self.finz - 1) then
            begin
               ipos := 0;
               writeln(self.fcons,str);
               str := ' ';
            end;
        end;

        end;
     end;

//class TCONSYSTfile
     procedure TCONSYSTfile.ReadTemp;
      var
       RegExp : TRegExpr;
       str : String;
     begin
          RegExp := TRegExpr.Create;
          self.current_izt := 0;
          while (self.current_izt < self.fizt) do
          begin
          Readln(self.fcons,str);
          try
          RegExp.Expression := '\d+[.eE0-9+-]+\d+';
          RegExp.Compile;

          if (RegExp.Exec(str)) then
          begin
            repeat
             self.current_izt :=  self.current_izt + 1;
             SetLength(self.Temp,Length(self.Temp) + 1);
             self.Temp[self.current_izt - 1] := Strtofloat(RegExp.Match[0]);
            until not RegExp.ExecNext  ;

          end;
          except on E : ERegExpr do
            RegExp.Free;
          end;

          end;
          RegExp.Free;
     end;

     //class TCONSYSTfile
     procedure TCONSYSTfile.WriteTemp;
     var
      ipos,maxpos,i : Integer;
      str : String;
     begin
        str := ' ';
        ipos := 0;
        maxpos := 8;
        for i := 0 to self.fizt - 1 do
        begin
        self.current_izt := i;

            str := str + ' ' + Floattostrf(self.Temp[self.current_izt],ffFixed,4,2);
            ipos := ipos + 1;
            if (ipos >= maxpos ) or (self.current_izt = self.fizt - 1) then
            begin
               ipos := 0;
               writeln(self.fcons,str);
               str := ' ';
            end;
        end;
     end;

     //class TCONSYSTfile
     Procedure TCONSYSTfile.ReadName;
      var
       RegExp : TRegExpr;
       str : String;
     begin
          RegExp := TRegExpr.Create;
          self.current_inz := 0;
          while (self.current_inz < self.finz) do
          begin
          Readln(self.fcons,str);
          try
          RegExp.Expression := '[^''\s,]+';
          RegExp.Compile;

          if (RegExp.Exec(str)) then
          begin
            repeat
             self.current_inz :=  self.current_inz + 1;
             SetLength(self.Name,Length(self.Name) + 1);
             self.Name[self.current_inz - 1] := RegExp.Match[0];
            until not RegExp.ExecNext  ;

          end;
          except on E : ERegExpr do
            RegExp.Free;
          end;

          end;
          RegExp.Free;
     end;

     //class TCONSYSTfile
     Procedure TCONSYSTfile.WriteName;
     var
      i : Integer;
     begin
        for i := 0 to self.finz - 1 do
        begin
            Writeln(self.fcons,#39 + self.Name[i] + #39);
        end;
     end;

     //class TCONSYSTfile
     Procedure TCONSYSTfile.WriteFile;
     begin
        Rewrite(self.fcons);
        Writeln(self.fcons,'IZT = '+Inttostr(self.fizt));
        Writeln(self.fcons,'INZ = '+Inttostr(self.finz));
        Writeln(self.fcons,'NAME = ');
        WriteName;
        Writeln(self.fcons,'TEMP = ');
        WriteTemp;
        Writeln(self.fcons,'RO = ');
        WriteRO;
     end;

     //class TCONSYSTfile
     Procedure TCONSYSTfile.ParseFile;
     var
       str : String;
     begin
          Reset(self.fcons);

          try
            while not EOF(self.fcons) do
            begin
              Readln(self.fcons,str);
              self.fRegExp.Expression := '(INZ)';
              self.fRegExp.Compile;
              if (self.fRegExp.Exec(str)) then
                 self.finz := self.ReadINZT(str);
              self.fRegExp.Expression := '(IZT)';
              self.fRegExp.Compile;
              if (self.fRegExp.Exec(str)) then
                 self.fizt := self.ReadINZT(str);
              self.fRegExp.Expression := '(NAME)';
              self.fRegExp.Compile;
              if (self.fRegExp.Exec(str)) then
                 self.ReadName;
              self.fRegExp.Expression := '(RO)';
              self.fRegExp.Compile;
              if (self.fRegExp.Exec(str)) then
                 self.ReadRo;
              self.fRegExp.Expression := '(TEM[^IZ])';
              self.fRegExp.Compile;
              if (self.fRegExp.Exec(str)) then
                 self.ReadTemp;
            end;
          finally
            self.fRegExp.Free;
          end;
     end;
      //class TCONSYSTfile
     function TCONSYSTfile.GetMaterialtemp(ind : Integer) : Real;
     begin
          Result := self.temp[ind];
     end;
      //class TCONSYSTfile
     function TCONSYSTfile.GetMaterialnuclidname(ind : Integer):TStringarray;
     begin
          Result := nil;
          SetLength(Result,self.finz);
          Result := self.Name;
     end;
      //class TCONSYSTfile
     function TCONSYSTfile.GetMaterialnuclidconc(ind : Integer):TRealArray;
     var
       iNucl : Integer;
     begin
     Result := nil;
     for iNucl := 0 to Length(self.conc[ind]) - 1 do
     begin
          SetLength(Result,Length(Result) + 1);
          Result[Length(Result) - 1] := conc[ind][iNucl];
     end;

     end;
     //class TCONSYSTfile
     procedure TCONSYSTfile.SetUP(Nuclids : TStringarray;  concentration : TRealArray2; temperature : array of Real);
     var
       i,j : Integer;
     begin
       self.finz := Length(Nuclids);
       self.fizt := Length(concentration);
       SetLength(self.Name,self.finz);
       SetLength(self.Temp,self.fizt);
       SetLength(self.Conc,self.fizt);
       for i:= 0 to self.fizt - 1 do
       begin
            SetLength(self.Conc[i],self.finz);
            for j:= 0 to self.finz - 1 do
                self.Conc[i][j] := concentration[i][j];
            self.Temp[i] := temperature[i];
       end;

       for i:= 0 to self.finz - 1 do
       begin
            self.Name[i] := Nuclids[i];
       end;
     end;
     //class TCONSYSTfile
     constructor TCONSYSTfile.Create(filename : String);
     begin
          AssignFile(self.fcons,filename);
          self.fRegExp := TRegExpr.Create;
          self.finz := 0;
          self.fizt := 0;
     end;
      //class TCONSYSTfile
     procedure TCONSYSTfile.Free;
     begin
          self.conc := nil;
          self.Temp := nil;
          self.Name := nil;
          CloseFile(self.fcons);
     inherited;
     end;
          // Tgeterafile
constructor Tgeterafile.Create(filename : String;binPath: String);
begin
        AssignFile(self.fGetfile,filename);
        self.fbinPath := binPath;
        fConc := nil;
        fnummaterial := 0;
        fident := nil;
        fname := nil;
        fMaterial := nil;
        fDescription := nil;
        fDensity := nil;
        fTemperature := nil;
        localmatname := '';
        localdens := 0;
        localtemp := 0;
        fneedreopen := True;
end;
// Tgeterafile
constructor Tgeterafile.Create(filename : String);
begin
	AssignFile(self.fGetfile,filename);
        fnummaterial := 0;
        fConc := nil;
        fident := nil;
        fname := nil;
        fMaterial := nil;
        fDescription := nil;
        fDensity := nil;
        fTemperature := nil;
end;
// Tgeterafile
procedure Tgeterafile.ReadMtr(filename : String);
begin
     IncNumber;
     self.fMaterial[fnummaterial - 1] := ExtractFileName(filename);
     ParseFile(filename);


end;
// Tgeterafile
procedure Tgeterafile.IncNumber;
begin
     fnummaterial := fnummaterial + 1;
     SetLength(self.fDensity,fnummaterial);
     SetLength(self.fMaterial,fnummaterial);
     SetLength(self.fDescription,fnummaterial);
     SetLength(self.fTemperature,fnummaterial);
     SetLength(self.fConc,fnummaterial);
     SetLength(self.fname,fnummaterial);
     SetLength(self.fident,fnummaterial);
end;
// Tgeterafile
function Tgeterafile.GetMaterialnuclidname(ind : Integer):TStringarray;
var
       iNucl : Integer;
     begin
     Result := nil;
     for iNucl := 0 to Length(self.fname[ind]) - 1 do
     begin
          SetLength(Result,Length(Result) + 1);
          Result[Length(Result) - 1] := self.fname[ind][iNucl];
     end;

     end;

// Tgeterafile
function Tgeterafile.GetMaterialnuclidconc(ind : Integer):TRealArray;
var
       iNucl : Integer;
     begin
     Result := nil;
     for iNucl := 0 to Length(self.fConc[ind]) - 1 do
     begin
          SetLength(Result,Length(Result) + 1);
          Result[Length(Result) - 1] := self.fConc[ind][iNucl];
     end;

     end;


// Tgeterafile
function  Tgeterafile.GetMatName(index: Integer) : String;
begin
  Result := self.fMaterial[index];
end;

// Tgeterafile
function  Tgeterafile.GetMatDesc(index: Integer) : String;
begin
  Result := self.fDescription[index];
end;

// Tgeterafile
function  Tgeterafile.GetMatDens(index: Integer) : Real;
begin
  Result := self.fDensity[index];
end;

// Tgeterafile
function Tgeterafile.GetMatTemp(index: Integer) : Real;
begin
  Result := self.fTemperature[index];
end;
// Tgeterafile
function Tgeterafile.GetIdent(index: Integer) : Integer;
begin
  Result := self.fident[index];
end;
// Tgeterafile
procedure Tgeterafile.ParseInput;
var
	str,temp: String;
	RegExp: array[1..4] of TRegExpr;
        i : Integer;
begin
 while fneedreopen do
 begin
        Reset(self.fGetfile);
        for i:=1 to 4 do
	    RegExp[i] :=  TRegExpr.Create;
        fneedreopen := False;
        try
          temp := '^[^@]*(material[(]' +Inttostr(self.fnummaterial + 1) + '[)]).*$';
          RegExp[1].Expression := temp;RegExp[1].Compile;
          //
          temp := '^[^@]*(t[(]' +Inttostr(self.fnummaterial + 1) + '[)]).*$';
          RegExp[2].Expression := temp;RegExp[2].Compile;
          //
          temp := '^[^@]*(dens[(]' +Inttostr(self.fnummaterial + 1) + '[)]).*$';
          RegExp[3].Expression := temp;RegExp[3].Compile;
          while not EOF(self.fGetfile) do
          begin
               Readln(self.fGetfile,str);
                if (RegExp[1].Exec(str)) then
                begin
                   RegExp[4].Expression :='([=].*)[''](.*)['']' ;RegExp[4].Compile;
                   if (RegExp[4].Exec(str)) then
                      begin
                       self.localmatname:=RegExp[4].Match[2];
                       self.fneedreopen := True;
                      end;

                end;
                if (RegExp[2].Exec(str)) then
                begin
                   RegExp[4].Expression :='([=])([.eE0-9+-]+)\D' ;RegExp[4].Compile;
                   if (RegExp[4].Exec(str)) then

                       self.localtemp:=Strtofloat(RegExp[4].Match[2]);


                end;
                if (RegExp[3].Exec(str)) then
                begin
                   RegExp[4].Expression :='([=])([.eE0-9+-]+)\D' ;RegExp[4].Compile;
                   if (RegExp[4].Exec(str)) then
                       self.localdens:=Strtofloat(RegExp[4].Match[2]);


                end;
          end;
        finally
          RegExp[1].Free;
          RegExp[2].Free;
          RegExp[3].Free;
          RegExp[4].Free;
        end;
        if (self.fneedreopen) then self.ReadMtr(self.fbinPath + '\' +self.localmatname + '.mtr');
 end;
end;

// Tgeterafile
procedure Tgeterafile.ParseFile(filename : String);
var
	str,temp: String;
	RegExp: TRegExpr;
        f : TextFile;
begin
        AssignFile(f,filename);
	Reset(f);
	RegExp :=  TRegExpr.Create;
        self.fcurrentnumber := fnummaterial - 1;
	try
          Readln(f,str);
          self.fDescription[fcurrentnumber] := str;
          self.fTemperature[fcurrentnumber] := 0.0;

          Readln(f,str);
          if (Strtofloat(str) > 0) then
            self.fDensity[fcurrentnumber] := StrtoFloat(str)
          else
            self.fDensity[fcurrentnumber] := 0.0;
          Readln(f,str);
          temp := Trim(str);
          self.fident[fcurrentnumber] := Round(StrtoFloat(temp));
          while not EOF(f) do
          begin
               Readln(f,str);
               RegExp.Expression := '^(.*?)\s';RegExp.Compile;
                if (RegExp.Exec(str)) then
                begin

                   SetLength(self.fname[fcurrentnumber],Length(self.fname[fcurrentnumber]) + 1);
                   temp := Trim(RegExp.Match[0]);
                   RegExp.Expression := '[*](.*)[*]';RegExp.Compile;
                   if (RegExp.Exec(temp)) then
                      self.fname[fcurrentnumber][Length(self.fname[fcurrentnumber]) - 1] := Copy(temp,2,Length(temp)-2)
                   else
                      self.fname[fcurrentnumber][Length(self.fname[fcurrentnumber]) - 1] := temp;

                end;

               RegExp.Expression := '\s(\d+[.eE0-9+-]*\d*)';RegExp.Compile;
               if (RegExp.Exec(str)) then
                begin
                   SetLength(self.fConc[fcurrentnumber],Length(self.fConc[fcurrentnumber]) + 1);
                   self.fConc[fcurrentnumber][Length(self.fname[fcurrentnumber]) - 1] := StrtoFloat(RegExp.Match[0]);

                end;
          end;
        finally
		RegExp.Free;
                CloseFile(f);
	end;
end;

// Tgeterafile
procedure Tgeterafile.Free;
begin
	CloseFile(self.fGetFile);
        if Assigned(fConc) then fConc := nil;
        if Assigned(fident) then fident := nil;
        if Assigned(fname) then fname := nil;
        if Assigned(fMaterial) then fMaterial := nil;
        if Assigned(fDescription) then fDescription := nil;
        if Assigned(fDensity) then fDensity := nil;
        if Assigned(fTemperature) then fTemperature := nil;

end;


end.

