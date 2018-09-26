{$WARN SYMBOL_PLATFORM OFF}
{$WARN UNIT_PLATFORM OFF}
unit utils;

interface

uses
  Windows, StdCtrls, SysUtils, Forms, FileCtrl, idGlobal, Dialogs, Classes, ShellApi,
  lang, IniFiles, Graphics, ExtCtrls, U_Interpolation_BiLineaire, PNGUtils, ImageType,
  imgconv;

const
  Attributs : integer = FaDirectory + faHidden + faSysFile;
  WrapStr : string = #13 + #10;

var
  LngFile : TIniFile;

  Ready, Warning, AbortOperation,
  AreYouSure, Question, PleaseSelectAItem,
  Error, EmptyList, MustSpecifyProgram, MustSpecifyPicture,
  ProgramFileNotFound, PictureFileNotFound, MustEnterProgramName,
  MustEnterProgramType, ChooseDirectory, CreationStarted,
  CheckingInducerDir, SCRAMBLEToolExtract, CopyingBINProgram,
  DescramblingBIN, CheckingAnothersFiles, AddingFilesInCDRoot,
  CheckingStructureFolder, CheckingFileCopy, AddingFiles,
  DXLStepCreation, ZIPToolExtract, ZippingFiles,
  SBICreationCompleted, SBICreationCompletedEnjoyIt, OhYeah,
  CopyingScreenShot, BINisUnscrambled, BINisScrambled,
  ConfirmBINDetection, Information, BinWillBeCopiedAsUnscrambled,
  BinWillBeCopiedAsScrambled, CopyingBINasScrambled,
  CopyingBINasUnscrambled, SBIRestarted,
  IfYouGoBackSBIFileDeletedContinue, ResizingPNG,
  ReadMeFileNotFound, CopyingReadMeFile, CopyingStampFile, InvalidImage,
  PleaseCreateItOrSelectDontAddThisComment,
  YouHaveNotCreatedASbiComment, DeleteAllFields, FileSuccessfullyCreated,
  TheFileWillBeTruncatedContinue, ErrorAllFieldsAreEmpty,
  WarningFileIsSuperiorThan8192Bytes,  AddingSbiComment,
  SbiCommentSuccessfullyAdded, ErrorWhenAddingSbiCommentContinue,
  WarningSbiCommentTextFileIsTooBigTruncateTheFileAt8KB,
  TruncateOfTheTextFileSuccessfullyCompleted,
  CheckingTextFileSize, ErrorCommentAlreadyExistsOnTheFile,
  MacDreamToolSupportEnabled, SuccessfullyAddedMacDreamToolSupport,
  ErrorWhenAddingMacDreamToolSupport, ELFFileDetectedConvertingItToUnscrambledBIN,
  ErrorWhenConvertingTheELFToTheBIN, NewFolder, EnterFolderName,
  FolderCreationOK, FailedWhenCreatingTheDirectory, FolderAlreadyExists : string;

  SSHandle : HWND;
  
//procedure ScanDir;
procedure CreateSBI;
function Gauche(substr: string; s: string): string;
function GetTempDir: string;
procedure DeleteDir(TheFolder : string);
function CheckParam : boolean;
procedure ScruteLangFile;
procedure LoadLang(LangID : string);
procedure LoadEnglish;
procedure GetPNGSize(const sFile: string; var wWidth, wHeight: Word);
function MsgBox(Message, Caption : string ; Flags : integer) : integer;
function Status : string;
function GetRealPath(Path : string) : string;
procedure Delay(Delai : Double);
procedure SetInducerDirIcon;
procedure CreateDXLFile;
procedure CopyBINFile;
procedure CopyPNGFile;
procedure AddDebug(Info : string);
procedure RefreshDirTree;
procedure InitDebugLog;
function IsFileScrambled(FileName : PChar) : boolean ; stdcall; external 'bincheck.dll';
function GoBackConfirm : boolean;
procedure ActiveResize;
procedure DisactiveResize;
procedure CopyReadMeFile;
procedure CopyStamp;
procedure InitInducerDirectory(GoBackConfirmCall : boolean = False);
procedure CleanAllTempFiles(CleanGeneratedZipComment : boolean = True);
procedure RestartApp;
function GetFileSize(FileName : string) : Int64;
function ElfToBin(Source, Target : PChar) : boolean ; stdcall; external 'elf2bin.dll';
function GetSelectedLanguageFile() : TFileName;

implementation

uses main, about, logwin, app_comm, u_zipcom, zipcomm, ask;

{-------------------------------< DEBUT DES PROCEDURES >-------------------------------------------------------------------------------------------------- }

{-------------------------------< PROCEDURE GetFileSize >------------------------------------------------------------------------------------------------- }

function GetFileSize(FileName : string) : Int64;
var
  F : File;

begin
  Result := 0;

  //Si le fichier est readonly on l'enleve.
  //Si il existe pas ou est utilisé on s'en va
  if FileExists(FileName) = False then Exit;
  RemoveReadOnly(FileName);
  if IsFileInUse(FileName) = True then Exit;

  //sinon tout va bien, on donne la taille
  AssignFile(F, FileName);
  Reset(F, 1);
  Result := FileSize(F);
  CloseFile(F);
end;

{-------------------------------< DEBUT DES PROCEDURES >-------------------------------------------------------------------------------------------------- }

procedure RestartApp;
begin
  Main_Form.PScreen1.Visible := False;
  Main_Form.NScreen1.Visible := False;
  Main_Form.Screen1.Visible := False;
  Main_Form.PScreen2.Visible := False;
  Main_Form.NScreen2.Visible := False;
  Main_Form.Screen2.Visible := False;
  Main_Form.PScreen3.Visible := False;
  Main_Form.NScreen3.Visible := False;
  Main_Form.Screen3.Visible := False;
  Main_Form.PScreen4.Visible := False;
  Main_Form.NScreen4.Visible := False;
  Main_Form.Screen4.Visible := False;
  Main_Form.PScreen5.Visible := False;
  Main_Form.NScreen5.Visible := False;
  Main_Form.Screen5.Visible := False;
  Main_Form.PScreen6.Visible := False;
  Main_Form.NScreen6.Visible := False;
  Main_Form.Screen6.Visible := False;
  Main_Form.PScreenR.Visible := False;
  Main_Form.NScreenR.Visible := False;
  Main_Form.ScreenR.Visible := False;
  Main_Form.PScreenC.Visible := False;
  Main_Form.NScreenC.Visible := False;
  Main_Form.ScreenC.Visible := False;
  Main_Form.ProgressBar.Position := 0;

  ZipComment_Form.mWhatFileDoINeedToAdd.Clear;
  ZipComment_Form.mWhatsThis.Clear;
  ZipComment_Form.mWhoMadeThis.Clear;
  ZipComment_Form.mHowDoIPlayThis.Clear;
  ZipComment_Form.mControls.Clear;
end;

{-------------------------------< PROCEDURE CleanAllTempFiles >-------------------------------------------------------------------------------------------------- }

procedure CleanAllTempFiles(CleanGeneratedZipComment : boolean = True);
begin
  if DirectoryExists(InducerDir) = True then DeleteDir(InducerDir);
  if FileExists(GetTempDir + 'zip.exe') = True then DeleteFile(GetTempDir + 'zip.exe');
  if FileExists(GetTempDir + 'screen.png') = True then DeleteFile(GetTempDir + 'screen.png');
  if FileExists(GetTempDir + 'scramble.exe') = True then DeleteFile(GetTempDir + 'scramble.exe');

  //Si on fait un GoBackConfirm on l'efface pas si il existe...
  if CleanGeneratedZipComment = True then
    if FileExists(GetZipCommentFile) = True then DeleteFile(GetZipCommentFile);

  //Ce fichier est le fichier converti qui fait 8,00Kb obligé !
  if FileExists(GetTempDir + '~sbicomm.tmp') = True then DeleteFile(GetTempDir + '~sbicomm.tmp');
end;

{-------------------------------< PROCEDURE InitInducerDirectory >-------------------------------------------------------------------------------------------------- }

procedure InitInducerDirectory(GoBackConfirmCall : boolean = False);
begin
  //Destruction de l'ancien dossier Inducer et des progs.
{ if DirectoryExists(InducerDir) = True then DeleteDir(InducerDir);
  if FileExists(GetTempDir + 'zip.exe') = True then DeleteFile(GetTempDir + 'zip.exe');
  if FileExists(GetTempDir + 'screen.png') = True then DeleteFile(GetTempDir + 'screen.png');
  if FileExists(GetTempDir + 'scramble.exe') = True then DeleteFile(GetTempDir + 'scramble.exe'); }
  if GoBackConfirmCall = True then
    CleanAllTempFiles(False)
  else CleanAllTempFiles;

  //Création du dossier Inducer
  ForceDirectories(InducerDir);

  //Pour l'icone du dossier Inducer
  SetInducerDirIcon;

  //Mettre les TreeView dans le dossier
  Main_Form.SbiStruct.RootFolderCustomPath := InducerDir;
  Main_Form.SbiFiles.RootFolderCustomPath := InducerDir;
end;

{-------------------------------< PROCEDURE MsgBox >--------------------------------------------------------------------------------------------------------- }

function MsgBox(Message, Caption : string ; Flags : integer) : integer;
begin
  Result := MessageBoxA(Main_Form.Handle, PChar(Message), PChar(Caption), Flags);
end;

{-------------------------------< PROCEDURE CheckListBox >------------------------------------------------------------------------------------------------------------------------------- }

{ function CheckListBox(ListBox : TListBox ; All : boolean) : boolean;
begin
  if ListBox.Items.Count = 0 then
  begin
    //MsgBox('Empty list, sorry :)', 'Error', 48);
    MsgBox(EmptyList, Error, 48);
    Result := False;
    Exit;
  end;

  if All = False then
  begin
    if ListBox.ItemIndex < 0 then
    begin
      MsgBox(PleaseSelectAItem, Error, 48);
      //MsgBox('Please select an item :)', 'Error', 48);
      Result := False;
      Exit;
    end;
  end;

  Result := True;
end;  }

{-------------------------------< PROCEDURE Status >------------------------------------------------------------------------------------------------------------------ }

function Status : string;
begin
  Result := Main_Form.StatusBar.Panels[1].Text;
end;

{-------------------------------< PROCEDURE ExecAndWait >------------------------------------------------------------------------------------------------------------------ }

function ExecAndWait(FileName : string ; Hide : Boolean = False) : boolean;
var
  StartInfo : TStartupInfo;
  ProcessInformation : TProcessInformation;
  
begin
  Result := True;
  ZeroMemory(@StartInfo, SizeOf(StartInfo)); // remplie de 0 StartInfo
  StartInfo.cb := SizeOf(StartInfo);

  if Hide then
  begin
    StartInfo.wShowWindow := SW_HIDE;
    StartInfo.dwFlags := STARTF_USESHOWWINDOW;
  end;
  
  if CreateProcess(nil, PChar(FileName), nil, nil, True, 0, nil, nil, StartInfo, ProcessInformation) then
  begin
    WaitForSingleObject(ProcessInformation.hProcess, INFINITE);// attend que l'application désignée par le handle ProcessInformation.hProcess soit terminée
    Application.ProcessMessages;
  end else Result := False;
end;

{-------------------------------< PROCEDURE Gauche >------------------------------------------------------------------------------------------------------------------ }

function Gauche(substr: string; s: string): string;
begin
  result:=copy(s, 1, pos(substr, s)-1);
end;

{-------------------------------< PROCEDURE Droite>------------------------------------------------------------------------------------------------------------------ }

function Droite(substr: string; s: string): string;
begin
  if pos(substr,s)=0 then result:='' else
    result:=copy(s, pos(substr, s)+length(substr), length(s)-pos(substr, s)+length(substr));
end;

{-------------------------------< PROCEDURE DroiteDroite >------------------------------------------------------------------------------------------------------------------ }

function DroiteDroite(substr: string; s: string): string;
begin
  Repeat
    S:=droite(substr,s);
  until pos(substr,s)=0;
  result:=S;
end;

{-------------------------------< PROCEDURE ScruteFichier >------------------------------------------------------------------------------------------------------------------ }

{ procedure ScruteFichier(Dossier : string ; Filtre : string ; Attributs : integer);
var
  FichierTrouve  : string;
  Resultat : integer; //, Size : Integer;
  SearchRec      : TSearchRec;

begin
  if Dossier[length(Dossier)] = '\' then Dossier := Copy(Dossier,1,length(Dossier)-1);

  Resultat := FindFirst(Dossier +'\' + filtre, Attributs, SearchRec);
  //Size := 0;

  while Resultat = 0 do
  begin
    Application.ProcessMessages; // rend la main à windows pour qu'il traite les autres applications (évite que l'application garde trop longtemps la main)
    if ((SearchRec.Attr and faDirectory) <= 0) then // On a trouvé un Fichier (et non un dossier)
    begin
      FichierTrouve := Dossier + '\' + SearchRec.Name;
      //Size := StrToInt(Main_Form.Size_LabeledEdit.Text) + StrToInt(FichierSize(FichierTrouve, False));
      //Showmessage(FichierTrouve + ' : ' + inttostr(size));
      //Main_Form.Size_LabeledEdit.Text := IntToStr(Size);
      Main_Form.FileFound_ListBox.Items.Add(Droite('\', Droite(Main_Form.Root_Edit.Text, FichierTrouve)));// j'ajoute le Dossier trouvé dans le Memo2
    end;
    Resultat:=FindNext(SearchRec);
  end;
  FindClose(SearchRec);// libération de la mémoire
end; }

{-------------------------------< PROCEDURE ScruteDossier >------------------------------------------------------------------------------------------------------------------ }

{ procedure ScruteDossier(Dossier:string;filtre:string;attributs:integer;recursif:boolean);
var
  DossierTrouve, Folder :string;
  Resultat:Integer;
  SearchRec:TSearchRec;

begin
  if Dossier[length(Dossier)]= '\' then Dossier := Copy(Dossier, 1, Length(Dossier)-1); // s'il y a un '\' à la fin, je le retire

  Folder := DroiteDroite(Main_Form.Root_Edit.Text + '\', Dossier);
  if Folder <> '' then Main_Form.FolderFound_ListBox.Items.Add(Folder);// j'ajoute le Dossier trouvé dans le Memo2

  ScruteFichier(Dossier, filtre, attributs); //pour trouver les fichiers du dossier
  if recursif then   // si on veut aller voir les sous dossiers
  begin
    Resultat := FindFirst(Dossier + '\' + '*.*', FaDirectory,SearchRec); //permet de trouver le premier sous dossier de Dossier
    while Resultat=0 do                                           // SearchRec contient tous les renseignements concernant le dossier trouvé
    begin
      if (SearchRec.Name<>'.') and (SearchRec.Name<>'..')
         and ((SearchRec.Attr and faDirectory)>0)then// C'est comme cela que je teste si on a trouvé un Dossier et non un fichier
      begin
        DossierTrouve:=Dossier+'\'+SearchRec.Name; // pour avoir le nom du dossier avec le chemin complet
        // attention, souvent un memo est trop petit pour contenir tous les fichiers d'un disque dur !
        // si vous avez Delphi3 choisisez un TRichEdit vous serez moins limité
        if recursif then ScruteDossier(DossierTrouve,filtre,attributs,recursif);// je relance la recherche mais cette fois à partir du dossier trouvé
        Application.ProcessMessages; // rend la main à windows pour qu'il traite les autres applications (évite que l'application garde trop longtemps la main
      end;
      Resultat:=FindNext(SearchRec); // permet de trouver les sous dosssiers suivants
    end;
  end;//fin de if récursif
  FindClose(SearchRec);// libération de la mémoire
end;  }

{-------------------------------< PROCEDURE ScanDir >------------------------------------------------------------------------------------------------------------------ }

{ procedure ScanDir;
var
  DossierChoisi  :String;
  DossierInitial :WideString;

begin
  Main_Form.FileFound_ListBox.Clear;
  Main_Form.FolderFound_ListBox.Clear;

  DossierInitial:='';
  //if SelectDirectory('Choose the directory', DossierInitial, DossierChoisi) = False then Exit;
  if SelectDirectory(ChooseDirectory, DossierInitial, DossierChoisi) = False then Exit;

  Main_Form.Root_Edit.Text := DossierChoisi;
  
  ScruteDossier(DossierChoisi, '*.*', Attributs, True);
  //FileNb_LabeledEdit.Text := IntToStr(FileFound_ListBox.Count);
  //NbDir_LabeledEdit.Text := IntToStr(FolderFound_ListBox.Count);
  //Scan_BitBtn.Enabled := True;
  //Next3_Button.Visible := True;
  //Prev3_Button.Enabled := True;
end; }

{----------------------------------< PROCEDURE GetTempDir >------------------------------------------------------- }

function GetTempDir: string;
var
  Dossier : array[0..MAX_PATH] of Char;

begin
  Result := '';
  if GetTempPath(SizeOf(Dossier), Dossier) <> 0 then Result := StrPas(Dossier);
  Result := GetRealPath(Result);
end;

{----------------------------------< PROCEDURE ReplaceStr >------------------------------------------------------- }

function ReplaceStr(s, OldSubStr, NewSubStr: string): string; 
var 
  i: integer; 
  OldSubLen, TotalLength: integer; 
begin 
  Result := ''; 
  if s <> '' then 
  begin 
    OldSubLen := Length(OldSubStr); // für die Performance - for performance 
    TotalLength := Length(s); 
    i := 1; 
    while i <= TotalLength do 
    begin 
      if (i <= TotalLength - OldSubLen) and (Copy(s, i, OldSubLen) = OldSubStr) then 
      begin 
        Result := Result + NewSubStr; 
        Inc(i, OldSubLen); 
      end 
      else 
      begin 
        Result := Result + s[i]; 
        Inc(i); 
      end; 
    end; 
  end; 
end; 

{-------------------------------< PROCEDURE ExtractFile >--------------------------------------------------------------------------------------------------------------------------------- }

procedure ExtractFile(Ressource : string ; Extension : string);
var
 StrNomFichier  : string;
 ResourceStream : TResourceStream;
 FichierStream  : TFileStream;

begin
  StrNomFichier := GetTempDir + Ressource + '.' + Extension;
  ResourceStream := TResourceStream.Create(hInstance, Ressource, RT_RCDATA);

  try
    FichierStream := TFileStream.Create(StrNomFichier, fmCreate);
    try
      FichierStream.CopyFrom(ResourceStream, 0);
    finally
      FichierStream.Free;
    end;
  finally
    ResourceStream.Free;
  end;
end;

{-------------------------------< PROCEDURE DeleteDir >--------------------------------------------------------------------------------------------------------------------------------- }

procedure DeleteDir(TheFolder : string);
var
  aResult : Integer;
  aSearchRec : TSearchRec;

begin
  if TheFolder = '' then Exit;
  if TheFolder[Length(TheFolder)] <> '\' then TheFolder := TheFolder + '\';
  aResult := FindFirst(TheFolder + '*.*', faAnyFile, aSearchRec);
  while aResult=0 do
  begin
    if ((aSearchRec.Attr and faDirectory)<=0) then
    begin
      try
        if (FileGetAttr(TheFolder+aSearchRec.Name) and faReadOnly) > 0 then FileSetAttr(TheFolder+aSearchRec.Name, FileGetAttr(TheFolder+aSearchRec.Name) xor faReadOnly);
        //if FileGetAttr(TheFolder) > 0 then FileSetAttr(TheFolder, faAnyFile);
        DeleteFile(TheFolder+aSearchRec.Name)
      except
      end;
    end
    else
    begin
      try
        if aSearchRec.Name[1]<>'.' then   // pas le repertoire '.' et '..'sinon on tourne en rond
        begin
          DeleteDir(TheFolder+aSearchRec.Name); // vide les sous-repertoires de facon recursive
          RemoveDir(TheFolder+aSearchRec.Name);
        end;
      except // exception silencieuse si ne peut détrure le fichier car il est en cours d'utilisation : sera détruit la fois prochaine....
      end;
    end;
    aResult:=FindNext(aSearchRec);
  end;
  FindClose(aSearchRec); // libération de aSearchRec
  if DirectoryExists(TheFolder) = True then RemoveDir(TheFolder);
end;

{--------------------------------------< FONCTION GETRIGHTPATH >--------------------------------------------------------------------------------- }

{function GetRealPath(Path : string) : string;
var
  Dir : string;

begin
  Dir := Path;
  if Path = '' then Exit;
  while Path[Length(Path)] = '\' do
  begin
    //MsgBox(0, 'Path : ' + Path, 'ERROR', 0);
    Path := Copy(Path, 1, Length(Path) - 1);
  end;
  if Path = '' then
  begin
    Result := Dir;
    Exit;
  end;
  Result := Path + '\';
end; }

function GetRealPath(Path : string) : string;
var
  i : integer;
  LastCharWasSeparator : Boolean;

begin
  Result := '';
  LastCharWasSeparator := False;

  Path := Path + '\';

  for i := 1 to Length(Path) do
  begin
    if Path[i] = '\' then
    begin
      if not LastCharWasSeparator then
      begin
        Result := Result + Path[i];
        LastCharWasSeparator := True;
      end
    end
    else
    begin
       LastCharWasSeparator := False;
       Result := Result + Path[i];
    end;
  end;
end;

{-------------------------------< PROCEDURE GetPNGSize >--------------------------------------------------------------------------------------------------------------------------------- }

procedure GetPNGSize(const sFile: string; var wWidth, wHeight: Word);
type 
  TPNGSig = array[0..7] of Byte;

const 
  ValidSig: TPNGSig = (137,80,78,71,13,10,26,10);
   
var 
  Sig: TPNGSig; 
  f: tFileStream; 
  x: integer; 

{--< sous fonction ReadMWord >-- }

function ReadMWord(f: TFileStream): Word;
type 
  TMotorolaWord = record 
    case Byte of 
      0: (Value: Word); 
      1: (Byte1, Byte2: Byte); 
  end;

var 
  MW: TMotorolaWord;
   
begin 
  { It would probably be better to just read these two bytes in normally } 
  { and then do a small ASM routine to swap them.  But we aren't talking } 
  { about reading entire files, so I doubt the performance gain would be } 
  { worth the trouble. } 
  f.read(MW.Byte2, SizeOf(Byte)); 
  f.read(MW.Byte1, SizeOf(Byte)); 
  Result := MW.Value; 
end;

begin
  FillChar(Sig, SizeOf(Sig), #0); 
  f := TFileStream.Create(sFile, fmOpenRead); 
  try 
    f.read(Sig[0], SizeOf(Sig)); 
    for x := Low(Sig) to High(Sig) do 
      if Sig[x] <> ValidSig[x] then Exit; 
    f.Seek(18, 0); 
    wWidth := ReadMWord(f); 
    f.Seek(22, 0); 
    wHeight := ReadMWord(f); 
  finally 
    f.Free; 
  end; 
end;

{-------------------------------< PROCEDURE CheckParam >--------------------------------------------------------------------------------------------------------------------------------- }

function CheckParam : boolean;
begin
  if FileExists(Main_Form.BINFile.Text) = False then
  begin
    //MsgBox('BIN File "' + Main_Form.BINFile.Text + '" wasn''t found.', 'Fatal Error', 48);
    MsgBox(ProgramFileNotFound + ' ' + Main_Form.BINFile.Text, Error, 48);
    Result := False;
    Exit;
  end;

  if Main_Form.NoScreen.Checked = False then
  begin
    if FileExists(Main_Form.PictureFile.Text) = False then
    begin
      MsgBox(PictureFileNotFound + ' ' + Main_Form.PictureFile.Text, Error, 48);
      //MsgBox('PNG File "' + Main_Form.PNGFile.Text + '" wasn''t found.', 'Fatal Error', 48);
      Result := False;
      Exit;
    end;
  end;

  if Main_Form.Title.Text = '' then
  begin
    //MsgBox('You must enter a program name.', 'Fatal Error', 48);
    MsgBox(MustEnterProgramName, Error, 48);
    Result := False;
    Exit;
  end;

  if Main_Form.ProgramType.Text = '' then
  begin
    //MsgBox('You must enter a Program Type.', 'Fatal Error', 48);
    MsgBox(MustEnterProgramType, Error, 48);
    Result := False;
    Exit;
  end;

 { if Main_Form.Description.Text = '' then
  begin
    MsgBox('You must enter a description.', 'Fatal Error', 48);
    Result := False;
    Exit;
  end; }

  Result := True;
end;

{-------------------------------< PROCEDURE Delay >--------------------------------------------------------------------------------------------------------------------------------- }

procedure Delay(Delai : Double);
Var
  HeureDepart:TDateTime;

begin
  HeureDepart:=now;
  Delai:=delai/24/60/60/1000; //transforme les millisecondes en fractions de jours
  repeat
    Application.ProcessMessages; // rend la main à Windows pour ne pas blocquer les autres applications
  Until Now>HeureDepart+Delai;
end;

{-------------------------------< PROCEDURE AddDebug >--------------------------------------------------------------------------------------------------------------------------------- }

procedure AddDebug(Info : string);
begin
  //if FindWindow('TMain_Form', nil) = 0 then Exit;
  Main_Form.StatusBar.Panels[1].Text := Info;
  Log_Form.lbDebug.Items.Add(DateToStr(Date) + ' - ' + TimeToStr(Time) + ' | ' + Info);
  Log_Form.lbDebug.ItemIndex := Log_Form.lbDebug.Items.Count - 1;
  Delay(25);
end;

{-------------------------------< PROCEDURE AddDebug >--------------------------------------------------------------------------------------------------------------------------------- }

procedure InitDebugLog;
begin
  Log_Form.lbDebug.Items.Add(Main_Form.Caption + ' - *Debug Log*');
  Log_Form.lbDebug.Items.Add(' ');
end;

{-------------------------------< PROCEDURE RefreshDirTree >--------------------------------------------------------------------------------------------------------------------------------- }

procedure RefreshDirTree;
begin
  Main_Form.SbiFiles.RootFolderCustomPath := InducerDir;
  Main_Form.SbiStruct.RootFolderCustomPath := InducerDir;
  Main_Form.SbiStruct.RefreshTree;
  Main_Form.SbiFiles.Refresh;
end;

{-------------------------------< PROCEDURE CopyPNGFile >--------------------------------------------------------------------------------------------------------------------------------- }

procedure CopyPNGFile;
var
  PNGName, PNGDir,
  BinName, PNGFileInducer : string;

//---ReSizePNG-------------------------
procedure ReSizePNGIfNeeded(SourcePNG, DestPNG : string ; Width : integer = 300 ; Height : integer = 200);
var
  wWidth, wHeight : word;
  pngWidth, pngHeight : string;
  
begin
  GetPNGSize(SourcePNG, wWidth, wHeight);
  pngWidth := IntToStr(wWidth);
  pngHeight := IntToStr(wHeight);

  if (pngWidth <> '300') or (pngHeight <> '200') then
  begin
    PNGFileToBitmap(SourcePNG, GetTempDir + 'temp.bmp');
    ReSizeBMP(GetTempDir + 'temp.bmp', Width, Height);
    if FileExists(DestPNG) = True then
      DeleteFile(DestPNG);
    BitmapFileToPNG(GetTempDir + 'temp.bmp', DestPNG);
    DeleteFile(GetTempDir + 'temp.bmp');
  end;
end;

//----Main Proc-----  
begin
  AddDebug(CheckingInducerDir);
  
  PNGDir := InducerDir + 'Images\';
  BinName := LowerCase(ExtractFileName(Main_Form.BINFile.Text));
  PNGName := Gauche('.', BinName) + '.png'; //Creation du nom du fichier PNG à partir du BIN
  PNGFileInducer := PngDir + PNGName; //Nom final du PNG + Location.
  //En minuscule pour éviter les 1ST_READ.png...

  //ShowMessage(PngDir + PngName);

  //Effacer le PNG si il existe
  if FileExists(PNGFileInducer) = True then DeleteFile(PNGFileInducer);

  //On refait le dossier PNG.
  if DirectoryExists(PNGDir) then DeleteDir(PNGDir);
  ForceDirectories(PNGDir);

  //Si y'a un screen on copie normalement
  AddDebug(CopyingScreenShot);
  if Main_Form.NoScreen.Checked = False then
  begin
    if FileExists(PngDir + PngName) = False then
      CopyFileTo(Main_Form.PictureFile.Text, PngDir + PngName); //Copie banale
  end else begin
    //Sinon, bah on copie le screen qui est dans le dossier de SBI Builder
    if FileExists(ExtractFilePath(Application.ExeName) + 'noscreen.png') = True then
    begin
      if FileExists(PngDir + PngName) = False then
        CopyFileTo(ExtractFilePath(Application.ExeName) + 'noscreen.png', PngDir + 'noscreen.png');
      PNGName := 'noscreen.png';
    end else begin
      //Ou alors on extrait celui contenu dans le EXE si aucun trouvé
      ExtractFile('screen', 'png');
      if FileExists(PngDir + PngName) = False then
        CopyFileTo(GetTempDir + 'screen.png', PngDir + 'noscreen.png');
      DeleteFile(GetTempDir + 'screen.png');
      PNGName := 'noscreen.png';
    end;
  end;

  //Convertir pour avoir un vrai PNG!
  //Bah oui le fichier image est renommé en PNG quoiqu'il soit.
  case GetImageType(PngDir + PNGName) of //Cette fct detecte le type en lisant dans le fichier.
    I_Jpeg   : JpgToPng(PngDir + PNGName, PngDir + PNGName); //ShowMessage('JPEG');
    I_BMP    : BitmapFileToPNG(PngDir + PNGName, PngDir + PNGName);    //ShowMessage('BMP');
    I_GIF    : GifToPng(PngDir + PNGName, PngDir + PNGName); //ShowMessage('GIF');
    //I_PNG    : ShowMessage('PNG');  On fait rien.
    I_Unknow : begin
                 MsgBox(InvalidImage, Error, 48);
                 AddDebug(Ready);
                 Exit;
               end; //On se casse
  end;

  //Si l'user le demande on peut le resize
  if Main_Form.cbResizePNG.Enabled = True then //si no screen est coché, pas le faire.
    if Main_Form.cbResizePNG.Checked = True then
    begin
      AddDebug(ResizingPNG);
      ReSizePNGIfNeeded(PngDir + PNGName, PngDir + PNGName, Main_Form.eWidth.Value, Main_Form.eHeight.Value);
    end;

  AddDebug(Ready);
end;

{-------------------------------< PROCEDURE CopyBINFile >--------------------------------------------------------------------------------------------------------------------------------- }

procedure CopyBINFile;
label
  ExitProcedure;

var
  BinDir, BinName,
  BinFileInducer   : string;
  Rep              : integer;

//----Procédure pour copier en Scrambled----
procedure CopyBINasScrambled;
begin
  //Extraction du SCRAMBLE.EXE
  AddDebug(SCRAMBLEToolExtract);
  ExtractFile('Scramble', 'exe');

  //Copie du BIN dans le dossier Temp
  CopyFileTo(Main_Form.BINFile.Text, GetTempDir + BinName);

  //Action descrambling, executer et attendre la fin de SCRAMBLE
  AddDebug(DescramblingBIN);
  SetCurrentDir(GetTempDir);
  ExecAndWait('SCRAMBLE.exe -d ' + BINName + ' ' + BinDir + BinName, True);

  //Effacer le fichier BIN temporaire
  DeleteFile(GetTempDir + BinName);
  SetCurrentDir(ExtractFilePath(Application.ExeName));
end;

//----Procédure pour copier en Unscrambled----
procedure CopyBINasUnscrambled;
begin
  CopyFileTo(Main_Form.BINFile.Text, BinDir + BinName);
end;

//----Procédure Principale----
begin
  Main_Form.NScreen1.Enabled := False;
  Main_Form.PScreen1.Enabled := False;

  BinName := LowerCase(ExtractFileName(ChangeFileExt(Main_Form.BINFile.Text, '.bin'))); //Le nom du BIN
  BinDir := InducerDir + Main_Form.ProgramType.Text + '\';
  BinFileInducer := BinDir + BinName; //Tout en minuscule, histoire
  //d'éviter des 1ST_READ.bin...

  //Effacer le BIN si il existe
  AddDebug(CheckingInducerDir);
  if FileExists(BinFileInducer) = True then DeleteFile(BinFileInducer);
  if DirectoryExists(BinDir) = False then
    ForceDirectories(BinDir);

  //***v3.1 : Conversion de ELF -> BIN.
  if UpperCase(ExtractFileExt(Main_Form.BINFile.Text)) = '.ELF' then
  begin
    AddDebug(ELFFileDetectedConvertingItToUnscrambledBIN);
    if not ElfToBin(PChar(Main_Form.BINFile.Text), PChar(BinFileInducer)) then
      AddDebug(ErrorWhenConvertingTheELFToTheBIN);
    Goto ExitProcedure;
  end;

  AddDebug(CopyingBINProgram);

  //IsFileScrambled
  if Main_Form.Unscramble.Checked = True then
  begin

    //Détecter la nature du BIN
    if IsFileScrambled(PChar(Main_Form.BINFile.Text)) = True then
    begin
      AddDebug(BINisScrambled);

      //Confirmer la détection
      if Main_Form.ConfirmBIN.Checked = True then
      begin
        Rep := MsgBox(ConfirmBINDetection + WrapStr + Main_Form.StatusBar.Panels[1].Text, Warning, MB_YESNO + 48 + MB_DEFBUTTON1);
        if Rep = IDNO then begin
          MsgBox(BinWillBeCopiedAsUnscrambled, Information, 64);
          AddDebug(CopyingBINasUnscrambled);
          CopyBINasUnscrambled;
          Goto ExitProcedure;
        end else begin
          MsgBox(BinWillBeCopiedAsScrambled, Information, 64);
          AddDebug(CopyingBINasScrambled);
        end;
      end;

      CopyBINasScrambled;
    end else begin
      //----IsFileScrambled ---- UNSCRAMBLED ------
      AddDebug(BINisUnscrambled);

      //Confirmer la détection
      if Main_Form.ConfirmBIN.Checked = True then
      begin
        Rep := MsgBox(ConfirmBINDetection + WrapStr + Main_Form.StatusBar.Panels[1].Text, Warning, MB_YESNO + 48 + MB_DEFBUTTON1);
        if Rep = IDNO then begin
          MsgBox(BinWillBeCopiedAsScrambled, Information, 64);
          AddDebug(CopyingBINasScrambled);
          CopyBINasScrambled;
          Goto ExitProcedure;
        end else begin
          MsgBox(BinWillBeCopiedAsUnscrambled, Information, 64);
          AddDebug(CopyingBINasUnscrambled);
        end;
      end;

      CopyBINasUnscrambled;
    end; //Fin du IF IsFileScrambled

  end else begin
    //Le bin est directement unscrambled.
    //CopyFileTo(Main_Form.BINFile.Text, BinDir + BinName);
    AddDebug(BINisUnscrambled);
    CopyBINasUnscrambled;
  end;

  //On se casse!
  ExitProcedure:
  AddDebug(Ready);
  Main_Form.NScreen1.Enabled := True;
  Main_Form.PScreen1.Enabled := True;
end;

{-------------------------------< PROCEDURE CreateDXLFile >--------------------------------------------------------------------------------------------------------------------------------- }

procedure CreateDXLFile;
var
  DXLFile               : TextFile;
  DXLName, BinName,
  TargetBIN, TargetPNG  : string;
  
begin
  BinName := ChangeFileExt(ExtractFileName(Main_Form.BINFile.Text), '.bin');
  DXLName := InducerDir + Main_Form.ProgramType.Text + '\' + LowerCase(Gauche('.', BinName) + '.dxl'); //LowerCase histoire de pas avoir 1ST_READ.dxl...
  TargetBIN := Main_Form.ProgramType.Text + '/' + BinName;

  //Effacer le DXL si il existe
  AddDebug(CheckingInducerDir);
  if FileExists(DXLName) = True then DeleteFile(DXLName);
  if DirectoryExists(ExtractFilePath(DXLName)) = False then
    ForceDirectories(ExtractFilePath(DXLName));
    
  //Renomme TargetPNG, on retien le nouveau nom si la case est cochée
  if Main_Form.NoScreen.Checked = True then
    TargetPNG := 'noscreen.png'
  else TargetPNG := Gauche('.', BinName) + '.png';;

  //Création du fichier et on le remplit
  AddDebug(DXLStepCreation);
  AssignFile(DXLFile, DXLName);
  ReWrite(DXLFile);
  WriteLn(DXLFile, '  <ITEM');
  WriteLn(DXLFile, '    TITLE="' + Main_Form.Title.Text + '"');
  WriteLn(DXLFile, '    DESCRIPTION="' + ReplaceStr(Main_Form.Description.Text, #13 + #10, '#') + '"');
  WriteLn(DXLFile, '    SCREENSHOT="/cd/Images/' + TargetPNG + '"');
  WriteLn(DXLFile, '    TARGET="/cd/' + TargetBIN + '"');
  WriteLn(DXLFile, '    PREROLL="/cd/Themes/Loading.dxi"/>');
  CloseFile(DXLFile);
  AddDebug(Ready);
end;

{-------------------------------< PROCEDURE CreateSBI >--------------------------------------------------------------------------------------------------------------------------------- }

//---StepIt-----
procedure StepIt;
begin
  Main_Form.ProgressBar.Position := Main_Form.ProgressBar.Position + 1;
end;

procedure CreateSBI;
var
  //SrcFile, SrcPath,
  BinName, BinDir,
  SBIName,
  ZipLineCmd,
  ReadMeDir,
  ReadMeFile : string;

  ZipRes : boolean;
  //i : integer;

begin
  if Main_Form.SaveDialog.Execute = True then
  begin
    //Création démarrée
    AddDebug(CreationStarted);
    ZipRes := False;
    StepIt;

    //Définition des variables.
    //Les LowerCase sont la pour éviter d'avoir des 1ST_READ.sbi 
    SBIName := LowerCase(Main_Form.SaveDialog.FileName);   //Le nom du SBI final
    BinName := LowerCase(ExtractFileName(Main_Form.BINFile.Text));
    BinDir := InducerDir + Main_Form.ProgramType.Text + '\';
    StepIt;

    //ShowMessage('DXLName : ' + DXLName + ' | SBIName : ' + SBIName + ' | BinDir : ' + BinDir + ' | BinName : ' + BinName);

    //Destruction de l'ancien dossier Inducer et des progs. | MAJ : Bah non! Tout ce fait avant!
    //AddDebug(CheckingInducerDir);
    //if DirectoryExists(InducerDir) = True then DeleteDir(InducerDir);

    //Verification des fichiers extraits avant
    if FileExists(GetTempDir + 'zip.exe') = True then DeleteFile(GetTempDir + 'zip.exe');
    if FileExists(GetTempDir + 'screen.png') = True then DeleteFile(GetTempDir + 'screen.png');
    if FileExists(GetTempDir + 'scramble.exe') = True then DeleteFile(GetTempDir + 'scramble.exe'); 
    DeleteFile(GetTempDir + 'desktop.ini');
    StepIt;

    // ajouter les fichiers de Add_ListBox.
    //AddDebug('Checking anothers files...');
    AddDebug(CheckingAnothersFiles);
    StepIt;

    // creer la structure de dossier (si il y en a)
    //AddDebug('Checking structure folder...');
    AddDebug(CheckingStructureFolder);
    StepIt;

    // copier les fichier dans les dossiers crées.
    AddDebug(CheckingFileCopy);
    StepIt;

    //MacDreamTool Support (v3.1) :
    if Main_Form.cbMacDreamTool.Checked then
    begin

      //Uniquement si y'a un comment...
      if not Main_Form.rbDontAddThisComment.Checked then
      begin
        AddDebug(MacDreamToolSupportEnabled);

        ReadMeDir := GetRealPath(InducerDir + '\Readme');
        ReadMeFile := ChangeFileExt(BinName, '_comment.txt');
        if not DirectoryExists(ReadMeDir) then ForceDirectories(ReadMeDir);

        if Main_Form.rbCreateNewComment.Checked = True then
          ZipRes := CopyFileTo(GetZipCommentFile, ReadMeDir + ReadMeFile);

        if Main_Form.rbUseExternalTextFile.Checked = True then
          ZipRes := CopyFileTo(Main_Form.eZCReadMeLoc.Text, ReadMeDir + ReadMeFile);

        if ZipRes then
          AddDebug(SuccessfullyAddedMacDreamToolSupport)
        else AddDebug(ErrorWhenAddingMacDreamToolSupport);
      end;

    end;


    //Extraction de ZIP.EXE
    AddDebug(ZIPToolExtract);
    if FileExists(GetTempDir + 'zip.exe') = False then
      ExtractFile('ZIP', 'exe');
    StepIt;

    //Zippage des fichiers
    AddDebug(ZippingFiles);
    ZipLineCmd := 'ZIP.exe -r "' + SBIName + '" Inducer';
    SetCurrentDir(GetTempDir);
    ExecAndWait(ZipLineCmd);

    SetCurrentDir(ExtractFilePath(Application.ExeName));
    StepIt;
    //ShowMessage(ZipLineCmd);

    //Ajout du ZIP COMMENT
    if not Main_Form.rbDontAddThisComment.Checked then
    begin
      StepIt;
      AddDebug(AddingSbiComment);

      if Main_Form.rbCreateNewComment.Checked = True then
        ZipRes := AddZipComment(Main_Form.SaveDialog.FileName, GetZipCommentFile);

      if Main_Form.rbUseExternalTextFile.Checked = True then
        ZipRes := AddZipComment(Main_Form.SaveDialog.FileName, Main_Form.eZCReadMeLoc.Text);

      if ZipRes = True then
        AddDebug(SbiCommentSuccessfullyAdded)
      else AddDebug(ErrorWhenAddingSbiCommentContinue);
    end;

    //Terminé
    StepIt;
    AddDebug(SBICreationCompleted);

    Main_Form.ProgressBar.Position := Main_Form.ProgressBar.Max;
    MsgBox(SBICreationCompletedEnjoyIt, OhYeah, 64);
    AddDebug(Ready);

    //On voit la fin de la progression, quand même.
    Main_Form.Screen6.Visible := True;
    Main_Form.PScreen6.Visible := True;
    Main_Form.NScreen6.Visible := True;
  end;
end;

{-------------------------------< PROCEDURE ScruteLangFile >------------------------------------------------------------------------------------------------------------------ }

procedure ScruteLangFile;
var
  FichierTrouve, Dossier, Filtre, LangName : string;
  Resultat, Attributs : integer;
  SearchRec     : TSearchRec;

begin
  //Definition des variables...
  Dossier := ExtractFilePath(Application.ExeName) + 'lang';
  Attributs := faAnyFile;
  Filtre := '*.lng';

  if Dossier[length(Dossier)] = '\' then Dossier := Copy(Dossier,1,length(Dossier)-1);

  Resultat := FindFirst(Dossier + '\' + filtre, Attributs, SearchRec);
  //Size := 0;

  while Resultat = 0 do
  begin
    Application.ProcessMessages; // rend la main à windows pour qu'il traite les autres applications (évite que l'application garde trop longtemps la main)
    if ((SearchRec.Attr and faDirectory) <= 0) then // On a trouvé un Fichier (et non un dossier)
    begin
      FichierTrouve := Dossier + '\' + SearchRec.Name;
      //Size := StrToInt(Main_Form.Size_LabeledEdit.Text) + StrToInt(FichierSize(FichierTrouve, False));
      //Showmessage(FichierTrouve + ' : ' + inttostr(size));
      //Main_Form.Size_LabeledEdit.Text := IntToStr(Size);
      //Main_Form.FileFound_ListBox.Items.Add(Droite('\', Droite(Main_Form.Root_Edit.Text, FichierTrouve)));// j'ajoute le Dossier trouvé dans le Memo2
      //Lang_Form.Lang.Items.Add(Gauche('.', SearchRec.Name));

      //Ouvre le fichier
      LngFile := TIniFile.Create(FichierTrouve);

      //Ajoute le nom du fichier a la liste
      Lang_Form.LangFileName.Items.Add(SearchRec.Name);

      //Regarde le nom de la langue
      LangName := LngFile.ReadString('LANG', 'LangName', LangName);

      //Ajoute le nom de la langue
      Lang_Form.Lang.Items.Add(LangName);

      //Ferme le fichier et detruit la memoire alloué au fichier.
      LngFile.Free;
    end;
    Resultat:=FindNext(SearchRec);
  end;
  FindClose(SearchRec);// libération de la mémoire
end;

{-------------------------------< PROCEDURE GetSelectedLanguageFile >------------------------------------------------------------------------------------------------------------------ }

var _Selected_Language_ID : string = 'English';

function GetSelectedLanguageFile() : TFileName;
var
  LngDir : string;
  
begin
  Result := 'English';
  if _Selected_Language_ID = 'English' then Exit;
  LngDir := ExtractFilePath(Application.ExeName) + 'LANG\';
  Result := LngDir + _Selected_Language_ID;
end;

{-------------------------------< PROCEDURE LoadLang >------------------------------------------------------------------------------------------------------------------ }

procedure LoadLang(LangID : string);
var
  SetNew, NextCaption, PrevCaption : string;

begin
  _Selected_Language_ID := LangID;
  
  //Ouvrir le fichier voulu.
  LngFile := TIniFile.Create(GetSelectedLanguageFile());

  if FileExists(GetSelectedLanguageFile()) = False then
  begin
    _Selected_Language_ID := 'English';
    MsgBox('Damn! File "' + GetSelectedLanguageFile() + '" not found !' + WrapStr + 'So the default language (English of course) will be used.', 'OOPS!', 48);
    LoadEnglish;
    Ini.WriteString('Config', 'LangID', 'English');
    Exit;
  end;

  //C'est parti !

  {--------< BOUTONS >--------}
  SetNew := LngFile.ReadString('BUTTONS', 'About', '');
  Main_Form.About_Button.Caption := SetNew;
  SetNew := LngFile.ReadString('BUTTONS', 'Next', '');
  Main_Form.Start.Caption := SetNew;
  SetNew := LngFile.ReadString('Buttons', 'Previous', '');
  Main_Form.NoEnable.Caption := SetNew;
  SetNew := LngFile.ReadString('Buttons', 'Cancel', '');
  Main_Form.Cancel_Button.Caption := SetNew;
  Ask_Form.bCancel.Caption := SetNew;
  SetNew := LngFile.ReadString('Buttons', 'Restart', '');
  Main_Form.PScreen6.Caption := SetNew;
  SetNew := LngFile.ReadString('Buttons', 'Finish', '');
  Main_Form.NScreen6.Caption := SetNew;
  SetNew := LngFile.ReadString('Buttons', 'CreateSBI', '');
  Main_Form.NScreen5.Caption := SetNew;
  SetNew := LngFile.ReadString('Buttons', 'OK', '');
  Ask_Form.bOK.Caption := SetNew;

  { ---< MAIN FORM >--- }
  
  //Mettre plusieurs fois Next et Prev.
  NextCaption := Main_Form.Start.Caption;
  PrevCaption := Main_Form.NoEnable.Caption;

  //Previous
  Main_Form.PScreen1.Caption := PrevCaption;
  Main_Form.PScreen2.Caption := PrevCaption;
  Main_Form.PScreen3.Caption := PrevCaption;
  Main_Form.PScreen4.Caption := PrevCaption;
  Main_Form.PScreen5.Caption := PrevCaption;
  Main_Form.PScreenR.Caption := PrevCaption;
  Main_Form.PScreenC.Caption := PrevCaption;

  //Next
  Main_Form.NScreen1.Caption := NextCaption;
  Main_Form.NScreen2.Caption := NextCaption;
  Main_Form.NScreen3.Caption := NextCaption;
  Main_Form.NScreen4.Caption := NextCaption;
  Main_Form.NScreenR.Caption := NextCaption;
  Main_Form.NScreenC.Caption := NextCaption;

  //Descriptions
  SetNew := LngFile.ReadString('Description', 'MainDescription', '');
  Main_Form.MainDesc.Caption := SetNew;
  Main_Form.StatusBar.Panels[0].Text := LngFile.ReadString('Description', 'Status', '');
  Main_Form.StatusBar.Panels[1].Text := LngFile.ReadString('Events', 'Ready', 'Prêt');
  Main_Form.StatusBar.Hint := LngFile.ReadString('Hints', 'StatusBarDoubleClickHereForDisplayingTheDebugLog', '');

  //ETAPE 0 (Welcome)
  SetNew := LngFile.ReadString('Description', 'WelcomeToSbiBuilder', '');
  Main_Form.Welcome.Caption := SetNew;
  SetNew := LngFile.ReadString('Description', 'ThisProgramWillCreate', '');
  Main_Form.Info1.Caption := SetNew;
  SetNew := LngFile.ReadString('Description', 'ClickNextToContinue', '');
  Main_Form.Info2.Caption := SetNew;
  Main_Form.lInfos3.Caption := LngFile.ReadString('Description', 'IfYouWantToConfigureTheApplicationClickThisButton', Main_Form.lInfos3.Caption); 
  Main_Form.bConfig.Caption := LngFile.ReadString('Description', 'ConfigureButton', Main_Form.bConfig.Caption);

  //ETAPE 1 (BIN FILE)
  Main_Form.STEP1.Caption := LngFile.ReadString('STEP1', 'STEP1', '');
  Main_Form.STEP1GroupBox.Caption := LngFile.ReadString('STEP1', 'ProgramFileGroupBox', '');
  Main_Form.BINInfo.Caption := LngFile.ReadString('STEP1', 'Step1Description', '');
  Main_Form.BINWarning.Caption := LngFile.ReadString('STEP1', 'BINWarning', '');
  Main_Form.BINFile.EditLabel.Caption := LngFile.ReadString('STEP1', 'ProgramFile', '');
  Main_Form.Unscramble.Caption := LngFile.ReadString('STEP1', 'UnscrambleCheckBox', '');
  Main_Form.BIN_OpenDialog.Title := LngFile.ReadString('STEP1', 'BINOpenDialogTitle', '');
  Main_Form.BIN_OpenDialog.Filter := LngFile.ReadString('STEP1', 'BINFilter', '');
  Main_Form.gbBINOptions.Caption := LngFile.ReadString('Events', 'Options', '');
  Main_Form.ConfirmBIN.Caption := LngFile.ReadString('STEP1', 'ConfirmBINDetection', '');
  Main_Form.lBINOptions.Caption := LngFile.ReadString('STEP1', 'TheCopyAndTheCheckOfTheFileWillBeMadeAtStep4', '');

  //ETAPE 2 (PNG FILE)
  Main_Form.STEP2.Caption := LngFile.ReadString('STEP2', 'STEP2', '');
  Main_Form.STEP2Description.Caption := LngFile.ReadString('STEP2', 'STEP2Description', '');
  Main_Form.STEP2GroupBox.Caption := LngFile.ReadString('STEP2', 'STEP2GroupBox', '');
  Main_Form.NoScreen.Caption := LngFile.ReadString('STEP2', 'NoScreenshot', '');
  Main_Form.MustBeAPicture.Caption := LngFile.ReadString('STEP2', 'MustBeAPicture', '');
  Main_Form.ScreenShot_OpenDialog.Title := LngFile.ReadString('STEP2', 'ScreenShotOpenDialogTitle', '');
  Main_Form.ScreenShot_OpenDialog.Filter := LngFile.ReadString('STEP2', 'ScreenShotFilter', '');
  Main_Form.cbResizePNG.Caption := LngFile.ReadString('STEP2', 'ResizePNGIfNeeded', '');
  Main_Form.labWillBeTheNewSizeAfter.Caption := LngFile.ReadString('STEP2', 'WillBeTheNewSizeAfterResize', '');
  Main_Form.gbPNGOptions.Caption := LngFile.ReadString('Events', 'Options', '');
  
  //ETAPE 3 (README & STAMP)
  Main_Form.STEPR.Caption := LngFile.ReadString('STEP3', 'STEP3', '');
  Main_Form.STEPRDescription.Caption := LngFile.ReadString('STEP3', 'STEP3Description', '');
  Main_Form.STEPRGroupBox.Caption := LngFile.ReadString('STEP3', 'STEP3GroupBox', '');
  Main_Form.PleaseChooseReadMeFile.Caption := LngFile.ReadString('STEP3', 'PleaseChooseReadMeFile', '');
  Main_Form.cbStampReadMe.Caption := LngFile.ReadString('STEP3', 'IncludeTheSBIBuilderStampInTheSBIFile', '');
  Main_Form.STEPROptionsGroupBox.Caption := LngFile.ReadString('Events', 'Options', '');
  Main_Form.cbDontRenameTXT.Caption  := LngFile.ReadString('STEP3', 'DontRenameTheReadmeFileAsTheBIN', '');
  Main_Form.ReadMe_OpenDialog.Title := LngFile.ReadString('STEP3', 'PleaseChooseReadMeFile', '');
  Main_Form.ReadMe_OpenDialog.Filter := LngFile.ReadString('STEP3', 'ReadMeOpenDialogFilter', '');

  //ETAPE 4 (NOM & DESCRIPTION)
  Main_Form.STEP3.Caption := LngFile.ReadString('STEP4', 'STEP4', '');
  Main_Form.STEP3Description.Caption := LngFile.ReadString('STEP4', 'STEP4Description', '');
  Main_Form.ProgramTitle.Caption := LngFile.ReadString('STEP4', 'ProgramTitle', '');
  Main_Form.ProgramTypeTitle.Caption := LngFile.ReadString('STEP4', 'ProgramTypeTitle', '');
  Main_Form.Add.Caption := LngFile.ReadString('STEP4', 'TypeDescription', '');
  Main_Form.DescriptionTitle.Caption := LngFile.ReadString('STEP4', 'DescriptionTitle', '');
  Main_Form.lbThere4Types.Caption := LngFile.ReadString('STEP4', 'There4TypesAvailable', '');

  //ETAPE 5 (ZIP COMMENT) [v3.0]
  Main_Form.lZCStepPresentation.Caption := LngFile.ReadString('STEP5', 'STEP5', '');
  Main_Form.lZCStepDescription.Caption := LngFile.ReadString('STEP5', 'Step5Info', '');
  Main_Form.gbMakeYourChoice.Caption := ' ' + LngFile.ReadString('STEP5', 'MakeYourChoice', '') + ' ';
  Main_Form.gbZCCreator.Caption := ' ' + LngFile.ReadString('STEP5', 'InternalZipCommentCreator', '') + ' ';
  Main_Form.gbZCReadMe.Caption := ' ' + LngFile.ReadString('STEP3', 'STEP3GroupBox', '') + ' ';
  Main_Form.rbDontAddThisComment.Caption := LngFile.ReadString('STEP5', 'DontAddThisComment', '');
  Main_Form.rbCreateNewComment.Caption := LngFile.ReadString('STEP5', 'CreateNewCommentReadMeFile', '');
  Main_Form.rbUseExternalTextFile.Caption := LngFile.ReadString('STEP5', 'UseExternalTextFile', '');
  Main_Form.bZCCreator.Caption := LngFile.ReadString('STEP5', 'OpenCommentFileEditor', '');
  //Main_Form.lZCCreator.Caption := LngFile.ReadString('STEP5', 'EasyToUse', '');
  Main_Form.lZCReadMeLoc.Caption := LngFile.ReadString('STEP3', 'PleaseChooseReadMeFile', '');
  Main_Form.cbMacDreamTool.Caption := LngFile.ReadString('STEP5', 'MacDreamToolSupport', '');
  Main_Form.gbStep5Options.Caption := ' ' + LngFile.ReadString('Events', 'Options', '') + ' ';
  Main_Form.cbMacDreamTool.Hint := LngFile.ReadString('HINTS', 'MacDreamToolHint', '');

  ZipComment_Form.gbWhatFilesDoINeedToAdd.Caption := ' ' + LngFile.ReadString('STEP5', 'WhatFilesDoINeedToAdd', '') + ' ';
  ZipComment_Form.lWhats.Caption := ' ' + LngFile.ReadString('STEP5', 'Whats', '') + ' ';
  ZipComment_Form.lWhoMade.Caption := ' ' + LngFile.ReadString('STEP5', 'WhoMade', '') + ' ';
  ZipComment_Form.lHowToPlay.Caption := ' ' + LngFile.ReadString('STEP5', 'HowDoIPlay', '') + ' ';
  ZipComment_Form.gbControls.Caption := ' ' + LngFile.ReadString('STEP5', 'Controls', '') + ' ';
  ZipComment_Form.bCreateTheFile.Caption := LngFile.ReadString('STEP5', 'CreateTheFile', '');
  ZipComment_Form.bClearAllFields.Caption := LngFile.ReadString('STEP5', 'ClearAllFields', '');
  ZipComment_Form.bCancelThisOperation.Caption := LngFile.ReadString('STEP5', 'CancelThisOperation', '');
  ZipComment_Form.Caption := LngFile.ReadString('STEP5', 'CreateAZipCommentTextFile', '');

  //ETAPE 6 (FICHIERS EN PLUS)
  Main_Form.STEP4.Caption := LngFile.ReadString('STEP6', 'STEP6', '');
  Main_Form.AddProFilesInfos.Caption := LngFile.ReadString('STEP6', 'AddProFilesInfos', '');
  Main_Form.FolderStructure.Caption := LngFile.ReadString('STEP6', 'FolderStructure', '');
  Main_Form.FileStructure.Caption := LngFile.ReadString('STEP6', 'FileStructure', '');
  Main_Form.pmAddFolder2.Caption := LngFile.ReadString('STEP6', 'AddFolder', '');
  Main_Form.pmAddFolder1.Caption := LngFile.ReadString('STEP6', 'AddFolder', '');
  Main_Form.pmRefreshTree.Caption := LngFile.ReadString('STEP6', 'Refresh', '');
  Main_Form.pmRefreshFile.Caption := LngFile.ReadString('STEP6', 'Refresh', '');
  Main_Form.pmShowExplorer.Caption := LngFile.ReadString('STEP6', 'ShowExplorer', '');
  Main_Form.pmAddFile.Caption := LngFile.ReadString('STEP6', 'AddFile', '');
  Main_Form.Add_OpenDialog.Filter := LngFile.ReadString('STEP6', 'AddFilter', '');
  Main_Form.Add_OpenDialog.Title := LngFile.ReadString('STEP6', 'AddOpenDialogTitle', '');
  Main_Form.SelectDir.Title := LngFile.ReadString('STEP6', 'PleaseChooseTheDirectory', '');
  Main_Form.Newdir1.Caption := LngFile.ReadString('Events', 'NewFolder', '');
  Main_Form.NewFolder1.Caption := Main_Form.Newdir1.Caption;
  Main_Form.ViewFolder1.Caption := LngFile.ReadString('STEP6', 'ViewFolder', '');

  //ETAPE 7 (CREATION DU SBI)
  Main_Form.STEP5.Caption := LngFile.ReadString('STEP7', 'STEP7', '');
  Main_Form.STEP5Description.Caption := LngFile.ReadString('STEP7', 'STEP7Description', '');
  Main_Form.SaveDialog.Title := LngFile.ReadString('STEP7', 'SaveDialogTitle', '');
  Main_Form.SaveDialog.Filter := LngFile.ReadString('STEP7', 'SaveDialogFilter', '');
  Main_Form.pbProgress.Caption := LngFile.ReadString('STEP7', 'ProgressBar', '');

  //ETAPE 8 (FINI)
  Main_Form.STEP6.Caption := LngFile.ReadString('FINAL STEP', 'STEP8', '');
  Main_Form.STEP6Description.Caption := LngFile.ReadString('FINAL STEP', 'STEP8Description', '');
  Main_Form.ViewLogFileBtn.Caption := LngFile.ReadString('FINAL STEP', 'ViewLogFile', '');

  { ---< ADD TYPE >--- }
  { AddType_Form.Caption := LngFile.ReadString('ADDTYPE', 'TitleDialog', '');
  AddType_Form.BtnCancel.Caption := LngFile.ReadString('Buttons', 'Cancel', '');
  AddType_Form.BtnOK.Caption := LngFile.ReadString('Buttons', 'OK', '');
  AddType_Form.GroupBox.Caption := LngFile.ReadString('ADDTYPE', 'PleaseEnterNewType', '');
  AddType_Form.Info.Caption := LngFile.ReadString('ADDTYPE', 'Description', ''); }

  { ---< DEBUG LOG >--- }
  Log_Form.StatusBar.SimpleText := LngFile.ReadString('DebugLog', 'RightClickForOptions', '');
  Log_Form.OKBtn.Caption := LngFile.ReadString('Buttons', 'OK', '');
  Log_Form.SaveLog.Caption := LngFile.ReadString('DebugLog', 'SaveLog', '');
  Log_Form.SaveDialog.Title := LngFile.ReadString('DebugLog', 'DebugLogTitle', '');
  Log_Form.SaveDialog.Filter := LngFile.ReadString('DebugLog', 'DebugLogFilter', '');

  { ---< EVENTS >--- }
  Ready := LngFile.ReadString('Events', 'Ready', 'Prêt');
  Error := LngFile.ReadString('Events', 'Error', '');
  Warning := LngFile.ReadString('Events', 'Warning', '');
  AbortOperation := LngFile.ReadString('Events', 'AbortOperation', '');
  AreYouSure := LngFile.ReadString('Events', 'AreYouSure', '');
  Question := LngFile.ReadString('Events', 'Question', '');
  EmptyList := LngFile.ReadString('Events', 'EmptyList', '');
  PleaseSelectAItem := LngFile.ReadString('Events', 'PleaseSelectAItem', '');
  MustSpecifyProgram := LngFile.ReadString('Events', 'MustSpecifyProgram', '');
  MustSpecifyPicture := LngFile.ReadString('Events', 'MustSpecifyPicture', '');
  ProgramFileNotFound := LngFile.ReadString('Events', 'ProgramFileNotFound', '');
  PictureFileNotFound := LngFile.ReadString('Events', 'PictureFileNotFound', '');
  MustEnterProgramName := LngFile.ReadString('Events', 'MustEnterProgramName', '');
  MustEnterProgramType := LngFile.ReadString('Events', 'MustEnterProgramType', '');
  ChooseDirectory := LngFile.ReadString('Events', 'ChooseDirectory', '');
  CreationStarted := LngFile.ReadString('Events', 'CreationStarted', '');
  CheckingInducerDir := LngFile.ReadString('Events', 'CheckingInducerDir', '');
  SCRAMBLEToolExtract := LngFile.ReadString('Events', 'SCRAMBLEToolExtract', '');
  CopyingBINProgram := LngFile.ReadString('Events', 'CopyingBINProgram', '');
  DescramblingBIN := LngFile.ReadString('Events', 'DescramblingBIN', '');
  CopyingScreenShot := LngFile.ReadString('Events', 'CopyingScreenShot', '');
  CheckingAnothersFiles := LngFile.ReadString('Events', 'CheckingAnothersFiles', '');
  AddingFilesInCDRoot := LngFile.ReadString('Events', 'AddingFilesInCDRoot', '');
  CheckingStructureFolder := LngFile.ReadString('Events', 'CheckingStructureFolder', '');
  CheckingFileCopy := LngFile.ReadString('Events', 'CheckingFileCopy', '');
  AddingFiles := LngFile.ReadString('Events', 'AddingFiles', '');
  DXLStepCreation := LngFile.ReadString('Events', 'DXLStepCreation', '');
  ZIPToolExtract := LngFile.ReadString('Events', 'ZIPToolExtract', '');
  ZippingFiles := LngFile.ReadString('Events', 'ZippingFiles', '');
  SBICreationCompleted := LngFile.ReadString('Events', 'SBICreationCompleted', '');
  SBICreationCompletedEnjoyIt := LngFile.ReadString('Events', 'SBICreationCompletedEnjoyIt', '');
  OhYeah := LngFile.ReadString('Events', 'OhYeah', '');
  //WidthMustBe300 := LngFile.ReadString('Events', 'WidthMustBe300', '');
  //HeightMustBe200 := LngFile.ReadString('Events', 'HeightMustBe200', '');
  BINisUnscrambled := LngFile.ReadString('Events', 'BINisUnscrambled', '');
  BINisScrambled := LngFile.ReadString('Events', 'BINisScrambled', '');
  ConfirmBINDetection := LngFile.ReadString('Events', 'ConfirmBINDetection', '');
  Information := LngFile.ReadString('Events', 'Information', '');
  BinWillBeCopiedAsUnscrambled := LngFile.ReadString('Events', 'BinWillBeCopiedAsUnscrambled', '');
  BinWillBeCopiedAsScrambled := LngFile.ReadString('Events', 'BinWillBeCopiedAsScrambled', '');
  CopyingBINasScrambled := LngFile.ReadString('Events', 'CopyingBINasScrambled', '');
  CopyingBINasUnscrambled := LngFile.ReadString('Events', 'CopyingBINasUnscrambled', '');
  SBIRestarted := LngFile.ReadString('Events', 'SBIRestarted', '');
  IfYouGoBackSBIFileDeletedContinue := LngFile.ReadString('Events', 'IfYouGoBackSBIFileDeletedContinue', '');
  ResizingPNG := LngFile.ReadString('Events', 'ResizingPNG', '');
  CopyingReadMeFile := LngFile.ReadString('Events', 'CopyingReadMeFile', '');
  CopyingStampFile := LngFile.ReadString('Events', 'CopyingStampFile', '');
  InvalidImage := LngFile.ReadString('Events', 'InvalidImage', '');
  ReadMeFileNotFound := LngFile.ReadString('Events', 'ReadMeFileNotFound', '');
  ErrorAllFieldsAreEmpty := LngFile.ReadString('Events', 'ErrorAllFieldsAreEmpty', '');
  WarningFileIsSuperiorThan8192Bytes := LngFile.ReadString('Events', 'WarningFileIsSuperiorThan8192Bytes', '');
  TheFileWillBeTruncatedContinue := LngFile.ReadString('Events', 'TheFileWillBeTruncatedContinue', '');
  FileSuccessfullyCreated := LngFile.ReadString('Events', 'FileSuccessfullyCreated', '');
  DeleteAllFields := LngFile.ReadString('Events', 'DeleteAllFields', '');
  YouHaveNotCreatedASbiComment := LngFile.ReadString('Events', 'YouHaveNotCreatedASbiComment', '');
  PleaseCreateItOrSelectDontAddThisComment := LngFile.ReadString('Events', 'PleaseCreateItOrSelectDontAddThisComment', '');
  AddingSbiComment := LngFile.ReadString('Events', 'AddingSbiComment', '');
  SbiCommentSuccessfullyAdded := LngFile.ReadString('Events', 'SbiCommentSuccessfullyAdded', '');
  ErrorWhenAddingSbiCommentContinue := LngFile.ReadString('Events', 'ErrorWhenAddingSbiCommentContinue', '');
  WarningSbiCommentTextFileIsTooBigTruncateTheFileAt8KB := LngFile.ReadString('Events', 'WarningSbiCommentTextFileIsTooBigTruncateTheFileAt8KB', '');
  TruncateOfTheTextFileSuccessfullyCompleted := LngFile.ReadString('Events', 'TruncateOfTheTextFileSuccessfullyCompleted', '');
  ErrorCommentAlreadyExistsOnTheFile := LngFile.ReadString('Events', 'ErrorCommentAlreadyExistsOnTheFile', '');
  CheckingTextFileSize := LngFile.ReadString('Events', 'CheckingTextFileSize', '');

  //v3.1
  MacDreamToolSupportEnabled := LngFile.ReadString('Events', 'MacDreamToolSupportEnabled', '');
  SuccessfullyAddedMacDreamToolSupport := LngFile.ReadString('Events', 'SuccessfullyAddedMacDreamToolSupport', '');
  ErrorWhenAddingMacDreamToolSupport := LngFile.ReadString('Events', 'ErrorWhenAddingMacDreamToolSupport', '');
  ELFFileDetectedConvertingItToUnscrambledBIN := LngFile.ReadString('Events', 'ELFFileDetectedConvertingItToUnscrambledBIN', '');
  ErrorWhenConvertingTheELFToTheBIN := LngFile.ReadString('Events', 'ErrorWhenConvertingTheELFToTheBIN', '');

  FolderCreationOK := LngFile.ReadString('Events', 'FolderCreationOK', '');
  FailedWhenCreatingTheDirectory := LngFile.ReadString('Events', 'FailedWhenCreatingTheDirectory', '');
  NewFolder := LngFile.ReadString('Events', 'NewFolder', '');
  EnterFolderName := LngFile.ReadString('Events', 'EnterFolderName', '');
  FolderAlreadyExists := LngFile.ReadString('Events', 'FolderAlreadyExists', '');

  //Fermer le fichier.
  LngFile.Free;
end;

{-------------------------------< PROCEDURE LoadEnglish >------------------------------------------------------------------------------------------------------------------ }

procedure LoadEnglish;
begin
  Ready := 'Ready';
  Error := 'Error';
  Warning := 'Warning';
  AbortOperation := 'Abort current operation ?';
  AreYouSure := 'Are you sure ???';
  Question := 'Question';
  EmptyList := 'Empty list, sorry :)';
  MustSpecifyProgram := 'You must specify a program file.';
  MustSpecifyPicture := 'You must specify a picture file.';
  ProgramFileNotFound := 'Program file wasn''t found :';
  PictureFileNotFound := 'Picture file wasn''t found :';
  ReadMeFileNotFound := 'Read-Me File wasn''t found :';
  MustEnterProgramName := 'You must enter a Program name.';
  MustEnterProgramType := 'You must enter a Program type.';
  ChooseDirectory := 'Choose the directory';
  CreationStarted := 'Creation started.';
  CheckingInducerDir := 'Checking Inducer Dir...';
  SCRAMBLEToolExtract := 'SCRAMBLE.EXE tool extraction...';
  CopyingBINProgram := 'Copying BIN program...';
  DescramblingBIN := 'Unscrambling BIN program for use with Dream Inducer...';
  CopyingScreenShot := 'Copying screenshot...';
  CheckingAnothersFiles := 'Checking anothers files...';
  AddingFilesInCDRoot := 'Adding files in CD root...';
  CheckingStructureFolder := 'Checking structure folder...';
  CheckingFileCopy := 'Checking file copy...';
  AddingFiles := 'Adding files...';
  DXLStepCreation := 'DXL step creation...';
  ZIPToolExtract := 'ZIP.EXE tool extraction...';
  ZippingFiles := 'Zipping files...';
  SBICreationCompleted := 'SBI Creation completed.';
  SBICreationCompletedEnjoyIt := 'YESS! SBI creation completed, enjoy it :)';
  OhYeah := 'Oh yeah :D';
  //WidthMustBe300 := 'Width must be 300 pixels! Found : ';
  //HeightMustBe200 := 'Height must be 200 pixels! Found : ';
  BINisUnscrambled := 'BIN''s detected as unscrambled.';
  BINisScrambled := 'BIN''s detected as scrambled.';
  ConfirmBINDetection := 'Do you agree with the BIN check module?';
  Information := 'Information';
  BinWillBeCopiedAsUnscrambled := 'The BIN will be copied as an unscrambled file.';
  BinWillBeCopiedAsScrambled := 'The BIN will be copied as an scrambled file, and will be unscrambled.';
  CopyingBINasScrambled := 'Copying BIN as scrambled and unscrambling it...';
  CopyingBInasUnscrambled := 'Copying BIN as unscrambled...';
  SBIRestarted := 'SBI Creation restarted.';
  IfYouGoBackSBIFileDeletedContinue := 'Warning : If you go back, the content of your SBI will be deleted. Continue ?';
  ResizingPNG := 'Resizing PNG File...';
  CopyingReadMeFile := 'Copying Read-Me file...';
  CopyingStampFile := 'Copying SBI Builder stamp file (Thanks!)';
  InvalidImage := 'Invalid image.';
  ErrorAllFieldsAreEmpty := 'Error, all fields are empty.';
  WarningFileIsSuperiorThan8192Bytes := 'WARNING : File is > 8192 bytes.';
  TheFileWillBeTruncatedContinue := 'The file will be truncated. Continue ?';
  FileSuccessfullyCreated := 'File successfully created.';
  DeleteAllFields := 'Delete all fields ?';
  YouHaveNotCreatedASbiComment := 'You haven''t created a SBI comment.';
  PleaseCreateItOrSelectDontAddThisComment := 'Please create it or select "Don''t add this comment".';
  AddingSbiComment := 'Adding SBI Comment...';
  SbiCommentSuccessfullyAdded := 'SBI Comment successfully added.';
  ErrorWhenAddingSbiCommentContinue := 'ERROR when adding SBI Comment ...! Continue...';
  WarningSbiCommentTextFileIsTooBigTruncateTheFileAt8KB := 'WARNING : SBI Comment Text File is too big. Truncate the file at 8,00Kb...';
  TruncateOfTheTextFileSuccessfullyCompleted := 'Truncate of the text file successfully completed.';
  ErrorCommentAlreadyExistsOnTheFile := 'ERROR : Comment already exists on the file.';
  CheckingTextFileSize := 'Checking text file size...';
  MacDreamToolSupportEnabled := 'MacDreamTool support enabled.';
  SuccessfullyAddedMacDreamToolSupport := 'Successfully added MacDreamTool support.';
  ErrorWhenAddingMacDreamToolSupport := 'Error when adding MacDreamTool support.';
  ELFFileDetectedConvertingItToUnscrambledBIN := 'ELF file detected. Converting it to unscrambled BIN.';
  ErrorWhenConvertingTheELFToTheBIN := 'Error when converting the ELF to the BIN.';
  FolderCreationOK := 'Folder creation OK.';
  FailedWhenCreatingTheDirectory := 'ERROR : Failed when creating the directory !';
  NewFolder := 'New folder...';
  EnterFolderName := 'Enter folder name :';
  FolderAlreadyExists := 'The folder already exists.';
end;

{-------------------------------< PROCEDURE SetInducerDirIcon >--------------------------------------------------------------------------------------------------------- }

procedure SetInducerDirIcon;

function DeleteSlash(Path : string) : string;
var
  Dir : string;

begin
  Dir := Path;
  if Path = '' then Exit;
  while Path[Length(Path)] = '\' do
  begin
    //MsgBox(0, 'Path : ' + Path, 'ERROR', 0);
    Path := Copy(Path, 1, Length(Path) - 1);
  end;
  if Path = '' then
  begin
    Result := Dir;
    Exit;
  end;
  Result := Path;
end;

var
  F  : TextFile;
  Attributs:Integer;
  //BatF

begin
  AssignFile(F, InducerDir + 'desktop.ini');
  ReWrite(F);
  WriteLn(F, '[.ShellClassInfo]');
  WriteLn(F, 'IconFile="' + Application.ExeName + '"');
  WriteLn(F, 'IconIndex=1');
  CloseFile(F);

  Attributs := FileGetAttr(InducerDir + 'desktop.ini');
  if Attributs and faHidden = 0 then
  FileSetAttr(InducerDir + 'desktop.ini', Attributs or faHidden);

  //Set Icon
 { if FileExists(GetTempDir + 'seticon.bat') = True then
    DeleteFile(GetTempDir + 'seticon.bat');
  AssignFile(BatF, GetTempDir + 'seticon.bat');
  ReWrite(BatF);
  WriteLn(BatF, '@echo off');
  WriteLn(BatF, 'cls');
  WriteLn(BatF, 'rem Created by ' + Main_Form.Caption);
  WriteLn(BatF, 'attrib +s "' + DeleteSlash(InducerDir) + '"');
  CloseFile(BatF);
  ExecAndWait(GetTempDir + 'seticon.bat');
  DeleteFile(GetTempDir + 'seticon.bat'); 

  ExtractFile('SETICON', 'exe');
  ExecAndWait(GetTempDir + 'seticon.exe ' + InducerDir);
  DeleteFile(GetTempDir + 'seticon.exe'); }
  WinExec(PChar('attrib +s "' + DeleteSlash(InducerDir) + '"'), SW_HIDE);
end;

{-------------------------------< PROCEDURE GoBackConfirm >--------------------------------------------------------------------------------------------------------- }

function GoBackConfirm : boolean;
var
  CanContinue : integer;

begin
  Result := False;
  CanContinue := MsgBox(IfYouGoBackSBIFileDeletedContinue, Warning, 48 + MB_OKCANCEL + MB_DEFBUTTON2);
  if CanContinue = IDCANCEL then Exit;

  //Effacer le dossier Inducer, revenir au début
  AddDebug(SBIRestarted);
  Result := True;
{  DeleteDir(InducerDir);
  CreateDir(InducerDir);
  SetInducerDirIcon; }
  InitInducerDirectory(True);   //Initialisation du dossier Inducer.

  RestartApp;  //Enlever tous les panels & boutons
  AddDebug(Ready);
end;

{-------------------------------< PROCEDURE ActiveResize >--------------------------------------------------------------------------------------------------------------------------------- }

procedure ActiveResize;
begin
  Main_Form.labWillBeTheNewSizeAfter.Enabled := True;
  Main_Form.eHeight.Enabled := True;
  Main_Form.eWidth.Enabled := True;
  Main_Form.laCross.Enabled := True;
end;

{-------------------------------< PROCEDURE DisactiveResize >--------------------------------------------------------------------------------------------------------------------------------- }

procedure DisactiveResize;
begin
  Main_Form.labWillBeTheNewSizeAfter.Enabled := False;
  Main_Form.eHeight.Enabled := False;
  Main_Form.eWidth.Enabled := False;
  Main_Form.laCross.Enabled := False;
end;

{-------------------------------< PROCEDURE CopyReadMeFile >--------------------------------------------------------------------------------------------------------------------------------- }

procedure CopyReadMeFile;
var
  TxtName, TxtDir,
  TxtFileInducer : string;

begin
  //Le nom du TXT
  if Main_Form.cbDontRenameTXT.Checked = False then
    TxtName := ChangeFileExt(ExtractFileName(Main_Form.BINFile.Text), '.txt')
  else TxtName := ExtractFileName(Main_Form.ReadMeEdit.Text);

  TxtDir := GetRealPath(InducerDir) + 'Readme\';
  TxtFileInducer := GetRealPath(TxtDir) + LowerCase(TxtName); //Mettre en
  //minuscules pour eviter les README.txt...

  //Effacer le ReadMe si il existe
  AddDebug(CheckingInducerDir);
  if FileExists(TxtFileInducer) = True then DeleteFile(TxtFileInducer);
  if DirectoryExists(TxtDir) = False then
    ForceDirectories(TxtDir);

  AddDebug(CopyingReadMeFile);
  //ShowMessage(TxtFileInducer);
  CopyFileTo(Main_Form.ReadMeEdit.Text, TxtFileInducer);

  AddDebug(Ready);
end;

{-------------------------------< PROCEDURE CopyStamp >--------------------------------------------------------------------------------------------------------------------------------- }

procedure CopyStamp;
var
  TxtDir : string;
  
begin
  TxtDir := GetRealPath(InducerDir) + 'Readme\';

  //Effacer le ReadMe si il existe
  AddDebug(CheckingInducerDir);
  if FileExists(TxtDir + 'buildsbi.txt') = True then
    DeleteFile(TxtDir + 'buildsbi.txt');
  if DirectoryExists(TxtDir) = False then
    ForceDirectories(TxtDir);

  AddDebug(CopyingStampFile);
  ExtractFile('buildsbi', 'txt');
  CopyFileTo(GetTempDir + 'buildsbi.txt', TxtDir + 'buildsbi.txt');

  AddDebug(Ready);
end;

{-------------------------------< FIN DES PROCEDURES >--------------------------------------------------------------------------------------------------------------------------------- }

end.
