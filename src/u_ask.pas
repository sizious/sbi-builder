unit u_ask;

interface

uses
  Windows, SysUtils, Controls;
  
function ShowPrompt(Caption, Message : string) : string;

implementation

uses ask;

function ShowPrompt(Caption, Message : string) : string;
var
  Res : integer;

begin
  Ask_Form.eAsk.Clear;
  Ask_Form.Caption := Caption;
  Ask_Form.gbAsk.Caption := ' ' + Message + ' ';

  Res := Ask_Form.ShowModal;

  if Res = mrOK then
    Result := Ask_Form.eAsk.Text
  else Result := '';

end;

end.
