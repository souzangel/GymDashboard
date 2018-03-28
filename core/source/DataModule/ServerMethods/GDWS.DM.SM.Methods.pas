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
  GDWS.Usuarios, GDWS.Base.Classe, GDWS.DM.Connection, GDWS.Utils, GDWS.Lista.Classes, GDWS.Base.Metodos, GDWS.Methodos.Usuarios;

{$R *.dfm}

{ TMethods }

function TMethods.all(pData: String): TJSONValue;
var
  lListaSM: TArray<TPersistentClass>;
  lSM: TPersistentClass;
  lClass, lMethod: string;
  lClassMethods: TGDWSBaseMetodos;


  lJsonValue: TJSONValue;
  lJsonObject: TJSONObject;
  lJsonPair: TJsonPair;

begin
  gerarLog(pData);

  lJsonValue := TJSONObject.ParseJSONValue(pData);
  lJsonObject := lJsonValue as TJSONObject;

  lListaSM := TGDWSListaClasses.getListaMethods;

  lJsonPair  := lJsonObject.Get('class');
  lClass := lJsonPair.JsonValue.Value;

  lJsonPair  := lJsonObject.Get('method');
  lMethod := lJsonPair.JsonValue.Value;

  for lSM in lListaSM do
  begin
    if lSM = TGDWSMethodosUsuarios then
      lClassMethods := TGDWSMethodosUsuarios.Create;

    if lClass = lClassMethods.className then
    begin
      Result := lClassMethods.ExecuteMethod(lClassMethods, lMethod, lJsonObject);
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


