unit about;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, jpeg, ShellApi, IniFiles;

type
  TAboutBox = class(TForm)
    Panel1: TPanel;
    CloseBtn: TButton;
    Bevel1: TBevel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Image1: TImage;
    Label13: TLabel;
    Author: TLabel;
    Label14: TLabel;
    Label11: TLabel;
    Button1: TButton;
    Label12: TLabel;
    Label15: TLabel;
    procedure Label3MouseEnter(Sender: TObject);
    procedure Label3MouseLeave(Sender: TObject);
    procedure Label3Click(Sender: TObject);
    procedure Label7MouseEnter(Sender: TObject);
    procedure Label7MouseLeave(Sender: TObject);
    procedure Label7Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  AboutBox: TAboutBox;

implementation

uses about_main_form, utils;

{$R *.dfm}

procedure LoadAboutBoxLanguage();
var
  LngFile : TIniFile;
  LangFileName : TFileName;
  
begin
  LangFileName := GetSelectedLanguageFile();
  if LangFileName = 'English' then Exit;
  
  LngFile := TIniFile.Create(LangFileName);
  try
    AboutBox.CloseBtn.Caption := LngFile.ReadString('Buttons', 'Close', '');
    AboutBox.Author.Caption := 'Translation by ' + LngFile.ReadString('Lang', 'Author', '') + ' (File version ' + LngFile.ReadString('Lang', 'Version', '') + ') ...';
  finally
    LngFile.Free;
  end;
end;

procedure TAboutBox.Label3MouseEnter(Sender: TObject);
begin
  Label3.Font.Style := [fsUnderline];
  Label3.Font.Color := clBlue;
  Label3.Cursor := crHandPoint;
end;

procedure TAboutBox.Label3MouseLeave(Sender: TObject);
begin
  Label3.Font.Style := [];
  Label3.Font.Color := clGreen;
  Label3.Cursor := crDefault;
end;

procedure TAboutBox.Label3Click(Sender: TObject);
begin
  ShellExecute(AboutBox.Handle, 'open', 'http://www.dcemulation.fr.st/', '', '', SW_SHOWNORMAL);
end;

procedure TAboutBox.Label7MouseEnter(Sender: TObject);
begin
  Label7.Font.Style := [fsUnderline];
  Label7.Font.Color := clBlue;
  Label7.Cursor := crHandPoint;
end;

procedure TAboutBox.Label7MouseLeave(Sender: TObject);
begin
  Label7.Font.Style := [];
  Label7.Font.Color := clGreen;
  Label7.Cursor := crDefault;
end;

procedure TAboutBox.Label7Click(Sender: TObject);
begin
  ShellExecute(AboutBox.Handle, 'open', 'http://dcreload.free.fr/', '', '', SW_SHOWNORMAL);
end;

procedure TAboutBox.Button1Click(Sender: TObject);
begin
  //S_AboutBox.ShowModal;
  frmAboutDemo := TfrmAboutDemo.Create(Application);
  try
    frmAboutDemo.ShowModal;
  finally
    frmAboutDemo.Free;
  end;
end;

procedure TAboutBox.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
  begin
    Key := #0;
    Close;
  end;
end;

procedure TAboutBox.FormShow(Sender: TObject);
begin
  LoadAboutBoxLanguage();
end;

end.
