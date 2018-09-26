unit text_objects_3d;

interface

uses
  Graphics, Forms;

const
  CHARS_DEPTH     = 25;
  Z_VALUE         = 800;  //100 is forbidden

  // l'objet sera affiché pendant tout un cycle : fadin (-255 > 0) + DELAY_BEFORE_GLOBE_FADOUT + fadout (0 > -255)
  DELAY_BEFORE_3DTEXT_FADOUT = 250; // objet visible pendant x + (255 * 2)
  DELAY_BEFORE_3DTEXT_FADIN = 850; // durée pendant laquelle l'objet sera invisible
  START_SHIFT = 850; //décalage par rapport au début de l'anim
   
procedure Init3DTextObject(Host : TForm);
procedure Draw3DTextObjects();

implementation

uses
  about_utils;
  
//==============================================================================

const
  S_VERTICES_COUNT      = 12; // 12 pour le "S"
  I_VERTICES_COUNT      = 10; // 10 pour le "i"
  I_DOT_VERTICES_COUNT  = 4; // 4 pour le point sur le "i"
  Z_VERTICES_COUNT      = 10; // 11 pour le "Z"
  O_VERTICES_COUNT_P1   = 4; // exterieur
  O_VERTICES_COUNT_P2   = 4; // interieur
  U_VERTICES_COUNT      = 8;

  S_VERTICES_START          = 0; // de 0..(S_VERTICES_COUNT * 2) - 1
  I_VERTICES_START          = S_VERTICES_START + (S_VERTICES_COUNT * 2); // de (S_VERTICES_COUNT * 2)..(I_VERTICES_COUNT * 2) - 1
  I_DOT_VERTICES_START      = I_VERTICES_START + (I_VERTICES_COUNT * 2); // de (I_VERTICES_COUNT * 2)..(Z_VERTICES_COUNT * 2) - 1
  Z_VERTICES_START          = I_DOT_VERTICES_START + (I_DOT_VERTICES_COUNT * 2);
  _2ND_I_VERTICES_START     = Z_VERTICES_START + (Z_VERTICES_COUNT * 2);
  _2ND_I_DOT_VERTICES_START = _2ND_I_VERTICES_START + (I_VERTICES_COUNT * 2);
  O_VERTICES_START_P1       = _2ND_I_DOT_VERTICES_START + (I_DOT_VERTICES_COUNT * 2);
  O_VERTICES_START_P2       = O_VERTICES_START_P1 + (O_VERTICES_COUNT_P1 * 2);
  U_VERTICES_START          = O_VERTICES_START_P2 + (O_VERTICES_COUNT_P2 * 2);
  _2ND_S_VERTICES_START     = U_VERTICES_START + (U_VERTICES_COUNT * 2);
  
  TOTAL_VERTICES =  (S_VERTICES_COUNT * 2) + (I_VERTICES_COUNT * 2) +
                    (I_DOT_VERTICES_COUNT * 2) + (Z_VERTICES_COUNT * 2) +
                    (I_VERTICES_COUNT * 2) + (I_DOT_VERTICES_COUNT * 2) +
                    (O_VERTICES_COUNT_P1 * 2) + (O_VERTICES_COUNT_P2 * 2) +
                    (U_VERTICES_COUNT * 2) + (S_VERTICES_COUNT * 2);

//------------------------------------------------------------------------------

type
  TPoint3d = record
    x: real;
    y: real;
    z: real;
  end;

  TPoint2d = record
    x: real;
    y: real;
  end;

  TCube = record
    _3d: array[0..TOTAL_VERTICES] of TPoint3d;
    _2d: array[0..TOTAL_VERTICES] of TPoint2d;
  end;

//------------------------------------------------------------------------------

var
  Zmax, Xa, Ya, Za: integer;  //paramètres
  O : TPoint2d;                //origine
  SiZ : TCube;               //objet
  ClientWindow : TForm;
  Palette : array[0..255] of Integer;
  ColorIndex : Integer;
  
  _text_brightness : Integer = -256;
  value : Integer = 1;
  _text_delay_before_fadout : Integer = 0;
  _text_delay_before_fadin : Integer = 0;
  _start_shift : Integer = 0;
  
//==============================================================================

procedure DoObjectShift(VerticesStart, VerticesCount, ShiftValue : Integer);
var
  i : Integer;

begin
  for i := VerticesStart to (VerticesStart + (VerticesCount * 2)) - 1 do
    SiZ._3d[i].x := SiZ._3d[i].x - ShiftValue;
end;

//------------------------------------------------------------------------------

procedure DrawBackFace(VerticesStart, VerticesCount : Integer);
var
  i : Integer;
  
begin
  for i := VerticesStart to (VerticesStart + VerticesCount) - 1 do
  begin
    SiZ._3d[i + VerticesCount].x := SiZ._3d[i].x;
    SiZ._3d[i + VerticesCount].y := SiZ._3d[i].y;
    SiZ._3d[i + VerticesCount].z := CHARS_DEPTH - 100;
  end;
end;

//------------------------------------------------------------------------------

procedure CloneObject(SrcVerticesStart, SrcVerticesCount, DestVerticesStart, Shift : Integer);
var
  i, Index : Integer;
  
begin
  // face avant
  for i := SrcVerticesStart to (SrcVerticesStart + SrcVerticesCount) - 1 do
  begin
    Index := (i - SrcVerticesStart) + DestVerticesStart;   
    SiZ._3d[Index].x := SiZ._3d[i].x;
    SiZ._3d[Index].y := SiZ._3d[i].y;
    SiZ._3d[Index].z := SiZ._3d[i].z;
  end;

  //face arrière
  DrawBackFace(DestVerticesStart, SrcVerticesCount);

  // décalage par rapport au centre
  DoObjectShift(DestVerticesStart, SrcVerticesCount, Shift);
end;

//------------------------------------------------------------------------------

procedure Init3DTextObject(Host : TForm);
var
  x : Integer;
  colorRGB : TRGBColor;
  
begin
  ClientWindow := Host;

  //generate the palette
  ColorIndex := 0;
  for x := Low(palette) to High(palette) do
  begin
      //use HSVtoRGB to vary the Hue of the color through the palette
      colorRGB := HSVtoRGB(ColorHSV(x, 255, 255));
      palette[x] := RGBtoINT(colorRGB);
  end;
  
  _text_brightness := -256;
  value := 1;
  _text_delay_before_fadout := 0;
  _text_delay_before_fadin := 0;
  _start_shift := 0;
  
  //initialisation des angles de départ
  Xa := 0;
  Ya := 0;
  Za := 0;

  //on efface tout sur la Form1 + Pen en vert
  ClientWindow.Repaint;
  ClientWindow.Canvas.Pen.Color := Palette[ColorIndex];

  //définition d'un champ 3d et d'origines
  O.x := ClientWindow.Width div 2;  //centre de la fiche (normal)
  O.y := ClientWindow.Height div 2;
  Zmax := Z_VALUE;

  //définition d'un objet 3d

  // --- Lettre "S" ------------------------------------------------------------

  // face avant
  SiZ._3d[S_VERTICES_START].x     := -100;  SiZ._3d[S_VERTICES_START].y     := -100; SiZ._3d[S_VERTICES_START].z    := -100;
  SiZ._3d[S_VERTICES_START+1].x   :=  100;  SiZ._3d[S_VERTICES_START+1].y   := -100; SiZ._3d[S_VERTICES_START+1].z  := -100;
  SiZ._3d[S_VERTICES_START+2].x   :=  100;  SiZ._3d[S_VERTICES_START+2].y   :=  -50; SiZ._3d[S_VERTICES_START+2].z  := -100;
  SiZ._3d[S_VERTICES_START+3].x   := -50;   SiZ._3d[S_VERTICES_START+3].y   :=  -50; SiZ._3d[S_VERTICES_START+3].z  := -100;
  SiZ._3d[S_VERTICES_START+4].x   := -50;   SiZ._3d[S_VERTICES_START+4].y   :=  -35; SiZ._3d[S_VERTICES_START+4].z  := -100;
  SiZ._3d[S_VERTICES_START+5].x   := 100;   SiZ._3d[S_VERTICES_START+5].y   :=  -35; SiZ._3d[S_VERTICES_START+5].z  := -100;
  SiZ._3d[S_VERTICES_START+6].x   := 100;   SiZ._3d[S_VERTICES_START+6].y   :=  100; SiZ._3d[S_VERTICES_START+6].z  := -100;
  SiZ._3d[S_VERTICES_START+7].x   := -100;  SiZ._3d[S_VERTICES_START+7].y   :=  100; SiZ._3d[S_VERTICES_START+7].z  := -100;
  SiZ._3d[S_VERTICES_START+8].x   := -100;  SiZ._3d[S_VERTICES_START+8].y   :=  50;  SiZ._3d[S_VERTICES_START+8].z  := -100;
  SiZ._3d[S_VERTICES_START+9].x   := 55;    SiZ._3d[S_VERTICES_START+9].y   :=  50;  SiZ._3d[S_VERTICES_START+9].z  := -100;
  SiZ._3d[S_VERTICES_START+10].x  := 55;    SiZ._3d[S_VERTICES_START+10].y  :=  35;  SiZ._3d[S_VERTICES_START+10].z := -100;
  SiZ._3d[S_VERTICES_START+11].x  := -100;  SiZ._3d[S_VERTICES_START+11].y  :=  35;  SiZ._3d[S_VERTICES_START+11].z := -100;

  // face arrière
  DrawBackFace(S_VERTICES_START, S_VERTICES_COUNT);

  // décalage de 200 px par rapport au centre
  DoObjectShift(S_VERTICES_START, S_VERTICES_COUNT, 600);

  // --- Lettre "i" ------------------------------------------------------------

  // le "i" (face avant)
  SiZ._3d[I_VERTICES_START].x     := -10;  SiZ._3d[I_VERTICES_START].y     := -60; SiZ._3d[I_VERTICES_START].z    := -100;
  SiZ._3d[I_VERTICES_START+1].x   :=  75;  SiZ._3d[I_VERTICES_START+1].y   := -60; SiZ._3d[I_VERTICES_START+1].z  := -100;
  SiZ._3d[I_VERTICES_START+2].x   :=  75;  SiZ._3d[I_VERTICES_START+2].y   :=  40; SiZ._3d[I_VERTICES_START+2].z  := -100;
  SiZ._3d[I_VERTICES_START+3].x   := 120;  SiZ._3d[I_VERTICES_START+3].y   :=  40; SiZ._3d[I_VERTICES_START+3].z  := -100;
  SiZ._3d[I_VERTICES_START+4].x   := 120;  SiZ._3d[I_VERTICES_START+4].y   :=  100; SiZ._3d[I_VERTICES_START+4].z  := -100;
  SiZ._3d[I_VERTICES_START+5].x   := -30;  SiZ._3d[I_VERTICES_START+5].y   :=  100; SiZ._3d[I_VERTICES_START+5].z  := -100;
  SiZ._3d[I_VERTICES_START+6].x   := -30;  SiZ._3d[I_VERTICES_START+6].y   :=  40; SiZ._3d[I_VERTICES_START+6].z  := -100;
  SiZ._3d[I_VERTICES_START+7].x   := 20;   SiZ._3d[I_VERTICES_START+7].y   :=  40; SiZ._3d[I_VERTICES_START+7].z  := -100;
  SiZ._3d[I_VERTICES_START+8].x   := 20;   SiZ._3d[I_VERTICES_START+8].y   :=  -10;  SiZ._3d[I_VERTICES_START+8].z  := -100;
  SiZ._3d[I_VERTICES_START+9].x   := -10;  SiZ._3d[I_VERTICES_START+9].y   :=  -10;  SiZ._3d[I_VERTICES_START+9].z  := -100;

  // "i" face arrière
  DrawBackFace(I_VERTICES_START, I_VERTICES_COUNT);

  // le point sur le "i"
  SiZ._3d[I_DOT_VERTICES_START].x := -10; SiZ._3d[I_DOT_VERTICES_START].y := -100; SiZ._3d[I_DOT_VERTICES_START].z := -100;
  SiZ._3d[I_DOT_VERTICES_START+1].x :=  75; SiZ._3d[I_DOT_VERTICES_START+1].y := -100; SiZ._3d[I_DOT_VERTICES_START+1].z := -100;
  SiZ._3d[I_DOT_VERTICES_START+2].x :=  75; SiZ._3d[I_DOT_VERTICES_START+2].y :=  -70; SiZ._3d[I_DOT_VERTICES_START+2].z := -100;
  SiZ._3d[I_DOT_VERTICES_START+3].x := -10; SiZ._3d[I_DOT_VERTICES_START+3].y :=  -70; SiZ._3d[I_DOT_VERTICES_START+3].z := -100;

  // le point sur le "i" face arrière
  DrawBackFace(I_DOT_VERTICES_START, I_DOT_VERTICES_COUNT);

  // décalage par rapport au centre
  DoObjectShift(I_VERTICES_START, I_VERTICES_COUNT, 450);
  DoObjectShift(I_DOT_VERTICES_START, I_DOT_VERTICES_COUNT, 450);
  
  // --- Lettre "Z" ------------------------------------------------------------

  // lettre "Z" face avant
  SiZ._3d[Z_VERTICES_START+0].x := -100; SiZ._3d[Z_VERTICES_START+0].y := -100; SiZ._3d[Z_VERTICES_START+0].z := -100;
  SiZ._3d[Z_VERTICES_START+1].x :=  100; SiZ._3d[Z_VERTICES_START+1].y := -100; SiZ._3d[Z_VERTICES_START+1].z := -100;
  SiZ._3d[Z_VERTICES_START+2].x :=  100; SiZ._3d[Z_VERTICES_START+2].y :=  -50; SiZ._3d[Z_VERTICES_START+2].z := -100;
  SiZ._3d[Z_VERTICES_START+3].x := 0; SiZ._3d[Z_VERTICES_START+3].y :=  50; SiZ._3d[Z_VERTICES_START+3].z := -100;
  SiZ._3d[Z_VERTICES_START+4].x := 100; SiZ._3d[Z_VERTICES_START+4].y :=  50; SiZ._3d[Z_VERTICES_START+4].z := -100;
  SiZ._3d[Z_VERTICES_START+5].x := 100; SiZ._3d[Z_VERTICES_START+5].y :=  100; SiZ._3d[Z_VERTICES_START+5].z := -100;
  SiZ._3d[Z_VERTICES_START+6].x := -100; SiZ._3d[Z_VERTICES_START+6].y :=  100; SiZ._3d[Z_VERTICES_START+6].z := -100;
  SiZ._3d[Z_VERTICES_START+7].x := -100; SiZ._3d[Z_VERTICES_START+7].y :=  50; SiZ._3d[Z_VERTICES_START+7].z := -100;
  SiZ._3d[Z_VERTICES_START+8].x := 0; SiZ._3d[Z_VERTICES_START+8].y :=  -50; SiZ._3d[Z_VERTICES_START+8].z := -100;
  SiZ._3d[Z_VERTICES_START+9].x := -100; SiZ._3d[Z_VERTICES_START+9].y :=  -50; SiZ._3d[Z_VERTICES_START+9].z := -100;

  //face arrière
  DrawBackFace(Z_VERTICES_START, Z_VERTICES_COUNT);

  // décalage par rapport au centre
  DoObjectShift(Z_VERTICES_START, Z_VERTICES_COUNT, 200);

  // --- Deuxième lettre "i" ------------------------------------------------------------

  CloneObject(I_VERTICES_START, I_VERTICES_COUNT, _2ND_I_VERTICES_START, -400);
  CloneObject(I_DOT_VERTICES_START, I_DOT_VERTICES_COUNT, _2ND_I_DOT_VERTICES_START, -400);

  // --- Lettre "O" ------------------------------------------------------------

  // face avant (exterieur)
  SiZ._3d[O_VERTICES_START_P1+0].x := -100; SiZ._3d[O_VERTICES_START_P1+0].y := -100; SiZ._3d[O_VERTICES_START_P1+0].z := -100;
  SiZ._3d[O_VERTICES_START_P1+1].x :=  100; SiZ._3d[O_VERTICES_START_P1+1].y := -100; SiZ._3d[O_VERTICES_START_P1+1].z := -100;
  SiZ._3d[O_VERTICES_START_P1+2].x :=  100; SiZ._3d[O_VERTICES_START_P1+2].y :=  100; SiZ._3d[O_VERTICES_START_P1+2].z := -100;
  SiZ._3d[O_VERTICES_START_P1+3].x := -100; SiZ._3d[O_VERTICES_START_P1+3].y :=  100; SiZ._3d[O_VERTICES_START_P1+3].z := -100;

  //face arrière (exterieur)
  DrawBackFace(O_VERTICES_START_P1, O_VERTICES_COUNT_P1);

  // face avant (interieur)
  SiZ._3d[O_VERTICES_START_P2+0].x := -25; SiZ._3d[O_VERTICES_START_P2+0].y := -30; SiZ._3d[O_VERTICES_START_P2+0].z := -100;
  SiZ._3d[O_VERTICES_START_P2+1].x :=  25; SiZ._3d[O_VERTICES_START_P2+1].y := -30; SiZ._3d[O_VERTICES_START_P2+1].z := -100;
  SiZ._3d[O_VERTICES_START_P2+2].x :=  25; SiZ._3d[O_VERTICES_START_P2+2].y :=  30; SiZ._3d[O_VERTICES_START_P2+2].z := -100;
  SiZ._3d[O_VERTICES_START_P2+3].x := -25; SiZ._3d[O_VERTICES_START_P2+3].y :=  30; SiZ._3d[O_VERTICES_START_P2+3].z := -100;

  // face arrière (interieur)
  DrawBackFace(O_VERTICES_START_P2, O_VERTICES_COUNT_P2);

  // décalage par rapport au centre
  DoObjectShift(O_VERTICES_START_P1, O_VERTICES_COUNT_P1, -190);
  DoObjectShift(O_VERTICES_START_P2, O_VERTICES_COUNT_P2, -190);

  // --- Lettre "U" ------------------------------------------------------------

  // face avant
  SiZ._3d[U_VERTICES_START+0].x := 30; SiZ._3d[U_VERTICES_START+0].y := -100; SiZ._3d[U_VERTICES_START+0].z := -100;
  SiZ._3d[U_VERTICES_START+1].x :=  100; SiZ._3d[U_VERTICES_START+1].y := -100; SiZ._3d[U_VERTICES_START+1].z := -100;
  SiZ._3d[U_VERTICES_START+2].x :=  100; SiZ._3d[U_VERTICES_START+2].y :=  100; SiZ._3d[U_VERTICES_START+2].z := -100;
  SiZ._3d[U_VERTICES_START+3].x := -100; SiZ._3d[U_VERTICES_START+3].y :=  100; SiZ._3d[U_VERTICES_START+3].z := -100;
  SiZ._3d[U_VERTICES_START+4].x := -100; SiZ._3d[U_VERTICES_START+4].y :=  -100; SiZ._3d[U_VERTICES_START+4].z := -100;
  SiZ._3d[U_VERTICES_START+5].x := -30; SiZ._3d[U_VERTICES_START+5].y :=  -100; SiZ._3d[U_VERTICES_START+5].z := -100;
  SiZ._3d[U_VERTICES_START+6].x := -30; SiZ._3d[U_VERTICES_START+6].y :=  50; SiZ._3d[U_VERTICES_START+6].z := -100;
  SiZ._3d[U_VERTICES_START+7].x := 30; SiZ._3d[U_VERTICES_START+7].y :=  50; SiZ._3d[U_VERTICES_START+7].z := -100;

  // face arrière
  DrawBackFace(U_VERTICES_START, U_VERTICES_COUNT);

  // décalage par rapport au centre
  DoObjectShift(U_VERTICES_START, U_VERTICES_COUNT, -410);

  // --- Lettre "S" ------------------------------------------------------------

  CloneObject(S_VERTICES_START, S_VERTICES_COUNT, _2ND_S_VERTICES_START, -1240);
end;
  
//------------------------------------------------------------------------------

procedure DoLine(point1, point2: TPoint2d);
begin
  ClientWindow.Canvas.MoveTo(round(point1.x), round(point1.y));
  ClientWindow.Canvas.LineTo(round(point2.x), round(point2.y));
end;

//------------------------------------------------------------------------------

function Point2d(X, Y : Real) : TPoint2d;
begin
  Result.x := X;
  Result.y := Y;
end;

//------------------------------------------------------------------------------

function Rotation(point: TPoint3d): TPoint3d;
var
  matrice: array[0..2] of array[0..2] of real;
  Xb, Yb, Zb: real;
begin
  //conversion deg > rad
  Xb := Xa * pi / 180;
  Yb := Ya * pi / 180;
  Zb := Za * pi / 180;

  matrice[0,0] := cos(Zb)*cos(Yb);
  matrice[1,0] := sin(Zb)*cos(Yb);
  matrice[2,0] := -sin(Yb);
  matrice[0,1] := cos(Zb)*sin(Yb)*sin(Xb) - sin(Zb)*cos(Xb);
  matrice[1,1] := sin(Zb)*sin(Yb)*sin(Xb) + cos(Xb)*cos(Zb);
  matrice[2,1] := sin(Xb)*cos(Yb);
  matrice[0,2] := cos(Zb)*sin(Yb)*cos(Xb) + sin(Zb)*sin(Xb);
  matrice[1,2] := sin(Zb)*sin(Yb)*cos(Xb) - cos(Zb)*sin(Xb);
  matrice[2,2] := cos(Xb)*cos(Yb);

  result.x := matrice[0,0]*point.x +
              matrice[1,0]*point.y +
              matrice[2,0]*point.z ;
  result.y := matrice[0,1]*point.x +
              matrice[1,1]*point.y +
              matrice[2,1]*point.z ;
  result.z := matrice[0,2]*point.x +
              matrice[1,2]*point.y +
              matrice[2,2]*point.z ;

end;

//------------------------------------------------------------------------------

function DoProjection(point: TPoint3d): TPoint2d;
begin
  result.x := (point.x * 256) / (point.z + Zmax) + O.x;
  result.y := (point.y * 256) / (point.z + Zmax) + O.y;
end;

//------------------------------------------------------------------------------

procedure DrawObject(VerticesStart, VerticesCount : Integer);
var
  i : Integer;
  
begin
  //face avant
  for i := VerticesStart to (VerticesStart + VerticesCount) - 2 do
  begin
    DoLine(SiZ._2d[i], SiZ._2d[i+1]);
  end;
  DoLine(SiZ._2d[VerticesStart], SiZ._2d[(VerticesStart + VerticesCount) - 1]);

  //face arrière
  for i := (VerticesStart + VerticesCount) to ((VerticesStart + VerticesCount) + VerticesCount) - 2 do
    DoLine(SiZ._2d[i], SiZ._2d[i+1]);
  DoLine(SiZ._2d[VerticesStart + VerticesCount], SiZ._2d[(VerticesStart + VerticesCount * 2) - 1]);

  // arêtes de coté
  for i := VerticesStart to VerticesStart + VerticesCount - 1 do
    DoLine(SiZ._2d[i], SiZ._2d[i + VerticesCount]);
end;

//------------------------------------------------------------------------------

procedure Draw3DTextObjects();
var
  i : Integer;
  
begin
  //calcul de la rotation
  //projection 3d -> 2d
  for i := Low(SiZ._2d) to High(SiZ._2d) do
    SiZ._2d[i] := DoProjection( Rotation(SiZ._3d[i]) );

  //affichage sur le canvas
  //ClientWindow.Repaint;

  ClientWindow.Canvas.Pen.Color := ChangeBrightness(Palette[ColorIndex], _text_brightness);
  if (_start_shift = START_SHIFT) then
    _text_brightness := _text_brightness + value
  else
    begin
      Inc(_start_shift);
      Exit;
    end;

  // luminosité
  if _text_brightness > 0 then
  begin
    _text_brightness := 0;

    if _text_delay_before_fadout >= DELAY_BEFORE_3DTEXT_FADOUT then
    begin
      value := -1; //relancer le fade out
      _text_delay_before_fadout := 0;
      _text_delay_before_fadin := 0;
    end;
    
    Inc(_text_delay_before_fadout);
  end;

  if _text_brightness < -255 then
  begin
    _text_brightness := -255;
    
    if _text_delay_before_fadin >= DELAY_BEFORE_3DTEXT_FADIN then
    begin
      value := 1;
      _text_delay_before_fadin := 0;
      _text_delay_before_fadout := 0;
    end;
    
    Inc(_text_delay_before_fadin);
    Exit;
  end;


    
  Inc(ColorIndex);
  if ColorIndex > High(Palette) then ColorIndex := 0;
  
  //ClientWindow.Canvas.Pen.Color := clWhite;

  // dessiner le texte en 3D.
  
  DrawObject(S_VERTICES_START, S_VERTICES_COUNT); //lettre "S"

  DrawObject(I_VERTICES_START, I_VERTICES_COUNT); // "i" principal
  DrawObject(I_DOT_VERTICES_START, I_DOT_VERTICES_COUNT); // point sur le "i"

  DrawObject(Z_VERTICES_START, Z_VERTICES_COUNT);  // "z"

  DrawObject(_2ND_I_VERTICES_START, I_VERTICES_COUNT); // "i"
  DrawObject(_2ND_I_DOT_VERTICES_START, I_DOT_VERTICES_COUNT);

  DrawObject(O_VERTICES_START_P1, O_VERTICES_COUNT_P1); // "o"
  DrawObject(O_VERTICES_START_P2, O_VERTICES_COUNT_P2);

  DrawObject(U_VERTICES_START, U_VERTICES_COUNT); // "u"

  DrawObject(_2ND_S_VERTICES_START, S_VERTICES_COUNT); //"s"

  // --- Fin -------------------------------------------------------------------
  
  //on avance la rotation
  Xa := (Xa+1) mod 360;
  Ya := (Ya+3) mod 360;
  Za := (Za+1) mod 360;
end;

//------------------------------------------------------------------------------

end.
