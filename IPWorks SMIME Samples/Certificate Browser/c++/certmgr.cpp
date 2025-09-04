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
#include <cstring>
#include "../../include/ipworkssmime.h"
#define LINE_LEN 100

class MyCertMgr : public CertMgr
{
  //overwrite events here if needed
public:
  virtual int FireCertList(CertMgrCertListEventParams *e)
  {
    printf("%s\n", e->CertSubject);
    return 0;
  }
};

int main(int argc, char **argv)
{
  if (argc < 3) {
    fprintf(stderr, "usage: certmgr cert password\n\n");
    fprintf(stderr, "  cert      the certificate store file to load\n");
    fprintf(stderr, "  password  the password for the certificate file\n\n");
    fprintf(stderr, "Example:    certmgr ../test.pfx test\n\n");
    printf("Press enter to continue.");
    getchar();
  }
  else 
  {
    MyCertMgr certmgr;

    certmgr.SetCertStoreType(2); //CST_PFXFILE
    certmgr.SetCertStore(argv[1], strlen(argv[1]));
    certmgr.SetCertStorePassword(argv[2]);

    printf("Listing all certificates in store %s:\n\n", argv[1]);

    certmgr.ListStoreCertificates();
    if (certmgr.GetLastErrorCode())
    {
      printf("%d (%s)", certmgr.GetLastErrorCode(), certmgr.GetLastError());
    }
    printf("\npress <return> to continue...\n");
    getchar();
  }
}


