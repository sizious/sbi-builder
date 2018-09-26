unit logwin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, ComCtrls, Menus, XPMenu;

type
  TLog_Form = class(TForm)
    lbDebug: TListBox;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Panel1: TPanel;
    Image4: TImage;
    Bevel1: TBevel;
    StatusBar: TStatusBar;
    Panel2: TPanel;
    OKBtn: TBitBtn;
    PopupMenu: TPopupMenu;
    SaveLog: TMenuItem;
    SaveDialog: TSaveDialog;
    procedure OKBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SaveLogClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Log_Form: TLog_Form;

implementation

uses main, utils;

{$R *.dfm}

procedure TLog_Form.OKBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TLog_Form.FormCreate(Sender: TObject);
begin
  Log_Form.Caption := Main_Form.Caption + ' - *Debug Log*';
  InitDebugLog;
end;

procedure TLog_Form.SaveLogClick(Sender: TObject);
begin
  if SaveDialog.Execute = True then
    lbDebug.Items.SaveToFile(SaveDialog.FileName);
end;

procedure TLog_Form.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
  begin
    Key := #0;
    Close;
  end;
end;

end.
