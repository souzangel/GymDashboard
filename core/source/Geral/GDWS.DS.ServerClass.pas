unit GDWS.DS.ServerClass;

interface

uses Datasnap.DSServer,
     Datasnap.DSCommonServer,
     Datasnap.DSReflect,
     Datasnap.DSNames,
     Datasnap.DataBkr,
     System.Classes;

type
  TGDWSDSServerClass = class(TDSServerClass)
  private
    FPersistentClass: TPersistentClass;
    procedure RegDSServerClass(pOwner: TComponent; pServer: TDSServer);
  protected
    function GetDSClass: TDSClass; override;
  public
    constructor Create(pOwner: TComponent; pServer: TDSCustomServer;
      pClass: TPersistentClass; pLifeCycle: string = TDSLifeCycle.Invocation);
      reintroduce; overload;
  end;

implementation

constructor TGDWSDSServerClass.Create(pOwner: TComponent; pServer: TDSCustomServer;
  pClass: TPersistentClass; pLifeCycle: String);
begin
  inherited Create(pOwner);
  FPersistentClass := pClass;
  Self.Server      := pServer;
  Self.LifeCycle   := pLifeCycle;
  GetDSClass;
end;

function TGDWSDSServerClass.GetDSClass: TDSClass;
//var
  //IsAdapted: Boolean;

begin
  Result := nil;
  if FPersistentClass <> nil then
    begin
      //IsAdapted := FPersistentClass.InheritsFrom(TProviderDataModule);
      //Result := TDSClass.Create(FPersistentClass, IsAdapted);
      Result := TDSClass.Create(FPersistentClass, False);
      //if IsAdapted then
        //Result := TDSClass.Create(TDSProviderDataModuleAdapter, Result);
    end;
end;

procedure TGDWSDSServerClass.RegDSServerClass(pOwner: TComponent; pServer: TDSServer);
begin
  TGDWSDSServerClass.Create(pOwner, pServer, FPersistentClass, Self.LifeCycle);
end;

end.
