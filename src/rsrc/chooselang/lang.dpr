program lang;

uses
  Windows;

{$R lang.res}

begin
  WinExec(PChar('buildsbi /chooselang'), SW_SHOWNORMAL);
end.
 