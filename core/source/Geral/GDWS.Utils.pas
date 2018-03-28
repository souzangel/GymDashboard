unit GDWS.Utils;

interface

uses
  System.SysUtils, Datasnap.Provider, GDWS.Base.Classe, GDWS.Types, Data.DB, JSON;

type
  TGDWSUtils = class(TGDWSBaseClasse)
  private
  public
    class function CDSToJSON(pCDS: TGDWSCustomClientDataSet): TJSONArray; static;
    class function RetornoToJSON(pRetorno: TGDWSCustomRetorno): TJSONObject; static;
    class function DataSetToOleVariant(pDS: TGDWSCustomDataSet): OleVariant; static;
    class function QueryToOleVariant(pQuery: TGDWSCustomQuery): OleVariant; static;
    class function Iif(pCondicao: Boolean; pTrueResult, pFalseResult: Variant): Variant; static;
    constructor Create; override;
    destructor Destroy; override;
  end;

implementation

constructor TGDWSUtils.Create;
begin
  inherited;

end;

destructor TGDWSUtils.Destroy;
begin

  inherited;
end;

class function TGDWSUtils.RetornoToJSON(pRetorno: TGDWSCustomRetorno): TJSONObject;
var
  I: Integer;
  lJSONObject: TJSONObject;
begin
  lJSONObject := TJSONObject.Create;

  case pRetorno.Status of
    rcsSucesso:
      lJSONObject.AddPair('Status', 'SUCESSO');
    rcsErro:
      lJSONObject.AddPair('Status', 'ERRO');
  end;

  lJSONObject.AddPair('mensagem', pRetorno.Mensagem);
  lJSONObject.AddPair('lista_erros', pRetorno.ListaErros.Text);
  //lJSONObject.AddPair('codigo_erro', pRetorno.CodigoErro);
  lJSONObject.AddPair('linhas_retornadas', pRetorno.QuantidadeLinhasRetornadas.ToString);
  lJSONObject.AddPair('linhas_afetadas', pRetorno.QuantidadeLinhasAfetadas.ToString);
  lJSONObject.AddPair('id', pRetorno.RetGeraID.ToString);

  Result := lJSONObject;
end;

class function TGDWSUtils.CDSToJSON(pCDS: TGDWSCustomClientDataSet): TJSONArray;
var
  I: Integer;
  lJSONArray: TJSONArray;
  lJSONObject: TJSONObject;
begin
  lJSONArray := TJSONArray.Create;

  pCDS.First;
  while not pCDS.Eof do
  begin
    lJSONObject := TJSONObject.Create;

    for I := 0 to pCDS.Fields.Count - 1 do
    begin
      lJSONObject.AddPair(pCDS.Fields[I].FieldName, pCDS.FieldByName(pCDS.Fields[I].FieldName).AsString);
    end;

    lJSONArray.AddElement(lJSONObject);

    pCDS.Next;
  end;

  Result := lJSONArray;
end;

class function TGDWSUtils.DataSetToOleVariant(pDS: TGDWSCustomDataSet): OleVariant;
var
  lDSProvider: TDataSetProvider;
begin
  lDSProvider := TDataSetProvider.Create(nil);
  try
    lDSProvider.DataSet := TDataSet(pDS);
    Result := lDSProvider.Data
  finally
    lDSProvider.Free;
  end;
end;

class function TGDWSUtils.QueryToOleVariant(pQuery: TGDWSCustomQuery): OleVariant;
var
  lCDS: TGDWSCustomClientDataSet;
  I, J: Integer;
begin
  lCDS := TGDWSCustomClientDataSet.Create(nil);
  try
    lCDS.Close;
    lCDS.FieldDefs.Clear;

    for I := 0 to pQuery.Fields.Count - 1 do
    begin
      lCDS.FieldDefs.Add(pQuery.Fields[i].FieldName, pQuery.Fields[i].DataType, pQuery.Fields[i].Size, pQuery.Fields[i].Required);
    end;

    lCDS.CreateDataSet;

    pQuery.First;
    while not pQuery.Eof do
    begin
      lCDS.Insert;

      for J := 0 to pQuery.Fields.Count - 1 do
      begin
        lCDS.AddVariant(pQuery.Fields[J].FieldName, pQuery.Fields[J].Value);
      end;

      lCDS.Post;

      pQuery.Next;
    end;

    Result := lCDS.Data;
  finally
    lCDS.Free;
  end;
end;

class function TGDWSUtils.Iif(pCondicao: Boolean; pTrueResult, pFalseResult: Variant): Variant;
begin
  if pCondicao then
    Result := pTrueResult
  else
    Result := pFalseResult;
end;

end.


