unit core.helpers;

{$mode ObjFPC}{$H+}
{$modeswitch TypeHelpers}

interface

uses
  core.types,
  Classes,
  SysUtils,
  Variants;

type
  {%REGION 'Resources'}
  TResourcesHelper = type helper for TResources
    procedure RemoveAll;
  end;
  {%ENDREGION}

  {%REGION 'Variant'}
  TVariantHelper = type helper for Variant
    function AsInteger: Integer;
    function AsString: String;
  end;

  {%ENDREGION}

implementation

uses
  core.consts;

{ TResourcesHelper }

procedure TResourcesHelper.RemoveAll;
var
  LRes: IResource;
begin
  if Self.Count > 0 then
  begin
    for LRes in Self.Values do
    begin
      if LRes.Directory = CORE_MAIN_APP_PATH then
        LRes.Delete
      else
        LRes.DeleteDirectory;
    end;
  end;
end;

{ TVariantHelper }

function TVariantHelper.AsInteger: Integer;
begin
  Result := Integer(Self);
end;

function TVariantHelper.AsString: String;
begin
  Result := VarToStr(Self);
end;

end.
