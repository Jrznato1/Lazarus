unit core.types;

{$mode ObjFPC}{$H+}

interface

uses
  Generics.Collections,
  Classes,
  SysUtils,
  DB,
  Variants;

type
{%REGION 'Declarações Forward'}
  IResource = interface;
  IQuery = interface;
{%ENDREGION}

{%REGION 'Primitives'}
{%ENDREGION}

{%REGION 'Records'}
{%ENDREGION}

{%REGION 'Listas / Dicionários'}
  TResources = specialize TDictionary<Integer,IResource>;
{%ENDREGION}

{%REGION 'Classes'}
{%ENDREGION}

{%REGION 'Interfaces'}
  {%REGION 'CORE - Interface Base'}
  {Base para todas as outras interfaces}
  ICore = interface
    ['{818F3447-72C4-4551-9243-5BAD47F89061}']
    function AsObject: TObject;
  end;
  {%ENDREGION}

  {%REGION 'Inits - Interface de Inicialização'}
  { Comments here }
  IInit = interface(ICore)
    ['{41592C40-2CE4-45E3-9CBC-01B68AFA453D}']
    function Initialize: IInit;
  end;
  {%ENDREGION}

  {%REGION 'Identificador'}
  { Interface de Identificador }
  IIdentifier = interface(ICore)
    ['{DAD5C798-DD76-49B5-971C-80C56A44858E}']
    function ID: Variant;
    function ID(const AId: Variant): IIdentifier;
    function Name: String;
    function Name(const AName: String): IIdentifier;
  end;
  {%ENDREGION}

  {%REGION 'Conexões - Interfaces de Conexões'}
  { Interface base de conexão }
  IConnection = interface(ICore)
    ['{299E10D3-4AB9-45A2-A4A1-AC1C541C4153}']
    function TimeOut: Integer;
    function TimeOut(const ATimeOutLimit: Integer): IConnection;
    function Port: Integer;
    function Port(const APort: Integer): IConnection;

    function Connect: IConnection;
    function Disconnect: IConnection;

    function IsConnected: Boolean;
    function IsConnected(const Connected: Boolean): IConnection;
  end;

  { Interface base de conexão com banco de dados }
  IDBConnection = interface(IConnection)
    ['{83E7CAD3-1C2F-4E9A-B2D3-C8DA80A43D9A}']
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
  end;
  {%ENDREGION}

  {%REGION 'Arquivos' - Interfaces de Arquivos}
  { Interface base de arquivo }
  IFile = interface(IIdentifier)
    ['{60215D00-A34F-480B-B72E-303EB8813648}']
    function AsBytesStream: TBytesStream;

    function IsEmpty: Boolean;

    function Extension: String;
    function Extension(const AExtension: String): IFile;
    function Path: String;
    function Path(const APath: String): IFile;
    function Directory: String;
    function Directory(const ADirectory: String): IFile;
    function UseAllFilesFilter: Boolean;
    function UseAllFilesFilter(const AllFiles: Boolean): IFile;

    function Load: IFile;
    function Load(const APath: String): IFile;
    function Load(const AStream: TStream): IFile;
    function LoadWithDialog(const Filters: TStringArray): IFile;
    function Save: IFile;
    function Save(const APath: String): IFile;
    function SaveWithDialog(const Filters: TStringArray): IFile;
    function Delete: IFile;
    function Delete(const APath: String): IFile;
    function DeleteWithDialog(const Filters: TStringArray): IFile;
  end;

  // Interface de recursos
  IResource = interface(IFile)
    ['{2DDBC9F1-11C7-4754-BBAE-E53B85A37CC3}']
    function DeleteDirectory: IResource;
    function DeleteDirectory(const ADirectory: String): IResource;
  end;
  {%ENDREGION}

  {%REGION 'DAO - Data Access Object'}
  { Interface de Query }
  IQuery = interface(ICore)
    ['{1CB95C14-9314-4EE0-A890-A08EACFAEB07}']
    function Open: IQuery;
    function Close: IQuery;
    function Exec: IQuery;
    function Script: TStringList;
    function AsDataSet: TDataSet;
  end;

  { Interface base de DAO }
  IDao = interface(ICore)
    ['{F8F994A3-D077-47DF-B8E1-D71A236E2D80}']
    function Connection: IDBConnection;
    function Connection(const AConnection: IDBConnection): IDao;
    function Query: IQuery;
    function Query(const AQuery: IQuery): IDao;
    function Start: IDao;
    function Rollback: IDao;
    function Commit: IDao;
    function Select(const AScript: String): IQuery;
    function Execute(const AScript: String): IQuery;
  end;
  {%ENDREGION}

{%ENDREGION}

{%REGION 'CORE - Classe Base'}
  {Implementação da Interface base de ICore}
  TCore = class(TInterfacedObject, ICore)
  strict private
  protected
    procedure FreeObject(AObject: TObject);
  public
    function AsObject: TObject;

    constructor Create; virtual;
    destructor Destroy; override;
  end;
{%ENDREGION}

implementation

{ TCore }

procedure TCore.FreeObject(AObject: TObject);
begin
  if Assigned(AObject) then
    FreeAndNil(AObject);
end;

function TCore.AsObject: TObject;
begin
  Result := Self as TObject;
end;

constructor TCore.Create;
begin
end;

destructor TCore.Destroy;
begin
  inherited Destroy;
end;

end.
