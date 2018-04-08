unit GDWS.Cliente.Persistencia;

interface

uses
  GDWS.Base.Persistencia, GDWS.Types, GDWS.Base.Classe, System.SysUtils, GDWS.Base.Controle, Data.DB;

type
  TGDWSClientePersistencia = class(TGDWSBasePersistencia)
  private
    { private declarations }
  protected
    { protected declarations }
    procedure SQL(out pObjeto: TGDWSBaseControle); override;
  public
    { public declarations }

  published
    { published declarations }
  end;

implementation

{ TPessoaClientePst }

procedure TGDWSClientePersistencia.SQL(out pObjeto: TGDWSBaseControle);
begin
  try
    case pObjeto.TipoSQL of
      rcstPadrao:
        SQLPadrao(pObjeto);
    end;
  except
    on E: Exception do
      raise;
  end;
end;

end.


