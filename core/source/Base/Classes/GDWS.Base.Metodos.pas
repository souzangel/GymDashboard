unit GDWS.Base.Metodos;

interface

uses
  System.Json, GDWS.Base.Classe, System.SysUtils, System.Classes;

type
  TGDWSBaseMetodos = class(TGDWSBaseClasse)
  private
    FData: TJSONObject;
    FclassName: string;
    FResultado: TJsonValue;
    procedure SetData(const Value: TJSONObject);
    procedure ExecMethod(OnObject: TObject; MethodName: string);
    procedure SetclassName(const Value: string);
    procedure SetResultado(const Value: TJsonValue);
    { private declarations }

  protected
    { protected declarations }
    property Resultado: TJsonValue read FResultado write SetResultado;
  public
    { public declarations }
    property className: string read FclassName write SetclassName;
    property Data: TJSONObject read FData write SetData;
    function ExecuteMethod(pObj: TObject; pMethod: string; pData: TJSONObject): TJSonValue;


  end;

type
  TExec = procedure of object;

implementation

{ TGDWSBaseMetodos }

function TGDWSBaseMetodos.ExecuteMethod(pObj: TObject; pMethod: string; pData: TJSONObject): TJSonValue;
begin
  Data := pData;
  ExecMethod(pObj, pMethod);
  Result := Resultado;
end;

procedure TGDWSBaseMetodos.ExecMethod(OnObject: TObject; MethodName: string);
var
  lRoutine: TMethod;
  lExec: TExec;
begin
  lRoutine.Data := Pointer(OnObject);
  lRoutine.Code := OnObject.MethodAddress(MethodName);
  if Assigned(lRoutine.Code) then
  begin
    lExec := TExec(lRoutine);
    lExec;
  end;
end;

procedure TGDWSBaseMetodos.SetclassName(const Value: string);
begin
  FclassName := Value;
end;

procedure TGDWSBaseMetodos.SetData(const Value: TJSONObject);
begin
  FData := Value;
end;

procedure TGDWSBaseMetodos.SetResultado(const Value: TJsonValue);
begin
  FResultado := Value;
end;

end.


