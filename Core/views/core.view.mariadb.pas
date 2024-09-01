unit core.view.mariadb;

{$mode ObjFPC}{$H+}

interface

uses
  core.types,
  Classes,
  SysUtils,
  BufDataset,
  DB,
  Forms,
  Controls,
  Graphics,
  Dialogs,
  StdCtrls,
  DBGrids;

type
  TfrmMariaDB = class(TForm)
    bdsUsuariocd_Usuario: TLongintField;
    bdsUsuariods_Usuario: TStringField;
    btAdd: TButton;
    btRemover: TButton;
    btConectar: TButton;
    bdsUsuario: TBufDataset;
    btRemoverTodos: TButton;
    dsUsuario: TDataSource;
    edServer: TEdit;
    edUser: TEdit;
    edPassword: TEdit;
    edPort: TEdit;
    edDatabase: TEdit;
    Grade: TDBGrid;
    edUsuario: TEdit;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    meLog: TMemo;
    procedure btAddClick(Sender: TObject);
    procedure btConectarClick(Sender: TObject);
    procedure btRemoverClick(Sender: TObject);
    procedure btRemoverTodosClick(Sender: TObject);
  private
    FDao: IDao;
    procedure LoadUsuarios;
  public
    property DAO: IDao read FDao;
    constructor Create(TheOwner: TComponent); override;
  end;

var
  frmMariaDB: TfrmMariaDB;

implementation

uses
  core.globals,
  core.helpers;

{$R *.lfm}

{ TfrmMariaDB }

procedure TfrmMariaDB.btConectarClick(Sender: TObject);
begin
  try
    FDao.Connection
      .Hostname( edServer.Text )
      .Database( edDatabase.Text )
      .Username( edUser.Text )
      .Password( edPassword.Text )
      .Port( edPort.Text.AsString.ToInteger );

    FDao.Connection.Connect;

    if FDao.Connection.IsConnected then
    begin
      meLog.Lines.Add('Conectado com sucesso');
      LoadUsuarios;
    end;
  except
    on E: Exception do meLog.Lines.Add(E.Message);
  end;
end;

procedure TfrmMariaDB.btRemoverClick(Sender: TObject);
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

procedure TfrmMariaDB.btRemoverTodosClick(Sender: TObject);
begin
  FDao.Execute('delete from tb_Usuario');
  LoadUsuarios;
end;

procedure TfrmMariaDB.LoadUsuarios;
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

procedure TfrmMariaDB.btAddClick(Sender: TObject);
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

constructor TfrmMariaDB.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  FDao := Factories.Interfaces.DAO( Factories.Interfaces.MariaDBConnection );
end;

end.

