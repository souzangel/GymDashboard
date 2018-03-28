unit GDWS.Base.DM;

interface

uses
  SysUtils, Classes, DB, JvDataSource, DBClient;

type
  TGDWSBaseDM = class(TDataModule)

  end;

  TdmBaseOf = class of TGDWSBaseDM;

var
  GDWSBaseDM: TGDWSBaseDM;

implementation

{$R *.dfm}

{ TdmBase }

end.
