unit GDWS.Usuarios;

interface

uses
  GDWS.Base.Controle, GDWS.Types, GDWS.Base.Classe, System.SysUtils, Data.DB;

type
  TGDWSUsuarios = class(TGDWSBaseControle)
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
  GDWS.Usuarios.Persistencia;

{ TTeste }

procedure TGDWSUsuarios.ValidarRegistroCDS;
begin
  try
    case Operacao of
      opInsert, opUpdate, opDelete, opGetItem:
        begin
          if Lista.GetInteger('USE_ID') <= 0 then
            GDWSCustomRetorno.ListaErros.Add('O campo "ID" não pode ser menor ou igual a zero.');
        end;
    end;

    case Operacao of
      opInsert, opUpdate:
        begin
          if Lista.GetString('USE_USERNAME') = '' then
            GDWSCustomRetorno.ListaErros.Add('O campo "Username" não pode ser vazio.');

          if Lista.GetString('USE_PASSWORD') = '' then
            GDWSCustomRetorno.ListaErros.Add('O campo "Password" não pode ser vazio.');

          if Lista.GetString('USE_ADMIN') = '' then
            GDWSCustomRetorno.ListaErros.Add('O campo "Admim" não pode ser vazio.');
        end;
    end;
  except
    on E: Exception do
      raise;
  end;
end;

function TGDWSUsuarios.Executar(pOperacao: TOperacao): TGDWSCustomRetorno;
var
  lObjPst: TGDWSUsuariosPersistencia;
begin
  try
    lObjPst := TGDWSUsuariosPersistencia.Create;
    try
      NomeTabela := 'USERS';
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


