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
  LResMariaDB: IResource;
  LCount: Integer;
begin
  LResSqlite := Factories.Interfaces.Resource;
  LResMariaDB := Factories.Interfaces.Resource;

  // Prepara o resource de SQLite
  LCount := Resources.Count + 1;
  LResSqlite.ID(LCount).Name(CORE_RESOURCE_SQLITE_DLL);
  LResSqlite
    .Extension('.dll')
    .Path(CORE_MAIN_APP_PATH + LResSqlite.Name + LResSqlite.Extension)
    .Directory(CORE_MAIN_APP_PATH)
    .Load;

  Resources.Add(LResSqlite.ID, LResSqlite);
  Resources[LCount].Save;

  // Prepara o resource de MariaDB
  Inc(LCount);
  LResMariaDB.ID(LCount).Name(CORE_RESOURCE_MARIADB_DLL);
  LResMariaDB
    .Extension('.dll')
    .Path(CORE_MAIN_APP_PATH + LResMariaDB.Name + LResMariaDB.Extension)
    .Directory(CORE_MAIN_APP_PATH)
    .Load;

  Resources.Add(LResMariaDB.ID, LResMariaDB);
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
  {$I ..\Resources\MariaDB.lrs}

end.

