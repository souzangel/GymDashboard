unit GDWS.Base.Controle;

interface

uses
  GDWS.Base.Classe, GDWS.Types, System.SysUtils, DBClient, Data.DB;

type
  TGDWSBaseControle = class(TGDWSBaseClasse)
  private
    FFiltroSQL: string;
    FGDWSCustomRetorno: TGDWSCustomRetorno;
    FOperacao: TOperacao;
    FCDSObjetos: TGDWSCustomClientDataSet;
    FNomeTabela: string;
    FSchema: string;
    FTipoSQL: TGDWSCustomSQLType;
    procedure SetFiltroSQL(const Value: string);
    procedure SetGDWSCustomRetorno(const Value: TGDWSCustomRetorno);
    procedure SetOperacao(const Value: TOperacao);
    procedure SetCDSObjetos(const Value: TGDWSCustomClientDataSet);
    procedure SetNomeTabela(const Value: string);
    procedure SetSchema(const Value: string);
    procedure SetTipoSQL(const Value: TGDWSCustomSQLType);
    procedure DefineSchema;
  protected
    property GDWSCustomRetorno: TGDWSCustomRetorno read FGDWSCustomRetorno write SetGDWSCustomRetorno;
  public
    property FiltroSQL: string read FFiltroSQL write SetFiltroSQL;
    property Lista: TGDWSCustomClientDataSet read FCDSObjetos write SetCDSObjetos;
    property Schema: string read FSchema write SetSchema;
    property NomeTabela: string read FNomeTabela write SetNomeTabela;
    property Operacao: TOperacao read FOperacao write SetOperacao;
    property TipoSQL: TGDWSCustomSQLType read FTipoSQL write SetTipoSQL;

    //Implementar e herdar nas classses filhas
    function Validar: TGDWSCustomRetorno;
    procedure ValidarRegistroCDS; virtual; abstract;
    function Executar(pOperacao: TOperacao): TGDWSCustomRetorno; virtual; abstract;
    constructor Create; override;
    destructor Destroy; override;
  published
    { published declarations }
  end;

implementation

uses
  GDWS.Base.Persistencia, GDWS.DM.Connection;

{ TBaseControl }

constructor TGDWSBaseControle.Create;
begin
  inherited;
  DefineSchema;

  FCDSObjetos := TGDWSCustomClientDataSet.Create(nil);

  FFiltroSQL := '1=0';

  FCDSObjetos.Close;
  FCDSObjetos.Data := Executar(opSQLObjetos).RetSQL;
  FCDSObjetos.Open;

  FFiltroSQL := '';

  FTipoSQL := rcstPadrao;

end;

destructor TGDWSBaseControle.Destroy;
begin
  FCDSObjetos.Close;
  FreeAndNil(FCDSObjetos);

  inherited;
end;

procedure TGDWSBaseControle.DefineSchema;
begin
  if GDWSDMConnection.GetConn.Params.DriverID = 'FB' then
    Schema := ''
  else if GDWSDMConnection.GetConn.Params.DriverID = 'MySQL' then
    Schema := '';
end;

procedure TGDWSBaseControle.SetCDSObjetos(const Value: TGDWSCustomClientDataSet);
begin
  FCDSObjetos := Value;
end;

procedure TGDWSBaseControle.SetFiltroSQL(const Value: string);
begin
  FFiltroSQL := Value;
end;

procedure TGDWSBaseControle.SetNomeTabela(const Value: string);
begin
  FNomeTabela := Value;
end;

procedure TGDWSBaseControle.SetOperacao(const Value: TOperacao);
begin
  FOperacao := Value;
end;

procedure TGDWSBaseControle.SetGDWSCustomRetorno(const Value: TGDWSCustomRetorno);
begin
  FGDWSCustomRetorno := Value;
end;

procedure TGDWSBaseControle.SetSchema(const Value: string);
begin
  FSchema := Value;
end;

procedure TGDWSBaseControle.SetTipoSQL(const Value: TGDWSCustomSQLType);
begin
  FTipoSQL := Value;
end;

function TGDWSBaseControle.Validar: TGDWSCustomRetorno;
begin
  try
    FGDWSCustomRetorno := TGDWSCustomRetorno.Create;

    case Operacao of
      opInsert, opUpdate, opDelete, opGetItem:
        begin
          if Lista.Active then
          begin
            Lista.First;
            while not Lista.Eof do
            begin
              ValidarRegistroCDS;
              Lista.Next;
            end;
          end;
        end;

      opGetList, opSQLObjetos, opGenID:
        begin

        end;
    end;

    if GDWSCustomRetorno.ListaErros.Count > 0 then
    begin
      GDWSCustomRetorno.Status := rcsErro;
      GDWSCustomRetorno.Mensagem := 'Erro de validação.';
      GDWSCustomRetorno.CodigoErro := '1';
    end
    else
    begin
      GDWSCustomRetorno.Status := rcsSucesso;
      GDWSCustomRetorno.Mensagem := 'Dados validados com sucesso.';
    end;

    Result := GDWSCustomRetorno;
  except
    on E: Exception do
      raise;
  end;

end;

end.


