unit GDWS.Metodos.Cliente;

interface

uses
  GDWS.Base.Metodos, System.SysUtils, System.Classes, GDWS.Types, Variants, System.JSON;

type
  TGDWSMetodosCliente = class(TGDWSBaseMetodos)
    procedure insert;
    procedure delete;
    procedure update;
    procedure lista;

  public
    constructor Create;
  end;

implementation

uses
  GDWS.Cliente, GDWS.Base.Classe, GDWS.DM.Connection, GDWS.Utils, REST.Json;

constructor TGDWSMetodosCliente.Create;
begin
  className := 'cliente';
end;

procedure TGDWSMetodosCliente.lista;
var
  lCliente: TGDWSCliente;
  lRetorno: TGDWSCustomRetorno;
  lJsonPair: TJSONPair;
  lListaAux: TGDWSCustomClientDataSet;
  I: Integer;
begin
  try
    GDWSDMConnection := TGDWSDMConnection.Create(nil);
    lCliente := TGDWSCliente.Create;
    try
      lRetorno := lCliente.Executar(opGetList);

      Resultado := TGDWSUtils.CDSToJSON(lCliente.Lista);
    finally
      FreeAndNil(lCliente);
      FreeAndNil(GDWSDMConnection);
    end;
  except
    on E: Exception do
      raise;
  end;
end;

procedure TGDWSMetodosCliente.insert;
var
  lCliente: TGDWSCliente;
  lRetorno: TGDWSCustomRetorno;
  lJsonPair: TJSONPair;
  lListaAux: TGDWSCustomClientDataSet;
  I: Integer;
begin
  try
    GDWSDMConnection := TGDWSDMConnection.Create(nil);
    lCliente := TGDWSCliente.Create;
    try
      GDWSDMConnection.Start;

      lCliente.Lista.Insert;

      lCliente.Lista.AddInteger('CLI_ID', lCliente.Executar(opGenID).RetGeraID);

      for I := 0 to lCliente.Lista.Fields.count - 1 do
      begin
        lJsonPair := Data.Get(lCliente.Lista.Fields[I].FieldName.ToLower);

        if lJsonPair <> nil then
          lCliente.Lista.AddString(lCliente.Lista.Fields[I].FieldName, lJsonPair.JsonValue.Value);
      end;

      lCliente.Lista.Post;

      lRetorno := lCliente.Executar(opInsert);

      if lRetorno.Status = rcsSucesso then
        GDWSDMConnection.Commit
      else
        GDWSDMConnection.Rollback;

      lRetorno.RetGeraID := lCliente.Lista.FieldByName('CLI_ID').AsInteger;

      Resultado := TGDWSUtils.RetornoToJSON(lRetorno);
    finally
      FreeAndNil(lCliente);
      FreeAndNil(GDWSDMConnection);
    end;
  except
    on E: Exception do
      raise;
  end;
end;

procedure TGDWSMetodosCliente.delete;
var
  lCliente: TGDWSCliente;
  lRetorno: TGDWSCustomRetorno;
  lJsonPair: TJSONPair;
  lListaAux: TGDWSCustomClientDataSet;
  I: Integer;
begin
  try
    GDWSDMConnection := TGDWSDMConnection.Create(nil);
    lCliente := TGDWSCliente.Create;
    try
      GDWSDMConnection.Start;

      lCliente.Lista.Insert;

      for I := 0 to lCliente.Lista.Fields.count - 1 do
      begin
        lJsonPair := Data.Get(lCliente.Lista.Fields[I].FieldName.ToLower);

        if lJsonPair <> nil then
          lCliente.Lista.AddString(lCliente.Lista.Fields[I].FieldName, lJsonPair.JsonValue.Value);
      end;

      lCliente.Lista.Post;

      lRetorno := lCliente.Executar(opDelete);

      if lRetorno.Status = rcsSucesso then
        GDWSDMConnection.Commit
      else
        GDWSDMConnection.Rollback;

      Resultado := TGDWSUtils.RetornoToJSON(lRetorno);
    finally
      FreeAndNil(lCliente);
      FreeAndNil(GDWSDMConnection);
    end;
  except
    on E: Exception do
      raise;
  end;
end;

procedure TGDWSMetodosCliente.update;
var
  lCliente: TGDWSCliente;
  lRetorno: TGDWSCustomRetorno;
  lJsonPair: TJSONPair;
  lListaAux: TGDWSCustomClientDataSet;
  I: Integer;
begin
  try
    GDWSDMConnection := TGDWSDMConnection.Create(nil);
    lCliente := TGDWSCliente.Create;
    try
      GDWSDMConnection.Start;

      lCliente.Lista.Insert;

      for I := 0 to lCliente.Lista.Fields.count - 1 do
      begin
        lJsonPair := Data.Get(lCliente.Lista.Fields[I].FieldName.ToLower);

        if lJsonPair <> nil then
          lCliente.Lista.AddString(lCliente.Lista.Fields[I].FieldName, lJsonPair.JsonValue.Value);
      end;

      lCliente.Lista.Post;

      lRetorno := lCliente.Executar(opUpdate);

      if lRetorno.Status = rcsSucesso then
        GDWSDMConnection.Commit
      else
        GDWSDMConnection.Rollback;

      Resultado := TGDWSUtils.RetornoToJSON(lRetorno);
    finally
      FreeAndNil(lCliente);
      FreeAndNil(GDWSDMConnection);
    end;
  except
    on E: Exception do
      raise;
  end;
end;


end.


