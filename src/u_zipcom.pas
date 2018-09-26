unit u_zipcom;

interface

uses
  Windows, SysUtils;

procedure CreateZipCommentFile;
function GetZipCommentFile : string;
  
implementation

uses utils, zipcomm, main;

//---GetZipCommentFile---
function GetZipCommentFile : string;
var
  FName : string;

begin
  Result := '';
  FName := GetRealPath(GetTempDir) + '~zipcomm.tmp';
  if FileExists(FName) = True then Result := FName;
end;

//---CreateZipCommentFile---
procedure CreateZipCommentFile;
var
  F : TextFile;
  FName, Title : string;
  i : integer;

begin
  //Result := False;
  FName := GetRealPath(GetTempDir) + '~zipcomm.tmp';
  Title := Main_Form.Title.Text;
  if FileExists(FName) = True then DeleteFile(FName);

  //Création du fichier
  AssignFile(F, FName);
  ReWrite(F);

  if (Length(ZipComment_Form.mWhatFileDoINeedToAdd.Lines.Text) <> 0) then
  begin
    WriteLn(F, '<-- What files do I need to add? -->');
    for i := 0 to ZipComment_Form.mWhatFileDoINeedToAdd.Lines.Count - 1 do
      WriteLn(F, ZipComment_Form.mWhatFileDoINeedToAdd.Lines[i]);
    WriteLn(F, '');
  end;

  if (Length(ZipComment_Form.mWhatsThis.Lines.Text) <> 0) then
  begin
    WriteLn(F, '<-- What''s ', Title, ' ? -->');
    for i := 0 to ZipComment_Form.mWhatsThis.Lines.Count - 1 do
      WriteLn(F, ZipComment_Form.mWhatsThis.Lines[i]);
    WriteLn(F, '');
  end;

  if (Length(ZipComment_Form.mWhoMadeThis.Lines.Text) <> 0) then
  begin
    WriteLn(F, '<-- Who Made ', Title, ' ? -->');
    for i := 0 to ZipComment_Form.mWhoMadeThis.Lines.Count - 1 do
      WriteLn(F, ZipComment_Form.mWhoMadeThis.Lines[i]);
    WriteLn(F, '');
  end;

  if (Length(ZipComment_Form.mHowDoIPlayThis.Lines.Text) <> 0) then
  begin
    WriteLn(F, '<-- How Do I Play ', Title, ' ? -->');
    for i := 0 to ZipComment_Form.mHowDoIPlayThis.Lines.Count - 1 do
      WriteLn(F, ZipComment_Form.mHowDoIPlayThis.Lines[i]);
    WriteLn(F, '');
  end;

  if (Length(ZipComment_Form.mControls.Lines.Text) <> 0) then
  begin
    WriteLn(F, '<-- Controls: -->');
    for i := 0 to ZipComment_Form.mControls.Lines.Count - 1 do
      WriteLn(F, ZipComment_Form.mControls.Lines[i]);
  end;

  CloseFile(F);
  //Result := True;
end;

end.
