unit GDWS.package;

interface

uses
  {* Geral *}
  GDWS.Types, GDWS.Base.Classe, GDWS.DS.ServerClass, GDWS.Seguranca, GDWS.Utils, GDWS.Lista.Classes,

  {* Classes Base *}
  GDWS.Base.Controle, GDWS.Base.Persistencia,

  {* DataModules Base *}
  GDWS.Base.DM, GDWS.Base.Metodos,

  {* Controles *}
  GDWS.Pessoas, GDWS.Usuarios,

  {* Persistencia *}
  GDWS.Pessoas.Persistencia, GDWS.Usuarios.Persistencia,

  {* DataModules Geral *}
  GDWS.DM.Connection,

  {* DataModules Server Methods *}
  GDWS.DM.SM.Methods,

  {* DataModules Methods *}
  GDWS.Metodos.Usuarios
  ;

implementation

end.


