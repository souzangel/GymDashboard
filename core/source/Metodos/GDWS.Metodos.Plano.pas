unit GDWS.Metodos.Plano;

interface

uses
  GDWS.Base.Metodos, System.SysUtils, System.Classes, GDWS.Types, Variants, System.JSON;

type
  TGDWSMetodosPlano = class(TGDWSBaseMetodos)
    procedure insert;
    procedure delete;
    procedure update;
    procedure lista;

  public
    constructor Create;
  end;

implementation

uses
  GDWS.Plano, GDWS.Base.Classe, GDWS.DM.Connection, GDWS.Utils, REST.Json;

constructor TGDWSMetodosPlano.Create;
begin
  className := 'plano';
end;

procedure TGDWSMetodosPlano.insert;
var
  lPlano: TGDWSPlano;
  lRetorno: TGDWSCustomRetorno;
  lJsonPair: TJSONPair;
  lListaAux: TGDWSCustomClientDataSet;
  I: Integer;
begin
  try
    GDWSDMConnection := TGDWSDMConnection.Create(nil);
    lPlano := TGDWSPlano.Create;
    try
      GDWSDMConnection.Start;

      lPlano.Lista.Insert;

      lPlano.Lista.AddInteger('PLA_ID', lPlano.Executar(opGenID).RetGeraID);

      for I := 0 to lPlano.Lista.Fields.count - 1 do
      begin
        lJsonPair := Data.Get(lPlano.Lista.Fields[I].FieldName.ToLower);

        if lJsonPair <> nil then
          lPlano.Lista.AddString(lPlano.Lista.Fields[I].FieldName, lJsonPair.JsonValue.Value);
      end;

      lPlano.Lista.Post;

      lRetorno := lPlano.Executar(opInsert);

      if lRetorno.Status = rcsSucesso then
        GDWSDMConnection.Commit
      else
        GDWSDMConnection.Rollback;

      lRetorno.RetGeraID := lPlano.Lista.FieldByName('PLA_ID').AsInteger;

      Resultado := TGDWSUtils.RetornoToJSON(lRetorno);
    finally
      FreeAndNil(lPlano);
      FreeAndNil(GDWSDMConnection);
    end;
  except
    on E: Exception do
      raise;
  end;
end;

procedure TGDWSMetodosPlano.lista;
var
  lPlano: TGDWSPlano;
  lRetorno: TGDWSCustomRetorno;
  lJsonPair: TJSONPair;
  lListaAux: TGDWSCustomClientDataSet;
  I: Integer;
begin
  try
    GDWSDMConnection := TGDWSDMConnection.Create(nil);
    lPlano := TGDWSPlano.Create;
    try
      lRetorno := lPlano.Executar(opGetList);

      Resultado := TGDWSUtils.CDSToJSON(lPlano.Lista);
    finally
      FreeAndNil(lPlano);
      FreeAndNil(GDWSDMConnection);
    end;
  except
    on E: Exception do
      raise;
  end;
end;

procedure TGDWSMetodosPlano.delete;
var
  lPlano: TGDWSPlano;
  lRetorno: TGDWSCustomRetorno;
  lJsonPair: TJSONPair;
  lListaAux: TGDWSCustomClientDataSet;
  I: Integer;
begin
  try
    GDWSDMConnection := TGDWSDMConnection.Create(nil);
    lPlano := TGDWSPlano.Create;
    try
      GDWSDMConnection.Start;

      lPlano.Lista.Insert;

      for I := 0 to lPlano.Lista.Fields.count - 1 do
      begin
        lJsonPair := Data.Get(lPlano.Lista.Fields[I].FieldName.ToLower);

        if lJsonPair <> nil then
          lPlano.Lista.AddString(lPlano.Lista.Fields[I].FieldName, lJsonPair.JsonValue.Value);
      end;

      lPlano.Lista.Post;

      lRetorno := lPlano.Executar(opDelete);

      if lRetorno.Status = rcsSucesso then
        GDWSDMConnection.Commit
      else
        GDWSDMConnection.Rollback;

      Resultado := TGDWSUtils.RetornoToJSON(lRetorno);
    finally
      FreeAndNil(lPlano);
      FreeAndNil(GDWSDMConnection);
    end;
  except
    on E: Exception do
      raise;
  end;
end;

procedure TGDWSMetodosPlano.update;
var
  lPlano: TGDWSPlano;
  lRetorno: TGDWSCustomRetorno;
  lJsonPair: TJSONPair;
  lListaAux: TGDWSCustomClientDataSet;
  I: Integer;
begin
  try
    GDWSDMConnection := TGDWSDMConnection.Create(nil);
    lPlano := TGDWSPlano.Create;
    try
      GDWSDMConnection.Start;

      lPlano.Lista.Insert;

      for I := 0 to lPlano.Lista.Fields.count - 1 do
      begin
        lJsonPair := Data.Get(lPlano.Lista.Fields[I].FieldName.ToLower);

        if lJsonPair <> nil then
          lPlano.Lista.AddString(lPlano.Lista.Fields[I].FieldName, lJsonPair.JsonValue.Value);
      end;

      lPlano.Lista.Post;

      lRetorno := lPlano.Executar(opUpdate);

      if lRetorno.Status = rcsSucesso then
        GDWSDMConnection.Commit
      else
        GDWSDMConnection.Rollback;

      Resultado := TGDWSUtils.RetornoToJSON(lRetorno);
    finally
      FreeAndNil(lPlano);
      FreeAndNil(GDWSDMConnection);
    end;
  except
    on E: Exception do
      raise;
  end;
end;


end.


