unit core.view.sqlite;

{$mode ObjFPC}{$H+}

interface

uses
  core.types,
  Classes,
  SysUtils,
  DB,
  BufDataset,
  Forms,
  Controls,
  Graphics,
  Dialogs,
  StdCtrls,
  DBGrids;

type
  TViewSqlite = class(TForm)
    bdsUsuariocd_Usuario: TLongintField;
    bdsUsuariods_Usuario: TStringField;
    btDatabase: TButton;
    btConectar: TButton;
    btIncluir: TButton;
    btRemover: TButton;
    bdsUsuario: TBufDataset;
    dsUsuario: TDataSource;
    Grade: TDBGrid;
    edDatabase: TEdit;
    edUsuario: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    meLog: TMemo;
    procedure btConectarClick(Sender: TObject);
    procedure btDatabaseClick(Sender: TObject);
    procedure btIncluirClick(Sender: TObject);
    procedure btRemoverClick(Sender: TObject);
  private
    FDao: IDao;
    procedure LoadUsuarios;
  public
    property Dao: IDao read FDao;

    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  ViewSqlite: TViewSqlite;

implementation

uses
  core.helpers,
  core.globals;

{$R *.lfm}

{ TViewSqlite }

procedure TViewSqlite.btDatabaseClick(Sender: TObject);
var
  LFile: IFile;
begin
  LFile := Factories.Interfaces.AFile;
  LFile.LoadWithDialog(['SQLite Database|*.db']);
  edDatabase.Text := LFile.Path;
end;

procedure TViewSqlite.btIncluirClick(Sender: TObject);
begin
  if not edUsuario.Text.AsString.IsEmpty then
  begin
    try
      FDao.Execute('insert into tb_Usuario (ds_Usuario) values(' + edUsuario.Text.AsString.QuotedString + ')');
      LoadUsuarios;
    except
      on E: Exception do ShowMessage(E.Message);
    end;
  end;
end;

procedure TViewSqlite.btRemoverClick(Sender: TObject);
begin
  if not bdsUsuario.IsEmpty then
  begin
    try
      FDao.Execute('delete from tb_Usuario where cd_Usuario = ' + bdsUsuariocd_Usuario.AsString);
      LoadUsuarios;
    except
      on E: Exception do ShowMessage(E.Message);
    end;
  end;
end;

procedure TViewSqlite.LoadUsuarios;
var
  LDataset: TDataSet;
begin
  bdsUsuario.Close;
  bdsUsuario.CreateDataset;

  try
    LDataset := FDao.Select('select * from tb_Usuario').AsDataSet;

    if not LDataset.IsEmpty then
    begin
      LDataset.First;
      while not LDataset.EOF do
      begin
        bdsUsuario.Append;
        bdsUsuariocd_Usuario.AsInteger := LDataset.FieldByName('cd_Usuario').AsInteger;
        bdsUsuariods_Usuario.AsString := LDataset.FieldByName('ds_Usuario').AsString;
        bdsUsuario.Post;

        LDataset.Next;
      end;
      bdsUsuario.First;
    end;
  except
    on E: Exception do ShowMessage(E.Message);
  end;
end;

procedure TViewSqlite.btConectarClick(Sender: TObject);
begin
  try
    FDao.Connection
      .Database( edDatabase.Text )
      .Connect;

    if FDao.Connection.IsConnected then
    begin
      meLog.Lines.Add('Conectado com sucesso');
      LoadUsuarios;
    end;
  except
    on E: Exception do meLog.Lines.Add(E.Message);
  end;
end;

constructor TViewSqlite.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  FDao := Factories.Interfaces.DAO( Factories.Interfaces.SQLiteConnection );
end;

destructor TViewSqlite.Destroy;
begin
  inherited Destroy;
end;

end.

