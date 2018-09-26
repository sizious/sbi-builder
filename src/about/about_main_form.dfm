object frmAboutDemo: TfrmAboutDemo
  Left = 275
  Top = 179
  BorderStyle = bsDialog
  Caption = 
    'About [big_fury]SiZiOUS ... (Thanks to GED TOON and TheWhiteShad' +
    'ow you know why)'
  ClientHeight = 446
  ClientWidth = 632
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Shell Dlg 2'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pBottom: TPanel
    Left = 0
    Top = 386
    Width = 632
    Height = 60
    BevelOuter = bvNone
    Color = clNavy
    TabOrder = 0
    object iTextScroller: TImage
      Left = 8
      Top = 15
      Width = 615
      Height = 33
    end
    object pDelimiterBottom: TPanel
      Left = 0
      Top = 0
      Width = 632
      Height = 2
      Align = alTop
      BevelOuter = bvNone
      Color = clGreen
      TabOrder = 0
    end
  end
  object pTop: TPanel
    Left = 0
    Top = 0
    Width = 632
    Height = 60
    BevelOuter = bvNone
    Color = clNavy
    TabOrder = 1
    object pDelimiterTop: TPanel
      Left = 0
      Top = 58
      Width = 632
      Height = 2
      Align = alBottom
      BevelOuter = bvNone
      Color = clGreen
      TabOrder = 0
    end
  end
  object pLogo: TPanel
    Left = 96
    Top = 72
    Width = 450
    Height = 146
    BevelOuter = bvNone
    Color = clGreen
    Constraints.MinHeight = 146
    TabOrder = 2
    object iLogo: TImage
      Left = 0
      Top = 0
      Width = 450
      Height = 144
      Transparent = True
    end
  end
  object tGlobe: TTimer
    Enabled = False
    Interval = 10
    OnTimer = tGlobeTimer
    Left = 8
    Top = 8
  end
  object tTextScroller: TTimer
    Enabled = False
    Interval = 1
    OnTimer = tTextScrollerTimer
    Left = 8
    Top = 394
  end
  object tStart: TTimer
    Enabled = False
    Interval = 1
    OnTimer = tStartTimer
    Left = 592
    Top = 8
  end
end
