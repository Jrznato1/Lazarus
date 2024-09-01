unit core.helpers;

{$mode ObjFPC}{$H+}
{$modeswitch TypeHelpers}

interface

uses
  core.types,
  Classes,
  Controls,
  SysUtils;

type
  {%REGION 'Resources'}
  TResourcesHelper = type helper for TResources
    procedure RemoveAll;
  end;
  {%ENDREGION}

  {%REGION 'Caption'}
  TCaptionHelper = type helper for TCaption
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

{ TCaptionHelper }

function TCaptionHelper.AsString: String;
begin
  Result := String(Self);
end;

end.
