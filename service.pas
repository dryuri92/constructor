unit Service;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,Math,Clipbrd;
 type
 TDoubleArray   = array of Double;
 TDoubleArray2  = array of array of Double;
 TDoubleArray3  = array of array of array of Double;
 TRealArray     = array of Real;
 TRealArray2    = array of array of Real;
 TIntegerArray  = array of Integer;
 TIntegerArray2 = array of array of Integer;
 TStringArray   = array of string;
 TStringArray2  = array of array of string;
 TSingleArray   = array of Single;
 //TColorArray    = array of TColor;
 TAnsiCharArray = array of AnsiChar;
 {function SplitString(const s : string; const sep : Char = ' ') : TStringArray;                        // get the array of substring}
 function WorkStr(const s : string; const sep : Char = ' '; ZeroLen : Boolean = False) : TStringArray; // get the array of substring
 function Floattostring(const f: Real) : String;                                                       // get a character representation of float value
 function IsInStr(arr : TStringArray ; Const Val : String):Boolean;                                            // Check if element in array
 function IsInInt(arr : TIntegerArray ; Const Val : Integer):Boolean;                                            // Check if element in array
implementation

{function SplitString(const s : string; const sep : Char = ' ') : TStringArray;                        // get the array of substring
var
  MyString : String;
  Splitted : TStringArray;//TArray<String>;
  i, L: Integer;
begin
  MyString := s;
  Splitted := MyString.Split([sep]);
  L := Length(Splitted);
  SetLength(Result, L);
  for i := 0 to L - 1 do Result[i] := Splitted[i];
end;}
//
//
function WorkStr(const s:string; const sep:char = ' '; ZeroLen : boolean = false):TStringArray;
var
  a:Integer;
  str, SubStr :string;
  i : Integer;
  pos1 : Integer;
  Char1 : char;
begin
  SetLength(Result, 0);
  if sep = ' ' then str := Trim(s)+sep
  else str := s + sep;
  pos1 := 0;
  //for i := 1 to str.Length do
  for i := 1 to Length(str) do
  begin
    Char1 := str[i];
    if Char1 = sep then
    begin
      //SubStr := Trim(str.Substring(pos1-1, i-pos1));
    SubStr := (Copy(str,pos1 + 1, i  - pos1 - 1));
      //if (SubStr.Length <> 0) or (ZeroLen) then
      if (Length(Substr) <> 0) or (ZeroLen) then
      begin
        SetLength(Result, Length(Result)+1);
        Result[Length(Result)-1] := SubStr;
      end;
      pos1 := i;
    end;
  end;
end;
//
function Floattostring(const f: Real) : String;                                                       // get a character representation of float value
begin
  if abs(f) < 1.E-03 then
     Result := Floattostrf(f,ffExponent,6,3)
  else
     Result := Floattostrf(f,ffFixed,8,3);
  if (f = 0.0) then
     Result := '0.000';

end;

//

function IsInStr(arr : TStringArray ; Const Val : String):Boolean;                                            // Check if element in array
var
  i : Integer;
begin
   Result := False;
   for i := Low(arr) to High(arr) do
       if (arr[i] = val) then
          begin
            Result := True;
            Exit;
          end;
end;

function IsInInt(arr : TIntegerArray ; Const Val : Integer):Boolean;                                            // Check if element in array
var
  i : Integer;
begin
   Result := False;
   for i := Low(arr) to High(arr) do
       if (arr[i] = val) then
          begin
            Result := True;
            Exit;
          end;
end;
end.

