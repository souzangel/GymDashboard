unit GDWS.DM.SC;

interface

uses
  System.SysUtils, System.Classes, Datasnap.DSServer, Datasnap.DSCommonServer, Datasnap.DSClientMetadata, Datasnap.DSHTTPServiceProxyDispatcher, Datasnap.DSProxyJavaAndroid, Datasnap.DSProxyJavaBlackBerry, Datasnap.DSProxyObjectiveCiOS, Datasnap.DSProxyCsharpSilverlight, Datasnap.DSProxyFreePascal_iOS, Datasnap.DSAuth, IPPeerServer, Datasnap.DSTCPServerTransport, Datasnap.DSHTTP, Datasnap.DSHTTPWebBroker;

type
  TGDWSDMSC = class(TDataModule)
    DSServer: TDSServer;
    DSAuthenticationManager: TDSAuthenticationManager;
    DSTCPServerTransp: TDSTCPServerTransport;
    procedure DSAuthenticationManagerUserAuthorize(Sender: TObject; EventObject: TDSAuthorizeEventObject; var valid: Boolean);
    procedure DSAuthenticationManagerUserAuthenticate(Sender: TObject; const Protocol, Context, User, Password: string; var valid: Boolean; UserRoles: TStrings);
  private
    { Private declarations }
    FDSServerClass: TDSServerClass;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

function DSServer: TDSServer;
function DSTCPServerTransport: TDSTCPServerTransport;
function DSAuthenticationManager: TDSAuthenticationManager;

implementation

uses
  Winapi.Windows, GDWS.Seguranca, GDWS.Utils, GDWS.DS.ServerClass, GDWS.Lista.Classes, GDWS.Form.Principal;

{$R *.dfm}

var
  FModule: TComponent;
  FDSServer: TDSServer;
  FDSTCPServerTransp: TDSTCPServerTransport;
  FDSAuthenticationManager: TDSAuthenticationManager;

function DSServer: TDSServer;
begin
  Result := FDSServer;
end;

function DSTCPServerTransport: TDSTCPServerTransport;
begin
  Result := FDSTCPServerTransp;
end;

function DSAuthenticationManager: TDSAuthenticationManager;
begin
  Result := FDSAuthenticationManager;
end;

constructor TGDWSDMSC.Create(AOwner: TComponent);
var
  lListaSM: TArray<TPersistentClass>;
  lSM: TPersistentClass;
begin
  inherited;
  FDSServer := DSServer;
  FDSAuthenticationManager := DSAuthenticationManager;
  FDSTCPServerTransp := DSTCPServerTransp;

  lListaSM := TGDWSListaClasses.getListaServerMethods;
  try
    for lSM in lListaSM do
    begin
      TGDWSDSServerClass.Create(Self, DSServer, lSM);
    end;
  finally
    lListaSM := nil;
  end;
end;

destructor TGDWSDMSC.Destroy;
begin
  inherited;
  FDSServer := nil;
  FDSAuthenticationManager := nil;
  FreeAndNil(FDSServerClass);
end;

procedure TGDWSDMSC.DSAuthenticationManagerUserAuthenticate(Sender: TObject; const Protocol, Context, User, Password: string; var valid: Boolean; UserRoles: TStrings);
begin
  { TODO : Validate the client user and password.
    If role-based authorization is needed, add role names to the UserRoles parameter  }
  valid := False;
  if ((UpperCase(User) = 'GDWS') and (UpperCase(Password) = 'GDWS')) then
  begin
    valid := True;
  end;
end;

procedure TGDWSDMSC.DSAuthenticationManagerUserAuthorize(Sender: TObject; EventObject: TDSAuthorizeEventObject; var valid: Boolean);
begin
  { TODO : Authorize a user to execute a method.
    Use values from EventObject such as UserName, UserRoles, AuthorizedRoles and DeniedRoles.
    Use DSAuthenticationManager.Roles to define Authorized and Denied roles
    for particular server methods. }
  if ((UpperCase(EventObject.UserName) = 'GDWS')) then
  begin
    valid := True;
  end;
end;

initialization
  FModule := TGDWSDMSC.Create(nil);

finalization
  FModule.Free;

end.


