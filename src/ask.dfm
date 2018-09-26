object Ask_Form: TAsk_Form
  Left = 363
  Top = 285
  BorderStyle = bsDialog
  Caption = 'Ask_Form'
  ClientHeight = 98
  ClientWidth = 282
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Shell Dlg 2'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object gbAsk: TGroupBox
    Left = 8
    Top = 8
    Width = 265
    Height = 49
    TabOrder = 0
    object eAsk: TEdit
      Left = 8
      Top = 16
      Width = 249
      Height = 21
      TabOrder = 0
    end
  end
  object bOK: TBitBtn
    Left = 8
    Top = 64
    Width = 89
    Height = 25
    TabOrder = 1
    Kind = bkOK
  end
  object bCancel: TBitBtn
    Left = 184
    Top = 64
    Width = 89
    Height = 25
    Caption = 'Cancel'
    TabOrder = 2
    Kind = bkCancel
  end
end
