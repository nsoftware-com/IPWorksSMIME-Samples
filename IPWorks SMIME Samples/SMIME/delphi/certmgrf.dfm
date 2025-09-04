object FormCertmgr: TFormCertmgr
  Left = 268
  Top = 159
  Width = 415
  Height = 439
  Caption = 'FormCertmgr'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 40
    Width = 76
    Height = 13
    Caption = 'Certificate store:'
  end
  object Label2: TLabel
    Left = 8
    Top = 64
    Width = 100
    Height = 13
    Caption = 'Available certificates:'
  end
  object Label3: TLabel
    Left = 8
    Top = 224
    Width = 83
    Height = 13
    Caption = 'Certificate details:'
  end
  object lblCaption: TLabel
    Left = 8
    Top = 8
    Width = 46
    Height = 13
    Caption = 'lblCaption'
  end
  object CertificateStore: TComboBox
    Left = 104
    Top = 32
    Width = 177
    Height = 21
    ItemHeight = 13
    TabOrder = 0
    Text = 'CertificateStore'
    OnChange = CertificateStoreChange
  end
  object AvailableCertificates: TListBox
    Left = 8
    Top = 80
    Width = 385
    Height = 129
    ItemHeight = 13
    Sorted = True
    TabOrder = 1
    OnClick = AvailableCertificatesClick
  end
  object CertificateInfo: TMemo
    Left = 8
    Top = 240
    Width = 385
    Height = 161
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 2
  end
  object cmdOK: TButton
    Left = 296
    Top = 32
    Width = 97
    Height = 25
    Caption = 'OK'
    TabOrder = 3
    OnClick = cmdOKClick
  end
  object ipmCertmgr1: TipmCertmgr
    CertStore = 'MY'
    OnCertList = ipmCertmgr1CertList
    OnStoreList = ipmCertmgr1StoreList
    Left = 336
  end
end
