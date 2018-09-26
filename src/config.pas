unit config;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, IniFiles;

type
  TfrmConfig = class(TForm)
    gbOptions: TGroupBox;
    cbSplash: TCheckBox;
    gbLangSel: TGroupBox;
    bRestart: TButton;
    Bevel1: TBevel;
    bOK: TButton;
    lHintLang: TLabel;
    bCancel: TButton;
    procedure FormShow(Sender: TObject);
    procedure bRestartClick(Sender: TObject);
  private
    { Déclarations privées }
    RestartAppToChangeLanguage : string;
    procedure LoadConfig;
    procedure LoadConfigBoxLanguage;
  public
    { Déclarations publiques }
    procedure SaveConfig;
  end;

var
  frmConfig: TfrmConfig;

function IsSplashScreenEnabled() : Boolean;

implementation

{$R *.dfm}

uses
  utils;

//------------------------------------------------------------------------------

function IsSplashScreenEnabled() : Boolean;
var
  ini : TIniFile;

begin
  Ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'config.ini');
  try
    Result := Ini.ReadBool('Config', 'ShowSplashScreen', True);
  finally
    Ini.Free;
  end;
end;

//------------------------------------------------------------------------------

{ TfrmConfig }

procedure TfrmConfig.LoadConfig;
//var
  //ini : TIniFile;

begin
  //Ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'config.ini');
  //try
    cbSplash.Checked := IsSplashScreenEnabled();
  {finally
    Ini.Free;
  end;} // prochaines options...
end;

//------------------------------------------------------------------------------

procedure TfrmConfig.LoadConfigBoxLanguage();
var
  LngFile : TIniFile;
  LangFileName : TFileName;

begin
  RestartAppToChangeLanguage := 'The application must be restarted. All changes''ll be lost. Continue ?';

  LangFileName := GetSelectedLanguageFile();
  if LangFileName = 'English' then Exit;

  LngFile := TIniFile.Create(LangFileName);
  try
    Self.Caption := LngFile.ReadString('Config', 'ConfigurationTitle', Self.Caption);
    bOK.Caption := LngFile.ReadString('Buttons', 'OK', bOK.Caption);
    bCancel.Caption := LngFile.ReadString('Buttons', 'Cancel', bCancel.Caption);

    gbOptions.Caption := ' ' + LngFile.ReadString('Config', 'Options', gbOptions.Caption) + ' : ';
    cbSplash.Caption := LngFile.ReadString('Config', 'ShowSplashScreenAtStartup', cbSplash.Caption);
    gbLangSel.Caption := ' ' + LngFile.ReadString('Config', 'LanguageSelection', gbLangSel.Caption) + ' : ';

    lHintLang.Caption := LngFile.ReadString('Config', 'IfYouWantToChangeTheLanguagePleaseClickOnThisButton', lHintLang.Caption);
    bRestart.Caption := LngFile.ReadString('Config', 'ChangeButton', bRestart.Caption);

    RestartAppToChangeLanguage := LngFile.ReadString('Config', 'RestartAppToChangeLanguage', RestartAppToChangeLanguage);
  finally
    LngFile.Free;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmConfig.SaveConfig;
var
  ini : TIniFile;

begin
  Ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'config.ini');
  try
    Ini.WriteBool('Config', 'ShowSplashScreen', cbSplash.Checked);
  finally
    Ini.Free;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmConfig.FormShow(Sender: TObject);
begin
  LoadConfig();
  LoadConfigBoxLanguage();
end;

//------------------------------------------------------------------------------

procedure TfrmConfig.bRestartClick(Sender: TObject);
var
  OK : Integer;

begin
  OK := MessageBoxA(Handle, PChar(RestartAppToChangeLanguage), PChar(Question), MB_ICONQUESTION + MB_YESNO);
  if OK = IDNO then Exit;

  SaveConfig;
  
  //CleanAllTempFiles;
  WinExec(PChar('"' + Application.ExeName + '" /chooselang'), SW_SHOWNORMAL);
  Application.Terminate;
  Halt(0);
end;

//------------------------------------------------------------------------------

end.
