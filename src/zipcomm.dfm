object ZipComment_Form: TZipComment_Form
  Left = 307
  Top = 177
  BorderStyle = bsDialog
  Caption = 'Create a SBI Comment Text File'
  ClientHeight = 425
  ClientWidth = 489
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Shell Dlg 2'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnClose = FormClose
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lWhats: TLabel
    Left = 536
    Top = 120
    Width = 39
    Height = 13
    Caption = ' What'#39's '
  end
  object lWhoMade: TLabel
    Left = 536
    Top = 136
    Width = 54
    Height = 13
    Caption = 'Who made '
  end
  object lHowToPlay: TLabel
    Left = 536
    Top = 152
    Width = 69
    Height = 13
    Caption = 'How do I play '
  end
  object gbWhatFilesDoINeedToAdd: TGroupBox
    Left = 8
    Top = 8
    Width = 233
    Height = 129
    Caption = ' What files do I need to add ? : '
    TabOrder = 0
    object mWhatFileDoINeedToAdd: TMemo
      Left = 8
      Top = 16
      Width = 217
      Height = 105
      ScrollBars = ssBoth
      TabOrder = 0
      OnChange = mWhatFileDoINeedToAddChange
    end
  end
  object gbWhatsThis: TGroupBox
    Left = 248
    Top = 8
    Width = 233
    Height = 129
    TabOrder = 1
    object mWhatsThis: TMemo
      Left = 8
      Top = 16
      Width = 217
      Height = 105
      ScrollBars = ssBoth
      TabOrder = 0
      OnChange = mWhatsThisChange
    end
  end
  object gbWhoMadeThis: TGroupBox
    Left = 8
    Top = 144
    Width = 233
    Height = 129
    TabOrder = 2
    object mWhoMadeThis: TMemo
      Left = 8
      Top = 16
      Width = 217
      Height = 105
      ScrollBars = ssBoth
      TabOrder = 0
      OnChange = mWhoMadeThisChange
    end
  end
  object gbHowDoIPlayThis: TGroupBox
    Left = 248
    Top = 144
    Width = 233
    Height = 129
    TabOrder = 3
    object mHowDoIPlayThis: TMemo
      Left = 8
      Top = 16
      Width = 217
      Height = 105
      ScrollBars = ssBoth
      TabOrder = 0
      OnChange = mHowDoIPlayThisChange
    end
  end
  object gbControls: TGroupBox
    Left = 8
    Top = 280
    Width = 473
    Height = 105
    Caption = ' Controls : '
    TabOrder = 4
    object mControls: TMemo
      Left = 8
      Top = 16
      Width = 457
      Height = 81
      ScrollBars = ssBoth
      TabOrder = 0
      OnChange = mControlsChange
    end
  end
  object bCreateTheFile: TButton
    Left = 8
    Top = 392
    Width = 153
    Height = 25
    Caption = '&Create the file...'
    TabOrder = 5
    OnClick = bCreateTheFileClick
  end
  object bClearAllFields: TButton
    Left = 168
    Top = 392
    Width = 153
    Height = 25
    Caption = 'C&lear all fields...'
    TabOrder = 6
    OnClick = bClearAllFieldsClick
  end
  object bCancelThisOperation: TButton
    Left = 328
    Top = 392
    Width = 153
    Height = 25
    Caption = 'C&ancel this operation'
    TabOrder = 7
    OnClick = bCancelThisOperationClick
  end
end
