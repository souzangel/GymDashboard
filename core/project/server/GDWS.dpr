program GDWS;
{$APPTYPE GUI}

uses
  Forms,
  Web.WebReq,
  GDWS.Form.Principal in '..\..\source\Forms\GDWS.Form.Principal.pas' {GDWSFormPrincipal},
  GDWS.DM.SC in '..\..\source\DataModule\ServerContainers\GDWS.DM.SC.pas' {GDWSDMSC: TDataModule},
  GDWS.DM.WM in '..\..\source\DataModule\WebModules\GDWS.DM.WM.pas' {GDWSDMWM: TWebModule};

{$R *.res}

begin
  if WebRequestHandler <> nil then
    WebRequestHandler.WebModuleClass := WebModuleClass;
  Application.Initialize;
  Application.CreateForm(TGDWSFormPrincipal, GDWSFormPrincipal);
  Application.Run;
end.
