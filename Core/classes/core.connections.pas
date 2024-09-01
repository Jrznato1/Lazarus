unit core.connections;

{$mode ObjFPC}{$H+}

interface

uses
  core.types,
  Classes,
  SysUtils,
  ZConnection;

type
  { Base de Conexão }
  TConnection = class(TCore, IConnection)
  strict private
    FIsConnected: Boolean;
    FTimeOut: Integer;
    FPort: Integer;
    const
      CONNECTION_MAIN_PORT = 8080;
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
  TDBConnection = class(TConnection, IDBConnection)
  strict private
    FConn: TZConnection;
    FDatabase: String;
    FUsername: String;
    FPassword: String;
    FHostname: String;
    FKeepConnection: Boolean;
    FLoginPrompt: Boolean;
    FUseWindowsAuth: Boolean;
    FLibLocation: String;
    FProtocol: String;
  protected
    procedure DoConnect; override;
    procedure DoDisconnect; override;
    procedure PrepareConnection; virtual;
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
    function UseWindowsAuth: Boolean;
    function UseWindowsAuth(const AUseWindowsAuth: Boolean): IDBConnection;
    function LibLocation: String;
    function LibLocation(const ALibraryLocation: String): IDBConnection;
    function Protocol: String;
    function Protocol(const AConnProtocol: String): IDBConnection;

    function GetConn: TZConnection;
    procedure SetConn(AConnection: TZConnection);

    constructor Create; override;
    destructor Destroy; override;
  end;

  // Conexão DB - SQLite
  TSqliteConnection = class(TDBConnection, IDBConnection)
  strict private
    const
      SQLITE_PROTOCOL = 'sqlite';
  protected
  public
    constructor Create; override;
    destructor Destroy; override;
  end;

  // Conexão DB - MariaDB
  TMariaDBConnection = class(TDBConnection, IDBConnection)
  strict private
    const
      MARIADB_MAIN_PORT = 3306;
      MARIADB_PROTOCOL  = 'mariadb';
      MARIADB_MAIN_USER = 'root';
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
  FPort := CONNECTION_MAIN_PORT;
end;

destructor TConnection.Destroy;
begin
  inherited Destroy;
end;

{ TDBConnection }

function TDBConnection.GetConn: TZConnection;
begin
  Result := FConn;
end;

procedure TDBConnection.SetConn(AConnection: TZConnection);
begin
  FConn := AConnection;
end;

procedure TDBConnection.DoConnect;
begin
  try
    PrepareConnection;
    if not FConn.Connected then
    begin
      FConn.Connect;
      IsConnected(FConn.Connected);
    end;
  except
    on E: Exception do raise Exception.Create('DBConnection - Falha ao conectar.' + CORE_DOUBLE_LINEBREAK + E.Message);
  end;
end;

procedure TDBConnection.DoDisconnect;
begin
  try
    if FConn.Connected then
    begin
      FConn.Disconnect;
      IsConnected(False);
    end;
  except
    on E: Exception do raise Exception.Create('DBConnection - Falha ao desconectar.' + CORE_DOUBLE_LINEBREAK + E.Message);
  end;
end;

procedure TDBConnection.PrepareConnection;
begin
  FConn.Database := FDatabase;
  FConn.User := FUsername;
  FConn.Password := FPassword;
  FConn.LoginPrompt := FLoginPrompt;
  FConn.HostName := FHostname;
  FConn.Port := Port;
  FConn.Protocol := FProtocol;
  FConn.LibraryLocation := FLibLocation;
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

function TDBConnection.UseWindowsAuth: Boolean;
begin
  Result := FUseWindowsAuth;
end;

function TDBConnection.UseWindowsAuth(const AUseWindowsAuth: Boolean
  ): IDBConnection;
begin
  Result := Self;
  FUseWindowsAuth := AUseWindowsAuth;
end;

function TDBConnection.LibLocation: String;
begin
  Result := FLibLocation;
end;

function TDBConnection.LibLocation(const ALibraryLocation: String
  ): IDBConnection;
begin
  Result := Self;
  FLibLocation := ALibraryLocation;
end;

function TDBConnection.Protocol: String;
begin
  Result := FProtocol;
end;

function TDBConnection.Protocol(const AConnProtocol: String): IDBConnection;
begin
  Result := Self;
  FProtocol := AConnProtocol;
end;

constructor TDBConnection.Create;
begin
  inherited Create;
  FLoginPrompt := False;
  FKeepConnection := False;
  TimeOut( CORE_DB_OPERATION_TIMELIMIT );
  FConn := TZConnection.Create(nil);
end;

destructor TDBConnection.Destroy;
begin
  Disconnect;
  FreeObject( FConn );
  inherited Destroy;
end;

{ TSqliteConnection }

constructor TSqliteConnection.Create;
begin
  inherited Create;
  Protocol( SQLITE_PROTOCOL );
  LibLocation(CORE_MAIN_APP_PATH + CORE_RESOURCE_SQLITE_DLL + '.dll');
end;

destructor TSqliteConnection.Destroy;
begin
  inherited Destroy;
end;

{ TMariaDBConnection }

constructor TMariaDBConnection.Create;
begin
  inherited Create;
  Username( MARIADB_MAIN_USER );
  Port( MARIADB_MAIN_PORT );
  Protocol( MARIADB_PROTOCOL );
  LibLocation(CORE_MAIN_APP_PATH + CORE_RESOURCE_MARIADB_DLL +  '.dll');
end;

destructor TMariaDBConnection.Destroy;
begin
  inherited Destroy;
end;

end.

