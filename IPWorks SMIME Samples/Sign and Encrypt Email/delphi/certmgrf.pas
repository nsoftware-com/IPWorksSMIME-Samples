unit certmgrf;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ipmcore, ipmtypes, ipmcertmgr;

type
  TFormCertmgr = class(TForm)
    CertificateStore: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    AvailableCertificates: TListBox;
    CertificateInfo: TMemo;
    Label3: TLabel;
    lblCaption: TLabel;
    cmdOK: TButton;
    ipmCertMgr1: TipmCertMgr;


    procedure ipmCertmgr1StoreList(Sender: TObject;
      const CertStore: String);
    procedure FormCreate(Sender: TObject);
    procedure AvailableCertificatesClick(Sender: TObject);
    procedure CertificateStoreChange(Sender: TObject);
    procedure cmdOKClick(Sender: TObject);
    procedure ipmCertmgr1CertList(Sender: TObject; CertEncoded: string; CertEncodedB: TArray<System.Byte>;
      const CertSubject, CertIssuer, CertSerialNumber: String;
      HasPrivateKey: Boolean);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormCertmgr: TFormCertmgr;

implementation

{$R *.DFM}






procedure TFormCertmgr.ipmCertmgr1StoreList(Sender: TObject;
  const CertStore: String);
begin
        CertificateStore.Items.Add(CertStore);
end;

procedure TFormCertmgr.FormCreate(Sender: TObject);
begin
    	//ipmCertmgr1.Action  := CertmgrListCertificateStores;
        ipmCertmgr1.ListCertificateStores();
  if CertificateStore.Items.Count > 0 then
  begin
  	CertificateStore.ItemIndex := 0;
	  CertificateStoreChange(nil);
  end;
end;

procedure TFormCertmgr.AvailableCertificatesClick(Sender: TObject);
begin
          ipmCertmgr1.CertSubject := AvailableCertificates.Items.Strings[AvailableCertificates.ItemIndex];
	CertificateInfo.Text :=
  	'Issuer: ' + ipmCertmgr1.CertIssuer + #13 + #10 +
		'Subject: ' + ipmCertmgr1.CertSubject + #13 + #10 +
		'Version: ' + ipmCertmgr1.CertVersion + #13 + #10 +
		'Serial Number: ' + ipmCertmgr1.CertSerialNumber + #13 + #10 +
		'Signature Algorithm: ' + ipmCertmgr1.CertSignatureAlgorithm + #13 + #10 +
		'Effective Date: ' + ipmCertmgr1.CertEffectiveDate + #13 + #10 +
		'Expiration Date: ' + ipmCertmgr1.CertExpirationDate + #13 + #10 +
		'Public Key Algorithm: ' + ipmCertmgr1.CertPublicKeyAlgorithm + #13 + #10 +
		'Public Key Length: ' + IntToStr(ipmCertmgr1.CertPublicKeyLength) + #13 + #10 +
		'Public Key: ' + ipmCertmgr1.CertPublicKey;
end;

procedure TFormCertmgr.CertificateStoreChange(Sender: TObject);
begin
        AvailableCertificates.Clear;
    CertificateInfo.Clear;
    ipmCertmgr1.CertStore := CertificateStore.Items.Strings[CertificateStore.ItemIndex];
    //ipmCertmgr1.Action := CertmgrListStoreCertificates;
    ipmCertmgr1.ListStoreCertificates();
    if AvailableCertificates.Items.Count > 0 then
  	begin
  		AvailableCertificates.ItemIndex := 0;
	  	AvailableCertificatesClick(nil);
    end;
end;

procedure TFormCertmgr.cmdOKClick(Sender: TObject);
begin
FormCertmgr.Close ;
end;

procedure TFormCertmgr.ipmCertmgr1CertList(Sender: TObject;
  CertEncoded: string; CertEncodedB: TArray<System.Byte>; const CertSubject, CertIssuer,
  CertSerialNumber: String; HasPrivateKey: Boolean);
begin
        AvailableCertificates.Items.Add(CertSubject);
end;

end.
