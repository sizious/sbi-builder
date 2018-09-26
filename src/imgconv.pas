unit imgconv;

interface

uses
  Windows, SysUtils, Graphics, GifImage, Jpeg;

procedure JpgToPng(FicJpg, FicPng : string);
procedure GifToPng(FicGif, FicPng : string);
  
implementation

uses pngutils, utils;

//---GifToBmp---
procedure GifToBmp(FicGif, FicBmp: string);
var
  ImageGif  : TGifImage;
  ImageBMP  : TBitmap;

begin
  ImageGif := TGifImage.Create;
  try
    ImageGif.LoadFromFile(FicGif); // chargement du JPEG à partir d'un fichier
    ImageBMP := TBitmap.Create;
    try
      ImageBMP.Width := ImageGif.Width;  // détermination de la taille de ImageBMP
      ImageBMP.Height := ImageGif.Height;
      ImageBMP.Canvas.Draw(0,0,ImageGif); // On dessine de ImageJPEG dans ImageBMP
      ImageBMP.SaveToFile(FicBmp);  // Sauvegarde de ImageBMP sous fichier
    finally
      ImageBMP.Free; // libération de la mémoire (même en cas d'erreur grâce au try finally)
    end;
  finally
    ImageGif.Free;  // libération de la mémoire (même en cas d'erreur grâce au try finally)
  end;
end;

//---JpgToBmp---
procedure JpgToBmp(FicJpg, FicBmp: string);
var
  ImageJPEG : TJPEGImage;
  ImageBMP  : TBitmap;

begin
  ImageJPEG := TJPEGImage.Create;
  try
    ImageJPEG.LoadFromFile(FicJpg); // chargement du JPEG à partir d'un fichier
    ImageBMP := TBitmap.Create;
    try
      ImageBMP.Width := ImageJPEG.Width;  // détermination de la taille de ImageBMP
      ImageBMP.Height := ImageJPEG.Height;
      ImageBMP.Canvas.Draw(0,0,ImageJPEG); // On dessine de ImageJPEG dans ImageBMP
      ImageBMP.SaveToFile(FicBmp);  // Sauvegarde de ImageBMP sous fichier
    finally
      ImageBMP.Free; // libération de la mémoire (même en cas d'erreur grâce au try finally)
    end;
  finally
    ImageJPEG.Free;  // libération de la mémoire (même en cas d'erreur grâce au try finally)
  end;
end;

//---IcoToBmp---
{procedure IcoToBmp(FicIco, FicBmp :string);
//transformation d'un ICO en BMP
var
  ImageICO : TPicture;
  ImageBMP  : TBitmap;
  
begin
  ImageICO := TPicture.Create;
  try
    ImageICO.LoadFromFile(FicIco); // chargement de l'image ICO à partir d'un fichier
    ImageBMP := TBitmap.Create;
    try
      ImageBMP.Width := ImageICO.Width;  // On dimenssionne ImageBMP aux dimenssions de ImageICO
      ImageBMP.Height := ImageICO.Height;
      ImageBMP.Canvas.Draw(0,0,ImageICO.Graphic); // On dessine ImageICO sur ImageBMP
      ImageICO.Assign(ImageBMP);          // On fait la manip inverse
      ImageICO.SaveToFile(FicBmp);   // sauvegarde sous fichier
    finally
      ImageBMP.free;
    end;
  finally
    ImageICO.Free;
  end;
end; }

//------------------------------------------------------------------------------

//---JpgToPng---
procedure JpgToPng(FicJpg, FicPng : string);
var
  TempFile : string;

begin
  TempFile := GetRealPath(GetTempDir) + ChangeFileExt(ExtractFileName(FicJpg), '.bmp'); //le jpg
  JpgToBmp(FicJpg, TempFile);

  if UpperCase(FicJpg) = UpperCase(FicPng) then
    DeleteFile(FicJpg); //On veut le remplacer...

  BitmapFileToPNG(TempFile, FicPng);
  DeleteFile(TempFile);
end;

//---GifToPng---
procedure GifToPng(FicGif, FicPng : string);
var
  TempFile : string;

begin
  TempFile := GetRealPath(GetTempDir) + ChangeFileExt(ExtractFileName(FicGif), '.bmp'); //le jpg
  GifToBmp(FicGif, TempFile);

  if UpperCase(FicGif) = UpperCase(FicPng) then
    DeleteFile(FicGif); //On veut le remplacer...

  BitmapFileToPNG(TempFile, FicPng);
  DeleteFile(TempFile);
end;

end.
