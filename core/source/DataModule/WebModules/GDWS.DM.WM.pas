unit GDWS.DM.WM;

interface

uses
  System.SysUtils, System.Classes, Web.HTTPApp, Datasnap.DSHTTPCommon, Datasnap.DSHTTPWebBroker, Datasnap.DSServer, Web.WebFileDispatcher, Web.HTTPProd, DSAuth, Datasnap.DSProxyDispatcher, Datasnap.DSProxyJavaAndroid, Datasnap.DSProxyJavaBlackBerry, Datasnap.DSProxyObjectiveCiOS, Datasnap.DSProxyCsharpSilverlight, Datasnap.DSProxyFreePascal_iOS, Datasnap.DSProxyJavaScript, IPPeerServer, Datasnap.DSMetadata, Datasnap.DSServerMetadata, Datasnap.DSClientMetadata, Datasnap.DSCommonServer, Datasnap.DSHTTP;

type
  TGDWSDMWM = class(TWebModule)
    ServerFunctionInvoker: TPageProducer;
    ReverseString: TPageProducer;
    WebFileDispatcher: TWebFileDispatcher;
    DSProxyGenerator: TDSProxyGenerator;
    DSServerMetaDataProvider: TDSServerMetaDataProvider;
    DSProxyDispatcher: TDSProxyDispatcher;
    DSRESTWebDispatcher: TDSRESTWebDispatcher;
    procedure ServerFunctionInvokerHTMLTag(Sender: TObject; Tag: TTag; const TagString: string; TagParams: TStrings; var ReplaceText: string);
    procedure WebModuleDefaultAction(Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WebModuleBeforeDispatch(Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WebFileDispatcherBeforeDispatch(Sender: TObject; const AFileName: string; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WebModuleCreate(Sender: TObject);
  private
    { Private declarations }
    FServerFunctionInvokerAction: TWebActionItem;
    function AllowServerFunctionInvoker: Boolean;
  public
    { Public declarations }
  end;

var
  WebModuleClass: TComponentClass = TGDWSDMWM;

implementation

uses
  Web.WebReq, GDWS.DM.SM.Pessoas, GDWS.DM.SC;

{$R *.dfm}

procedure TGDWSDMWM.ServerFunctionInvokerHTMLTag(Sender: TObject; Tag: TTag; const TagString: string; TagParams: TStrings; var ReplaceText: string);
begin
  if SameText(TagString, 'urlpath') then
    ReplaceText := string(Request.InternalScriptName)
  else if SameText(TagString, 'port') then
    ReplaceText := IntToStr(Request.ServerPort)
  else if SameText(TagString, 'host') then
    ReplaceText := string(Request.Host)
  else if SameText(TagString, 'classname') then
    ReplaceText := GDWS.DM.SM.Pessoas.TGDWSDMSMPessoas.ClassName
  else if SameText(TagString, 'loginrequired') then
    if DSRESTWebDispatcher.AuthenticationManager <> nil then
      ReplaceText := 'true'
    else
      ReplaceText := 'false'
  else if SameText(TagString, 'serverfunctionsjs') then
    ReplaceText := string(Request.InternalScriptName) + '/js/serverfunctions.js'
  else if SameText(TagString, 'servertime') then
    ReplaceText := DateTimeToStr(Now)
  else if SameText(TagString, 'serverfunctioninvoker') then
    if AllowServerFunctionInvoker then
      ReplaceText := '<div><a href="' + string(Request.InternalScriptName) + '/ServerFunctionInvoker" target="_blank">Server Functions</a></div>'
    else
      ReplaceText := '';
end;

procedure TGDWSDMWM.WebModuleDefaultAction(Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
begin
  if (Request.InternalPathInfo = '') or (Request.InternalPathInfo = '/') then
    Response.Content := ReverseString.Content
  else
    Response.SendRedirect(Request.InternalScriptName + '/');
end;

procedure TGDWSDMWM.WebModuleBeforeDispatch(Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
begin
  if FServerFunctionInvokerAction <> nil then
    FServerFunctionInvokerAction.Enabled := AllowServerFunctionInvoker;

  Response.SetCustomHeader('Access-Control-Allow-Origin', '*');
end;

function TGDWSDMWM.AllowServerFunctionInvoker: Boolean;
begin
  Result := (Request.RemoteAddr = '127.0.0.1') or (Request.RemoteAddr = '0:0:0:0:0:0:0:1') or (Request.RemoteAddr = '::1');
end;

procedure TGDWSDMWM.WebFileDispatcherBeforeDispatch(Sender: TObject; const AFileName: string; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  D1, D2: TDateTime;
begin
  Handled := False;
  if SameFileName(ExtractFileName(AFileName), 'serverfunctions.js') then
    if not FileExists(AFileName) or (FileAge(AFileName, D1) and FileAge(WebApplicationFileName, D2) and (D1 < D2)) then
    begin
      DSProxyGenerator.TargetDirectory := ExtractFilePath(AFileName);
      DSProxyGenerator.TargetUnitName := ExtractFileName(AFileName);
      DSProxyGenerator.Write;
    end;
end;

procedure TGDWSDMWM.WebModuleCreate(Sender: TObject);
begin
  FServerFunctionInvokerAction := ActionByName('ServerFunctionInvokerAction');
  DSServerMetaDataProvider.Server := DSServer;
  DSRESTWebDispatcher.Server := DSServer;
  if DSServer.Started then
  begin
    DSRESTWebDispatcher.DbxContext := DSServer.DbxContext;
    DSRESTWebDispatcher.Start;
  end;
  DSRESTWebDispatcher.AuthenticationManager := DSAuthenticationManager;
end;

initialization

finalization
  Web.WebReq.FreeWebModules;

end.


