object GDWSFormPrincipal: TGDWSFormPrincipal
  Left = 271
  Top = 114
  Caption = 'GDWS Form Principal'
  ClientHeight = 239
  ClientWidth = 399
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 48
    Width = 55
    Height = 13
    Caption = 'Server Port'
  end
  object lbl1: TLabel
    Left = 160
    Top = 48
    Width = 105
    Height = 13
    Caption = 'Server Transport Port'
  end
  object ButtonStart: TButton
    Left = 24
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Start'
    TabOrder = 0
    OnClick = ButtonStartClick
  end
  object ButtonStop: TButton
    Left = 105
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Stop'
    TabOrder = 1
    OnClick = ButtonStopClick
  end
  object EditPort: TEdit
    Left = 24
    Top = 67
    Width = 121
    Height = 21
    TabOrder = 2
    Text = '56799'
  end
  object ButtonOpenBrowser: TButton
    Left = 32
    Top = 120
    Width = 107
    Height = 25
    Caption = 'Open Browser'
    TabOrder = 3
    OnClick = ButtonOpenBrowserClick
  end
  object edtServerTransportPort: TEdit
    Left = 160
    Top = 67
    Width = 121
    Height = 21
    TabOrder = 4
    Text = '211'
  end
  object ApplicationEvents1: TApplicationEvents
    OnIdle = ApplicationEvents1Idle
    Left = 288
    Top = 24
  end
end
