unit core.querys;

{$mode ObjFPC}{$H+}

interface

uses
  core.types,
  Classes,
  SysUtils,
  SQLDB,
  DB;

type
  // Base de Query
  TQuery = class(TCore, IQuery)
  strict private
    FQuery: TSQLQuery;
    FTransaction: TSQLTransaction;
    FConnection: IDBConnection;
  protected
  public
    function Open: IQuery;
    function Close: IQuery;
    function Exec: IQuery;
    function Script: TStringList;
    function AsDataSet: TDataSet;

    constructor Create; override;
    constructor Create(const AConnection: IDBConnection);
    destructor Destroy; override;
  end;

implementation

uses
  core.consts,
  core.globals;

{ TQuery }

function TQuery.Open: IQuery;
begin
  Result := Self;
  try
    if not FQuery.Active then
      FQuery.Open;
  except
    on E: Exception do Exception.Create('Query - Falha ao abrir a query.' + CORE_DOUBLE_LINEBREAK + E.Message);
  end;
end;

function TQuery.Close: IQuery;
begin
  Result := Self;
  try
    if FQuery.Active then
      FQuery.Close;
  except
    on E: Exception do Exception.Create('Query - Falha ao fechar a query.' + CORE_DOUBLE_LINEBREAK + E.Message);
  end;
end;

function TQuery.Exec: IQuery;
begin
  Result := Self;
  try
    if FQuery.Active then
      FQuery.ExecSQL;
  except
    on E: Exception do Exception.Create('Query - Falha ao executar a query.' + CORE_DOUBLE_LINEBREAK + E.Message);
  end;
end;

function TQuery.Script: TStringList;
begin
  Result := FQuery.SQL;
end;

function TQuery.AsDataSet: TDataSet;
begin
  Result := FQuery as TDataSet;
end;

constructor TQuery.Create;
begin
  inherited Create;
  FQuery := Factories.Objects.SQLQuery;
  FQuery.SQLConnection := TSQLConnection(FConnection.AsObject);

  FTransaction := Factories.Objects.Transaction;
  FTransaction.SQLConnection := TSQLConnection(FConnection.AsObject);

  FQuery.SQLTransaction := FTransaction;
end;

constructor TQuery.Create(const AConnection: IDBConnection);
begin
  FConnection := AConnection;
  Create;
end;

destructor TQuery.Destroy;
begin
  FConnection := nil;
  Close;
  FreeObject( FQuery );
  inherited Destroy;
end;

end.

