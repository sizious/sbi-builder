unit ask;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TAsk_Form = class(TForm)
    gbAsk: TGroupBox;
    bOK: TBitBtn;
    bCancel: TBitBtn;
    eAsk: TEdit;
    procedure FormActivate(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Ask_Form: TAsk_Form;

implementation

{$R *.dfm}

procedure TAsk_Form.FormActivate(Sender: TObject);
begin
  Ask_Form.eAsk.SetFocus;
end;

end.
