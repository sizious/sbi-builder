unit delimiters;

interface

uses
  ExtCtrls;
  
procedure InitDelimiters();
procedure DrawDelimiter(Delimiter : TPanel ; const PaletteSelect : Integer = 0);
procedure SetDelimiterPaletteStartValue(const PaletteSelect : Integer ; const StartValue : Integer);

implementation

uses
  about_utils;

var
  Palette : array[0..255] of Integer;
  DelimitersIndexPalettes : array[0..1] of Integer;
  
//------------------------------------------------------------------------------

procedure GenerateDelimitersPalette();
var
  x : Integer;
  colorRGB : TRGBColor;
  
begin
  //generate the palette
  for x := Low(Palette) to High(Palette) do
  begin
      //use HSVtoRGB to vary the Hue of the color through the palette
      colorRGB := HSVtoRGB(ColorHSV(x, 255, 255));
      Palette[x] := RGBtoINT(colorRGB);
  end;
end;

//------------------------------------------------------------------------------

procedure InitDelimiters();
var
  i : Integer;
  
begin
  GenerateDelimitersPalette();
  
  for i := Low(DelimitersIndexPalettes) to High(DelimitersIndexPalettes) do
    DelimitersIndexPalettes[i] := 0;
end;

//------------------------------------------------------------------------------

procedure SetDelimiterPaletteStartValue(const PaletteSelect : Integer ; const StartValue : Integer);
var
  PaletteIndex : Integer;
  
begin
  PaletteIndex := PaletteSelect;
  if PaletteIndex > High(DelimitersIndexPalettes) then PaletteIndex := High(DelimitersIndexPalettes);
  if PaletteIndex < Low(DelimitersIndexPalettes) then PaletteIndex := Low(DelimitersIndexPalettes);

  DelimitersIndexPalettes[PaletteIndex] := StartValue;
end;

//------------------------------------------------------------------------------

procedure DrawDelimiter(Delimiter : TPanel ; const PaletteSelect : Integer = 0);
var
  PaletteIndex, CurrentCounterValue : Integer;
  
begin
  PaletteIndex := PaletteSelect;
  if PaletteIndex > High(DelimitersIndexPalettes) then PaletteIndex := High(DelimitersIndexPalettes);
  if PaletteIndex < Low(DelimitersIndexPalettes) then PaletteIndex := Low(DelimitersIndexPalettes);

  CurrentCounterValue := DelimitersIndexPalettes[PaletteIndex];
  Delimiter.Color := Palette[CurrentCounterValue];
  
  Inc(DelimitersIndexPalettes[PaletteIndex]);
  if DelimitersIndexPalettes[PaletteIndex] > High(Palette) then
    DelimitersIndexPalettes[PaletteIndex] := Low(Palette);
end;

//------------------------------------------------------------------------------

end.
