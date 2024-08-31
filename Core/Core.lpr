program Core;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  {$IFDEF HASAMIGA}
  athreads,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms,
  core.init,
  core.types,
  core.consts,
  core.enums,
  core.globals,
  core.factories,
  core.connections,
  core.files,
  core.helpers,
  core.resources,
  core.dao,
  core.view.form.main,
  core.identifier,
  core.querys,
  core.view.mobile;

{$R *.res}

begin
  // Inicialização
  Factories.Interfaces.Init.Initialize;

  RequireDerivedFormResource := True;
  Application.Scaled := True;
  Application.Initialize;
  Application.CreateForm(TFormMain, FormMain);
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

