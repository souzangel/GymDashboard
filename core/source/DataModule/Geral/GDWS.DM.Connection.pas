unit GDWS.DM.Connection;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.DApt, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait, FireDAC.Comp.UI, FireDAC.Phys.IBBase, FireDAC.Phys.FB, FireDAC.Comp.Client, Data.DB, JvComponentBase, JvThreadTimer, Forms, FireDAC.Phys.FBDef, Dialogs, FireDAC.Phys.MySQL, FireDAC.Phys.MySQLDef, GDWS.Types,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.Phys.IBWrapper,
  Datasnap.DBClient, FireDAC.Comp.DataSet, Datasnap.Provider;

type
  TGDWSDMConnection = class(TDataModule)
    FDConn: TFDConnection;
    FDTrans: TFDTransaction;
    FDWCursor: TFDGUIxWaitCursor;
    FDLinkMySQL: TFDPhysMySQLDriverLink;
    FDLinkFB: TFDPhysFBDriverLink;
    procedure thdTimerTimer(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    procedure ConectarBD;
    { Private declarations }
  public
    { Public declarations }
    procedure Connect;
    procedure Disconnect;
    procedure Start;
    procedure Rollback;
    procedure Commit;
    function GetConn: TGDWSCustomConnection;
  end;

var
  GDWSDMConnection: TGDWSDMConnection;

implementation

uses
  GDWS.UtilS, IniFiles, GDWS.Seguranca, IWSystem;

{$R *.dfm}

procedure TGDWSDMConnection.ConectarBD;
var
  lNomeBanco, lUser, lSenha: string;
  lIniFile: TIniFile;
begin
  try
    lIniFile := TIniFile.Create(ExtractFilePath(gsAppPath) + 'confdb.ini');
    lNomeBanco := lIniFile.ReadString('DB', 'path', '');

    if not FileExists(lNomeBanco) then
      raise Exception.Create('Banco de dados não encontrado na pasta banco!');

    lUser := lIniFile.ReadString('DB', 'user', '');
    lSenha := lIniFile.ReadString('DB', 'password', '');
    FDConn.Params.Add('Database=' + lNomeBanco);
    FDConn.Params.Add('User_Name=' + lUser);
    FDConn.Params.Add('password=' + lSenha);
    FDConn.Connected := True;

    if not FDConn.Connected then
      raise Exception.Create('Não foi possível conectar-se ao banco de dados! ');
  except
    on E: Exception do
    begin
      ShowMessage('ConectarBD: ' + E.Message);
      raise;
    end;
  end;
end;

procedure TGDWSDMConnection.DataModuleCreate(Sender: TObject);
begin
  Connect;
end;

procedure TGDWSDMConnection.DataModuleDestroy(Sender: TObject);
begin
  Disconnect;
end;

function TGDWSDMConnection.GetConn: TGDWSCustomConnection;
begin
  try
    Result := TGDWSCustomConnection(FDConn);
  except
    on E: Exception do
      raise;
  end;
end;

procedure TGDWSDMConnection.Rollback;
begin
  FDConn.Rollback;
end;

procedure TGDWSDMConnection.Start;
begin
  FDConn.StartTransaction;
end;

procedure TGDWSDMConnection.Commit;
begin
  FDConn.Commit;
end;

procedure TGDWSDMConnection.Connect;
begin
  try
    ConectarBD;
    if not FDConn.Connected then
      FDConn.Connected := True;
  except
    on E: Exception do
      raise;
  end;
end;

procedure TGDWSDMConnection.Disconnect;
begin
  if FDConn.Connected then
    FDConn.Connected := False;
end;

procedure TGDWSDMConnection.thdTimerTimer(Sender: TObject);
begin
  ConectarBD;
end;

end.


