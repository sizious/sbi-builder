object Log_Form: TLog_Form
  Left = 336
  Top = 190
  Width = 447
  Height = 396
  Caption = 'DEBUG LOG'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Shell Dlg 2'
  Font.Style = []
  Icon.Data = {
    0000010001001010000001000800680500001600000028000000100000002000
    0000010008000000000040010000000000000000000000000000000000000000
    00009C5100008B4700007D4000006B350000E4C7A800E3CFB800E3CDB400E4CA
    AE00E4C4A000E5C19900F5EDE400F6E9DB00F6E3CE00F7DCBF00F5ECE200DCBC
    9800DCBB9500FCF4EB00DDBA9300DDB88F00FCECDA00DDB68C00DEB48800FDE3
    C600FBF7F300FBF7F100ECD6BD00FCF4EC00FCF3E900FCF1E500EDD2B400FCED
    DC00FCEBD800FCE9D300EDCDAA00FDE4C900FDE2C200FBF6EF00FBF5EE00FCF3
    EA00FCF2E600FCF0E200FCEEDE00FCEAD500FDE7D100FDE5CC00FDE3C500FDDF
    BC00DEB28100C77E2E00E2B27C00D49A5B00C77D2C00C77C2B00D4975400DFAB
    7100E6B88400FDE1C000FCDBB200FCF1E400FCEFE000FCEEDC00FCECD900FCEB
    D500FCE8D000FDE6CB00FCE3C600FCE2C100FCDFB900FCD8A800FCEEDF00DEAF
    7B00D4995800C77D2B00C77C2A00D4975200ECC69900FCE3C300FCE0BF00FCDE
    B900FCDAB200FCD4A100FCEBD700FBEAD300FBE8CF00FBE7CD00FBE6C800FCE4
    C400FCE2C000FCE0BB00FCDDB500FCDAB100FCD7AB00FCD19A00DDAB7000D496
    5000C77B2700D4944C00C77A2500C77A2400D4924700DEA36000EFC38B00FAD4
    A300FACE9200FAE3C100FAE2BD00FAE0BA00FBDFB800FBDEB500FBDCB100FBDB
    AE00FBDAA900FAD7A700FAD6A300FAD4A100FAD29B00FACA89007A3E0000FBDB
    B000D4924600C7792200C7792100D4914200E4AF6B00D48F4000C7781F00C777
    1E00D48D3D00DD9E5100E4A75D00F8C17C00F8D09500F8CF9300F8CE8E00F7CB
    8B00F7CA8900F9CB8600F9C98600F9C88300F9C78200F8C78000F8C37C00F6BF
    7500F2B36500F1B96F00F1B96E00F0B86B00EFB56800F1B86A00F2B96D00F3B9
    6A00F3B76900F4B66700F3B36400F1AD5E00EEA85700FFFFFF00000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000004
    040404040404040404040404040400779293949595969798999A9B9C9D040077
    85868788898A8B8C8D8E8F909104007778797A7B7C7D7E7F8081828384040002
    6A6B6C6D6E6F70717273747576040002565F6061616263646566676869040002
    53405455565758595A5B5C5D5E0400014748494A364B4C4D4E4F505152040001
    293C2A3D3E3F4041424344454604000112313233343535363738393A3B040001
    26271C28292A2B152C2D2E2F30040001191A1B1C1D1E1F202122232425040001
    0F1001111213011415160217180400010B0100010C0100010D0200020E040001
    05060107050801050509020A0504000101010001010100020202000203048000
    0000800000008000000080000000800000008000000080000000800000008000
    000080000000800000008000000080000000888800008000000088880000}
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 0
    Top = 4
    Width = 4
    Height = 295
    Align = alLeft
  end
  object Image2: TImage
    Left = 435
    Top = 4
    Width = 4
    Height = 295
    Align = alRight
  end
  object Image3: TImage
    Left = 0
    Top = 0
    Width = 439
    Height = 4
    Align = alTop
  end
  object Image4: TImage
    Left = 0
    Top = 299
    Width = 439
    Height = 4
    Align = alBottom
  end
  object lbDebug: TListBox
    Left = 4
    Top = 4
    Width = 431
    Height = 295
    Align = alClient
    ItemHeight = 13
    PopupMenu = PopupMenu
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 303
    Width = 439
    Height = 40
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object Bevel1: TBevel
      Left = 0
      Top = 0
      Width = 439
      Height = 2
      Align = alTop
    end
    object Panel2: TPanel
      Left = 328
      Top = 2
      Width = 111
      Height = 38
      Align = alRight
      BevelOuter = bvNone
      Caption = 'Panel2'
      TabOrder = 0
      object OKBtn: TBitBtn
        Left = 6
        Top = 8
        Width = 99
        Height = 25
        Caption = '&OK'
        TabOrder = 0
        OnClick = OKBtnClick
        Kind = bkOK
      end
    end
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 343
    Width = 439
    Height = 19
    Panels = <>
    SimplePanel = True
    SimpleText = 'SBI Builder - Debug Log - Right Click for options'
  end
  object PopupMenu: TPopupMenu
    Images = Main_Form.ImageList
    Left = 24
    Top = 24
    object SaveLog: TMenuItem
      Caption = '&Save log...'
      ImageIndex = 4
      OnClick = SaveLogClick
    end
  end
  object SaveDialog: TSaveDialog
    DefaultExt = 'log'
    Filter = 
      'Debug log files (*.log)|*.log|Text files (*.txt)|*.txt|All files' +
      ' (*.*)|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Title = 'Save Log to...'
    Left = 56
    Top = 24
  end
end
