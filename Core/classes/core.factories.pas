unit core.factories;

{$mode ObjFPC}{$H+}

interface

uses
  core.types,
  core.connections,
  core.files,
  core.resources,
  core.dao,
  core.querys,
  core.init,

  Classes,
  SysUtils,
  SQLite3Conn,
  SQLDB,
  mysql57conn;

type
  { Classe base de Fábrica }
  TFactory = class
  private
  public
  end;

  { Classe de fábrica de interfaces }
  TInterfaceFactory = class(TFactory)
  public
    // Inicialização
    class function Init: IInit; static;
    // Arquivos
    class function AFile: IFile; static;
    // Recursos
    class function Resource: IResource; static;
    // Conexões
    class function SQLiteConnection: IDBConnection; static;
    class function SQLServerConnection: IDBConnection; static;
    class function MariaDBConnection: IDBConnection; static;
    // Querys
    class function Query(const AConnection: IDBConnection): IQuery; static;
    // DAO
    class function DAO(const AConnection: IDBConnection): IDao; static;
  end;

  { Classe de fábrica de objetos }
  TObjectFactory = class(TFactory)
  public
    // Listas
    class function Resources: TResources; static;
    class function StringList: TStringList; static;
    // Conexões
    class function SQLite3Conn: TSQLite3Connection; static;
    class function SQLServerConn: TSQLConnector; static;
    class function MySQL57Conn: TMySQL57Connection; static;
    // Querys
    class function SQLQuery: TSQLQuery; static;
    // Transações
    class function Transaction: TSQLTransaction; static;
  end;

  TFactories = record
    Interfaces: TInterfaceFactory;
    Objects: TObjectFactory;
  end;

implementation

{ TInterfaceFactory }

class function TInterfaceFactory.Init: IInit;
begin
  Result := TInit.Create;
end;

class function TInterfaceFactory.AFile: IFile;
begin
  Result := TFile.Create;
end;

class function TInterfaceFactory.Resource: IResource;
begin
  Result := TResource.Create;
end;

class function TInterfaceFactory.SQLiteConnection: IDBConnection;
begin
  Result := TDBSqliteConnection.Create;
end;

class function TInterfaceFactory.SQLServerConnection: IDBConnection;
begin
  Result := TDBSqlConnection.Create;
end;

class function TInterfaceFactory.MariaDBConnection: IDBConnection;
begin
  Result := TDBMariaDB.Create;
end;

class function TInterfaceFactory.Query(const AConnection: IDBConnection): IQuery;
begin
  Result := TQuery.Create(AConnection);
end;

class function TInterfaceFactory.DAO(const AConnection: IDBConnection): IDao;
begin
  Result := TDao.Create(AConnection);
end;

{ TObjectFactory }

class function TObjectFactory.Resources: TResources;
begin
  Result := TResources.Create;
end;

class function TObjectFactory.SQLite3Conn: TSQLite3Connection;
begin
  Result := TSQLite3Connection.Create(nil);
end;

class function TObjectFactory.SQLServerConn: TSQLConnector;
begin
  Result := TSQLConnector.Create(nil);
end;

class function TObjectFactory.MySQL57Conn: TMySQL57Connection;
begin
  Result := TMySQL57Connection.Create(nil);
end;

class function TObjectFactory.SQLQuery: TSQLQuery;
begin
  Result := TSQLQuery.Create(nil);
end;

class function TObjectFactory.Transaction: TSQLTransaction;
begin
  Result := TSqlTransaction.Create(nil);
end;

class function TObjectFactory.StringList: TStringList;
begin
  Result := TStringList.Create;
end;

end.
