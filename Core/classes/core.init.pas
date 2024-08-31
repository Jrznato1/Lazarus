unit core.init;

{$mode ObjFPC}{$H+}

interface

uses
  core.types,
  LResources;

type
  // Base de implementação do Init
  TInit = class(TCore, IInit)
  strict private
  protected
    procedure DoInitialize; virtual;
  public
    function Initialize: IInit;

    constructor Create; override;
    destructor Destroy; override;
  end;

implementation

uses
  core.consts,
  core.globals;

{ TInit }

procedure TInit.DoInitialize;
var
  LResSqlite: IResource;
  LResMySql: IResource;
  LCount: Integer;
begin
  LResSqlite := Factories.Interfaces.Resource;
  LResMySql := Factories.Interfaces.Resource;

  // Prepara o resource de SQLite
  LCount := Resources.Count + 1;
  LResSqlite
    .Name('sqlite3')
    .Extension('.dll')
    .Path(CORE_MAIN_APP_PATH + LResSqlite.Name + LResSqlite.Extension)
    .Directory(CORE_MAIN_APP_PATH)
    .Load;
  Resources.Add(LCount, LResSqlite);
  Resources[LCount].Save;

  // Prepara o resource de MySQL
  Inc(LCount);
  LResMySQL
    .Name('libmysql')
    .Extension('.dll')
    .Path(CORE_MAIN_APP_PATH + LResMySQL.Name + LResMySql.Extension)
    .Directory(CORE_MAIN_APP_PATH)
    .Load;
  Resources.Add(LCount, LResMySQL);
  Resources[LCount].Save;
end;

function TInit.Initialize: IInit;
begin
  Result := Self;
  DoInitialize;
end;

constructor TInit.Create;
begin
  inherited Create;
end;

destructor TInit.Destroy;
begin
  inherited Destroy;
end;

initialization
  {$I ..\Resources\SQLite.lrs}
  {$I ..\Resources\MySQL.lrs}

end.

