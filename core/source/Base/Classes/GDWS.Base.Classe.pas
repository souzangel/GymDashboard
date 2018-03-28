unit GDWS.Base.Classe;

interface

uses
  System.Classes;

type
  TOperacao = (opNone, opInsert, opUpdate, opDelete, opGetList, opGetItem, opGenID, opSQLObjetos);

  TGDWSBaseClasse = class(TPersistent)
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }

    constructor Create; virtual;
    destructor Destroy; virtual;
  published
    { published declarations }
  end;

implementation

{ TBaseClass }

constructor TGDWSBaseClasse.Create;
begin
  inherited;

end;

destructor TGDWSBaseClasse.Destroy;
begin

  inherited;
end;

end.


