{
  Unit PNGUtils
  Permet de convertir les fichiers PNG...
}

unit pngutils;

interface

uses
  PNGImage, Graphics;

procedure PNGFileToBitmap(const Source, Dest: String);
procedure BitmapFileToPNG(const Source, Dest: String);

implementation

procedure BitmapFileToPNG(const Source, Dest: String);
var
  Bitmap: TBitmap;
  PNG: TPNGObject;

begin
  Bitmap := TBitmap.Create;
  PNG := TPNGObject.Create;
  {In case something goes wrong, free booth Bitmap and PNG}
  try
    Bitmap.LoadFromFile(Source);
    PNG.Assign(Bitmap);    //Convert data into png
    PNG.SaveToFile(Dest);
  finally 
    Bitmap.Free;
    PNG.Free;
  end
end;

procedure PNGFileToBitmap(const Source, Dest: String);
var
  Bitmap: TBitmap;
  PNG: TPNGObject;
begin
  PNG := TPNGObject.Create;
  Bitmap := TBitmap.Create;
  {In case something goes wrong, free booth PNG and Bitmap}
  try
    PNG.LoadFromFile(Source);
    Bitmap.Assign(PNG);    //Convert data into bitmap
    Bitmap.SaveToFile(Dest);
  finally 
    PNG.Free;
    Bitmap.Free;
  end
end;

{ procedure TImageToPNG(Source: TImage; const Dest: String);
var
  PNG: TPNGObject;
  BMP: TBitmap;
begin
  PNG := TPNGObject.Create;

  //In case something goes wrong, free PNG
  try
    //If the TImage contains a TBitmap, just assign from it
    if Source.Picture.Graphic is TBitmap then
      PNG.Assign(TBitmap(Source.Picture.Graphic))    //Convert bitmap data into png
    else begin

      //Otherwise try to assign first to a TBimap
      BMP := TBitmap.Create;
      try
        BMP.Assign(Source.Picture.Graphic);
        PNG.Assign(BMP);
      finally
        BMP.Free;
      end;

    end;

    //Save to PNG format
    PNG.SaveToFile(Dest);
  finally 
    PNG.Free;
  end
end;      }

end.




