{
  SBI Builder v3.2

  Correction : Application LARGEMENT plus rapide
  Correction : Scramble est invisible lorsqu'il est executé (sert à rien mais bon...)
  Correction : Les champs du créateur de commentaires interne sont nettoyés à chaque création d'un SBI
  Correction : No screen coché par défaut
  Correction : Nouvelle bonus About Box...
  Correction : Splash screen désactivable
  Correction : Nouveaux graphiques + icônes...
  Correction : Quelques autres modifs...
  
  Ajout       : Le nom de l'application est déduit du nom du fichier binaire
}
{$WARN SYMBOL_PLATFORM OFF}
{$WARN UNIT_PLATFORM OFF}
unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ExtDlgs, Menus, FileCtrl, utils,
  ComCtrls, jpeg, IniFiles, XPMan, VirtualTrees, VirtualExplorerTree,
  JvBaseDlg, JvBrowseFolder, VirtualShellUtilities, TFlatHintUnit,
  VirtualNameSpace, VirtualPIDLTools, ShlObj, XPMenu, ImgList, AppEvnts,
  JvEdit, ShellApi, JvComponent, JvExStdCtrls, JvValidateEdit;

type
  TMain_Form = class(TForm)
    BIN_OpenDialog: TOpenDialog;
    Shape: TShape;
    Bevel1: TBevel;
    Label2: TLabel;
    MainDesc: TLabel;
    Bevel2: TBevel;
    About_Button: TButton;
    Cancel_Button: TButton;
    Add_OpenDialog: TOpenDialog;
    Add_PopupMenu: TPopupMenu;
    pmAddFolder2: TMenuItem;
    N1: TMenuItem;
    pmRefreshTree: TMenuItem;
    Root_PopupMenu: TPopupMenu;
    pmRefreshFile: TMenuItem;
    SaveDialog: TSaveDialog;
    Image1: TImage;
    StatusBar: TStatusBar;
    Bevel3: TBevel;
    Welcome: TLabel;
    Panel1: TPanel;
    Image: TImage;
    Info1: TLabel;
    Info2: TLabel;
    NoEnable: TButton;
    PScreen1: TButton;
    PScreen2: TButton;
    Start: TButton;
    NScreen1: TButton;
    NScreen2: TButton;
    Screen1: TPanel;
    STEP1: TLabel;
    BINInfo: TLabel;
    STEP1GroupBox: TGroupBox;
    BINWarning: TLabel;
    BINFile: TLabeledEdit;
    BIN_Button: TButton;
    Screen2: TPanel;
    STEP2: TLabel;
    STEP2Description: TLabel;
    STEP2GroupBox: TGroupBox;
    MustBeAPicture: TLabel;
    PictureFile: TEdit;
    ScreenShot_Button: TButton;
    XPManifest: TXPManifest;
    SelectDir: TJvBrowseForFolderDialog;
    pmShowExplorer: TMenuItem;
    N2: TMenuItem;
    pmAddFile: TMenuItem;
    FlatHint: TFlatHint;
    pmAddFolder1: TMenuItem;
    N3: TMenuItem;
    XPMenu: TXPMenu;
    ImageList: TImageList;
    ApplicationEvents: TApplicationEvents;
    gbPNGOptions: TGroupBox;
    NoScreen: TCheckBox;
    cbResizePNG: TCheckBox;
    laCross: TLabel;
    labWillBeTheNewSizeAfter: TLabel;
    gbBINOptions: TGroupBox;
    Unscramble: TCheckBox;
    ConfirmBIN: TCheckBox;
    ScreenR: TPanel;
    STEPR: TLabel;
    STEPRDescription: TLabel;
    STEPRGroupBox: TGroupBox;
    PleaseChooseReadMeFile: TLabel;
    ReadMeEdit: TEdit;
    ReadMeBrowseButton: TButton;
    STEPROptionsGroupBox: TGroupBox;
    cbStampReadMe: TCheckBox;
    PScreenR: TButton;
    NScreenR: TButton;
    PScreen3: TButton;
    NScreen3: TButton;
    ReadMe_OpenDialog: TOpenDialog;
    cbDontRenameTXT: TCheckBox;
    ScreenShot_OpenDialog: TOpenPictureDialog;
    lBINOptions: TLabel;
    Screen3: TPanel;
    STEP3: TLabel;
    STEP3Description: TLabel;
    DescriptionTitle: TGroupBox;
    Description: TMemo;
    ProgramTitle: TGroupBox;
    Title: TEdit;
    ProgramTypeTitle: TGroupBox;
    Add: TLabel;
    lbThere4Types: TLabel;
    ProgramType: TComboBox;
    PScreenC: TButton;
    NScreenC: TButton;
    ScreenC: TPanel;
    lZCStepPresentation: TLabel;
    Screen4: TPanel;
    STEP4: TLabel;
    AddProFilesInfos: TLabel;
    CurrentFolderLabel: TLabel;
    FileStructure: TGroupBox;
    SbiFiles: TVirtualExplorerListview;
    FolderStructure: TGroupBox;
    SbiStruct: TVirtualExplorerTreeview;
    Screen5: TPanel;
    STEP5: TLabel;
    STEP5Description: TLabel;
    pbProgress: TGroupBox;
    ProgressBar: TProgressBar;
    Screen6: TPanel;
    STEP6: TLabel;
    STEP6Description: TLabel;
    ViewLogFileBtn: TButton;
    lZCStepDescription: TLabel;
    gbZCReadMe: TGroupBox;
    lZCReadMeLoc: TLabel;
    eZCReadMeLoc: TEdit;
    bZCReadMeLoc: TButton;
    gbMakeYourChoice: TGroupBox;
    rbDontAddThisComment: TRadioButton;
    rbCreateNewComment: TRadioButton;
    rbUseExternalTextFile: TRadioButton;
    gbZCCreator: TGroupBox;
    bZCCreator: TButton;
    PScreen4: TButton;
    NScreen4: TButton;
    PScreen5: TButton;
    NScreen5: TButton;
    PScreen6: TButton;
    NScreen6: TButton;
    gbStep5Options: TGroupBox;
    cbMacDreamTool: TCheckBox;
    Newdir1: TMenuItem;
    ViewFolder1: TMenuItem;
    NewFolder1: TMenuItem;
    eWidth: TJvValidateEdit;
    eHeight: TJvValidateEdit;
    bConfig: TButton;
    lInfos3: TLabel;
    procedure BIN_ButtonClick(Sender: TObject);
    procedure ScreenShot_ButtonClick(Sender: TObject);
    procedure Cancel_ButtonClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure NScreen5Click(Sender: TObject);
    procedure About_ButtonClick(Sender: TObject);
    procedure AddClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure StartClick(Sender: TObject);
    procedure PScreen1Click(Sender: TObject);
    procedure NScreen1Click(Sender: TObject);
    procedure PScreen2Click(Sender: TObject);
    procedure NScreen2Click(Sender: TObject);
    procedure PScreen3Click(Sender: TObject);
    procedure NScreen3Click(Sender: TObject);
    procedure PScreen4Click(Sender: TObject);
    procedure PScreen5Click(Sender: TObject);
    procedure NScreen4Click(Sender: TObject);
    procedure NScreen6Click(Sender: TObject);
    procedure NoScreenClick(Sender: TObject);
    procedure PScreen6Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure pmRefreshTreeClick(Sender: TObject);
    procedure pmAddFolder2Click(Sender: TObject);
    procedure pmShowExplorerClick(Sender: TObject);
    procedure pmAddFileClick(Sender: TObject);
    procedure SbiStructChange(Sender: TBaseVirtualTree;
      Node: PVirtualNode);
    procedure SbiStructMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure StatusBarDblClick(Sender: TObject);
    procedure pmAddFolder1Click(Sender: TObject);
    procedure UnscrambleClick(Sender: TObject);
    procedure ApplicationEventsException(Sender: TObject; E: Exception);
    procedure cbResizePNGClick(Sender: TObject);
    procedure NScreenRClick(Sender: TObject);
    procedure PScreenRClick(Sender: TObject);
    procedure ReadMeBrowseButtonClick(Sender: TObject);
    procedure ViewLogFileBtnClick(Sender: TObject);
    procedure NScreenCClick(Sender: TObject);
    procedure PScreenCClick(Sender: TObject);
    procedure rbCreateNewCommentClick(Sender: TObject);
    procedure rbDontAddThisCommentClick(Sender: TObject);
    procedure rbUseExternalTextFileClick(Sender: TObject);
    procedure bZCCreatorClick(Sender: TObject);
    procedure bZCReadMeLocClick(Sender: TObject);
    procedure Cancel_ButtonKeyPress(Sender: TObject; var Key: Char);
    procedure BINFileChange(Sender: TObject);
    procedure Newdir1Click(Sender: TObject);
    procedure ViewFolder1Click(Sender: TObject);
    procedure NewFolder1Click(Sender: TObject);
    procedure bConfigClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Main_Form: TMain_Form;
  ChooseLang : boolean = True;
  Ini : TIniFile;
  InducerDir : string = '';

implementation

uses about, lang, SHFileOp, logwin, zipcomm, app_comm, u_zipcom, u_ask,
  config;

{$R *.dfm}
{$R zip.RES}
{$R noscreen.RES}
{$R scramble.RES}
{$R stamp.RES}
{$R sbipack_icon.RES}

procedure TMain_Form.BIN_ButtonClick(Sender: TObject);
begin
  if BIN_OpenDialog.Execute = True then BINFile.Text := BIN_OpenDialog.FileName;
end;

procedure TMain_Form.ScreenShot_ButtonClick(Sender: TObject);
begin
  if ScreenShot_OpenDialog.Execute = True then PictureFile.Text := ScreenShot_OpenDialog.FileName; 
end;

procedure TMain_Form.Cancel_ButtonClick(Sender: TObject);
begin
  Main_Form.Close;
end;

procedure TMain_Form.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then Close;
end;

procedure TMain_Form.NScreen5Click(Sender: TObject);
begin
  PScreen5.Enabled := False;
  NScreen5.Enabled := False;
  Main_Form.SaveDialog.FileName := LowerCase(Gauche('.', ExtractFileName(BINFile.Text)) + '.sbi'); //Eviter les 1ST_READ.sbi
  if CheckParam = False then Exit;
  CreateSBI;
  NScreen5.Enabled := True;
  PScreen5.Enabled := True;
end;

procedure TMain_Form.About_ButtonClick(Sender: TObject);
begin
  AboutBox := TAboutBox.Create(Application);
  try
    AboutBox.ShowModal;
  finally
    AboutBox.Free;
  end;
end;

procedure TMain_Form.AddClick(Sender: TObject);
begin
  //AddType_Form.ShowModal;
end;

procedure TMain_Form.FormCreate(Sender: TObject);
var
  i : integer;

begin
  //on remet comme ça doit être à l'execution
  Self.Width := 630;
  Self.Height := 415;
  for i := 1 to 6 do
    with FindComponent('Screen' + IntToStr(i)) as TPanel do
    begin
      Left := 192;
      Top := 64;
      Color := clBtnFace; 
    end;
  with ScreenC do
  begin
    Left := 192;
    Top := 64;
    Color := clBtnFace;
  end;
  with ScreenR do
  begin
    Left := 192;
    Top := 64;
    Color := clBtnFace;
  end;
  //ok tout est bon

  //Titre de l'application
  Application.Title := Main_Form.Caption;

  //Mettre à jour les variables sur le dossier inducer.
  InducerDir := GetRealPath(GetTempDir + 'Inducer');

  //Empecher les panels de devenir transparent avec un XPManifest
  for i := 0 to ComponentCount - 1 do
    if Components[i] is TPanel then (Components[i] as TPanel).ParentBackground := False;

  //Charger les types
 { if FileExists(ExtractFilePath(Application.ExeName) + 'progtype.ini') = True then
    ProgramType.Items.LoadFromFile(ExtractFilePath(Application.ExeName) + 'progtype.ini'); }

  //Ini : langue detection.
  Ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'config.ini');

  //Rechoisir la langue
  if ParamCount <> 0 then
  begin
    if LowerCase(ParamStr(1)) = '/chooselang' then
      Ini.WriteString('Config', 'LangID', '');
  end;
  
  //Changement v2.51
  InitInducerDirectory;

  //taLeftJustify
  //eHeight.Alignment := taLeftJustify;
  //eWidth.Alignment := taLeftJustify;

  NoScreen.Checked := True;
end;

procedure TMain_Form.FormClose(Sender: TObject; var Action: TCloseAction);
var
  Rep : integer;

begin
  if Status <> Ready then
  begin
    //Rep := MsgBox('Abort current operation ?', 'Warning', 48 + MB_OKCANCEL + MB_DEFBUTTON2);
    Rep := MsgBox(AbortOperation, Warning, 48 + MB_OKCANCEL + MB_DEFBUTTON2);
    if Rep = IDCANCEL then
    begin
      Action := caNone;
      Exit;
    end;
  end;

  //Destruction de l'ancien dossier Inducer et des progs.
  CleanAllTempFiles;
  Application.Terminate;
  Halt(0);
end;

procedure TMain_Form.StartClick(Sender: TObject);
begin
  Screen1.Visible := True;
  PScreen1.Visible := True;
  NScreen1.Visible := True;
end;

procedure TMain_Form.PScreen1Click(Sender: TObject);
begin
  Screen1.Visible := False;
  PScreen1.Visible := False;
  NScreen1.Visible := False;
end;

procedure TMain_Form.NScreen1Click(Sender: TObject);
begin
  if BINFile.Text = '' then
  begin
    //MsgBox('You must specify a BIN File.', 'Error', 48);
    MsgBox(MustSpecifyProgram, Error, 48);
    Exit;
  end;

  if FileExists(BINFile.Text) = False then
  begin
    //MsgBox('BIN File "' + BINFile.Text + '" wasn''t found.', 'Error', 48);
    MsgBox(ProgramFileNotFound + ' ' + BINFile.Text, Error, 48);
    Exit;
  end;

  //3.2 : remplissage champ du nom prog
  Title.Text := ChangeFileExt(ExtractFileName(BINFile.Text), '');

  //CopyBINFile; //Copy Real Time (on peut pas, parce que on doit savoir le type du prog).
  //On copie donc au STEP4.
  Screen2.Visible := True;
  PScreen2.Visible := True;
  NScreen2.Visible := True;
end;

procedure TMain_Form.PScreen2Click(Sender: TObject);
begin
  Screen2.Visible := False;
  PScreen2.Visible := False;
  NScreen2.Visible := False;
end;

procedure TMain_Form.NScreen2Click(Sender: TObject);
begin
  if NoScreen.Checked = False then
  begin
    if PictureFile.Text = '' then
    begin
      //MsgBox('You must specify a PNG File.', 'Error', 48);
      MsgBox(MustSpecifyPicture, Error, 48);
      Exit;
    end;

    if FileExists(PictureFile.Text) = False then
    begin
      //MsgBox('PNG File "' + PNGFile.Text + '" wasn''t found.', 'Error', 48);
      MsgBox(PictureFileNotFound + ' ' + PictureFile.Text, Error, 48);
      Exit;
    end;
  end;

  //Copier le PNG maintenant
  Main_Form.NScreen2.Enabled := False;
  Main_Form.PScreen2.Enabled := False;
  CopyPNGFile;
  Main_Form.NScreen2.Enabled := True;
  Main_Form.PScreen2.Enabled := True;
  
  ScreenR.Visible := True;
  PScreenR.Visible := True;
  NScreenR.Visible := True;
end;

procedure TMain_Form.PScreen3Click(Sender: TObject);
begin
  Screen3.Visible := False;
  PScreen3.Visible := False;
  NScreen3.Visible := False;
end;

procedure TMain_Form.NScreen3Click(Sender: TObject);
begin
  if Main_Form.Title.Text = '' then
  begin
    //MsgBox('You must enter a program name.', 'Fatal Error', 48);
    MsgBox(MustEnterProgramName, Error, 48);
    Exit;
  end;

  if Main_Form.ProgramType.Text = '' then
  begin
    //MsgBox('You must enter a Program Type.', 'Fatal Error', 48);
    MsgBox(MustEnterProgramType, Error, 48);
    Exit;
  end;

  //Nouveauté de la version v3.0 : On efface d'abord toutes les dossiers
  //APPS, DEMOS, EMUS et GAMES, parce que si l'user fait précédent au step 4
  //Il y'aura plusieurs dossier différent (APPS, DEMOS... etc) avec le meme
  //Binaire dedant!
  //Théoriquement le SBI est créé un à la fois donc on peut le faire sans crainte
  //et puis ce ne sont que des copies...
  DeleteDir(GetRealPath(InducerDir) + 'Apps');
  DeleteDir(GetRealPath(InducerDir) + 'Demos');
  DeleteDir(GetRealPath(InducerDir) + 'Emus');
  DeleteDir(GetRealPath(InducerDir) + 'Games');
  //On efface pas InducerDir parce que y'a l'image copiée dedant !

  //Créer le DXL maintenant
  Main_Form.NScreen3.Enabled := False;
  Main_Form.PScreen3.Enabled := False;
  CopyBINFile; //Copie Real Time | (décalé... dans STEP1 now.) -> NON
  //On peut pas copier dans STEP1 car c'est à partir de STEP3 qu'on connait
  //le type du prog, donc au connaitra le dossier ou il se trouvera.
  CreateDXLFile;
  RefreshDirTree;
  Main_Form.NScreen3.Enabled := True;
  Main_Form.PScreen3.Enabled := True;

  ScreenC.Visible := True;
  PScreenC.Visible := True;
  NScreenC.Visible := True;
end;

procedure TMain_Form.PScreen4Click(Sender: TObject);
begin
  if GoBackConfirm = False then Exit;

  Screen4.Visible := False;
  PScreen4.Visible := False;
  NScreen4.Visible := False;
end;

procedure TMain_Form.PScreen5Click(Sender: TObject);
begin
  Screen5.Visible := False;
  PScreen5.Visible := False;
  NScreen5.Visible := False;
end;

procedure TMain_Form.NScreen4Click(Sender: TObject);
begin
  Screen5.Visible := True;
  PScreen5.Visible := True;
  NScreen5.Visible := True;
end;

procedure TMain_Form.NScreen6Click(Sender: TObject);
begin
  Close;
  //Halt(0);
end;

procedure TMain_Form.NoScreenClick(Sender: TObject);
begin
  if NoScreen.Checked = True then
  begin
    PictureFile.Enabled := False;
    PictureFile.Color := clBtnFace;
    ScreenShot_Button.Enabled := False;
    cbResizePNG.Enabled := False;
    DisactiveResize;
  end
  else
  begin
    PictureFile.Enabled := True;
    PictureFile.Color := clWindow;
    ScreenShot_Button.Enabled := True;
    cbResizePNG.Enabled := True;
    if cbResizePNG.Checked = True then ActiveResize;
  end;
end;

procedure TMain_Form.PScreen6Click(Sender: TObject);
begin
{  PScreen1.Visible := False;
  Screen1.Visible := False;
  NScreen1.Visible := False;
  PScreen2.Visible := False;
  Screen2.Visible := False;
  NScreen2.Visible := False;
  PScreen3.Visible := False;
  Screen3.Visible := False;
  NScreen3.Visible := False;
  PScreen4.Visible := False;
  Screen4.Visible := False;
  NScreen4.Visible := False;
  PScreen5.Visible := False;
  Screen5.Visible := False;
  NScreen5.Visible := False;
  PScreen6.Visible := False;
  Screen6.Visible := False;
  NScreen6.Visible := False;
  NScreenR.Visible := False;
  PScreenR.Visible := False;
  ScreenR.Visible := False; }

  //Changement v2.51
  InitInducerDirectory;
  
  RestartApp;  //Enlever tous les panels & boutons
  AddDebug('>>> RESTART...');
  AddDebug(Ready);
end;

procedure TMain_Form.FormActivate(Sender: TObject);
var
  LangID : string;
  
begin
  if ChooseLang = False then Exit;

  LangID := Ini.ReadString('Config', 'LangID', LangID);

  if LangID = 'English' then
  begin
    LoadEnglish;
    ChooseLang := False;
    Exit;
  end;

  if LangID <> '' then
  begin
    LoadLang(LangID);
    ChooseLang := False;
    Exit;
  end;

  if LangID = '' then
  begin

    if DirectoryExists(ExtractFilePath(Application.ExeName) + 'lang') = False then
    begin
      MsgBox('Directory "' + ExtractFilePath(Application.ExeName) + 'lang' + '" not found, so default language (english) will be used.', 'Fatal Error - Oh dear :-/ -- GOD WERE ARE YOU ??', 48);
      Ini.WriteString('Config', 'LangID', 'English');
      LoadEnglish;
      Exit;
    end;

    ScruteLangFile;

    //if FileExists(Ini.FileName) = False then
    //begin
    Lang_Form.ShowModal;
    ChooseLang := False;
    Exit;
    //end;
  end;

  if LangID <> '' then LoadLang(LangID);

  ChooseLang := False;
end;

procedure TMain_Form.pmRefreshTreeClick(Sender: TObject);
begin
  SbiStruct.RefreshTree;
  SbiFiles.Refresh;
  SbiFiles.RefreshTree;
end;

procedure TMain_Form.pmAddFolder2Click(Sender: TObject);
begin
  if SelectDir.Execute = True then
  begin
    SbiStruct.Active := False;
    SbiFiles.Active := False;
    if DirectoryExists(SelectDir.Directory) = False then Exit;

    SHCopyFiles(SelectDir.Directory, InducerDir, [oFOF_ALLOWUNDO], 'Copying');
    SbiStruct.RefreshTree;
    SbiFiles.RefreshTree;

    SbiStruct.Active := True;
    SbiFiles.Active := True;

    //pour selectionner la node apres traitement
    SbiFiles.BrowseTo(InducerDir, True, True, True, False);
  end;

end;

procedure TMain_Form.pmShowExplorerClick(Sender: TObject);
begin
  WinExec('explorer', SW_SHOWNORMAL);
end;

procedure TMain_Form.pmAddFileClick(Sender: TObject);
var
  Path : string;
  i : integer;

begin
  if Add_OpenDialog.Execute = True then
  begin
    Path := GetRealPath(CurrentFolderLabel.Caption);

    SbiStruct.Active := False;
    SbiFiles.Active := False;

    for i := 0 to Add_OpenDialog.Files.Count - 1 do
      //ShowMessage(Add_OpenDialog.Files.Strings[i] + ' - ' + Path);
      SHCopyFiles(Add_OpenDialog.Files.Strings[i], Path + ExtractFileName(Add_OpenDialog.Files.Strings[i]), [oFOF_ALLOWUNDO], 'Copying');

    SbiStruct.Active := True;
    SbiFiles.Active := True;

    //pour selectionner la node apres traitement
    SbiFiles.BrowseTo(Path, True, True, True, False);
  end;

end;

procedure TMain_Form.SbiStructChange(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
begin
  if SbiStruct.SelectedPath = '' then Exit;
  CurrentFolderLabel.Caption := SbiStruct.SelectedPath;
end;

procedure TMain_Form.SbiStructMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
{ var
  CurrentNode : PVirtualNode; }

begin
  { CurrentNode := SbiStruct.GetNodeAt(X, Y);
  if CurrentNode = nil then Exit; }
  //ShowMessage(IntToStr(CurrentNode.Index));
end;

procedure TMain_Form.StatusBarDblClick(Sender: TObject);
begin
  Log_Form.Show;
end;

procedure TMain_Form.pmAddFolder1Click(Sender: TObject);
var
  Path      : string;
{  NS        : TNamespace;
  FocusPIDL : PItemIDList; }

begin
  if SelectDir.Execute = True then
  begin
    { if SbiStruct.ValidateNamespace(SbiStruct.FocusedNode, NS) = True then
      FocusPIDL := PIDLMgr.CopyPIDL(NS.AbsolutePIDL);     }

    SbiStruct.Active := False;
    SbiFiles.Active := False;

    if DirectoryExists(SelectDir.Directory) = False then Exit;
    Path := GetRealPath(CurrentFolderLabel.Caption);
    
    SHCopyFiles(SelectDir.Directory, Path, [oFOF_ALLOWUNDO], 'Copying');
    SbiStruct.RefreshTree;
    SbiFiles.RefreshTree;

    SbiStruct.Active := True;
    SbiFiles.Active := True;

    //pour selectionner la node apres traitement
    SbiFiles.BrowseTo(Path, True, True, True, False);
  end;

end;

procedure TMain_Form.UnscrambleClick(Sender: TObject);
begin
  if Unscramble.Checked = False then
    ConfirmBIN.Enabled := False
  else ConfirmBIN.Enabled := True;
end;

procedure TMain_Form.ApplicationEventsException(Sender: TObject;
  E: Exception);
begin
  MsgBox('GENERAL ERROR : ' + E.Message + WrapStr + 'Sorry for this french message, my compiler''s french.' + WrapStr + 'Please restart SBI Builder. All data will be lost... :/', 'GENERAL ERROR', 16);
  AddDebug('GENERAL ERROR : ' + E.Message);
end;

procedure TMain_Form.cbResizePNGClick(Sender: TObject);
begin
  if cbResizePNG.Checked = True then
    ActiveResize
  else DisactiveResize;
end;

procedure TMain_Form.NScreenRClick(Sender: TObject);
begin
  if ReadMeEdit.Text <> '' then
  begin
    if FileExists(ReadMeEdit.Text) = False then
    begin
      MsgBox(ReadMeFileNotFound + WrapStr + ' "' + ReadMeEdit.Text + '".', Error, 48);
      Exit;
    end;

    //Copier le ReadMe maintenant
    Main_Form.NScreenR.Enabled := False;
    Main_Form.PScreenR.Enabled := False;
    CopyReadMeFile;
    Main_Form.NScreenR.Enabled := True;
    Main_Form.PScreenR.Enabled := True;
  end;

  if Main_Form.cbStampReadMe.Checked = True then
    CopyStamp;

  Screen3.Visible := True;
  PScreen3.Visible := True;
  NScreen3.Visible := True;
end;

procedure TMain_Form.PScreenRClick(Sender: TObject);
begin
  ScreenR.Visible := False;
  PScreenR.Visible := False;
  NScreenR.Visible := False;
end;

procedure TMain_Form.ReadMeBrowseButtonClick(Sender: TObject);
begin
  if ReadMe_OpenDialog.Execute = True then
    ReadMeEdit.Text := ReadMe_OpenDialog.FileName;
end;

procedure TMain_Form.ViewLogFileBtnClick(Sender: TObject);
begin
  Log_Form.Show;
end;

procedure TMain_Form.NScreenCClick(Sender: TObject);
var
  CanDo : integer;

begin
  if Main_Form.rbUseExternalTextFile.Checked = True then
  begin

    //Le fichier existe?
    if FileExists(Main_Form.eZCReadMeLoc.Text) = False then
    begin
      MsgBox(ReadMeFileNotFound + WrapStr + ' "' + eZCReadMeLoc.Text + '".', Error, 48);
      Exit;
    end;

    //Taille valide ?
    //SHOWMESSAGE(INTTOSTR(GetFileSize(Main_Form.eZCReadMeLoc.Text)));
    if GetFileSize(Main_Form.eZCReadMeLoc.Text) > 8192 then
    begin
      CanDo := MsgBox(WarningFileIsSuperiorThan8192Bytes + ' ' + TheFileWillBeTruncatedContinue, Error, 48 + MB_YESNO + MB_DEFBUTTON2);
      if CanDo = IDNO then Exit;
    end;

  end;

  if Main_Form.rbCreateNewComment.Checked = True then
  begin
    //Fichier existe ?
    if FileExists(GetZipCommentFile) = False then
    begin
      MsgBox(YouHaveNotCreatedASbiComment + WrapStr + PleaseCreateItOrSelectDontAddThisComment, Error, 48);
      Exit;
    end;

    //La taille est vérifiée à la création (donc si il fait restart il demande rien,
    //parce qu'il sait déjà que c'est pas la peine de demander).
  end;


  Screen4.Visible := True;
  PScreen4.Visible := True;
  NScreen4.Visible := True;
end;

procedure TMain_Form.PScreenCClick(Sender: TObject);
begin
  ScreenC.Visible := False;
  PScreenC.Visible := False;
  NScreenC.Visible := False;
end;

procedure TMain_Form.rbCreateNewCommentClick(Sender: TObject);
begin
  bZCReadMeLoc.Enabled := False;
  eZCReadMeLoc.Enabled := False;
  lZCReadMeLoc.Enabled := False;
  bZCCreator.Enabled := True;
  //lZCCreator.Enabled := True;
end;

procedure TMain_Form.rbDontAddThisCommentClick(Sender: TObject);
begin
  bZCReadMeLoc.Enabled := False;
  eZCReadMeLoc.Enabled := False;
  lZCReadMeLoc.Enabled := False;
  bZCCreator.Enabled := False;
  //lZCCreator.Enabled := False;
end;

procedure TMain_Form.rbUseExternalTextFileClick(Sender: TObject);
begin
  bZCReadMeLoc.Enabled := True;
  eZCReadMeLoc.Enabled := True;
  lZCReadMeLoc.Enabled := True;
  bZCCreator.Enabled := False;
  //lZCCreator.Enabled := False;
end;

procedure TMain_Form.bZCCreatorClick(Sender: TObject);
begin
  ZipComment_Form.ShowModal;
end;

procedure TMain_Form.bZCReadMeLocClick(Sender: TObject);
begin
  if ReadMe_OpenDialog.Execute = True then
    eZCReadMeLoc.Text := ReadMe_OpenDialog.FileName;
end;

procedure TMain_Form.Cancel_ButtonKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
  begin
    Key := #0;
    Close;
  end;
end;

procedure TMain_Form.BINFileChange(Sender: TObject);
var
  Ext : string;

begin
  Ext := UpperCase(ExtractFileExt(Main_Form.BINFile.Text));

  if Ext = '.ELF' then
  begin
    ConfirmBIN.Enabled := False;
    Unscramble.Enabled := False;
  end else begin
    ConfirmBIN.Enabled := True;
    Unscramble.Enabled := True;
  end;

end;

procedure TMain_Form.Newdir1Click(Sender: TObject);
var
  Dir, CurrPath : string;

begin
  Dir := ShowPrompt(NewFolder, EnterFolderName);

  if Length(Dir) <> 0 then
  begin
    CurrPath := GetRealPath(CurrentFolderLabel.Caption);
    Dir := GetRealPath(CurrPath + Dir);

    if not DirectoryExists(Dir) then
    begin

      if CreateDir(Dir) then
        AddDebug(FolderCreationOK)
      else begin
        AddDebug(FailedWhenCreatingTheDirectory);
        MsgBox(FailedWhenCreatingTheDirectory, Error, 48);
      end;

    end else AddDebug(FolderAlreadyExists);

    AddDebug(Ready);

    //pour selectionner la node apres traitement
    SbiFiles.BrowseTo(CurrPath, True, True, True, False);
  end;

  Main_Form.pmRefreshTree.Click;
end;

procedure TMain_Form.ViewFolder1Click(Sender: TObject);
var
  CurrPath : string;

begin
  CurrPath := GetRealPath(CurrentFolderLabel.Caption);
  ShellExecute(Handle, 'open', PChar(CurrPath), '', '', SW_SHOWNORMAL);
end;

procedure TMain_Form.NewFolder1Click(Sender: TObject);
var
  Dir, CurrPath : string;

begin
  Dir := ShowPrompt(NewFolder, EnterFolderName);

  if Length(Dir) <> 0 then
  begin
    CurrPath := InducerDir;
    Dir := GetRealPath(CurrPath + Dir);

    if not DirectoryExists(Dir) then
    begin

      if CreateDir(Dir) then
        AddDebug(FolderCreationOK)
      else begin
        AddDebug(FailedWhenCreatingTheDirectory);
        MsgBox(FailedWhenCreatingTheDirectory, Error, 48);
      end;

    end else AddDebug(FolderAlreadyExists);

    AddDebug(Ready);

    //pour selectionner la node apres traitement
    SbiFiles.BrowseTo(CurrPath, True, True, True, False);
  end;

  Main_Form.pmRefreshTree.Click;
end;

procedure TMain_Form.bConfigClick(Sender: TObject);
begin
  frmConfig := TfrmConfig.Create(Application);
  try
    if frmConfig.ShowModal = mrOK then frmConfig.SaveConfig;
  finally
    frmConfig.Free;
  end;
end;

end.
