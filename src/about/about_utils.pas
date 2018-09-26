unit about_utils;

interface

uses
  Windows, Graphics;
  
type
  TPoint3D = record
    X : integer;
    Y : integer;
    Z : integer;
  end;

  THSVColor = record
    H : Integer;
    S : Integer;
    V : Integer;
  end;

  TRGBColor = record
    R : Integer;
    G : Integer;
    B : Integer;
  end;
  
function HsvToRgb(colorHSV : THSVColor) : TRGBColor;
function ColorHSV(h, s, v : Integer) : THSVColor;
function RGBToInt(RGB : TRGBColor) : Integer;
procedure BitmapToControl(Handle : THandle ; Bitmap : TBitmap ; TranspancyColor : TColor);
function IntToRGB(Color : Integer) : TRGBColor;
function ChangeBrightness(RGB : TRGBColor ; Value : Integer) : TRGBColor; overload;
function ChangeBrightness(Color : TColor ; Value : Integer) : TColor; overload;

implementation

//------------------------------------------------------------------------------

procedure BitmapToControl(Handle : THandle ; Bitmap : TBitmap ; TranspancyColor : TColor);
var
    i, j, debutY : Integer;
    rgn, rgn1 : HRGN;

begin
rgn := CreateRectRgn(0, 0, 0, 0);
for i := 0 to Bitmap.Width-1 do
  begin
    j := 0;
    while j < Bitmap.Height-1 do
      begin
       if Bitmap.Canvas.Pixels[i, j] <> TranspancyColor then
        begin
         debutY := j;
         while (Bitmap.Canvas.Pixels[i, j] <> TranspancyColor)
                and (j < Bitmap.Height) do
          inc(j);
         rgn1 := CreateRectRgn(i, debutY, i+1, j);
         CombineRgn(rgn, rgn, rgn1, RGN_OR);
         DeleteObject(rgn1);
        end;
      inc(j);
      end;
  end;

  SetWindowRgn(Handle, rgn, true);
end;

//------------------------------------------------------------------------------

function HSVtoRGB(colorHSV : THSVColor) : TRGBColor;
var
  r, g, b, h, s, v : Single; //this function works with floats between 0 and 1
  f, p, q, t : Single;
  i : Integer;

begin
    r := 0;
    g := 0;
    b := 0;

    h := colorHSV.h / 256.0;
    s := colorHSV.s / 256.0;
    v := colorHSV.v / 256.0;


  // The trivial case for saturation = zero is handled:

    //If saturation is 0, the color is a shade of gray
    if s = 0 then
      begin
        b := v;
        g := b;
        r := g;
      end


  // The HSV model can be presented on a cone with hexagonal shape.
  //For each of the sides of the hexagon, a separate case is calculated:

    //If saturation > 0, more complex calculations are needed
  else
    begin

        h := h * 6; //to bring hue to a number between 0 and 6, better for the calculations
        i := Trunc(h);  //e.g. 2.7 becomes 2 and 3.01 becomes 3 or 4.9999 becomes 4
        f := h - i;  //the fractional part of h
        p := v * (1 - s);
        q := v * (1 - (s * f));
        t := v * (1 - (s * (1 - f)));
        case i of
            0 : begin r := v; g := t; b := p; end;
            1 : begin r := q; g := v; b := p; end;
            2 : begin r := p; g := v; b := t; end;
            3 : begin r := p; g := q; b := v; end;
            4 : begin r := t; g := p; b := v; end;
            5 : begin r := v; g := p; b := q; end;
        end;
                    
    end;


  //And again, the results are "returned" as integers between 0 and 255.

    Result.r := Trunc(r * 255.0);
    Result.g := Trunc(g * 255.0);
    Result.b := Trunc(b * 255.0);
end;

//------------------------------------------------------------------------------

function ColorHSV(h, s, v : Integer) : THSVColor;
begin
  Result.H := h;
  Result.S := s;
  Result.V := v;
end;

//------------------------------------------------------------------------------

function RGBtoInt(RGB : TRGBColor) : Integer;
begin
    Result := 65536 * RGB.R + 256 * RGB.G + RGB.B;
end;

//------------------------------------------------------------------------------

function IntToRGB(Color : Integer) : TRGBColor;
begin
  Result.R := (Color shr 16) and $FF;
  Result.G := (Color shr 8) and $FF;
  Result.B := Color and $FF;
  //Result.R := (Color div 65536) mod 256;
  //Result.G := (Color div 256) mod 256;
  //Result.B := Color mod 256;
end;

//------------------------------------------------------------------------------

function ChangeBrightness(RGB : TRGBColor ; Value : Integer) : TRGBColor; overload;
begin
  RGB.R := (RGB.R + Value);
  RGB.G := (RGB.G + Value);
  RGB.B := (RGB.B + Value);

  if RGB.R < 0 then RGB.R := 0;
  if RGB.G < 0 then RGB.G := 0;
  if RGB.B < 0 then RGB.B := 0;

  if RGB.R > 255 then RGB.R := 255;
  if RGB.G > 255 then RGB.G := 255;
  if RGB.B > 255 then RGB.B := 255;

  Result := RGB;
end;

//------------------------------------------------------------------------------

function ChangeBrightness(Color : TColor ; Value : Integer) : TColor; overload;
begin
  Result := RGBToInt(ChangeBrightness(IntToRGB(Color), Value));
end;

//------------------------------------------------------------------------------

end.
