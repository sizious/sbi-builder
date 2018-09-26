object frmConfig: TfrmConfig
  Left = 419
  Top = 299
  BorderStyle = bsDialog
  Caption = 'Configuration'
  ClientHeight = 160
  ClientWidth = 313
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Shell Dlg 2'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 8
    Top = 120
    Width = 297
    Height = 2
  end
  object gbOptions: TGroupBox
    Left = 8
    Top = 8
    Width = 297
    Height = 41
    Caption = ' Options : '
    TabOrder = 0
    object cbSplash: TCheckBox
      Left = 8
      Top = 16
      Width = 281
      Height = 17
      Caption = '&Show splash screen at startup'
      Checked = True
      State = cbChecked
      TabOrder = 0
    end
  end
  object gbLangSel: TGroupBox
    Left = 8
    Top = 56
    Width = 297
    Height = 57
    Caption = ' Language selection : '
    TabOrder = 1
    object lHintLang: TLabel
      Left = 8
      Top = 16
      Width = 185
      Height = 33
      AutoSize = False
      Caption = 'If you want to change the language please click on this button.'
      WordWrap = True
    end
    object bRestart: TButton
      Left = 200
      Top = 18
      Width = 86
      Height = 25
      Caption = '&Change ...'
      TabOrder = 0
      OnClick = bRestartClick
    end
  end
  object bOK: TButton
    Left = 144
    Top = 128
    Width = 75
    Height = 25
    Caption = '&OK'
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object bCancel: TButton
    Left = 224
    Top = 128
    Width = 75
    Height = 25
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 3
  end
end
