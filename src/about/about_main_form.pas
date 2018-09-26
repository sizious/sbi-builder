unit about_main_form;

interface

uses
  Windows, Messages, ExtCtrls, Controls, Classes, Forms, StdCtrls, Graphics;

const
  LARGE_SPACE = '                         ';

  SCROLLER_TEXT = 'Trust me, Dreamcast was a true revolution...'        
    + LARGE_SPACE + 'So this is the lastest version of SBI Builder...'
    + LARGE_SPACE + 'Nice huh ? I hope you''ll enjoy it...'
    + LARGE_SPACE + 'Dreamcast''ll never die, you know ? Yup that''s right, '
    + 'we have a lot of work to do !'
    + LARGE_SPACE + 'See you in next release ... '
    + LARGE_SPACE + 'Greets to all my scene friends...'
    + LARGE_SPACE + 'Enjoy, SiZ!';

  TEXT_SCROLLER_SPEED = 2;
  TEXT_SCROLLER_START_LEFT_OFFSET = 800;

type
  TfrmAboutDemo = class(TForm)
    tGlobe: TTimer;
    pBottom: TPanel;
    pDelimiterTop: TPanel;
    pTop: TPanel;
    pLogo: TPanel;
    iLogo: TImage;
    iTextScroller: TImage;
    tTextScroller: TTimer;
    pDelimiterBottom: TPanel;
    tStart: TTimer;
    procedure tGlobeTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure tTextScrollerTimer(Sender: TObject);
    procedure tStartTimer(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  frmAboutDemo: TfrmAboutDemo;

implementation

uses
  globe, delimiters, about_utils, bitmap_font, MiniFMOD, text_objects_3d;

{$R *.dfm}
{$R resources.RES}

procedure TfrmAboutDemo.tGlobeTimer(Sender: TObject);
begin
  //clear window to all black before plotting new points
  Canvas.Brush.Color := clBlack;
  Canvas.FillRect(Rect(0, 0, Width, Height));

  DrawGlobe();
  Draw3DTextObjects();
end;

//------------------------------------------------------------------------------

procedure TfrmAboutDemo.FormCreate(Sender: TObject);
var
  i : Integer;

begin
  for i := 0 to ComponentCount - 1 do
    if Components[i] is TPanel then (Components[i] as TPanel).ParentBackground := False;
     
  //Application.Title := Caption;

  pDelimiterTop.Color := clBlack;
  pDelimiterBottom.Color := clBlack;
  Color := clBlack;
  
  InitGlobe(Self);

  InitDelimiters();
  SetDelimiterPaletteStartValue(1, 128); // pour le delimiter 2 (n°1 dans le tab) on va commencer à colorier à partir de la valeur 128 (et pas 0)

  iLogo.Picture.Bitmap.LoadFromResourceName(hInstance, 'LOGO');
  BitmapToControl(pLogo.Handle, iLogo.Picture.Bitmap, iLogo.Picture.Bitmap.Canvas.Pixels[0, 0]);

  iTextScroller.Left := Self.Width + TEXT_SCROLLER_START_LEFT_OFFSET;
  iTextScroller.Left := iTextScroller.Left;

  CreateBitmapLabel(SCROLLER_TEXT, iTextScroller.Picture.Bitmap);
  
  iTextScroller.AutoSize := True;
  
  DoubleBuffered := True;

  Init3DTextObject(Self);

  pTop.Top := - pTop.Height;
  pBottom.Top := Height;
  pLogo.Left := - pLogo.Width;
end;

//------------------------------------------------------------------------------

procedure TfrmAboutDemo.FormDestroy(Sender: TObject);
begin
  XMFree();
end;

//------------------------------------------------------------------------------

procedure TfrmAboutDemo.FormShow(Sender: TObject);
begin
  XMLoadFromRes('XM', 'MUSIC');
  XMPlay();

  tStart.Enabled := True;
end;

//------------------------------------------------------------------------------

procedure TfrmAboutDemo.tTextScrollerTimer(Sender: TObject);
begin
  DrawDelimiter(pDelimiterTop);
  DrawDelimiter(pDelimiterBottom, 1);

  iTextScroller.Left := iTextScroller.Left - TEXT_SCROLLER_SPEED;
  if (iTextScroller.Left + iTextScroller.Width < 0) then
    iTextScroller.Left := Self.Width + TEXT_SCROLLER_START_LEFT_OFFSET;
end;

//------------------------------------------------------------------------------

procedure TfrmAboutDemo.tStartTimer(Sender: TObject);
begin
  if pTop.Top < 0 then pTop.Top := pTop.Top + 2;
  if (pBottom.Top) > (ClientHeight - pBottom.Height) then pBottom.Top := pBottom.Top - 2;
  if (pLogo.Left < 96) then pLogo.Left := pLogo.Left + 10;
  
  tStart.Enabled := (pTop.Top < 0) or (pBottom.Top > (ClientHeight - pBottom.Height)) or (pLogo.Left < 96);
  tGlobe.Enabled := not tStart.Enabled;
  tTextScroller.Enabled := not tStart.Enabled;
end;

procedure TfrmAboutDemo.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then Close;
end;

end.
