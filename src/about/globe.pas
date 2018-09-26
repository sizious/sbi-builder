unit globe;

interface

uses
  Windows, Graphics, Types, Forms;
  
procedure InitGlobe(client : TForm);
procedure DrawGlobe();
procedure UpdateClientWindowSize(ClientWindow : TForm);

implementation

uses
  Math, about_utils;
  
const
  RADIUS = 80;
  SCALE  = 50;
  SLICES = 12;
  PPS    = 20;

  // l'objet sera affiché pendant tout un cycle : fadin (-255 > 0) + DELAY_BEFORE_GLOBE_FADOUT + fadout (0 > -255)
  DELAY_BEFORE_GLOBE_FADOUT = 250;  // objet visible pendant x + (255 * 2)
  DELAY_BEFORE_GLOBE_FADIN = 850; // durée pendant laquelle l'objet sera invisible

var
  ClientWindow : TForm;
  
  XAngle, YAngle, ZAngle, Distance, Dir : Integer;
  cxClient, cyClient : Integer;
  
  Points : array[0..SLICES, 0..PPS] of TPoint3D;
  Ball : array[0..SLICES, 0..PPS] of TPoint3D;

  SinTable : array[0..255] of Integer;
  CosTable : array[0..255] of Integer;

  ColorIndex : Integer = 0;
  Palette : array[0..255] of Integer;

  _globe_brightness : Integer = -255;
  value : Integer = 1;
  _globe_delay_before_fadout : Integer = 0;
  _globe_delay_before_fadin : Integer = 0;
  
//------------------------------------------------------------------------------

procedure UpdateClientWindowSize(ClientWindow : TForm);
begin
  cxClient := ClientWindow.Width;
  cyClient := ClientWindow.Height;
end;

//------------------------------------------------------------------------------

procedure SetupBall();
var
  slice, point : Integer;
  Phi , Theta : Double;

begin

  for slice := 0 to SLICES - 1 do
  begin
    Phi := PI / SLICES * slice;
    for point := 0 TO PPS - 1 do
    begin
      Theta := 2 * PI / PPS * point;

      // Convert Radius, Theta and Phi to x, y, z coords
      Ball[slice][point].y := Ceil((RADIUS * sin ( Phi ) * cos(Theta)));
      Ball[slice][point].x := Ceil((RADIUS * sin ( Phi ) * sin(Theta)));
      Ball[slice][point].z := Ceil(RADIUS * cos ( Phi));
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure InitGlobe(client : TForm);
var
  loop : Integer;
  ColorRGB : TRGBColor;
  x : Integer;

begin
  for loop := 0 TO 255 do
  begin
    SinTable[loop] := Ceil( sin( PI * 2 / 255 * loop ) * 128 );
    CosTable[loop] := Ceil( cos( PI * 2 / 255 * loop ) * 128 );
  end;

  Distance := 100;
  Dir      := -3;
  SetupBall();

  XAngle := 0;
  YAngle := 0;
  ZAngle := 0;

  cxClient := client.Width;
  cyClient := client.Height;

  //generate the palette
  for x := Low(palette) to High(palette) do
  begin
      //use HSVtoRGB to vary the Hue of the color through the palette
      colorRGB := HSVtoRGB(ColorHSV(x, 255, 255));
      palette[x] := RGBtoINT(colorRGB);
  end;

  ClientWindow := client; 
  
  ColorIndex := 0;
  _globe_brightness := -255;
  value := 1;
  _globe_delay_before_fadout := 0;
  _globe_delay_before_fadin := 0;
end;

//------------------------------------------------------------------------------

procedure RotateGlobe();
var
  i, i2, TempX, TempY, TempZ, OldTempX : Integer;

begin

  for i := 0 to SLICES - 1 do
    for i2 := 0 to PPS - 1 do
    begin
      TempY := (Ball[i][i2].y * CosTable[XAngle] - Ball[i][i2].z * SinTable[XAngle]) div 128;
      TempZ := (Ball[i][i2].y * SinTable[XAngle] + Ball[i][i2].z * CosTable[XAngle]) div 128;
      TempX := (Ball[i][i2].x * CosTable[YAngle] - TempZ * SinTable[YAngle]) div 128;
      TempZ := (Ball[i][i2].x * SinTable[YAngle] + TempZ * CosTable[YAngle]) div 128;
      OldTempX := TempX;
      TempX := (TempX * CosTable[ZAngle] - TempY * SinTable[ZAngle]) div 128;
      TempY := (OldTempX * SinTable[ZAngle] + TempY * CosTable[ZAngle]) div 128;
      Points[i][i2].x := (TempX * SCALE) div Distance + cxClient div 2;
      Points[i][i2].y := (TempY * SCALE) div Distance + cyClient div 2 ;
      Points[i][i2].z := TempZ;
    end;

end;

//------------------------------------------------------------------------------

procedure DrawPoints();
var
  i, i2 : Integer;
  tmpColor : TColor;
  
begin
  //if not Fading then
  Inc(ColorIndex);
  if ColorIndex > High(Palette) then ColorIndex := 0;
  
  tmpColor := Palette[ColorIndex];

  // luminosité
  tmpColor := ChangeBrightness(tmpColor, _globe_brightness);
  _globe_brightness := _globe_brightness + value;
  
  if _globe_brightness > 0 then
  begin
    _globe_brightness := 0;

    if _globe_delay_before_fadout >= DELAY_BEFORE_GLOBE_FADOUT then
    begin
      value := -1; //relancer le fade out
      _globe_delay_before_fadout := 0;
      _globe_delay_before_fadin := 0;
    end;

    Inc(_globe_delay_before_fadout);
  end;

  if _globe_brightness < -255 then
  begin
    _globe_brightness := -255;

    if _globe_delay_before_fadin >= DELAY_BEFORE_GLOBE_FADIN then
    begin
      value := 1;
      _globe_delay_before_fadin := 0;
       _globe_delay_before_fadout := 0;
    end;

    Inc(_globe_delay_before_fadin);
    Exit; //sinon ça dessine des points noirs
  end;

  //tmpColor := clWhite;
  
  // dessiner le globe
  for i := 0 to SLICES - 1 do
    for i2 := 0 TO PPS - 1 do
      if Points[i][i2].z >= 0 then
      begin
        ClientWindow.Canvas.Pixels[Points[i][i2].x, Points[i][i2].y] := tmpColor;
        ClientWindow.Canvas.Pixels[Points[i][i2].x+1, Points[i][i2].y] := tmpColor;
        ClientWindow.Canvas.Pixels[Points[i][i2].x, Points[i][i2].y+1] := tmpColor;
        ClientWindow.Canvas.Pixels[Points[i][i2].x+1, Points[i][i2].y+1] := tmpColor;
      end;
end;

//------------------------------------------------------------------------------

procedure DrawGlobe();
begin
  if (cxClient = 0) or (cyClient = 0) then Exit;
  Sleep (1);

  //MessageBoxA(0, 'ok', '', 0);
  
  RotateGlobe();
  DrawPoints();

  XAngle  := XAngle +  3;
  YAngle  := YAngle +  2;
  ZAngle  := ZAngle +  1;
  Distance := Distance + Dir;
  
  if XAngle    > 250  then XAngle  :=  0;
  if YAngle    > 250  then YAngle  :=  0;
  if ZAngle    > 250  then ZAngle  :=  0;
  if Distance >= 100  then Dir     := -1;
  if Distance <=  20  then Dir     :=  1;
end;

//------------------------------------------------------------------------------


end.
