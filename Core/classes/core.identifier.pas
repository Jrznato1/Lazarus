unit core.identifier;

{$mode ObjFPC}{$H+}

interface

uses
  core.types,
  Classes,
  SysUtils;

type
  TIdentifier = class(TCore, IIdentifier)
  strict private
    FId: Variant;
    FName: String;
  protected
  public
    function ID: Variant;
    function ID(const AId: Variant): IIdentifier;
    function Name: String;
    function Name(const AName: String): IIdentifier;

    constructor Create; override;
    destructor Destroy; override;
  end;

implementation

{ TIdentifier }

function TIdentifier.ID: Variant;
begin
  Result := FId;
end;

function TIdentifier.ID(const AId: Variant): IIdentifier;
begin
  Result := Self;
  FId := AId;
end;

function TIdentifier.Name: String;
begin
  Result := FName;
end;

function TIdentifier.Name(const AName: String): IIdentifier;
begin
  Result := Self;
  FName := AName;
end;

constructor TIdentifier.Create;
begin
  inherited Create;
end;

destructor TIdentifier.Destroy;
begin
  inherited Destroy;
end;

end.

