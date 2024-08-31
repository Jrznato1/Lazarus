unit core.consts;

{$mode ObjFPC}{$H+}

interface

uses
  Classes,
  Forms,
  SysUtils;

{%REGION 'Constantes'}
var
  CORE_MAIN_APP_PATH: String;

const
  CORE_DOUBLE_LINEBREAK                = sLineBreak + sLineBreak;
  CORE_DB_OPERATION_TIMELIMIT          = 9999; // segundos
  CORE_REMOVE_RESOURCES_WHEN_CLOSE_APP = True;
  CORE_OPEN_DIALOG_ALL_FILES           = '|All files|*.*';
{%ENDREGION}

implementation

initialization
  CORE_MAIN_APP_PATH := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName));

end.

