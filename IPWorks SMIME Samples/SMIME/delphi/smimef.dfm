object FormSmime: TFormSmime
  Left = 245
  Top = 231
  Width = 581
  Height = 485
  Caption = 'S/MIME Encoding'
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
    Width = 423
    Height = 26
    Caption = 
      'This idemo shows how to use the features of the FormSmime object. Fi' +
      'll in the text area below and then select an FormSmime action to per' +
      'form on that text. '
    WordWrap = True
  end
  object Label2: TLabel
    Left = 8
    Top = 343
    Width = 259
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = 'Any appropriate MIME headers will be displayed below:'
  end
  object mmoMessage: TMemo
    Left = 8
    Top = 48
    Width = 437
    Height = 288
    Anchors = [akLeft, akTop, akRight, akBottom]
    Lines.Strings = (
      'Just some sample text.')
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object mmoHeaders: TMemo
    Left = 8
    Top = 359
    Width = 434
    Height = 89
    Anchors = [akLeft, akRight, akBottom]
    Lines.Strings = (
      '')
    ScrollBars = ssBoth
    TabOrder = 1
  end
  object GroupBox1: TGroupBox
    Left = 452
    Top = 48
    Width = 113
    Height = 113
    Anchors = [akTop, akRight]
    Caption = 'Encrypt && Sign'
    TabOrder = 2
    object cmdSign: TButton
      Left = 8
      Top = 16
      Width = 97
      Height = 25
      Caption = 'Sign'
      TabOrder = 0
      OnClick = cmdSignClick
    end
    object cmdEncrypt: TButton
      Left = 8
      Top = 48
      Width = 97
      Height = 25
      Caption = 'Encrypt'
      TabOrder = 1
      OnClick = cmdEncryptClick
    end
    object cmdSignAndEncrypt: TButton
      Left = 8
      Top = 80
      Width = 97
      Height = 25
      Caption = 'Sign && Encrypt'
      TabOrder = 2
      OnClick = cmdSignAndEncryptClick
    end
  end
  object GroupBox2: TGroupBox
    Left = 452
    Top = 168
    Width = 113
    Height = 113
    Anchors = [akTop, akRight]
    Caption = 'Decrypt && Verify'
    TabOrder = 3
    object cmdDecrypt: TButton
      Left = 8
      Top = 48
      Width = 97
      Height = 25
      Caption = 'Decrypt'
      TabOrder = 0
      OnClick = cmdDecryptClick
    end
    object cmdVerify: TButton
      Left = 8
      Top = 16
      Width = 97
      Height = 25
      Caption = 'Verify'
      TabOrder = 1
      OnClick = cmdVerifyClick
    end
    object cmdDecryptAndVerify: TButton
      Left = 8
      Top = 80
      Width = 97
      Height = 25
      Caption = 'Decrypt && Verify'
      TabOrder = 2
      OnClick = cmdDecryptAndVerifyClick
    end
  end
  object ipmCertMgr1: TipmCertMgr
    CertStore = 'MY'
    Left = 472
    Top = 8
  end
  object ipmSmime1: TipmSmime
    CertStore = 'MY'
    EncryptingAlgorithm = '1.2.840.113549.3.2'
    SigningAlgorithm = '1.3.14.3.2.26'
    Left = 504
    Top = 8
  end
end


