unit core.resources;

{$mode ObjFPC}{$H+}

interface

uses
  core.types,
  core.files,
  Classes,
  SysUtils,
  FileUtil,
  LResources;

type
  // Classe de Resources
  TResource = class(TFile, IResource)
  strict private
  protected
    procedure DoLoad; override;
    procedure DoSave; override;
    procedure DoDelete; override;
  public
    function DeleteDirectory: IResource;
    function DeleteDirectory(const ADirectory: String): IResource;

    constructor Create; override;
    destructor Destroy; override;
  end;

implementation

uses
  core.consts,
  core.globals;

{ TResource }

procedure TResource.DoLoad;
var
  LRes: TLResource;
  LResStream: TLazarusResourceStream;
begin
  LRes := LazarusResources.Find( Name );
  if LRes <> nil then
  begin
    try
      LResStream := TLazarusResourceStream.Create(LRes.Name, PChar(Extension.Replace('.','').ToUpper));
      Load( LResStream );
    finally
      FreeObject( LResStream );
    end;
  end;
end;

procedure TResource.DoSave;
begin
  if not DirectoryExists( Directory ) then
    ForceDirectories( Directory );
  inherited DoSave;
end;

procedure TResource.DoDelete;
begin
  inherited DoDelete;
end;

function TResource.DeleteDirectory: IResource;
begin
  Result := DeleteDirectory(Directory);
end;

function TResource.DeleteDirectory(const ADirectory: String): IResource;
begin
  Result := Self;
  if DirectoryExists( ADirectory ) then
  begin
    if FileUtil.DeleteDirectory(ADirectory, False) then
      RemoveDir(ADirectory);
  end;
end;

constructor TResource.Create;
begin
  inherited Create;
end;

destructor TResource.Destroy;
begin
  inherited Destroy;
end;

end.

