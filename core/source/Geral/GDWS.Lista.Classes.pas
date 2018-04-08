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

uses GDWS.DM.SM.Methods, GDWS.Metodos.Usuarios, GDWS.Metodos.Plano, GDWS.Metodos.Atividade, GDWS.Metodos.Cliente;

{ TGDWSListaClasses }

class function TGDWSListaClasses.getListaServerMethods: TArray<TPersistentClass>;
begin
  {* Nesta lista deve ser adicionado todas as classes de server m�todos existentes no projeto *}

  Result := TArray<TPersistentClass>.Create(TMethods);
end;

class function TGDWSListaClasses.getListaMethods: TArray<TObject>;
begin
  {* Nesta lista deve ser adicionado todas as classes de m�todos existentes no projeto *}

  Result := TArray<TObject>.Create(TGDWSMetodosUsuarios.Create, TGDWSMetodosCliente.Create, TGDWSMetodosAtividade.Create, TGDWSMetodosPlano.Create);
end;

end.


