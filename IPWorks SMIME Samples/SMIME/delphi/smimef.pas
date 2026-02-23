(*
 * IPWorks S/MIME 2024 Delphi Edition - Sample Project
 *
 * This sample project demonstrates the usage of IPWorks S/MIME in a 
 * simple, straightforward way. It is not intended to be a complete 
 * application. Error handling and other checks are simplified for clarity.
 *
 * www.nsoftware.com/ipworkssmime
 *
 * This code is subject to the terms and conditions specified in the 
 * corresponding product license agreement which outlines the authorized 
 * usage and restrictions.
 *)
unit smimef;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ipmSmime, ipmcore, ipmtypes, ipmcertmgr, certmgrf;

type
  TFormSmime = class(TForm)

    ipmCertMgr1: TipmCertMgr;
    ipmSmime1: TipmSMIME;
    Label1: TLabel;
    Label2: TLabel;
    mmoMessage: TMemo;
    mmoHeaders: TMemo;
    GroupBox1: TGroupBox;
    cmdSign: TButton;
    cmdEncrypt: TButton;
    cmdSignAndEncrypt: TButton;
    GroupBox2: TGroupBox;
    cmdDecrypt: TButton;
    cmdVerify: TButton;
    cmdDecryptAndVerify: TButton;

    procedure cmdEncryptClick(Sender: TObject);
    procedure cmdSignClick(Sender: TObject);
    procedure cmdSignAndEncryptClick(Sender: TObject);
    procedure cmdVerifyClick(Sender: TObject);
    procedure cmdDecryptClick(Sender: TObject);
    procedure cmdDecryptAndVerifyClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormSmime: TFormSmime;

implementation

{$R *.DFM}

procedure TFormSmime.cmdEncryptClick(Sender: TObject);
begin
        mmoHeaders.lines.Clear;
        ipmSmime1.Reset();
        ipmSmime1.InputMessage := mmoMessage.Text;

        FormCertmgr.lblCaption.Caption :='Please select the recipient certificate to encrypt the message with.';
        FormCertmgr.ShowModal;
        if SizeOf(FormCertmgr.ipmCertMgr1.CertSubject) > 0 then
        begin
        ipmSmime1.AddRecipientCert(TEncoding.Default.GetBytes(FormCertmgr.ipmCertMgr1.CertEncoded));
        end;

    ipmSmime1.Encrypt;

    mmoHeaders.Text := ipmSmime1.OutputMessageHeadersString;
    mmoMessage.Text := ipmSmime1.OutputMessage;
end;

procedure TFormSmime.cmdSignClick(Sender: TObject);
begin
       mmoHeaders.lines.clear;
    ipmSmime1.Reset();
    ipmSmime1.InputMessage := mmoMessage.Text;

    FormCertmgr.lblCaption.Caption := 'Please select a valid certificate ' +
      'to sign the message with.' ;
    FormCertmgr.ShowModal ;
    if SizeOf(FormCertmgr.ipmCertMgr1.CertSubject) > 0 then
    begin
        ipmSmime1.CertStore := FormCertmgr.ipmCertMgr1.CertStore;
        ipmSmime1.CertSubject := FormCertmgr.ipmCertMgr1.CertSubject;
    End;

    ipmSmime1.DetachedSignature := True;
    ipmSmime1.IncludeCertificate := True;
    ipmSmime1.Sign;

    mmoHeaders.Text := ipmSmime1.OutputMessageHeadersString;
    mmoMessage.Text := ipmSmime1.OutputMessage;
end;

procedure TFormSmime.cmdSignAndEncryptClick(Sender: TObject);
begin
           mmoHeaders.lines.clear;
    ipmSmime1.Reset();
    ipmSmime1.InputMessage := mmoMessage.Text;

    FormCertmgr.lblCaption.Caption := 'Please select a valid certificate ' +
        'to sign the message with.';
    FormCertmgr.Showmodal;
    if SizeOf(FormCertmgr.ipmCertMgr1.CertSubject) > 0 then
    begin
        ipmSmime1.CertStore := FormCertmgr.ipmCertMgr1.CertStore;
        ipmSmime1.CertSubject := FormCertmgr.ipmCertMgr1.CertSubject;
    End;
    //Unload CertMgrServ

    ipmSmime1.DetachedSignature := True;
    ipmSmime1.IncludeCertificate := True;

    FormCertmgr.lblCaption.Caption := 'Please select the recipient ' +
        'certificate to encrypt the message with.';
    FormCertmgr.Showmodal;
    if SizeOf(FormCertmgr.ipmCertMgr1.CertSubject) > 0 then
    begin
        ipmSmime1.AddRecipientCert(TEncoding.Default.GetBytes(FormCertmgr.ipmCertMgr1.CertEncoded));
    End;
    //Unload CertMgrServ

    ipmSmime1.SignAndEncrypt;

    mmoHeaders.Text := ipmSmime1.OutputMessageHeadersString;
    mmoMessage.Text := ipmSmime1.OutputMessage;
end;

procedure TFormSmime.cmdVerifyClick(Sender: TObject);
begin

    ipmSmime1.Reset();
    ipmSmime1.InputMessage := mmoMessage.Text;
    ipmSmime1.InputMessageHeadersString := mmoHeaders.Text;

    ipmSmime1.VerifySignature;

	MessageDlg('Subject: ' + ipmSmime1.SignerCertSubject + chr(13) +  chr(10) +
        'Issuer: ' + ipmSmime1.SignerCertIssuer + chr(13) + chr(10) +
        'Serial Number: ' + ipmSmime1.SignerCertSerialNumber,
        mtInformation, [mbOk], 0);
    mmoHeaders.Text := ipmSmime1.OutputMessageHeadersString;
    mmoMessage.Text := ipmSmime1.OutputMessage;
end;

procedure TFormSmime.cmdDecryptClick(Sender: TObject);
begin
    ipmSmime1.InputMessage := mmoMessage.Text;
    ipmSmime1.Decrypt;
    mmoHeaders.Text := ipmSmime1.OutputMessageHeadersString;
    mmoMessage.Text := ipmSmime1.OutputMessage;
end;

procedure TFormSmime.cmdDecryptAndVerifyClick(Sender: TObject);
begin
    ipmSmime1.InputMessage := mmoMessage.Text;
    ipmSmime1.DecryptAndVerifySignature;
    mmoMessage.Text := ipmSmime1.OutputMessage;
        
	MessageDlg('Subject: ' + ipmSmime1.SignerCertSubject + chr(13) +  chr(10) +
        'Issuer: ' + ipmSmime1.SignerCertIssuer + chr(13) + chr(10) +
        'Serial Number: ' + ipmSmime1.SignerCertSerialNumber,
        mtInformation, [mbOk], 0);
        
    mmoHeaders.Text := ipmSmime1.OutputMessageHeadersString;
    mmoMessage.Text := ipmSmime1.OutputMessage;
end;

end.

