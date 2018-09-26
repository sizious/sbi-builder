unit zipcomm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TZipComment_Form = class(TForm)
    gbWhatFilesDoINeedToAdd: TGroupBox;
    mWhatFileDoINeedToAdd: TMemo;
    gbWhatsThis: TGroupBox;
    mWhatsThis: TMemo;
    gbWhoMadeThis: TGroupBox;
    mWhoMadeThis: TMemo;
    gbHowDoIPlayThis: TGroupBox;
    mHowDoIPlayThis: TMemo;
    gbControls: TGroupBox;
    mControls: TMemo;
    bCreateTheFile: TButton;
    lWhats: TLabel;
    lWhoMade: TLabel;
    lHowToPlay: TLabel;
    bClearAllFields: TButton;
    bCancelThisOperation: TButton;
    procedure bCancelThisOperationClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure mWhatFileDoINeedToAddChange(Sender: TObject);
    procedure mWhatsThisChange(Sender: TObject);
    procedure mWhoMadeThisChange(Sender: TObject);
    procedure mHowDoIPlayThisChange(Sender: TObject);
    procedure mControlsChange(Sender: TObject);
    procedure bCreateTheFileClick(Sender: TObject);
    procedure bClearAllFieldsClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  ZipComment_Form: TZipComment_Form;

implementation

uses utils, main, u_zipcom;

var
  Modified : boolean;

{$R *.dfm}

//---CleanAll---
procedure CleanAll;
begin
  Modified := False;
  ZipComment_Form.mControls.Clear;
  ZipComment_Form.mHowDoIPlayThis.Clear;
  ZipComment_Form.mWhatFileDoINeedToAdd.Clear;
  ZipComment_Form.mWhatsThis.Clear;
  ZipComment_Form.mWhoMadeThis.Clear;
end;

procedure TZipComment_Form.bCancelThisOperationClick(Sender: TObject);
begin
  Close;
end;

procedure TZipComment_Form.FormClose(Sender: TObject;
  var Action: TCloseAction);

var
  CanDo : integer;

begin
  if Modified = True then
  begin

    CanDo := MessageBoxA(Handle, PChar(DeleteAllFields), PChar(Warning), 48 + MB_YESNOCANCEL + MB_DEFBUTTON3);
    if CanDo = IDCANCEL then
    begin
      Action := caNone;
      Exit;
    end;

    if CanDo = IDYES then CleanAll;

  end;
end;

procedure TZipComment_Form.FormShow(Sender: TObject);
begin
  Modified := False;
  gbHowDoIPlayThis.Caption := lHowToPlay.Caption + Main_Form.Title.Text + ' ? : ';
  gbWhoMadeThis.Caption := lWhoMade.Caption + Main_Form.Title.Text + ' ? : ';
  gbWhatsThis.Caption := lWhats.Caption + Main_Form.Title.Text + ' ? : ';

  if (Length(ZipComment_Form.mWhatFileDoINeedToAdd.Lines.Text) <> 0)
    or (Length(ZipComment_Form.mWhatsThis.Lines.Text) <> 0)
     or (Length(ZipComment_Form.mWhoMadeThis.Lines.Text) <> 0)
       or (Length(ZipComment_Form.mHowDoIPlayThis.Lines.Text) <> 0)
         or (Length(ZipComment_Form.mControls.Lines.Text) <> 0)
           then Modified := True;
end;

procedure TZipComment_Form.mWhatFileDoINeedToAddChange(Sender: TObject);
begin
  Modified := True;
end;

procedure TZipComment_Form.mWhatsThisChange(Sender: TObject);
begin
  Modified := True;
end;

procedure TZipComment_Form.mWhoMadeThisChange(Sender: TObject);
begin
  Modified := True;
end;

procedure TZipComment_Form.mHowDoIPlayThisChange(Sender: TObject);
begin
  Modified := True;
end;

procedure TZipComment_Form.mControlsChange(Sender: TObject);
begin
  Modified := True;
end;

procedure TZipComment_Form.bCreateTheFileClick(Sender: TObject);
var
  CanDo : integer;
  
begin
  //ShowMessage('si c vide il veut pas');
  if (Length(ZipComment_Form.mWhatFileDoINeedToAdd.Text) = 0)
    and (Length(ZipComment_Form.mWhatsThis.Text) = 0)
      and (Length(ZipComment_Form.mWhoMadeThis.Text) = 0)
        and (Length(ZipComment_Form.mHowDoIPlayThis.Text) = 0)
          and (Length(ZipComment_Form.mControls.Text) = 0)
            then begin
              MessageBoxA(Handle, PChar(ErrorAllFieldsAreEmpty), PChar(Error), 48);
              Exit;
            end;

  CreateZipCommentFile;

  if GetZipCommentFile <> '' then
  begin

    //ShowMessage('avertissement sur la taille');
    if GetFileSize(GetZipCommentFile) > 8192 then
    begin
      CanDo := MessageBoxA(Handle, PChar(WarningFileIsSuperiorThan8192Bytes + ' ' + TheFileWillBeTruncatedContinue), PChar(Error), 48 + MB_YESNO + MB_DEFBUTTON2);
      if CanDo = IDNO then Exit;
    end else MessageBoxA(Handle, PChar(FileSuccessfullyCreated), PChar(Information), 64);

  end;

  Modified := False;
  Close;
  Main_Form.NScreenC.Click;
end;

procedure TZipComment_Form.bClearAllFieldsClick(Sender: TObject);
var
  CanDo : integer;

begin
  CanDo := MessageBoxA(Handle, PChar(AreYouSure), PChar(Warning), 48 + MB_YESNO + MB_DEFBUTTON2);
  if CanDo = IDNO then Exit;
  
  CleanAll;
end;

procedure TZipComment_Form.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
  begin
    Key := #0;
    Close;
  end;
end;

end.
