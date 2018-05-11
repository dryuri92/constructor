program project_new;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, unit_DB, ibexpress, lazcontrols, datetimectrls, system_info, Header,
  thread_process, DataModule, Qtable_class, Instance_class, unitqueue,
  Material_editor, Service, material_table, saver, ExportImport, Fillinstinfo;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TFormHeader, FormHeader);
  Ini_programm;
  Application.Initialize;
  Application.CreateForm(TDBmod, DBmod);
  //Application.CreateForm(TFormMatedit, FormMatedit);
  Application.CreateForm(TFormQueue, FormQueue);
  //Application.CreateForm(TFormmattable, Formmattable);
  //Application.CreateForm(TFormstater, Formstater);
  //Application.CreateForm(TDM, DM);
  Application.Run;
end.

