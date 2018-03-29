unit GDWS.DM.SM.Methods;

interface

uses
  System.SysUtils, System.Classes, Datasnap.DSProviderDataModuleAdapter, Variants, System.Json, REST.Json;

type
  TMethods = class(TDSServerModule)
  private
    procedure gerarLog(pValue: string);
  public
    function all(pData: String): TJSONValue;
  end;

implementation

uses
  GDWS.Usuarios, GDWS.Base.Classe, GDWS.DM.Connection, GDWS.Utils, GDWS.Lista.Classes, GDWS.Base.Metodos;

{$R *.dfm}

{ TMethods }

function TMethods.all(pData: String): TJSONValue;
var
  lClassMethodList: TArray<TObject>;
  lClassMethodItem: TObject;
  lClass, lMethodName: string;
  lClassMethods: TGDWSBaseMetodos;

  lJsonValue: TJSONValue;
  lJsonObject: TJSONObject;
  lJsonPair: TJsonPair;
begin
  gerarLog(pData);

  lJsonValue := TJSONObject.ParseJSONValue(pData);
  lJsonObject := lJsonValue as TJSONObject;

  lClassMethodList := TGDWSListaClasses.getListaMethods;

  lJsonPair  := lJsonObject.Get('class');
  lClass := lJsonPair.JsonValue.Value;

  lJsonPair  := lJsonObject.Get('method');
  lMethodName := lJsonPair.JsonValue.Value;

  for lClassMethodItem in lClassMethodList do
  begin
    lClassMethods := TGDWSBaseMetodos(lClassMethodItem);

    if lClass = lClassMethods.className then
    begin
      Result := lClassMethods.ExecuteMethod(lClassMethods, lMethodName, lJsonObject);
    end;

    lClassMethods.Free;
  end;

  lJsonObject.Free;
end;

procedure TMethods.gerarLog(pValue: string);
var
  lList: TStringList;
  lNomeArq: string;
begin
  lList := TStringList.Create;
  try
    lList.Text := pValue;

    lNomeArq := 'logs\' + StringReplace(DateTimeToStr(now), '/', '-', [rfReplaceAll]) + '.txt';
    lNomeArq := StringReplace(lNomeArq, ':', '', [rfReplaceAll]);

    lList.SaveToFile(lNomeArq);
  finally
    lList.Free;
  end;
end;

end.


