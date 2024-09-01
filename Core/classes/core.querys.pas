unit core.querys;

{$mode ObjFPC}{$H+}

interface

uses
  core.types,
  Classes,
  SysUtils,
  DB,
  ZConnection,
  ZDataset;

type
  // Base de Query
  TQuery = class(TCore, IQuery)
  strict private
    FQuery: TZQuery;
    FTransaction: TZTransaction;
    FConnection: IDBConnection;
    FScript: TStringList;
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
  core.globals,
  core.connections;

{ TQuery }

function TQuery.Open: IQuery;
begin
  Result := Self;
  try
    FQuery.SQL.Text := FScript.Text;
    FQuery.Open;
  except
    on E: Exception do raise Exception.Create('Query - Falha ao abrir a query.' + CORE_DOUBLE_LINEBREAK + E.Message);
  end;
end;

function TQuery.Close: IQuery;
begin
  Result := Self;
  try
    if FQuery.Active then
      FQuery.Close;
  except
    on E: Exception do raise Exception.Create('Query - Falha ao fechar a query.' + CORE_DOUBLE_LINEBREAK + E.Message);
  end;
end;

function TQuery.Exec: IQuery;
begin
  Result := Self;
  try
    FQuery.SQL.Text := FScript.Text;
    FQuery.ExecSQL;
  except
    on E: Exception do raise Exception.Create('Query - Falha ao executar a query.' + CORE_DOUBLE_LINEBREAK + E.Message);
  end;
end;

function TQuery.Script: TStringList;
begin
  Result := FScript;
end;

function TQuery.AsDataSet: TDataSet;
begin
  Result := FQuery as TDataSet;
end;

constructor TQuery.Create;
begin
  inherited Create;
  FTransaction := TZTransaction.Create(nil);
  FTransaction.Connection := TDBConnection(FConnection.AsObject).GetConn;

  FQuery := TZQuery.Create(nil);
  FQuery.Connection := TDBConnection(FConnection.AsObject).GetConn;
  FQuery.Transaction := FTransaction;

  FScript := Factories.Objects.StringList;
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
  FreeObject( FTransaction );
  FreeObject( FQuery );
  FreeObject( FScript );
  inherited Destroy;
end;

end.

