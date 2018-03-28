unit GDWS.Base.Persistencia;

interface

uses
  GDWS.Base.Classe, System.SysUtils, Data.DB, GDWS.Types, GDWS.Base.Controle, GDWS.DM.Connection;

type
  TGDWSBasePersistencia = class(TGDWSBaseClasse)
  private
    //Variáveis
    FQuery: TGDWSCustomQuery;
    FParamsArraySize: Integer;
    FGDWSCustomRetorno: TGDWSCustomRetorno;
    procedure SetQuery(const Value: TGDWSCustomQuery);
    procedure SetParamsArraySize(const Value: Integer);
    procedure SetGDWSCustomRetorno(const Value: TGDWSCustomRetorno);
    procedure MontarSQL(pObjeto: TGDWSBaseControle);
    procedure PreencherParametros(pObjeto: TGDWSBaseControle);
    procedure PreencherFields(pObjeto: TGDWSBaseControle);
  protected
    property GDWSCustomRetorno: TGDWSCustomRetorno read FGDWSCustomRetorno write SetGDWSCustomRetorno;
    procedure SQL(out pObjeto: TGDWSBaseControle); virtual; abstract;
    procedure SQLPadrao(out pObjeto: TGDWSBaseControle);
    procedure GeraID(pObjeto: TGDWSBaseControle); overload;
    property Query: TGDWSCustomQuery read FQuery write SetQuery;
    procedure CriarQuery;
    procedure DestruirQuery;
    procedure ExecutarPesquisa;
    procedure ExecutarCRUD;
    procedure AplicaFiltro(out pObjeto: TGDWSBaseControle);
    procedure PreencheRetornoSucesso(pObjeto: TGDWSBaseControle);
    procedure PreencheRetornoFalha(pException: Exception; pOperacao: TOperacao);
  public
    property ParamsArraySize: Integer read FParamsArraySize write SetParamsArraySize;
    function Executar(pObjeto: TGDWSBaseControle; pOperacao: TOperacao): TGDWSCustomRetorno;
    constructor Create; override;
    destructor Destroy; override;
  end;

implementation

uses
  GDWS.Utils;

{ TBasePst }

constructor TGDWSBasePersistencia.Create;
begin
  inherited;

end;

destructor TGDWSBasePersistencia.Destroy;
begin

  inherited;
end;

procedure TGDWSBasePersistencia.MontarSQL(pObjeto: TGDWSBaseControle);
var
  I, J: Integer;
  lPrimeiraField: Boolean;
begin
  case pObjeto.Operacao of
    opInsert:
      begin
        Query.SQL.Add(' INSERT INTO ' + pObjeto.Schema + TGDWSUtils.Iif(pObjeto.Schema <> '', '.', '') + pObjeto.NomeTabela + ' ( ');

        lPrimeiraField := False;
        { * Adicionando as Fields * }
        for I := 0 to pObjeto.Lista.Fields.Count - 1 do
        begin
          if (not (pfHidden in pObjeto.Lista.Fields[I].ProviderFlags)) then
          begin
            if (lPrimeiraField) then
              Query.SQL.Text := Query.SQL.Text + ', ';

            Query.SQL.Add(' ' + pObjeto.Lista.Fields[I].FieldName + ' ');

            lPrimeiraField := True;
          end;
        end;

        Query.SQL.Add(' ) VALUES ( ');

        lPrimeiraField := False;
        { * Adicionando os parâmetros * }
        for J := 0 to pObjeto.Lista.Fields.Count - 1 do
        begin
          if (not (pfHidden in pObjeto.Lista.Fields[J].ProviderFlags)) then
          begin
            if (lPrimeiraField) then
              Query.SQL.Text := Query.SQL.Text + ', ';

            Query.SQL.Add(' :' + pObjeto.Lista.Fields[J].FieldName + ' ');

            lPrimeiraField := True;
          end;
        end;

        Query.SQL.Add(' ) ');
      end;

    opUpdate, opDelete:
      begin
        case pObjeto.Operacao of
          opUpdate:
            begin
              Query.SQL.Add(' UPDATE ' + pObjeto.Schema + TGDWSUtils.Iif(pObjeto.Schema <> '', '.', '') + pObjeto.NomeTabela + ' SET ');

              lPrimeiraField := False;
              { * Adicionando as Fields * }
              for I := 0 to pObjeto.Lista.Fields.Count - 1 do
              begin
                if (not (pfInKey in pObjeto.Lista.Fields[I].ProviderFlags)) and (not (pfHidden in pObjeto.Lista.Fields[I].ProviderFlags)) then
                begin
                  if (lPrimeiraField) then
                    Query.SQL.Text := Query.SQL.Text + ', ';

                  Query.SQL.Add(' ' + pObjeto.Lista.Fields[I].FieldName + ' = :' + pObjeto.Lista.Fields[I].FieldName);

                  lPrimeiraField := True;
                end;
              end;
            end;

          opDelete:
            begin
              Query.SQL.Add(' DELETE FROM ' + pObjeto.Schema + TGDWSUtils.Iif(pObjeto.Schema <> '', '.', '') + pObjeto.NomeTabela + ' ');
            end;
        end;

        lPrimeiraField := False;

        { * Adicionando os parâmetros * }
        for J := 0 to pObjeto.Lista.Fields.Count - 1 do
        begin
          if (pfInKey in pObjeto.Lista.Fields[J].ProviderFlags) and (not (pfHidden in pObjeto.Lista.Fields[J].ProviderFlags)) then
          begin
            if lPrimeiraField = False then
              Query.SQL.Add(' WHERE ');

            Query.SQL.Add(TGDWSUtils.Iif(lPrimeiraField = False, ' AND ', '') + ' ( ' + pObjeto.Lista.Fields[J].FieldName + ' = :' + pObjeto.Lista.Fields[J].FieldName + ' ) ');
            lPrimeiraField := True;
          end;
        end;
      end;

    opGetItem, opSQLObjetos:
      begin
        Query.SQL.Add(' SELECT * FROM ' + pObjeto.Schema + TGDWSUtils.Iif(pObjeto.Schema <> '', '.', '') + pObjeto.NomeTabela + ' ');

        case pObjeto.Operacao of
          opGetItem:
            begin
              lPrimeiraField := False;
              { * Adicionando os parâmetros * }
              for J := 0 to pObjeto.Lista.Fields.Count - 1 do
              begin
                if (pfInKey in pObjeto.Lista.Fields[J].ProviderFlags) and (not (pfHidden in pObjeto.Lista.Fields[J].ProviderFlags)) then
                begin
                  if lPrimeiraField = False then
                    Query.SQL.Add(' WHERE ');

                  Query.SQL.Add(TGDWSUtils.Iif(lPrimeiraField = False, ' AND ', '') + '( ' + pObjeto.Lista.Fields[J].FieldName + ' = :' + pObjeto.Lista.Fields[J].FieldName + ' ) ');
                  lPrimeiraField := True;
                end;
              end;
            end;

          opSQLObjetos:
            begin
              AplicaFiltro(pObjeto);
            end;
        end;
      end;

    opGetList:
      begin
        SQL(pObjeto);
        AplicaFiltro(pObjeto);
      end;
  end;
end;

procedure TGDWSBasePersistencia.PreencherParametros(pObjeto: TGDWSBaseControle);
var
  I, J: Integer;
begin
  J := 0;
  pObjeto.Lista.First;
  while not pObjeto.Lista.Eof do
  begin
    for I := 0 to Query.Params.Count - 1 do
    begin
      case pObjeto.Lista.FieldByName(Query.Params[I].Name).DataType of
        ftString:
          Query.ParamByName(Query.Params[I].Name).AsStrings[J] := pObjeto.Lista.FieldByName(Query.Params[I].Name).AsString;
        ftInteger:
          Query.ParamByName(Query.Params[I].Name).AsIntegers[J] := pObjeto.Lista.FieldByName(Query.Params[I].Name).AsInteger;
        ftFloat:
          Query.ParamByName(Query.Params[I].Name).AsFloats[J] := pObjeto.Lista.FieldByName(Query.Params[I].Name).AsFloat;
        ftDate:
          Query.ParamByName(Query.Params[I].Name).AsDates[J] := pObjeto.Lista.FieldByName(Query.Params[I].Name).AsDateTime;
        ftDateTime:
          Query.ParamByName(Query.Params[I].Name).AsDateTimes[J] := pObjeto.Lista.FieldByName(Query.Params[I].Name).AsDateTime;
        ftTimeStamp:
          Query.ParamByName(Query.Params[I].Name).AsDateTimes[J] := pObjeto.Lista.FieldByName(Query.Params[I].Name).AsDateTime;
        ftTime:
          Query.ParamByName(Query.Params[I].Name).AsTimes[J] := pObjeto.Lista.FieldByName(Query.Params[I].Name).AsDateTime;
        ftSingle:
          Query.ParamByName(Query.Params[I].Name).AsSingles[J] := pObjeto.Lista.FieldByName(Query.Params[I].Name).AsSingle;
      end;
    end;

    J := J + 1;
    pObjeto.Lista.Next;
  end;
end;

procedure TGDWSBasePersistencia.PreencherFields(pObjeto: TGDWSBaseControle);
var
  I: Integer;
begin
  pObjeto.Lista.Edit;
  for I := 0 to pObjeto.Lista.Fields.Count - 1 do
  begin
    case pObjeto.Lista.Fields[I].DataType of
      ftString:
        pObjeto.Lista.FieldByName(pObjeto.Lista.Fields[I].FieldName).AsString := Query.FieldByName(pObjeto.Lista.Fields[I].FieldName).AsString;
      ftInteger:
        pObjeto.Lista.FieldByName(pObjeto.Lista.Fields[I].FieldName).AsInteger := Query.FieldByName(pObjeto.Lista.Fields[I].FieldName).AsInteger;
      ftFloat:
        pObjeto.Lista.FieldByName(pObjeto.Lista.Fields[I].FieldName).AsFloat := Query.FieldByName(pObjeto.Lista.Fields[I].FieldName).AsFloat;
      ftDate:
        pObjeto.Lista.FieldByName(pObjeto.Lista.Fields[I].FieldName).AsDateTime := Query.FieldByName(pObjeto.Lista.Fields[I].FieldName).AsDateTime;
      ftDateTime:
        pObjeto.Lista.FieldByName(pObjeto.Lista.Fields[I].FieldName).AsDateTime := Query.FieldByName(pObjeto.Lista.Fields[I].FieldName).AsDateTime;
      ftTimeStamp:
        pObjeto.Lista.FieldByName(pObjeto.Lista.Fields[I].FieldName).AsDateTime := Query.FieldByName(pObjeto.Lista.Fields[I].FieldName).AsDateTime;
      ftTime:
        pObjeto.Lista.FieldByName(pObjeto.Lista.Fields[I].FieldName).AsDateTime := Query.FieldByName(pObjeto.Lista.Fields[I].FieldName).AsDateTime;
      ftSingle:
        pObjeto.Lista.FieldByName(pObjeto.Lista.Fields[I].FieldName).AsSingle := Query.FieldByName(pObjeto.Lista.Fields[I].FieldName).AsSingle;
    end;
  end;

  pObjeto.Lista.Post;
end;

procedure TGDWSBasePersistencia.CriarQuery;
begin
  try
    FGDWSCustomRetorno := TGDWSCustomRetorno.Create;
    FQuery := TGDWSCustomQuery.Create(nil);
    FQuery.Close;
    FQuery.Connection := GDWSDMConnection.GetConn;
    FQuery.SQL.Clear;
    FQuery.UpdateOptions.UpdateMode := upWhereKeyOnly;

    //QUANTIDADE DE LINHAS QUE SERÃO INSERIDAS/ATUALIZADAS/EXCLUÍDAS
    FQuery.Params.ArraySize := FParamsArraySize;

    if FQuery.Connection.Connected then

    else
      raise Exception.Create('O banco de dados não está conectado corretamente!');
  except
    on E: Exception do
      raise;
  end;
end;

procedure TGDWSBasePersistencia.DestruirQuery;
begin
  try
    FQuery.Close;
    FQuery.Release;

    if Assigned(FQuery) then
      FreeAndNil(FQuery);
  except
    on E: Exception do
      raise;
  end;
end;

function TGDWSBasePersistencia.Executar(pObjeto: TGDWSBaseControle; pOperacao: TOperacao): TGDWSCustomRetorno;
begin
  try
    pObjeto.Operacao := pOperacao;

    if pObjeto.Validar.Status = rcsSucesso then
    begin
      CriarQuery;
      try
        case pObjeto.Operacao of
          opInsert, opUpdate, opDelete:
            begin
              ParamsArraySize := pObjeto.Lista.RecordCount;
              MontarSQL(pObjeto);
              PreencherParametros(pObjeto);
              ExecutarCRUD;
            end;

          opGetList, opSQLObjetos:
            begin
              MontarSQL(pObjeto);
              ExecutarPesquisa;
            end;

          opGetItem:
            begin
              ParamsArraySize := pObjeto.Lista.RecordCount;
              MontarSQL(pObjeto);
              PreencherParametros(pObjeto);
              ExecutarPesquisa;
              PreencherFields(pObjeto);
            end;

          opGenID:
            begin
              GeraID(pObjeto);
            end;
        end;

        PreencheRetornoSucesso(pObjeto);
      finally
        DestruirQuery;
      end;
    end;

    Result := GDWSCustomRetorno;
  except
    on E: Exception do
    begin
      PreencheRetornoFalha(E, pOperacao);
      Result := GDWSCustomRetorno;
      raise;
    end;
  end;
end;

procedure TGDWSBasePersistencia.ExecutarCRUD;
begin
  try
    FQuery.Execute(FParamsArraySize);
  except
    on E: Exception do
      raise;
  end;
end;

procedure TGDWSBasePersistencia.ExecutarPesquisa;
var
  I: Integer;
begin
  try
    FQuery.Open;
    FGDWSCustomRetorno.QuantidadeLinhasRetornadas := FQuery.RecordCount;
    for I := 0 to FQuery.Fields.count - 1 do
    begin
      FQuery.FieldByName(FQuery.Fields[I].FieldName).Required := False;
      FQuery.FieldByName(FQuery.Fields[I].FieldName).ProviderFlags := [pfHidden];
    end;
  except
    on E: Exception do
      raise;
  end;
end;

procedure TGDWSBasePersistencia.GeraID(pObjeto: TGDWSBaseControle);
var
  lID: Integer;
begin
  try
    FQuery.SQL.Add(' SELECT GEN_ID_' + pObjeto.NomeTabela + ' AS ID FROM ' + pObjeto.Schema + TGDWSUtils.Iif(pObjeto.Schema <> '', '.', '') + 'GENERATORS; ');
    ExecutarPesquisa;

    lID := FQuery.FieldByName('ID').AsInteger + 1;

    FQuery.SQL.Clear;

    FQuery.SQL.Add(' UPDATE ' + pObjeto.Schema + TGDWSUtils.Iif(pObjeto.Schema <> '', '.', '') + 'GENERATORS ');
    FQuery.SQL.Add(' SET                                  ');
    FQuery.SQL.Add(' GEN_ID_' + pObjeto.NomeTabela + ' = ' + lID.ToString);

    ExecutarCRUD;

    FQuery.SQL.Clear;
    FQuery.SQL.Add(' SELECT GEN_ID_' + pObjeto.NomeTabela + ' AS ID FROM ' + pObjeto.Schema + TGDWSUtils.Iif(pObjeto.Schema <> '', '.', '') + 'GENERATORS; ');
    ExecutarPesquisa;
  except
    on E: Exception do
    begin
      raise;
    end;
  end;
end;

procedure TGDWSBasePersistencia.PreencheRetornoSucesso(pObjeto: TGDWSBaseControle);
begin
  try
    GDWSCustomRetorno.Status := rcsSucesso;
    GDWSCustomRetorno.ListaErros.Clear;

    case pObjeto.Operacao of
      opInsert, opUpdate, opDelete:
        begin
          GDWSCustomRetorno.Mensagem := 'Operação executada com sucesso.';
          GDWSCustomRetorno.QuantidadeLinhasAfetadas := Query.RowsAffected;
        end;

      opGetItem:
        begin
          GDWSCustomRetorno.Mensagem := 'Registro consultado com sucesso.';
          GDWSCustomRetorno.QuantidadeLinhasRetornadas := Query.RecordCount;
          GDWSCustomRetorno.RetSQL := TGDWSUtils.QueryToOleVariant(Query);
        end;

      opGetList:
        begin
          GDWSCustomRetorno.Mensagem := 'Consulta efetuada com sucesso.';
          GDWSCustomRetorno.QuantidadeLinhasRetornadas := Query.RecordCount;
          GDWSCustomRetorno.RetSQL := TGDWSUtils.QueryToOleVariant(Query);
        end;

      opSQLObjetos:
        begin
          GDWSCustomRetorno.Mensagem := 'Objetos carregados com sucesso.';
          GDWSCustomRetorno.QuantidadeLinhasRetornadas := Query.RecordCount;
          GDWSCustomRetorno.RetSQL := TGDWSUtils.QueryToOleVariant(Query);
        end;

      opGenID:
        begin
          GDWSCustomRetorno.Mensagem := 'ID gerado com sucesso.';
          GDWSCustomRetorno.RetGeraID := Query.FieldByName('ID').AsInteger;
        end;
    end;

  except
    on E: Exception do
      raise;
  end;
end;

procedure TGDWSBasePersistencia.PreencheRetornoFalha(pException: Exception; pOperacao: TOperacao);
begin
  try
    GDWSCustomRetorno.Status := rcsErro;
    GDWSCustomRetorno.ListaErros.Clear;
    GDWSCustomRetorno.ListaErros.Add(pException.Message);

    case pOperacao of
      opInsert, opUpdate, opDelete:
        begin
          GDWSCustomRetorno.Mensagem := 'Falha ao executar operação.';
          GDWSCustomRetorno.QuantidadeLinhasAfetadas := Query.RowsAffected;
        end;

      opGetItem:
        begin
          GDWSCustomRetorno.Mensagem := 'Falha ao consultar registro.';
          GDWSCustomRetorno.QuantidadeLinhasRetornadas := Query.RecordCount;
        end;

      opGetList:
        begin
          GDWSCustomRetorno.Mensagem := 'Falha ao efetuar consulta.';
          GDWSCustomRetorno.QuantidadeLinhasRetornadas := Query.RecordCount;
        end;

      opSQLObjetos:
        begin
          GDWSCustomRetorno.Mensagem := 'Falha ao carregar objetos.';
          GDWSCustomRetorno.QuantidadeLinhasRetornadas := Query.RecordCount;
        end;

      opGenID:
        begin
          GDWSCustomRetorno.Mensagem := 'Falha ao gerar ID.';
        end;
    end;
  except
    on E: Exception do
      raise;
  end;
end;

procedure TGDWSBasePersistencia.SQLPadrao(out pObjeto: TGDWSBaseControle);
begin
  try
    Query.SQL.Add(' SELECT * FROM ' + pObjeto.Schema + TGDWSUtils.Iif(pObjeto.Schema <> '', '.', '') + pObjeto.NomeTabela + ' ');
  except
    on E: Exception do
      raise;
  end;
end;

procedure TGDWSBasePersistencia.AplicaFiltro(out pObjeto: TGDWSBaseControle);
begin
  try
    if Trim(pObjeto.FiltroSQL) <> '' then
      Query.SQL.Add(' WHERE ' + pObjeto.FiltroSQL);
  except
    on E: Exception do
      raise;
  end;
end;

procedure TGDWSBasePersistencia.SetParamsArraySize(const Value: Integer);
begin
  FParamsArraySize := Value;
end;

procedure TGDWSBasePersistencia.SetQuery(const Value: TGDWSCustomQuery);
begin
  FQuery := Value;
end;

procedure TGDWSBasePersistencia.SetGDWSCustomRetorno(const Value: TGDWSCustomRetorno);
begin
  FGDWSCustomRetorno := Value;
end;

end.


