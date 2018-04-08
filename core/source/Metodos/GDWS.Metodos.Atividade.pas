unit GDWS.Metodos.Atividade;

interface

uses
  GDWS.Base.Metodos, System.SysUtils, System.Classes, GDWS.Types, Variants, System.JSON;

type
  TGDWSMetodosAtividade = class(TGDWSBaseMetodos)
    procedure insert;
    procedure delete;
    procedure update;
    procedure lista;

  public
    constructor Create;
  end;

implementation

uses
  GDWS.Atividade, GDWS.Base.Classe, GDWS.DM.Connection, GDWS.Utils, REST.Json;

constructor TGDWSMetodosAtividade.Create;
begin
  className := 'atividade';
end;

procedure TGDWSMetodosAtividade.lista;
var
  lAtividade: TGDWSAtividade;
  lRetorno: TGDWSCustomRetorno;
  lJsonPair: TJSONPair;
  lListaAux: TGDWSCustomClientDataSet;
  I: Integer;
begin
  try
    GDWSDMConnection := TGDWSDMConnection.Create(nil);
    lAtividade := TGDWSAtividade.Create;
    try
      lRetorno := lAtividade.Executar(opGetList);

      Resultado := TGDWSUtils.CDSToJSON(lAtividade.Lista);
    finally
      FreeAndNil(lAtividade);
      FreeAndNil(GDWSDMConnection);
    end;
  except
    on E: Exception do
      raise;
  end;
end;

procedure TGDWSMetodosAtividade.insert;
var
  lAtividade: TGDWSAtividade;
  lRetorno: TGDWSCustomRetorno;
  lJsonPair: TJSONPair;
  lListaAux: TGDWSCustomClientDataSet;
  I: Integer;
begin
  try
    GDWSDMConnection := TGDWSDMConnection.Create(nil);
    lAtividade := TGDWSAtividade.Create;
    try
      GDWSDMConnection.Start;

      lAtividade.Lista.Insert;

      lAtividade.Lista.AddInteger('ATI_ID', lAtividade.Executar(opGenID).RetGeraID);

      for I := 0 to lAtividade.Lista.Fields.count - 1 do
      begin
        lJsonPair := Data.Get(lAtividade.Lista.Fields[I].FieldName.ToLower);

        if lJsonPair <> nil then
          lAtividade.Lista.AddString(lAtividade.Lista.Fields[I].FieldName, lJsonPair.JsonValue.Value);
      end;

      lAtividade.Lista.Post;

      lRetorno := lAtividade.Executar(opInsert);

      if lRetorno.Status = rcsSucesso then
        GDWSDMConnection.Commit
      else
        GDWSDMConnection.Rollback;

      lRetorno.RetGeraID := lAtividade.Lista.FieldByName('ATI_ID').AsInteger;

      Resultado := TGDWSUtils.RetornoToJSON(lRetorno);
    finally
      FreeAndNil(lAtividade);
      FreeAndNil(GDWSDMConnection);
    end;
  except
    on E: Exception do
      raise;
  end;
end;

procedure TGDWSMetodosAtividade.delete;
var
  lAtividade: TGDWSAtividade;
  lRetorno: TGDWSCustomRetorno;
  lJsonPair: TJSONPair;
  lListaAux: TGDWSCustomClientDataSet;
  I: Integer;
begin
  try
    GDWSDMConnection := TGDWSDMConnection.Create(nil);
    lAtividade := TGDWSAtividade.Create;
    try
      GDWSDMConnection.Start;

      lAtividade.Lista.Insert;

      for I := 0 to lAtividade.Lista.Fields.count - 1 do
      begin
        lJsonPair := Data.Get(lAtividade.Lista.Fields[I].FieldName.ToLower);

        if lJsonPair <> nil then
          lAtividade.Lista.AddString(lAtividade.Lista.Fields[I].FieldName, lJsonPair.JsonValue.Value);
      end;

      lAtividade.Lista.Post;

      lRetorno := lAtividade.Executar(opDelete);

      if lRetorno.Status = rcsSucesso then
        GDWSDMConnection.Commit
      else
        GDWSDMConnection.Rollback;

      Resultado := TGDWSUtils.RetornoToJSON(lRetorno);
    finally
      FreeAndNil(lAtividade);
      FreeAndNil(GDWSDMConnection);
    end;
  except
    on E: Exception do
      raise;
  end;
end;

procedure TGDWSMetodosAtividade.update;
var
  lAtividade: TGDWSAtividade;
  lRetorno: TGDWSCustomRetorno;
  lJsonPair: TJSONPair;
  lListaAux: TGDWSCustomClientDataSet;
  I: Integer;
begin
  try
    GDWSDMConnection := TGDWSDMConnection.Create(nil);
    lAtividade := TGDWSAtividade.Create;
    try
      GDWSDMConnection.Start;

      lAtividade.Lista.Insert;

      for I := 0 to lAtividade.Lista.Fields.count - 1 do
      begin
        lJsonPair := Data.Get(lAtividade.Lista.Fields[I].FieldName.ToLower);

        if lJsonPair <> nil then
          lAtividade.Lista.AddString(lAtividade.Lista.Fields[I].FieldName, lJsonPair.JsonValue.Value);
      end;

      lAtividade.Lista.Post;

      lRetorno := lAtividade.Executar(opUpdate);

      if lRetorno.Status = rcsSucesso then
        GDWSDMConnection.Commit
      else
        GDWSDMConnection.Rollback;

      Resultado := TGDWSUtils.RetornoToJSON(lRetorno);
    finally
      FreeAndNil(lAtividade);
      FreeAndNil(GDWSDMConnection);
    end;
  except
    on E: Exception do
      raise;
  end;
end;


end.


