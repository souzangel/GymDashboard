unit GDWS.Usuarios.Persistencia;

interface

uses
  GDWS.Base.Persistencia, GDWS.Types, GDWS.Base.Classe, System.SysUtils, GDWS.Base.Controle;

type
  TGDWSUsuariosPersistencia = class(TGDWSBasePersistencia)
  private
    procedure SQLNoPassword(out pObjeto: TGDWSBaseControle);
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

uses
  GDWS.Utils;

{ TUsuariosPst }

procedure TGDWSUsuariosPersistencia.SQL(out pObjeto: TGDWSBaseControle);
begin
  try
    case pObjeto.TipoSQL of
      rcstPadrao:
        SQLPadrao(pObjeto);
      rcstUsuarioLoginNoPassword:
        SQLPadrao(pObjeto);
    end;
  except
    on E: Exception do
      raise;
  end;
end;

procedure TGDWSUsuariosPersistencia.SQLNoPassword(out pObjeto: TGDWSBaseControle);
begin
  try
    Query.SQL.Add(' SELECT USE_ID, USE_USERNAME, USE_ADMIN FROM ' + pObjeto.Schema + TGDWSUtils.Iif(pObjeto.Schema <> '', '.', '') + pObjeto.NomeTabela + ' ');
  except
    on E: Exception do
      raise;
  end;
end;

end.


