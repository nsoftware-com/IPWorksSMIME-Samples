<?php
/*
 * IPWorks S/MIME 2024 PHP Edition - Sample Project
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
require_once('../include/ipworkssmime_smime.php');
require_once('../include/ipworkssmime_certmgr.php');
require_once('../include/ipworkssmime_const.php');
?>
<?php

function outputUsage() {
  echo "Usage: php smime.php op [options]\n\n";
  echo "Options:\n";
  echo "  -f      the input file\n";
  echo "  -o      the output file (console output is the default)\n";
  echo "  -s      the input message as a string\n";
  echo "  -r      the recipient certificate file for encryption and signature verification (testcert.cer)\n";
  echo "  -c      the private key certificate used for signing and decryption (testcert.pfx)\n";
  echo "  -p      the password for the private key certificate\n";
  echo "  op:     the operation (Encrypt, Decrypt, Sign, Verify, SignAndEncrypt, DecryptAndVerify)\n\n";
  echo "Example: php smime.php encrypt -f test.txt -o test.enc -r testcert.cer\n";
  echo "Example: php smime.php decrypt -f test.enc -o test.txt -c testcert.pfx -p test\n";
}

function input($prompt) {
  echo $prompt;
  $handle = fopen("php://stdin", "r");
  $data = trim(fgets($handle));
  fclose($handle);
  return $data;
}

$smime = new IPWorksSMIME_SMIME();
$smime->setIncludeHeaders(true);

$operation = "";
$recipientCertFile = "";
$certFile = "";
$certPassword = "";
$outputFile = "";
$inputSpecified = false;

if ($argc < 2) {
  outputUsage();
  return;
} else {
  try {
    $operation = $argv[1];
    for ($i = 0; $i < $argc; $i++){
      if (str_starts_with($argv[$i],"-")) {
        if ($argv[$i] == "-f") {
          $smime->setInputFile($argv[$i + 1]);
          $inputSpecified = true;
        } elseif ($argv[$i] == "-o") {
          $outputFile = $argv[$i + 1];
          $smime->setOutputFile($outputFile);
        } elseif ($argv[$i] == "-s") {
          $smime->setInputMessage($argv[$i + 1]);
          $inputSpecified = true;
        } elseif ($argv[$i] == "-r") {
          $recipientCertFile = $argv[$i + 1];
        } elseif ($argv[$i] == "-c") {
          $certFile = $argv[$i + 1];
        } elseif ($argv[$i] == "-p") {
          $certPassword = $argv[$i + 1];
        } else {
          // ignore
        }
      }
    }

    if ($operation == "help" || $operation == "?") {
      outputUsage();
      return;
    }

    if (!$inputSpecified) {
      echo "No input specified. Please set either an input string (-s) or file (-f).";
      return;
    }

    switch (strtolower($operation)) {
      case "encrypt":
        try {
          $smime->setRecipientCertCount(1);
          $smime->setRecipientCertStoreType(0, 99); //auto
          $smime->setRecipientCertStore(0, $recipientCertFile);
          $smime->setRecipientCertSubject(0 , "*");
        } catch (Exception $ex) {
          echo "Error loading certificate: " . $ex->getMessage() . "\n";
          return;
        }
        $smime->doEncrypt();
        echo "Encryption complete.\n";
        break;
      case "decrypt":
        try {
          $smime->setCertStoreType(99); //auto
          $smime->setCertStore($certFile);
          $smime->setCertStorePassword($certPassword);
          $smime->setCertSubject("*");
        } catch (Exception $ex) {
          echo "Error loading certificate: " . $ex->getMessage() . "\n";
          return;
        }
        $smime->doDecrypt();
        echo "Decryption complete.\n";
        break;
      case "sign":
        try {
          $smime->setCertStoreType(99); //auto
          $smime->setCertStore($certFile);
          $smime->setCertStorePassword($certPassword);
          $smime->setCertSubject("*");
        } catch (Exception $ex) {
          echo "Error loading certificate: " . $ex->getMessage() . "\n";
          return;
        }
        // $smime->setDetachedSignature(false); // should we use?
        $smime->doSign();
        echo "Signing complete.\n";
        break;
      case "verify":
        try {
          $smime->setSignerCertStoreType(99); //auto
          $smime->setSignerCertStore($recipientCertFile);
          $smime->setSignerCertSubject("*");
        } catch (Exception $ex) {
          echo "Error loading certificate: " . $ex->getMessage() . "\n";
          return;
        }
        $smime->doVerifySignature();
        echo "Signature verification complete.\n";
        break;
      case "signandencrypt":
        try {
          // encryption cert
          $smime->setRecipientCertCount(1);
          $smime->setRecipientCertStoreType(0, 99); //auto
          $smime->setRecipientCertStore(0, $recipientCertFile);
          $smime->setRecipientCertSubject(0 , "*");
          // signing cert
          $smime->setCertStoreType(99); //auto
          $smime->setCertStore($certFile);
          $smime->setCertStorePassword($certPassword);
          $smime->setCertSubject("*");
        } catch (Exception $ex) {
          echo "Error loading certificate: " . $ex->getMessage() . "\n";
          return;
        }
        $smime->doSignAndEncrypt();
        echo "Signing and Encryption complete.\n";
        break;
      case "decryptandverify":
        try {
          // decryption cert
          $smime->setCertStoreType(99); //auto
          $smime->setCertStore($certFile);
          $smime->setCertStorePassword($certPassword);
          $smime->setCertSubject("*");
          // signature cert (used for signature verification)
          $smime->setSignerCertStoreType(99); //auto
          $smime->setSignerCertStore($recipientCertFile);
          $smime->setSignerCertSubject("*");
        } catch (Exception $ex) {
          echo "Error loading certificate: " . $ex->getMessage() . "\n";
          return;
        }
        $smime->doDecryptAndVerifySignature();
        echo "Decryption and Signature verification complete.\n";
        break;
      default:
        echo "Invalid operation. Valid values are: Encrypt, Decrypt, Sign, Verify, SignAndEncrypt, and DecryptAndVerify\n";
        return;
    }
  } catch (Exeception $ex) {
    echo "Error: " . $ex->getMessage() . "\n";
  }
  if ($outputFile == "") {
    // output the message to the console
    echo "Output message:\n" . $smime->getOutputMessage() . "\n";
  }
}

?>