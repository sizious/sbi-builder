unit lang;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TLang_Form = class(TForm)
    GroupBox1: TGroupBox;
    Lang: TComboBox;
    Button1: TButton;
    LangFileName: TListBox;
    Image1: TImage;
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Lang_Form: TLang_Form;

implementation

uses main, utils;

{$R *.dfm}

procedure TLang_Form.Button1Click(Sender: TObject);
var
  LangID : string;

begin
  LangID := Lang_Form.LangFileName.Items.Strings[Lang_Form.Lang.ItemIndex];
  Ini.WriteString('Config', 'LangID', LangID);

  if LangID = 'English' then
  begin
    LoadEnglish;
    Exit;
  end;

  LoadLang(LangID);
end;

procedure TLang_Form.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Button1.Click;
end;

procedure TLang_Form.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
  begin
    Key := #0;
    Close;
  end;
end;

end.
