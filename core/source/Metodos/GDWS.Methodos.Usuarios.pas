unit GDWS.Methodos.Usuarios;

interface

uses
  GDWS.Base.Metodos, System.SysUtils, System.Classes, GDWS.Types, Variants, System.JSON;

type
  TGDWSMethodosUsuarios = class(TGDWSBaseMetodos)
    procedure insert;
    procedure login;
  private
  public
    {function update(pPessoa_Cliente_ID, pID, pUsername, pPassword, pEmail, pFoneFixo, pFoneMovel: string): TJSONObject;
    function delete(pID: string): TJSONObject;
    function getList(pFiltro: string): TJSONArray;
    function getItem(pID: string): TJSONArray;
    function genID: TJSONObject;}

    constructor Create;
  end;

implementation

uses
  GDWS.Usuarios, GDWS.Base.Classe, GDWS.DM.Connection, GDWS.Utils, REST.Json;

constructor TGDWSMethodosUsuarios.Create;
begin
  className := 'users';
end;

procedure TGDWSMethodosUsuarios.insert;
var
  lUsuario, lUsuarioAux: TGDWSUsuarios;
  lRetorno: TGDWSCustomRetorno;
  lJsonPair: TJSONPair;
  lListaAux: TGDWSCustomClientDataSet;
  I: Integer;
begin
  try
    GDWSDMConnection := TGDWSDMConnection.Create(nil);
    lUsuario := TGDWSUsuarios.Create;
    lUsuarioAux := TGDWSUsuarios.Create;
    try
      GDWSDMConnection.Start;

      lUsuario.Lista.Insert;

      lUsuario.Lista.AddInteger('USE_ID', lUsuario.Executar(opGenID).RetGeraID);

      for I := 0 to lUsuario.Lista.Fields.count - 1 do
      begin
        lJsonPair := Data.Get(lUsuario.Lista.Fields[I].FieldName.ToLower);

        if lJsonPair <> nil then
          lUsuario.Lista.AddString(lUsuario.Lista.Fields[I].FieldName, lJsonPair.JsonValue.Value);
      end;

      lUsuario.Lista.Post;

      lUsuarioAux.FiltroSQL := 'USE_USERNAME=' + QuotedStr(lUsuario.Lista.GetString('USE_USERNAME'));

      lRetorno := lUsuarioAux.Executar(opGetList);

      lUsuarioAux.Lista.Close;
      lUsuarioAux.Lista.Data := lRetorno.RetSQL;
      lUsuarioAux.Lista.Open;

      if lUsuarioAux.Lista.RecordCount > 0 then
      begin
        lRetorno.Status := rcsErro;
        lRetorno.Mensagem := 'O nome de usuário "' + lUsuario.Lista.GetString('USE_USERNAME') + '" não está disponível.';
        lRetorno.QuantidadeLinhasRetornadas := 0;
        lRetorno.QuantidadeLinhasAfetadas := 0;
        lRetorno.RetGeraID := 0;
      end
      else
      begin
        lRetorno := lUsuario.Executar(opInsert);

        if lRetorno.Status = rcsSucesso then
          GDWSDMConnection.Commit
        else
          GDWSDMConnection.Rollback;

        lRetorno.RetGeraID := lUsuario.Lista.FieldByName('USE_ID').AsInteger;
      end;

      Resultado := TGDWSUtils.RetornoToJSON(lRetorno);
    finally
      FreeAndNil(lUsuario);
      FreeAndNil(GDWSDMConnection);
      FreeAndNil(lUsuarioAux);
    end;
  except
    on E: Exception do
      raise;
  end;
end;

procedure TGDWSMethodosUsuarios.login;
var
  lUsuario: TGDWSUsuarios;
  lRetorno: TGDWSCustomRetorno;

  lJsonPair: TJSONPair;
  lJsonObj: TJSONObject;

  lUsername,
  lPassword: String;
begin
  try
    GDWSDMConnection := TGDWSDMConnection.Create(nil);
    lUsuario := TGDWSUsuarios.Create;
    try
      lJsonPair := Data.Get('use_username');
      lUsername := lJsonPair.JsonValue.Value;

      lJsonPair := Data.Get('use_password');
      lPassword := lJsonPair.JsonValue.Value;

      lUsuario.FiltroSQL := 'USE_USERNAME=' + QuotedStr(lUsername) + ' AND USE_PASSWORD=' + QuotedStr(lPassword);

      lUsuario.TipoSQL := rcstUsuarioLoginNoPassword;

      lRetorno := lUsuario.Executar(opGetList);

      lUsuario.Lista.Close;
      lUsuario.Lista.Data := lRetorno.RetSQL;
      lUsuario.Lista.Open;

      lJsonObj := TJSONObject.Create;

      if lUsuario.Lista.RecordCount > 0 then
        begin
          lJsonObj.AddPair('RetLogin','1');
          lJsonObj.AddPair('use_username',lUsuario.Lista.FieldByName('USE_USERNAME').AsString);
          lJsonObj.AddPair('use_admin',lUsuario.Lista.FieldByName('USE_ADMIN').AsString);
        end
      else lJsonObj.AddPair('RetLogin','0');

      Resultado := lJsonObj;
    finally
      FreeAndNil(lUsuario);
      FreeAndNil(GDWSDMConnection);
    end;
  except
    on E: Exception do
      raise;
  end;
end;

{function TGDWSMethodosUsuarios.getList: TJSONArray;
var
  lUsuario: TGDWSUsuarios;
  lRetorno: TGDWSCustomRetorno;
begin
  try
    GDWSDMConnection := TGDWSDMConnection.Create(Self);
    lUsuario := TGDWSUsuarios.Create;
    try
      GDWSDMConnection.Start;

      lUsuario.FiltroSQL := pFiltro;

      lRetorno := lUsuario.Executar(opGetList);
      if lRetorno.Status = rcsSucesso then
        GDWSDMConnection.Commit
      else
        GDWSDMConnection.Rollback;

      lUsuario.Lista.Close;
      lUsuario.Lista.Data := lRetorno.RetSQL;
      lUsuario.Lista.Open;

      Result := TGDWSUtils.CDSToJSON(lUsuario.Lista);
    finally
      FreeAndNil(lUsuario);
      FreeAndNil(GDWSDMConnection);
    end;
  except
    on E: Exception do
      raise;
  end;
end;

function TGDWSMethodosUsuarios.getItem: TJSONArray;
var
  lUsuario: TGDWSUsuarios;
  lRetorno: TGDWSCustomRetorno;
begin
  try
    GDWSDMConnection := TGDWSDMConnection.Create(Self);
    lUsuario := TGDWSUsuarios.Create;
    try
      GDWSDMConnection.Start;

      lUsuario.Lista.AddInteger('PU_ID', pID.ToInteger);

      lRetorno := lUsuario.Executar(opGetList);
      if lRetorno.Status = rcsSucesso then
        GDWSDMConnection.Commit
      else
        GDWSDMConnection.Rollback;

      lUsuario.Lista.Close;
      lUsuario.Lista.Data := lRetorno.RetSQL;
      lUsuario.Lista.Open;

      Result := TGDWSUtils.CDSToJSON(lUsuario.Lista);
    finally
      FreeAndNil(lUsuario);
      FreeAndNil(GDWSDMConnection);
    end;
  except
    on E: Exception do
      raise;
  end;
end;

function TGDWSMethodosUsuarios.delete: TJSONObject;
var
  lUsuario: TGDWSUsuarios;
  lRetorno: TGDWSCustomRetorno;
begin
  try
    GDWSDMConnection := TGDWSDMConnection.Create(Self);
    lUsuario := TGDWSUsuarios.Create;
    try
      GDWSDMConnection.Start;

      lUsuario.Lista.Insert;
      lUsuario.Lista.AddInteger('PU_ID', pID.ToInteger);
      lUsuario.Lista.Post;

      lRetorno := lUsuario.Executar(opDelete);
      if lRetorno.Status = rcsSucesso then
        GDWSDMConnection.Commit
      else
        GDWSDMConnection.Rollback;

      Result := TGDWSUtils.RetornoToJSON(lRetorno);
    finally
      FreeAndNil(lUsuario);
      FreeAndNil(GDWSDMConnection);
    end;
  except
    on E: Exception do
      raise;
  end;
end;

function TGDWSMethodosUsuarios.genID: TJSONObject;
var
  lUsuario: TGDWSUsuarios;
begin
  try
    GDWSDMConnection := TGDWSDMConnection.Create(Self);
    lUsuario := TGDWSUsuarios.Create;
    try
      Result := TGDWSUtils.RetornoToJSON(lUsuario.Executar(opGenID));
    finally
      FreeAndNil(lUsuario);
      FreeAndNil(GDWSDMConnection);
    end;
  except
    on E: Exception do
      raise;
  end;
end;

function TGDWSMethodosUsuarios.update: TJSONObject;
var
  lUsuario: TGDWSUsuarios;
  lRetorno: TGDWSCustomRetorno;
begin
  try
    GDWSDMConnection := TGDWSDMConnection.Create(Self);
    lUsuario := TGDWSUsuarios.Create;
    try
      GDWSDMConnection.Start;

      lUsuario.Lista.Insert;
      lUsuario.Lista.AddInteger('PU_PESSOA_ID', pID.ToInteger);
      lUsuario.Lista.AddInteger('PU_ID', lUsuario.Executar(opGenID).RetGeraID);
      lUsuario.Lista.AddString('PU_USERNAME', pUsername);
      lUsuario.Lista.AddString('PU_PASSWORD', pPassword);
      lUsuario.Lista.AddString('PU_EMAIL', pEmail);
      lUsuario.Lista.AddString('PU_FONE_FIXO', pFoneFixo);
      lUsuario.Lista.AddString('PU_FONE_MOVEL', pFoneMovel);
      lUsuario.Lista.AddDateTime('PU_DATA_ALTERACAO', Now);
      lUsuario.Lista.Post;

      lRetorno := lUsuario.Executar(opUpdate);
      if lRetorno.Status = rcsSucesso then
        GDWSDMConnection.Commit
      else
        GDWSDMConnection.Rollback;

      Result := TGDWSUtils.RetornoToJSON(lRetorno);
    finally
      FreeAndNil(lUsuario);
      FreeAndNil(GDWSDMConnection);
    end;
  except
    on E: Exception do
      raise;
  end;
end;}

end.


