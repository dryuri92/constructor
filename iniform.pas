unit iniform;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  StdCtrls;

type

  { Tiniform }

  Tiniform = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    ProgressBar: TProgressBar;
    procedure FormCreate(Sender: TObject);
  private
    fcurrent_value: Integer;

    { private declarations }
  public
    fmax_value : Integer;
    procedure Update(max_value,value : Integer);                                          //Update progress
    procedure Refresh;                                                          // Refresh form
    { public declarations }
  end;

//var
//  iniform: Tiniform;

implementation

{$R *.lfm}

{ Tiniform }

procedure Tiniform.FormCreate(Sender: TObject);
begin
    fcurrent_value := 0;
end;

procedure Tiniform.Update(max_value,value : Integer);                           //Update progress
begin
    fcurrent_value := value;
    fmax_value := max_value;
    //Refresh;
end;
procedure  Tiniform.Refresh;                                                    // Refresh form
begin
    Progressbar.Max := fmax_value;
    Label1.Caption  := Inttostr(Round(fcurrent_value/fmax_value*100.0));
    Progressbar.Position := fcurrent_value;
end;

end.

