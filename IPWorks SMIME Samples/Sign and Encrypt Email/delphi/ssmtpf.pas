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
unit ssmtpf;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ipmcertmgr, ipmcore, ipmtypes, ipmssmtp, StdCtrls;

type
  TFormSsmtp = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    mmoMessage: TMemo;
    txtSubject: TEdit;
    txtCc: TEdit;
    txtTo: TEdit;
    txtFrom: TEdit;
    ButtonSend: TButton;
    cmdEncrypt: TButton;
    cmdSign: TButton;
    cmdSignAndEncrypt: TButton;
    ipmSSMTP1: TipmSSMTP;
    ipmCertMgr1: TipmCertMgr;
    txtMailServer: TEdit;
    Label6: TLabel;
    procedure cmdSignClick(Sender: TObject);
    procedure cmdEncryptClick(Sender: TObject);
    procedure cmdSignAndEncryptClick(Sender: TObject);
    procedure ButtonSendClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormSsmtp: TFormSsmtp;

implementation

uses certmgrf;

{$R *.DFM}

procedure TFormSsmtp.cmdSignClick(Sender: TObject);
begin
    ipmssmtp1.MessageText := mmoMessage.Text;

    FormCertmgr.lblCaption.Caption := 'Please select a valid certificate ' +
      'to sign the message with.' ;
    FormCertmgr.ShowModal ;
    //If CertMgr.ipmCertMgr1.CertHandle <> 0 Then
    if sizeof(FormCertmgr.ipmCertMgr1.CertSubject) > 0 then
    begin
        ipmssmtp1.CertStore := FormCertmgr.ipmCertMgr1.CertStore;
        ipmssmtp1.CertSubject := FormCertmgr.ipmCertMgr1.CertSubject;
    End;

    ipmssmtp1.IncludeCertificate := True;
    ipmssmtp1.Sign;

    mmoMessage.Text := ipmssmtp1.MessageText;
end;

procedure TFormSsmtp.cmdEncryptClick(Sender: TObject);
begin
        ipmssmtp1.MessageText := mmoMessage.Text;

        FormCertmgr.lblCaption.Caption :='Please select the recipient certificate to encrypt the message with.';
        FormCertmgr.ShowModal;
        if sizeof(FormCertmgr.ipmCertMgr1.CertSubject) > 0 then
        begin
            ipmssmtp1.AddRecipientCert(TEncoding.Default.GetBytes(FormCertmgr.ipmCertMgr1.CertEncoded));
        end;
        // Unload CertMgrServ

        ipmssmtp1.Encrypt;

        mmoMessage.Text := ipmssmtp1.MessageText;
end;

procedure TFormSsmtp.cmdSignAndEncryptClick(Sender: TObject);
begin

        ipmssmtp1.MessageText := mmoMessage.Text;

        FormCertmgr.lblCaption.Caption := 'Please select a valid certificate ' +
                'to sign the message with.';
        FormCertmgr.Showmodal;
        if sizeof(FormCertmgr.ipmCertMgr1.CertSubject) > 0 then
        begin
                ipmssmtp1.CertStore := FormCertmgr.ipmCertMgr1.CertStore;
                ipmssmtp1.CertSubject := FormCertmgr.ipmCertMgr1.CertSubject;
        End;
        //Unload CertMgrServ

        ipmssmtp1.IncludeCertificate := True;

        FormCertmgr.lblCaption.Caption := 'Please select the recipient ' +
                'certificate to encrypt the message with.';
        FormCertmgr.Showmodal;
        if sizeof(FormCertmgr.ipmCertMgr1.CertSubject) > 0 then
        begin
                ipmssmtp1.AddRecipientCert(TEncoding.Default.GetBytes(FormCertmgr.ipmCertMgr1.CertEncoded));
        End;
        //Unload CertMgrServ

        ipmssmtp1.SignAndEncrypt;

        mmoMessage.Text := ipmssmtp1.MessageText;
end;

procedure TFormSsmtp.ButtonSendClick(Sender: TObject);
begin
ipmssmtp1.MailServer := txtmailserver.text;
ipmSSMTP1.From  := txtFrom.text;
ipmSSMTP1.SendTo := txtto.text;
ipmssmtp1.cc := txtcc.text;
ipmSSMTP1.subject := txtsubject.text;
ipmssmtp1.MessageText := mmomessage.Text;
ipmSSMTP1.Send;
ipmssmtp1.disconnect;
MessageDlg('Message Sent!', mtInformation, [mbOk], 0);
end;

end.

