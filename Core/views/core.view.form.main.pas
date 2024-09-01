unit core.view.form.main;

{$mode objfpc}{$H+}

interface

uses
  core.types,
  core.view.mariadb,
  Classes,
  SysUtils,
  SQLite3Conn,
  SQLDB,
  MSSQLConn,
  IBConnection,
  Forms,
  Controls,
  Graphics,
  Dialogs,
  StdCtrls,
  ExtCtrls;

type
  TFormMain = class(TForm)
    btRes3: TButton;
    btOpenDialogo: TButton;
    btSaveDialog: TButton;
    btDeleteDialog: TButton;
    btMariaDB: TButton;
    Edit1: TEdit;
    Image1: TImage;
    Memo1: TMemo;
    procedure btDeleteDialogClick(Sender: TObject);
    procedure btMariaDBClick(Sender: TObject);
    procedure btOpenDialogoClick(Sender: TObject);
    procedure btSaveDialogClick(Sender: TObject);
  private

  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  FormMain: TFormMain;
  TesteFile: IFile;

implementation

uses
  core.consts,
  core.globals;

{$R *.lfm}

{ TFormMain }

constructor TFormMain.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  TesteFile := Factories.Interfaces.AFile;
end;

destructor TFormMain.Destroy;
begin
  inherited Destroy;
end;

procedure TFormMain.btSaveDialogClick(Sender: TObject);
begin
  TesteFile.SaveWithDialog(['JPG Image|*.jpg','JPEG Image|*.jpeg']);
end;

procedure TFormMain.btOpenDialogoClick(Sender: TObject);
begin
  TesteFile.LoadWithDialog(['JPG Image|*.jpg','JPEG Image|*.jpeg']);
end;

procedure TFormMain.btDeleteDialogClick(Sender: TObject);
begin
  TesteFile.DeleteWithDialog(['JPG Image|*.jpg','JPEG Image|*.jpeg']);
end;

procedure TFormMain.btMariaDBClick(Sender: TObject);
begin
  frmMariaDB := TfrmMariaDB.Create(Self);
  try
    frmMariaDB.ShowModal;
  finally
    frmMariaDB.Free;
  end;
end;

end.

