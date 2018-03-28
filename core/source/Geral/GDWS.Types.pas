unit GDWS.Types;

interface

uses
  FireDAC.Comp.Client, FireDAC.Comp.DataSet, GDWS.Base.Classe, System.Classes,
  System.SysUtils, DBClient, Data.DB;

type
  TGDWSCustomConnection = class(TFDConnection)
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
  end;

  TGDWSCustomTransaction = class(TFDTransaction)
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
  end;

  TGDWSCustomQuery = class(TFDQuery)
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
  end;

  TGDWSCustomDataSet = class(TFDDataSet)
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
  end;

  TGDWSCustomClientDataSet = class(TClientDataSet)
  private
  protected
  public
    { * SET's * }
    procedure AddVariant(pFieldName: String; pValue: Variant); overload;
    procedure AddString(pFieldName: String; pValue: String); overload;
    procedure AddInteger(pFieldName: String; pValue: Integer); overload;
    procedure AddDouble(pFieldName: String; pValue: Double); overload;
    procedure AddDateTime(pFieldName: String; pValue: TDateTime); overload;
    procedure AddDate(pFieldName: String; pValue: TDate); overload;
    procedure AddTime(pFieldName: String; pValue: TTime); overload;

    { * GET's * }
    function GetVariant(pFieldName: String): Variant; overload;
    function GetString(pFieldName: String): String; overload;
    function GetInteger(pFieldName: String): Integer; overload;
    function GetDouble(pFieldName: String): Double; overload;
    function GetDateTime(pFieldName: String): TDateTime; overload;
    function GetDate(pFieldName: String): TDate; overload;
    function GetTime(pFieldName: String): TTime; overload;

    procedure RemoveHiddenFlag(pFieldName: String);
    procedure InsertHiddenFlag(pFieldName: String);

    constructor Create(AOwner: TComponent); override;

  end;

  TGDWSCustomStatus = (rcsSucesso, rcsErro, rcsNone);

  TGDWSCustomSQLType = (rcstPadrao, rcstUsuarioLoginNoPassword);

  TGDWSCustomRetorno = class(TGDWSBaseClasse)
  private
    FCodigoErro: string;
    FStatus: TGDWSCustomStatus;
    FQuantidadeLinhasAfetadas: Integer;
    FQuantidadeLinhasRetornadas: Integer;
    FRetGeraID: Integer;
    FRetSQL: OleVariant;
    FListaErros: TStringList;
    FMensagem: String;
    procedure SetCodigoErro(const Value: string);
    procedure SetQuantidadeLinhasAfetadas(const Value: Integer);
    procedure SetQuantidadeLinhasRetornadas(const Value: Integer);
    procedure SetStatus(const Value: TGDWSCustomStatus);
    procedure SetRetGeraID(const Value: Integer);
    procedure SetRetSQL(const Value: OleVariant);
    procedure SetListaErros(const Value: TStringList);
    procedure SetMensagem(const Value: String);
  protected
  public
    property Status: TGDWSCustomStatus read FStatus write SetStatus;
    property Mensagem: String read FMensagem write SetMensagem;
    property ListaErros: TStringList read FListaErros write SetListaErros;
    property CodigoErro: string read FCodigoErro write SetCodigoErro;
    property QuantidadeLinhasRetornadas: Integer read FQuantidadeLinhasRetornadas write SetQuantidadeLinhasRetornadas;
    property QuantidadeLinhasAfetadas: Integer read FQuantidadeLinhasAfetadas write SetQuantidadeLinhasAfetadas;
    property RetSQL: OleVariant read FRetSQL write SetRetSQL;
    property RetGeraID: Integer read FRetGeraID write SetRetGeraID;
    constructor Create; override;
    destructor Destroy; override;
  end;

implementation

{ TGDWSCustomRetorno }

constructor TGDWSCustomRetorno.Create;
begin
  inherited;
  FStatus := rcsNone;
  FMensagem := '';
  FListaErros := TStringList.Create;
  FCodigoErro := '0';
  FQuantidadeLinhasRetornadas := 0;
  FQuantidadeLinhasAfetadas := 0;
end;

destructor TGDWSCustomRetorno.Destroy;
begin
  FreeAndNil(FListaErros);
  inherited;
end;

procedure TGDWSCustomRetorno.SetCodigoErro(const Value: string);
begin
  FCodigoErro := Value;
end;

procedure TGDWSCustomRetorno.SetListaErros(const Value: TStringList);
begin
  FListaErros := Value;
end;

procedure TGDWSCustomRetorno.SetMensagem(const Value: String);
begin
  FMensagem := Value;
end;

procedure TGDWSCustomRetorno.SetQuantidadeLinhasAfetadas(const Value: Integer);
begin
  FQuantidadeLinhasAfetadas := Value;
end;

procedure TGDWSCustomRetorno.SetQuantidadeLinhasRetornadas(const Value: Integer);
begin
  FQuantidadeLinhasRetornadas := Value;
end;

procedure TGDWSCustomRetorno.SetRetGeraID(const Value: Integer);
begin
  FRetGeraID := Value;
end;

procedure TGDWSCustomRetorno.SetRetSQL(const Value: OleVariant);
begin
  FRetSQL := Value;
end;

procedure TGDWSCustomRetorno.SetStatus(const Value: TGDWSCustomStatus);
begin
  FStatus := Value;
end;

{ TGDWSCustomClientDataSet }

function TGDWSCustomClientDataSet.GetDate(pFieldName: String): TDate;
begin
  Result := FieldByName(pFieldName).AsDateTime;
end;

procedure TGDWSCustomClientDataSet.AddDate(pFieldName: String; pValue: TDate);
begin
  FieldByName(pFieldName).AsDateTime := pValue;
  RemoveHiddenFlag(pFieldName);
end;

procedure TGDWSCustomClientDataSet.AddDateTime(pFieldName: String;
  pValue: TDateTime);
begin
  FieldByName(pFieldName).AsDateTime := pValue;
  RemoveHiddenFlag(pFieldName);
end;

function TGDWSCustomClientDataSet.GetDateTime(pFieldName: String): TDateTime;
begin
  Result := FieldByName(pFieldName).AsDateTime;
end;

function TGDWSCustomClientDataSet.GetDouble(pFieldName: String): Double;
begin
  Result := FieldByName(pFieldName).AsFloat;
end;

procedure TGDWSCustomClientDataSet.AddDouble(pFieldName: String; pValue: Double);
begin
  FieldByName(pFieldName).AsFloat := pValue;
  RemoveHiddenFlag(pFieldName);
end;

function TGDWSCustomClientDataSet.GetInteger(pFieldName: String): Integer;
begin
  Result := FieldByName(pFieldName).AsInteger;
end;

procedure TGDWSCustomClientDataSet.AddInteger(pFieldName: String;
  pValue: Integer);
begin
  FieldByName(pFieldName).AsInteger := pValue;
  RemoveHiddenFlag(pFieldName);
end;

procedure TGDWSCustomClientDataSet.AddString(pFieldName, pValue: String);
begin
  FieldByName(pFieldName).AsString := pValue;
  RemoveHiddenFlag(pFieldName);
end;

function TGDWSCustomClientDataSet.GetString(pFieldName: String): String;
begin
  Result := FieldByName(pFieldName).AsString;
end;

procedure TGDWSCustomClientDataSet.AddTime(pFieldName: String; pValue: TTime);
begin
  FieldByName(pFieldName).AsDateTime := pValue;
  RemoveHiddenFlag(pFieldName);
end;

function TGDWSCustomClientDataSet.GetTime(pFieldName: String): TTime;
begin
  Result := FieldByName(pFieldName).AsDateTime;
end;

procedure TGDWSCustomClientDataSet.AddVariant(pFieldName: String;
  pValue: Variant);
begin
  FieldByName(pFieldName).AsVariant := pValue;
  RemoveHiddenFlag(pFieldName);
end;

function TGDWSCustomClientDataSet.GetVariant(pFieldName: String): Variant;
begin
  Result := FieldByName(pFieldName).AsVariant;
end;

constructor TGDWSCustomClientDataSet.Create(AOwner: TComponent);
begin
  inherited;

end;

procedure TGDWSCustomClientDataSet.RemoveHiddenFlag(pFieldName: String);
begin
  FieldByName(pFieldName).ProviderFlags := FieldByName(pFieldName).ProviderFlags - [pfHidden];
end;

procedure TGDWSCustomClientDataSet.InsertHiddenFlag(pFieldName: String);
begin
  FieldByName(pFieldName).ProviderFlags := [pfHidden];
end;

end.


