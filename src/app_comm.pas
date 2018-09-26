{$WARN SYMBOL_PLATFORM OFF}
{$WARN UNIT_PLATFORM OFF}
unit app_comm;

interface

uses
  Windows, SysUtils;

function AddZipComment(ZipFile, TextFile : string) : boolean;
function IsFileInUse(FileName : string) : boolean;
function RemoveReadOnly(FileName : string) : boolean;

implementation

uses utils;

//*************************PARTIE GESTION DU FICHIER****************************
//Pour que le fichier fasse d'une manière ou d'une autre 8,00Kb ! (8192 bytes).

//---GetTempDir---
{function GetTempDir : string;
var
  Dossier: array[0..MAX_PATH] of char;

begin
  Result := '';
  if GetTempPath(SizeOf(Dossier), Dossier) <> 0 then Result := StrPas(Dossier);
end;}

//---RemoveReadOnly---
function RemoveReadOnly(FileName : string) : boolean;
var
  Attributs : integer;

begin
  Result := False;  //Fichier pas ReadOnly.
  if FileExists(FileName) = False then Exit;
  Attributs := FileGetAttr(FileName);

  if Attributs and faReadOnly <> 0 then
  begin
    FileSetAttr(FileName, Attributs - faReadOnly); //On l'enleve.
    Result := True; //Fichier ReadOnly!
  end;
end;

//---IsFileInUse---
//Permet de savoir si le fichier n'est pas utilisé.
function IsFileInUse(FileName : string) : boolean;
var
  F : File;

begin
  Result := True;
  if FileExists(FileName) = False then Exit;
  RemoveReadOnly(FileName); //Enleve la lecture seule si il y'a.

  AssignFile(F, FileName);
  {$I-} Reset(F, 1);{$I+}
  CloseFile(F);
  
  if IOResult <> 0 then Exit; //fichier en lecture seule.
  Result := False;
end;

//---AppendFile---
function AppendFile(FileName : string ; Size : integer) : boolean;
const
  NULL : byte = $00;

var
  FS : File;

begin
  Result := False;
  if FileExists(FileName) = False then Exit;

  AssignFile(FS, FileName);
  Reset(FS, 1);

  Seek(FS, FileSize(FS));

  while FileSize(FS) <> Size do
    BlockWrite(FS, NULL, 1);

  CloseFile(FS);
  Result := True;
end;

//---TruncFile---
function TruncFile(FileName : string ; MaxPos : integer) : boolean;
var
  FS, FT    : File;
  Buf       : byte;
  BytesRead : integer;
  TempFile  : string;

begin
  Result := False;
  if FileExists(FileName) = False then Exit;

  AddDebug(WarningSbiCommentTextFileIsTooBigTruncateTheFileAt8KB);
  //Ouverture
  TempFile := GetTempDir + 'temp.bin';
  AssignFile(FS, FileName);
  if FileExists(TempFile) = True then DeleteFile(TempFile);
  AssignFile(FT, TempFile);
  Reset(FS, 1);
  ReWrite(FT, 1);

  //Si le fichier est plus petit que la taille à tronquer on se casse.
  if FileSize(FS) < MaxPos then Exit;

  //Recopie le fichier source dans le fichier cible jusqu'a MaxPos.
  while FileSize(FT) <> MaxPos do
  begin
    BlockRead(FS, Buf, SizeOf(Buf), BytesRead);
    BlockWrite(FT, Buf, BytesRead);
  end;

  //Fermer les fichiers.
  CloseFile(FS);
  CloseFile(FT);

  //Remplacer le fichier source par le fichier tronqué.
  DeleteFile(FileName);
  CopyFile(PChar(GetTempDir + 'temp.bin'), PChar(FileName), False);
  DeleteFile(TempFile);

  AddDebug(TruncateOfTheTextFileSuccessfullyCompleted);
  
  Result := True;
end;

//---SetFileSize---
function SetFileSize(FileName : string ; Size : integer) : boolean;
var
  F : File;

begin
  Result := False;
  if FileExists(FileName) = False then Exit;
  if IsFileInUse(FileName) = True then Exit;  //enleve le readonly et en plus vérifie la lecture seule.

  //Ouverture du fichier
  AssignFile(F, FileName);
  Reset(F, 1);

  //Si la taille est exactement celle recherchée... On se tire.
  if FileSize(F) = Size then
  begin
    Result := True;
    Exit;
  end;

  //Sinon :
  if FileSize(F) > Size then //Si la taille du fichier est > à la taille attendue...
    TruncFile(FileName, Size) //...on va tronquer le fichier à la taille attendue...
  else AppendFile(FileName, Size); //...sinon on va le completer afin qu'il fasse la taille attendue !

  CloseFile(F);
end;

//*************************PARTIE AJOUT DU ZIP COMMENT**************************
//Partie qui gère l'insertion du fichier texte de 8,00Kb dans le fichier ZIP.

//---IsZipCommentExists---
function IsZipCommentExists(ZipFile : string) : boolean;
var
  F       : File;
  Buffer  : byte;
  Pos     : integer;

begin
  Result := False;

  //Enleve le readonly et en plus vérifie l'utilisation sur les deux fichiers.
  if FileExists(ZipFile) = False then Exit;
  if IsFileInUse(ZipFile) = True then Exit;

  //Ouverture du fichier ZIP.
  AssignFile(F, ZipFile);
  Reset(F, 1);

  //On regarde l'octet correspondant...
  Pos := FileSize(F) - (8192 + 1);
  if Pos < FileSize(F) then
  begin
    CloseFile(F);
    Exit;
  end;
  
  Seek(F, Pos);
  BlockRead(F, Buffer, 1);
  CloseFile(F);
  
  if Buffer = $20 then Result := True; //Terminé.
end;

//---AddZipComment---
function AddZipComment(ZipFile, TextFile : string) : boolean;
var
  FS, FText : File;
  Buffer    : byte;
  Buf       : array[1..8192] of byte;
  NumRead   : integer;
  TempFile  : string;


begin
  Result := False;

  //Enleve le readonly et en plus vérifie l'utilisation sur les deux fichiers.
  if FileExists(ZipFile) = False then Exit;
  if IsFileInUse(ZipFile) = True then Exit;
  if FileExists(TextFile) = False then Exit;
  if IsFileInUse(TextFile) = True then Exit;

  //Copie du fichier texte pour le commentaire dans un fichier temp
  //Il risque d'être modifié.
  TempFile := GetTempDir + '~sbicomm.tmp';
  if FileExists(TempFile) = True then DeleteFile(TempFile);
  CopyFile(PChar(TextFile), PChar(TempFile), False);

  //Ouverture des deux fichiers.
  AssignFile(FS, ZipFile);
  AssignFile(FText, TempFile);
  Reset(FS, 1);
  Reset(FText, 1);

  //Corriger le fichier texte source
  //La taille doit faire 8192 octets.
  AddDebug(CheckingTextFileSize);
  SetFileSize(TempFile, 8192);

  //Vérifier si on a pas déjà ajouté un commentaire.
  //SEULEMENT POUR LES FICHIERS DE 8192 BYTES!
  if IsZipCommentExists(ZipFile) = True then
  begin
    AddDebug(ErrorCommentAlreadyExistsOnTheFile);
    Exit;
  end;

  //Ecrire le byte qui indique qu'il y'a un commentaire
  Seek(FS, FileSize(FS) - 1);
  Buffer := $20;
  BlockWrite(FS, Buffer, 1);

  //Ecrire le fichier texte dans le fichier zip.
  while not EOF(FText) do
  begin
    BlockRead(FText, Buf, SizeOf(Buf), NumRead);
    BlockWrite(FS, Buf, NumRead);
  end;

  //Fermer les fichiers.
  CloseFile(FS);
  CloseFile(FText);
  
  Result := True; //Terminé.
  if FileExists(TempFile) = True then DeleteFile(TempFile);
end;


end.
