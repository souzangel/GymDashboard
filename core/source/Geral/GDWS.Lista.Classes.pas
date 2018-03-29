unit GDWS.Lista.Classes;

interface

uses
  GDWS.Base.Classe, System.Classes, GDWS.Base.Metodos;

type
  TGDWSListaClasses = class(TGDWSBaseClasse)
  private
    { private declarations }

  public
    { public declarations }
    class function getListaServerMethods: TArray<TPersistentClass>;
    class function getListaMethods: TArray<TObject>; static;

  end;

implementation

uses GDWS.DM.SM.Pessoas, GDWS.DM.SM.Usuarios, GDWS.DM.SM.Methods, GDWS.Metodos.Usuarios;

{ TGDWSListaClasses }

class function TGDWSListaClasses.getListaServerMethods: TArray<TPersistentClass>;
begin
  {* Nesta lista deve ser adicionado todas as classes de server métodos existentes no projeto *}

  Result := TArray<TPersistentClass>.Create(TMethods);
end;

class function TGDWSListaClasses.getListaMethods: TArray<TObject>;
begin
  {* Nesta lista deve ser adicionado todas as classes de métodos existentes no projeto *}

  Result := TArray<TObject>.Create(TGDWSMetodosUsuarios.Create);
end;

end.


