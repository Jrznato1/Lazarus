unit core.globals;

{$mode ObjFPC}{$H+}

interface

uses
  core.factories,
  core.types,
  core.consts,
  Classes,
  SysUtils;

var
  Factories: TFactories;
  Resources: TResources;

implementation

uses
  core.helpers;

initialization
  Resources := Factories.Objects.Resources;

finalization
  if CORE_REMOVE_RESOURCES_WHEN_CLOSE_APP then
    Resources.RemoveAll;
  FreeAndNil( Resources );

end.

