unit core.files;

{$mode ObjFPC}{$H+}

interface

uses
  core.types,
  core.identifier,
  Classes,
  Dialogs,
  SysUtils;

type
  // Classe base de Arquivo
  TFile = class(TIdentifier, IFile)
  strict private
    FExt: String;
    FStream: TBytesStream;
    FPath: String;
    FDirectory: String;
    FUseAllFilesFilter: Boolean;
    FOpenDialog: TOpenDialog;
    FSaveDialog: TSaveDialog;
    procedure LoadDialogFilter(AFilters: TStringArray; ADialog: TFileDialog);
  protected
    procedure DoLoad; virtual;
    procedure DoSave; virtual;
    procedure DoDelete; virtual;
  public
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

    constructor Create; override;
    destructor Destroy; override;
  end;

implementation

uses
  core.consts,
  core.globals;

{ TFile }

procedure TFile.LoadDialogFilter(AFilters: TStringArray; ADialog: TFileDialog);
var
  i: Integer;
begin
  ADialog.Filter := '';

  if Length(AFilters) > 0 then
  begin
    for i := 0 to Length(AFilters) - 1 do
    begin
      ADialog.Filter := ADialog.Filter + '|' + AFilters[i];
    end;
  end;

  if UseAllFilesFilter then
    ADialog.Filter := ADialog.Filter + CORE_OPEN_DIALOG_ALL_FILES;
end;

procedure TFile.DoLoad;
begin
  Load( FPath );
end;

procedure TFile.DoSave;
begin
  Save( FPath );
end;

procedure TFile.DoDelete;
begin
  Delete( FPath );
end;

function TFile.AsBytesStream: TBytesStream;
begin
  Result := FStream;
end;

function TFile.IsEmpty: Boolean;
begin
  Result := Length(FStream.Bytes) = 0;
end;

function TFile.Extension: String;
begin
  Result := FExt;
end;

function TFile.Extension(const AExtension: String): IFile;
begin
  Result := Self;
  FExt := AExtension;
end;

function TFile.Path: String;
begin
  Result := FPath;
end;

function TFile.Path(const APath: String): IFile;
begin
  Result := Self;
  FPath := APath;
end;

function TFile.Directory: String;
begin
  Result := FDirectory;
end;

function TFile.Directory(const ADirectory: String): IFile;
begin
  Result := Self;
  FDirectory := ADirectory;
end;

function TFile.UseAllFilesFilter: Boolean;
begin
  Result := FUseAllFilesFilter;
end;

function TFile.UseAllFilesFilter(const AllFiles: Boolean): IFile;
begin
  Result := Self;
  FUseAllFilesFilter := AllFiles;
end;

function TFile.Load: IFile;
begin
  Result := Self;
  DoLoad;
end;

function TFile.Load(const APath: String): IFile;
begin
  Result := Self;
  if not APath.IsEmpty then
  begin
    Name( ExtractFileName(APath) );
    FExt := ExtractFileExt( APath );
    FPath := APath;
    FDirectory := ExtractFileDir( APath );
    FStream.LoadFromFile( APath );
  end;
end;

function TFile.Load(const AStream: TStream): IFile;
begin
  Result := Self;
  if AStream <> nil then
    FStream.LoadFromStream( AStream );
end;

function TFile.LoadWithDialog(const Filters: TStringArray): IFile;
begin
  Result := Self;
  LoadDialogFilter(Filters,FOpenDialog);
  FOpenDialog.Execute;
  if not FOpenDialog.FileName.IsEmpty then
    Load( FOpenDialog.FileName );
end;

function TFile.Save: IFile;
begin
  Result := Self;
  DoSave;
end;

function TFile.Save(const APath: String): IFile;
begin
  Result := Self;
  if Length(FStream.Bytes) > 0 then
    FStream.SaveToFile( APath );
end;

function TFile.SaveWithDialog(const Filters: TStringArray): IFile;
begin
  Result := Self;
  LoadDialogFilter(Filters,FSaveDialog);
  FSaveDialog.Execute;
  if not FSaveDialog.FileName.IsEmpty then
    Save( FSaveDialog.FileName );
end;

function TFile.Delete: IFile;
begin
  Result := Self;
  DoDelete;
end;

function TFile.Delete(const APath: String): IFile;
begin
  Result := Self;
  if FileExists( APath ) then
    DeleteFile( APath );
end;

function TFile.DeleteWithDialog(const Filters: TStringArray): IFile;
begin
  Result := Self;
  LoadDialogFilter(Filters,FOpenDialog);
  FOpenDialog.Execute;
  if not FOpenDialog.FileName.IsEmpty then
    Delete( FSaveDialog.FileName );
end;

constructor TFile.Create;
begin
  inherited Create;
  FStream := TBytesStream.Create;
  FUseAllFilesFilter := True;
  FOpenDialog := TOpenDialog.Create(nil);
  FSaveDialog := TSaveDialog.Create(nil);
end;

destructor TFile.Destroy;
begin
  FreeObject( FStream );
  FreeObject( FOpenDialog );
  FreeObject( FSaveDialog );
  inherited Destroy;
end;

end.
