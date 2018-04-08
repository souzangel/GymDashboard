unit GDWS.Cliente;

interface

uses
  GDWS.Base.Controle, GDWS.Types, GDWS.Base.Classe, System.SysUtils, Data.DB;

type
  TGDWSCliente = class(TGDWSBaseControle)
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
  GDWS.Cliente.Persistencia;

{ TTeste }

procedure TGDWSCliente.ValidarRegistroCDS;
begin
  try
    case Operacao of
      opInsert, opUpdate, opDelete, opGetItem:
        begin
          if Lista.GetInteger('CLI_ID') <= 0 then
            GDWSCustomRetorno.ListaErros.Add('O campo "ID" não pode ser menor ou igual a zero.');
        end;
    end;

    case Operacao of
      opInsert, opUpdate:
        begin
          if Lista.GetString('CLI_NOME') = '' then
            GDWSCustomRetorno.ListaErros.Add('O campo "Nome" não pode ser vazio.');

          if Lista.GetString('CLI_CPF') = '' then
            GDWSCustomRetorno.ListaErros.Add('O campo "CPF" não pode ser vazio.');
        end;
    end;
  except
    on E: Exception do
      raise;
  end;
end;

function TGDWSCliente.Executar(pOperacao: TOperacao): TGDWSCustomRetorno;
var
  lObjPst: TGDWSClientePersistencia;
begin
  try
    lObjPst := TGDWSClientePersistencia.Create;
    try
      NomeTabela := 'CLIENTE';
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


