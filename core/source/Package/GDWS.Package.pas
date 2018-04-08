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
  GDWS.Cliente, GDWS.Usuarios, GDWS.Atividade, GDWS.Plano,

  {* Persistencia *}
  GDWS.Cliente.Persistencia, GDWS.Usuarios.Persistencia, GDWS.Atividade.Persistencia, GDWS.Plano.Persistencia,

  {* DataModules Geral *}
  GDWS.DM.Connection,

  {* DataModules Server Methods *}
  GDWS.DM.SM.Methods,

  {* DataModules Methods *}
  GDWS.Metodos.Usuarios, GDWS.Metodos.Cliente, GDWS.Metodos.Plano, GDWS.Metodos.Atividade
  ;

implementation

end.


