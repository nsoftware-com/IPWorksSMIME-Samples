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
#define STR_SIZE 100

SMIME smime; 
char option[STR_SIZE];
char* recipientCertFile = "./testcert.cer";
char* myCertFile = "./testcert.pfx";
char* password = "password";

void prompt(const char* label, const char* punctuation, const char* defaultVal, bool inputData = false) {
    char input[STR_SIZE];

    printf("%s [%s] %s ", label, defaultVal, punctuation);

    fgets(input, sizeof(input), stdin);
    if (strlen(input) == 1) {
        strcpy(input, defaultVal); 
    }

    input[strcspn(input, "\n")] = '\0';
    if (inputData) {
        smime.SetInputMessage(input, strlen(input));
    }
    strcpy(option, input); 
}

void displayEncryptOptions() {
    printf("\nOperation:\n");
    printf(" 1) Encrypt\n");
    printf(" 2) Sign\n");
    printf(" 3) Sign and Encrypt\n\n");
    prompt("Enter Selection", ":", "3");
}

void displayDecryptOptions() {
    fflush(stdin);
    printf("\nOperation:\n");
    printf(" 1) Decrypt\n");
    printf(" 2) Verify\n");
    printf(" 3) Decrypt and Verify\n\n");
    prompt("Enter Selection", ":", "3");
}

void encryptComplete() {
    char* p;
    unsigned int len = 0;
    smime.GetOutputMessage(p, (int&)len);
    smime.SetInputMessage(p,len);
    char* test = smime.GetOutputMessageHeadersString();
    smime.SetInputMessageHeadersString(test);
    printf("\n%s",test);
    printf("\n%*s\n", len, p);
  

    printf("\n\nAfter encrypting/signing; the message may now be decrypted and the signature verified.\n");
    displayDecryptOptions();
    
}

void decryptComplete()
{
    printf("\n\nOperation Complete.Decrypted / Verified message : \n\n");
    char* p;
    unsigned int len = 0;
    smime.GetOutputMessage(p, (int &)len);
    printf("\n%*s\n", len, p);
    exit(0);
}
int main()
{
    printf("\nWelcome to the IPWorks SMIME Demo.\n");
    printf("This demo shows how to use the SMIME component to sign/encrypt/decrypt/verify messages.\n");
    printf("This demo ships with example certificates which are used for simplicity.\n");
    printf("------------------------------------------------------------\n\n");
    printf("To begin specify some text to encrypt and/or sign.\n");

    prompt("Input Data",":","test", true);

    printf("\nEnter the desired option for encryption");
    displayEncryptOptions();
    
    switch (atoi(option))
    {
    case 1:
        try
        {
            smime.AddRecipientCert(recipientCertFile, strlen(recipientCertFile));
            int res1 = smime.Encrypt();
            encryptComplete();
            if (res1 != 0) {
                printf("Error code: %d\t%s", res1, smime.GetLastError());
                exit(-1);
            }
        }
        catch (int e)
        {
            printf("Error : %d", e);
            exit(-1);
        }
        break;
    case 2:
        try
        {
            smime.SetCertStoreType(CST_PFXFILE);
            smime.SetCertStore(myCertFile, strlen(myCertFile));
            smime.SetCertStorePassword(password);
            smime.SetCertSubject("*");

            int ret_code = smime.Sign();
            if (ret_code != 0) {
                printf("Signing failed. Code: %d, Message: %s\r\n", ret_code, smime.GetLastError());
                exit(-1);
            }
            encryptComplete();
        }
        catch (int e)
        {
            printf("Error : %d", e);
            exit(-1);
        }
        break;
    case 3:
        try 
        {
            smime.AddRecipientCert(recipientCertFile, strlen(recipientCertFile));
            smime.SetCertStoreType(CST_PFXFILE);

            smime.SetCertStore(myCertFile, strlen(myCertFile));
            smime.SetCertStorePassword(password);
            smime.SetCertSubject("*");

            smime.SetDetachedSignature(true);
            smime.SetIncludeCertificate(true);
            int ret_code = smime.SignAndEncrypt();
            if (ret_code != 0) {
                printf("Signing/Encryption failed. Code: %d, Message: %s\r\n", ret_code, smime.GetLastError());
            }

            encryptComplete();
        }
        catch(int e)
        {
            printf("Error : %d", e);
            exit(-1);
        }
        break;
    default:
        printf("Invalid Option");
        displayEncryptOptions();
        break;
    }

    switch (atoi(option))
    {
    case 1:
        try 
        {
            int ret_code = 0;
            ret_code = smime.SetCertStoreType(CST_PFXFILE);
            ret_code = smime.SetCertStore(myCertFile, strlen(myCertFile));
            ret_code = smime.SetCertStorePassword(password);
            ret_code = smime.SetCertSubject("*");
  
            ret_code = smime.Decrypt();
            if (ret_code != 0) {
                printf("Decryption failed. Code: %d, Message: %s\r\n", ret_code, smime.GetLastError());
                exit(-1);
            }

            decryptComplete();
        }
        catch (int e)
        {
            printf("Error : %d", e);
            exit(-1);
        }
        break;
    case 2:
        try
        {
            int ret_code = smime.VerifySignature();
            if (ret_code != 0) {
                printf("Verification failed. Code: %d, Message: %s\r\n",ret_code,smime.GetLastError());
                exit(-1);
            }
            decryptComplete();
        }
        catch (int e)
        {
            printf("Error : %d", e);
            exit(-1);
        }
        break;
    case 3:
        try 
        {
            smime.SetCertStoreType(CST_PFXFILE);
            smime.SetCertStore(myCertFile, strlen(myCertFile));
            smime.SetCertStorePassword(password);
            smime.SetCertSubject("*");

            smime.SetDetachedSignature(true);
            smime.SetIncludeCertificate(true);

            int ret_code = smime.DecryptAndVerifySignature();
            if (ret_code != 0) {
                printf("Decryption failed. Code: %d, Message: %s\r\n", ret_code, smime.GetLastError());
                exit(-1);
            }
            decryptComplete();
        }
        catch (int e)
        {
            printf("Error : %d", e);
            exit(-1);
        }
        break;
    default:
        displayDecryptOptions();
        break;
    }
  
}



