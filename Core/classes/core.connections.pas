unit core.connections;

{$mode ObjFPC}{$H+}

interface

uses
  core.types,
  Classes,
  SysUtils,
  SQLite3Conn,
  SQLDB,
  mysql57conn;

type
  { Base de Conexão }
  TConnection = class(TCore, IConnection)
  strict private
    FIsConnected: Boolean;
    FTimeOut: Integer;
    FPort: Integer;
  protected
    procedure DoConnect; virtual; abstract;
    procedure DoDisconnect; virtual; abstract;
  public
    function TimeOut: Integer;
    function TimeOut(const ATimeOutLimit: Integer): IConnection;
    function Port: Integer;
    function Port(const APort: Integer): IConnection;

    function Connect: IConnection;
    function Disconnect: IConnection;

    function IsConnected: Boolean;
    function IsConnected(const Connected: Boolean): IConnection;

    constructor Create; override;
    destructor Destroy; override;
  end;

  { Base de conexão DB - Database }
  generic TDBConnection<T> = class(TConnection, IDBConnection)
  strict private
    FConn: T;
    FDatabase: String;
    FUsername: String;
    FPassword: String;
    FHostname: String;
    FKeepConnection: Boolean;
    FLoginPrompt: Boolean;
  protected
    function GetConn: T;
    procedure SetConn(AConnection: T);

    procedure DoConnect; override;
    procedure DoDisconnect; override;
  public
    function Database: string;
    function Database(const ADatabase: string): IDBConnection;
    function Username: string;
    function Username(const AUsername: string): IDBConnection;
    function Password: String;
    function Password(const APassword: string): IDBConnection;
    function Hostname: string;
    function Hostname(const AHostname: String): IDBConnection;
    function KeepConnection: Boolean;
    function KeepConnection(const KeepConnected: Boolean): IDBConnection;
    function LoginPrompt: Boolean;
    function LoginPrompt(const Prompt: Boolean): IDBConnection;

    constructor Create; override;
    destructor Destroy; override;
  end;

  // Conexão DB - SQLite
  TDBSqliteConnection = class(specialize TDBConnection<TSQLite3Connection>, IDBConnection)
  strict private
  protected
  public
    constructor Create; override;
    destructor Destroy; override;
  end;

  // Conexão DB - SQL Server
  TDBSqlConnection = class(specialize TDBConnection<TSQLConnector>, IDBConnection)
  strict private
  protected
  public
    constructor Create; override;
    destructor Destroy; override;
  end;

  // Conexão DB - MariaDB
  TDBMariaDB = class(specialize TDBConnection<TMySQL57Connection>, IDBConnection)
  strict private
  protected
  public
    constructor Create; override;
    destructor Destroy; override;
  end;

implementation

uses
  core.consts,
  core.globals;

{ TConnection }

function TConnection.TimeOut: Integer;
begin
  Result := FTimeOut;
end;

function TConnection.TimeOut(const ATimeOutLimit: Integer): IConnection;
begin
  Result := Self;
  FTimeOut := ATimeOutLimit;
end;

function TConnection.Port: Integer;
begin
  Result := FPort;
end;

function TConnection.Port(const APort: Integer): IConnection;
begin
  Result := Self;
  FPort := APort;
end;

function TConnection.Connect: IConnection;
begin
  Result := Self;
  DoConnect;
end;

function TConnection.Disconnect: IConnection;
begin
  Result := Self;
  DoDisconnect;
end;

function TConnection.IsConnected: Boolean;
begin
  Result := FIsConnected;
end;

function TConnection.IsConnected(const Connected: Boolean): IConnection;
begin
  Result := Self;
  FIsConnected := Connected;
end;

constructor TConnection.Create;
begin
  inherited Create;
  FIsConnected := False;
end;

destructor TConnection.Destroy;
begin
  inherited Destroy;
end;

{ TDBConnection }

function TDBConnection.GetConn: T;
begin
  Result := FConn;
end;

procedure TDBConnection.SetConn(AConnection: T);
begin
  FConn := AConnection;
end;

procedure TDBConnection.DoConnect;
begin
  try
    with TSQLConnection(FConn) do
    begin
      if not Connected then
      begin
        DatabaseName := Self.Database;
        UserName := Self.Username;
        Password := Self.Password;
        LoginPrompt := Self.LoginPrompt;
        KeepConnection := Self.KeepConnection;
        Open;
      end;
    end;
  except
    on E: Exception do Exception.Create('DBConnection - Falha ao conectar.' + CORE_DOUBLE_LINEBREAK + E.Message);
  end;
end;

procedure TDBConnection.DoDisconnect;
begin
  try
    with TSQLConnection(FConn) do
    begin
      if Connected then
        Close;
    end;
  except
    on E: Exception do Exception.Create('DBConnection - Falha ao desconectar.' + CORE_DOUBLE_LINEBREAK + E.Message);
  end;
end;

function TDBConnection.Database: string;
begin
  Result := FDatabase;
end;

function TDBConnection.Database(const ADatabase: string): IDBConnection;
begin
  Result := Self;
  FDatabase := ADatabase;
end;

function TDBConnection.Username: string;
begin
  Result := FUsername;
end;

function TDBConnection.Username(const AUsername: string): IDBConnection;
begin
  Result := Self;
  FUsername := AUsername;
end;

function TDBConnection.Password: String;
begin
  Result := FPassword;
end;

function TDBConnection.Password(const APassword: string): IDBConnection;
begin
  Result := Self;
  FPassword := APassword;
end;

function TDBConnection.Hostname: string;
begin
  Result := FHostname;
end;

function TDBConnection.Hostname(const AHostname: String): IDBConnection;
begin
  Result := Self;
  FHostname := AHostname;
end;

function TDBConnection.KeepConnection: Boolean;
begin
  Result := FKeepConnection;
end;

function TDBConnection.KeepConnection(const KeepConnected: Boolean
  ): IDBConnection;
begin
  Result := Self;
  FKeepConnection := KeepConnected;
end;

function TDBConnection.LoginPrompt: Boolean;
begin
  Result := FLoginPrompt;
end;

function TDBConnection.LoginPrompt(const Prompt: Boolean): IDBConnection;
begin
  Result := Self;
  FLoginPrompt := Prompt;
end;

constructor TDBConnection.Create;
begin
  inherited Create;
  FLoginPrompt := False;
  FKeepConnection := False;
  TimeOut( CORE_DB_OPERATION_TIMELIMIT );
end;

destructor TDBConnection.Destroy;
begin
  Disconnect;
  FreeObject( FConn );
  inherited Destroy;
end;

{ TDBSqliteConnection }

constructor TDBSqliteConnection.Create;
begin
  inherited Create;
  SetConn( Factories.Objects.SQLite3Conn );
end;

destructor TDBSqliteConnection.Destroy;
begin
  inherited Destroy;
end;

{ TDBSqlConnection }

constructor TDBSqlConnection.Create;
begin
  inherited Create;
  SetConn( Factories.Objects.SQLServerConn );
end;

destructor TDBSqlConnection.Destroy;
begin
  inherited Destroy;
end;

{ TDBMariaDB }

constructor TDBMariaDB.Create;
begin
  inherited Create;
  SetConn( Factories.Objects.MySQL57Conn );
end;

destructor TDBMariaDB.Destroy;
begin
  inherited Destroy;
end;

end.

