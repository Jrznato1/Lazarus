unit core.view.form.main;

{$mode objfpc}{$H+}

interface

uses
  core.types,
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
    Edit1: TEdit;
    Image1: TImage;
    Memo1: TMemo;
    procedure btDeleteDialogClick(Sender: TObject);
    procedure btOpenDialogoClick(Sender: TObject);
    procedure btSaveDialogClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
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

procedure TFormMain.FormShow(Sender: TObject);
begin

end;

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

end.

