object FormSsmtp: TFormSsmtp
  Left = 273
  Top = 129
  Width = 496
  Height = 515
  Caption = 'Send Secure Email'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 466
    Height = 26
    Caption = 
      'With this demo, you may send an email message in mime format usi' +
      'ng the SMTP control.  Simply fill in the necessary elements for ' +
      'the email and attach a file if you would like, and then click SE' +
      'ND.'
    WordWrap = True
  end
  object Label2: TLabel
    Left = 8
    Top = 164
    Width = 39
    Height = 13
    Caption = 'Subject:'
  end
  object Label3: TLabel
    Left = 8
    Top = 136
    Width = 16
    Height = 13
    Caption = 'Cc:'
  end
  object Label4: TLabel
    Left = 8
    Top = 108
    Width = 16
    Height = 13
    Caption = 'To:'
  end
  object Label5: TLabel
    Left = 8
    Top = 80
    Width = 29
    Height = 13
    Caption = 'From: '
  end
  object Label6: TLabel
    Left = 8
    Top = 52
    Width = 56
    Height = 13
    Caption = 'Mail Server:'
  end
  object mmoMessage: TMemo
    Left = 8
    Top = 192
    Width = 465
    Height = 249
    Lines.Strings = (
      '')
    ScrollBars = ssBoth
    TabOrder = 5
  end
  object txtSubject: TEdit
    Left = 76
    Top = 160
    Width = 300
    Height = 21
    TabOrder = 4
  end
  object txtCc: TEdit
    Left = 76
    Top = 132
    Width = 300
    Height = 21
    TabOrder = 3
  end
  object txtTo: TEdit
    Left = 76
    Top = 104
    Width = 300
    Height = 21
    TabOrder = 2
  end
  object txtFrom: TEdit
    Left = 76
    Top = 76
    Width = 301
    Height = 21
    TabOrder = 1
  end
  object ButtonSend: TButton
    Left = 388
    Top = 156
    Width = 84
    Height = 23
    Caption = 'S&end'
    ModalResult = 1
    TabOrder = 9
    OnClick = ButtonSendClick
  end
  object cmdEncrypt: TButton
    Left = 192
    Top = 448
    Width = 97
    Height = 25
    Caption = 'Encrypt'
    TabOrder = 7
    OnClick = cmdEncryptClick
  end
  object cmdSign: TButton
    Left = 88
    Top = 448
    Width = 97
    Height = 25
    Caption = 'Sign'
    TabOrder = 6
    OnClick = cmdSignClick
  end
  object cmdSignAndEncrypt: TButton
    Left = 296
    Top = 448
    Width = 97
    Height = 25
    Caption = 'Sign && Encrypt'
    TabOrder = 8
    OnClick = cmdSignAndEncryptClick
  end
  object txtMailServer: TEdit
    Left = 76
    Top = 48
    Width = 301
    Height = 21
    TabOrder = 0
  end
  object ipmSSMTP1: TipmSSMTP
    CertStore = 'MY'
    EncryptingAlgorithm = '1.2.840.113549.3.7'
    FirewallPort = 80
    SigningAlgorithm = '1.3.14.3.2.26'
    Left = 384
    Top = 120
  end
  object ipmCertMgr1: TipmCertMgr
    CertStore = 'MY'
    Left = 416
    Top = 120
  end
end


