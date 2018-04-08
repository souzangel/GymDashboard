unit GDWS.Atividade;

interface

uses
  GDWS.Base.Controle, GDWS.Types, GDWS.Base.Classe, System.SysUtils, Data.DB;

type
  TGDWSAtividade = class(TGDWSBaseControle)
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
  GDWS.Atividade.Persistencia;

{ TTeste }

procedure TGDWSAtividade.ValidarRegistroCDS;
begin
  try
    case Operacao of
      opInsert, opUpdate, opDelete, opGetItem:
        begin
          if Lista.GetInteger('ATI_ID') <= 0 then
            GDWSCustomRetorno.ListaErros.Add('O campo "ID" não pode ser menor ou igual a zero.');
        end;
    end;

    case Operacao of
      opInsert, opUpdate:
        begin
          if Lista.GetString('ATI_TIPO') = '' then
            GDWSCustomRetorno.ListaErros.Add('O campo "Tipo" não pode ser vazio.');
        end;
    end;
  except
    on E: Exception do
      raise;
  end;
end;

function TGDWSAtividade.Executar(pOperacao: TOperacao): TGDWSCustomRetorno;
var
  lObjPst: TGDWSAtividadePersistencia;
begin
  try
    lObjPst := TGDWSAtividadePersistencia.Create;
    try
      NomeTabela := 'ATIVIDADE';
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


