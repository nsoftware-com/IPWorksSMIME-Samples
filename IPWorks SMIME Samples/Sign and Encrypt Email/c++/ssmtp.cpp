/*
 * IPWorks S/MIME 2024 C++ Edition - Sample Project
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
 */


#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "../../include/ipworkssmime.h"
#define LINE_LEN 100

#define MAX_CERTS 100
#define MAX_SUBJECT_LEN 499
class MyCertMgr : public CertMgr
{
public:

	MyCertMgr()
	{
		numCerts = 0;
	}
	virtual int FireCertList(CertMgrCertListEventParams *e)
	{
		if (numCerts < MAX_CERTS)
		{
			strncpy(certs[numCerts], e->CertSubject, MAX_SUBJECT_LEN);
			certs[numCerts][MAX_SUBJECT_LEN] = '\0';
			numCerts++;
		}
		return 0;
	}
	virtual int FireError(CertMgrErrorEventParams *e)
	{
		printf ("%i: %s\n", e->ErrorCode, e->Description);
		return 0;
	}
	char certs[MAX_CERTS][MAX_SUBJECT_LEN+1]; // storage for 100 cert subjects
	int numCerts;														// number of cert subjects stored in certs[]
};

SSMTP			ssmtp;		// global
MyCertMgr CertMgr1;	// global

int SelCert()
{

	char myBuf[LINE_LEN+1];
	*myBuf = 0;
	fflush(stdin);

	CertMgr1.numCerts = 0;
	CertMgr1.SetCertStore("MY", 2);
	CertMgr1.ListStoreCertificates();

	for (int i=0; i<CertMgr1.numCerts; i++)
	{
		printf("%i) %s\n", i, CertMgr1.certs[i]);
	}
	printf("Please select a valid certificate. ");
	fgets(myBuf,LINE_LEN,stdin);
	myBuf[strlen(myBuf)-1] = '\0';

	CertMgr1.SetCertSubject(CertMgr1.certs[atoi(myBuf)]);
	return 0;
}

int Sign()
{
	char* certStore;
	int certStoreLength;
	SelCert();
	//ssmtp.SetCertHandle(CertMgr1.GetCertHandle());
	CertMgr1.GetCertStore(certStore, certStoreLength);
	ssmtp.SetCertStore(certStore, certStoreLength);
	ssmtp.SetCertSubject(CertMgr1.GetCertSubject());
	ssmtp.SetIncludeCertificate(true);
	ssmtp.Sign();

	return 0;
}

int Encrypt()
{

	char* mycert;
	unsigned int   len = 0;
	SelCert();
	CertMgr1.GetCertEncoded(mycert, (int &)len);
	ssmtp.AddRecipientCert(mycert, len);
	ssmtp.Encrypt();

	return 0;
}

int SignAndEncrypt()
{

	char* certStore;
	int certStoreLength;
	char * mycert;
	unsigned int len = 0;
	SelCert();															// cert to sign message with
	ssmtp.GetCertStore(certStore, certStoreLength);
	ssmtp.SetCertSubject(CertMgr1.GetCertSubject());
	ssmtp.SetIncludeCertificate(true);
	printf("\n");
	SelCert();															// cert to encrypt message with
	CertMgr1.GetCertEncoded(mycert, (int &)len);
	ssmtp.AddRecipientCert(mycert, len);
	ssmtp.SignAndEncrypt();

	return 0;
}

int SelectEncoding()
{

	char ch;

	printf("\nEncoding choices:\n"
	       "  1) Sign message\n"
	       "  2) Encrypt message\n"
	       "  3) Sign and encrypt message\n"
	       "  4) No encryption\n");
	ch = getchar();

	switch(ch)
	{
		case '1':
			return Sign();
		case '2':
			return Encrypt();
		case '3':
			return SignAndEncrypt();
		case '4':
			return 0;
		default:
			break;
	}

	return 0;
}


int main()
{

	char buffer[LINE_LEN+1];
	char messageText[10000];
	*messageText = 0;

	ssmtp.ResetHeaders();
	ssmtp.SetTimeout(30);

	printf("SMTP Server: ");
	fgets(buffer,LINE_LEN,stdin);
	buffer[strlen(buffer)-1] = '\0';
	ssmtp.SetMailServer(buffer);

	printf("From:        ");
	fgets(buffer,LINE_LEN,stdin);
	buffer[strlen(buffer)-1] = '\0';
	ssmtp.SetFrom(buffer);

	printf("To:          ");
	fgets(buffer,LINE_LEN,stdin);
	buffer[strlen(buffer)-1] = '\0';
	ssmtp.SetSendTo(buffer);

	printf("Subject:     ");
	fgets(buffer,LINE_LEN,stdin);
	buffer[strlen(buffer)-1] = '\0';
	ssmtp.SetSubject(buffer);

	*buffer = 0;
	printf("\nBegin your message text. (type '.' on a line by itself to end)\n");

	while(strcmp(buffer, ".") != 0)
	{
		fgets(buffer,LINE_LEN,stdin);
		buffer[strlen(buffer)-1] = '\0';
		strcat(messageText, buffer);
	}
	ssmtp.SetMessageText(messageText);
	SelectEncoding();
	printf("\n%s\n", ssmtp.GetMessageText());
	fflush(stdin);
	printf("\nSend? [Y/N] ");
	fgets(buffer,LINE_LEN,stdin);
	buffer[strlen(buffer)-1] = '\0';
	if (*buffer == 'Y' || *buffer == 'y')
	{
		int ret_code = ssmtp.Send();
		if (ret_code == 0) printf("Message sent.\n\n");
		else printf("%i: %s\n\n", ret_code, ssmtp.GetLastError());
	}

}


