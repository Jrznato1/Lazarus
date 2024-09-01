unit core.dao;

{$mode ObjFPC}{$H+}

interface

uses
  core.types,
  Classes,
  SysUtils;

type
  // Base de DAO
  TDao = class(TCore, IDao)
  strict private
    FConnection: IDBConnection;
    FQuery: IQuery;
  protected
    procedure StartTran; virtual;
    procedure RollbackTran; virtual;
    procedure CommitTran; virtual;
    procedure DoSelect(AScript: String); virtual;
    procedure DoExecute(AScript: String); virtual;
  public
    function Connection: IDBConnection;
    function Connection(const AConnection: IDBConnection): IDao;
    function Query: IQuery;
    function Query(const AQuery: IQuery): IDao;
    function Start: IDao;
    function Rollback: IDao;
    function Commit: IDao;
    function Select(const AScript: String): IQuery;
    function Execute(const AScript: String): IQuery;

    constructor Create; override;
    constructor Create(const AConnection: IDBConnection);
    destructor Destroy; override;
  end;

implementation

uses
  core.consts,
  core.globals,
  core.connections;

{ TDao }

procedure TDao.StartTran;
begin
  if not TDBConnection(FConnection.AsObject).GetConn.InTransaction then
    TDBConnection(FConnection.AsObject).GetConn.StartTransaction;
end;

procedure TDao.RollbackTran;
begin
  if TDBConnection(FConnection.AsObject).GetConn.InTransaction then
    TDBConnection(FConnection.AsObject).GetConn.Rollback;
end;

procedure TDao.CommitTran;
begin
  if TDBConnection(FConnection.AsObject).GetConn.InTransaction then
    TDBConnection(FConnection.AsObject).GetConn.Commit;
end;

procedure TDao.DoSelect(AScript: String);
begin
  try
    if not FConnection.IsConnected then
      FConnection.Connect;

    FQuery.Script.Text := AScript;
    FQuery.Open;
  except
    on E: Exception do raise Exception.Create('DAO - ' + E.Message);
  end;
end;

procedure TDao.DoExecute(AScript: String);
begin
  try
    if not FConnection.IsConnected then
      FConnection.Connect;

    FQuery.Script.Text := AScript;
    FQuery.Exec;
  except
    on E: Exception do raise Exception.Create('DAO - ' + E.Message);
  end;
end;

function TDao.Connection: IDBConnection;
begin
  Result := FConnection;
end;

function TDao.Connection(const AConnection: IDBConnection): IDao;
begin
  Result := Self;
  FConnection := AConnection;
end;

function TDao.Query: IQuery;
begin
  Result := FQuery;
end;

function TDao.Query(const AQuery: IQuery): IDao;
begin
  Result := Self;
  FQuery := AQuery;
end;

function TDao.Start: IDao;
begin
  Result := Self;
  try
    StartTran;
  except
    on E: Exception do raise Exception.Create('DAO - Falha ao iniciar a transação' + CORE_DOUBLE_LINEBREAK + E.Message);
  end;
end;

function TDao.Rollback: IDao;
begin
  Result := Self;
  try
    RollbackTran;
  except
    on E: Exception do raise Exception.Create('DAO - Falha ao desfazer a transação' + CORE_DOUBLE_LINEBREAK + E.Message);
  end;
end;

function TDao.Commit: IDao;
begin
  Result := Self;
  try
    CommitTran;
  except
    on E: Exception do raise Exception.Create('DAO - Falha ao comitar a transação' + CORE_DOUBLE_LINEBREAK + E.Message);
  end;
end;

function TDao.Select(const AScript: String): IQuery;
begin
  Result := FQuery;
  DoSelect(AScript);
end;

function TDao.Execute(const AScript: String): IQuery;
begin
  Result := FQuery;
  DoExecute(AScript);
end;

constructor TDao.Create;
begin
  inherited Create;
  FQuery := Factories.Interfaces.Query(FConnection);
end;

constructor TDao.Create(const AConnection: IDBConnection);
begin
  FConnection := AConnection;
  Create;
end;

destructor TDao.Destroy;
begin
  FConnection.Disconnect;
  inherited Destroy;
end;

end.

