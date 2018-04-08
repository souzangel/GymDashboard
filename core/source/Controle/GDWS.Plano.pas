unit GDWS.Plano;

interface

uses
  GDWS.Base.Controle, GDWS.Types, GDWS.Base.Classe, System.SysUtils, Data.DB;

type
  TGDWSPlano = class(TGDWSBaseControle)
  private
    { private declarations }
  protected
    { protected declarations }
  public
    procedure ValidarRegistroCDS; override;
    function Executar(pOperacao: TOperacao): TGDWSCustomRetorno; override;
  published
    { published declarations }
  end;

implementation

uses
  GDWS.Plano.Persistencia;

{ TTeste }

procedure TGDWSPlano.ValidarRegistroCDS;
begin
  try
    case Operacao of
      opInsert, opUpdate, opDelete, opGetItem:
        begin
          if Lista.GetInteger('PLA_ID') <= 0 then
            GDWSCustomRetorno.ListaErros.Add('O campo "ID" não pode ser menor ou igual a zero.');
        end;
    end;

    case Operacao of
      opInsert, opUpdate:
        begin
          if Lista.GetString('PLA_TIPO') = '' then
            GDWSCustomRetorno.ListaErros.Add('O campo "Tipo" não pode ser vazio.');
        end;
    end;
  except
    on E: Exception do
      raise;
  end;
end;

function TGDWSPlano.Executar(pOperacao: TOperacao): TGDWSCustomRetorno;
var
  lObjPst: TGDWSPlanoPersistencia;
begin
  try
    lObjPst := TGDWSPlanoPersistencia.Create;
    try
      NomeTabela := 'PLANO';
      Result := lObjPst.Executar(Self, pOperacao);
    finally
      FreeAndNil(lObjPst);
    end;
  except
    on E: Exception do
      raise;
  end;
end;

end.


