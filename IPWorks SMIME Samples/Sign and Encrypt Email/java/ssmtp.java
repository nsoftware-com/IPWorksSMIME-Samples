/*
 * IPWorks S/MIME 2024 Java Edition - Sample Project
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

import java.io.*;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.*;
import ipworkssmime.*;

public class ssmtp {
  Vector al;
  //Vector<String> al;
  boolean quit;
  int index;
  SSMTP ssmtp1;
  CertMgr certmgr;
  public ssmtp() {
    al = new Vector();
    //al = new Vector<String>();
    index = 0;
    go();
  }

  public void go() {
    try {
      certmgr = new CertMgr();
      ssmtp1 = new SSMTP();
      certmgr.addCertMgrEventListener(new CertMgrEvents(this));
      ssmtp1.resetHeaders();
      ssmtp1.setTimeout(30);
      System.out.print("SMTP Server: ");
      ssmtp1.setMailServer(input());
      System.out.print("From: ");
      ssmtp1.setFrom(input());
      System.out.print("To: ");
      ssmtp1.setSendTo(input());
      System.out.print("Subject: ");
      ssmtp1.setSubject(input());
      ssmtp1.setMessageText("This is a test message from ssmtp.\r\n");
      quit = true;
      selectEncoding();
      System.out.print("Send? [Y/N]: ");
      char selection = input().toLowerCase().charAt(0);
      if (selection == 'y') {
        ssmtp1.send();
      }
      System.out.print("Would you like to send another? [Y/N]: ");
      selection = input().toLowerCase().charAt(0);
      if (selection == 'n') {
        return;
      }
      go();
    }
    catch (IPWorksSMIMEException ex) {
      System.out.println("IPWorksSMIMEException thrown: " + ex.getCode() + " [" +
                         ex.getMessage() + "].");
    }
    catch (Exception ex) {
      System.out.println(ex.getMessage());
    }
  }

  public void selectEncoding() throws IOException, IPWorksSMIMEException {
    char ch;
    System.out.println("\nEncoding choices:\n" +
                       "  1) Sign message\n" +
                       "  2) Encrypt message\n" +
                       "  3) Sign and encrypt message\n" +
                       "  0) Quit");
    ch = input().charAt(0);

    switch (ch) {
      case '1':
        sign();
        break;
      case '2':
        encrypt();
        break;
      case '3':
        signAndEncrypt();
        break;
      case '0':
        quit = true;
        break;
    }
  }

  private void sign() throws IPWorksSMIMEException {
    selectCertificate();
    ssmtp1.setCertificate(certmgr.getCert());
    ssmtp1.setIncludeCertificate(true);
    ssmtp1.sign();
  }

  private void encrypt() throws IPWorksSMIMEException {
    selectCertificate();
    ssmtp1.addRecipientCert(certmgr.getCert().getEncoded());
    ssmtp1.encrypt();
  }

  private void signAndEncrypt() throws IPWorksSMIMEException {
    System.out.println("Please select signing certificate:");
    selectCertificate();
    ssmtp1.setCertificate(certmgr.getCert());
    ssmtp1.setIncludeCertificate(true);
    System.out.println("Please select encrypting certificate:");
    selectCertificate();
    ssmtp1.addRecipientCert(certmgr.getCert().getEncoded());
    ssmtp1.signAndEncrypt();
  }

  private String input() throws IOException {
    BufferedReader bf = new BufferedReader(new InputStreamReader(System.in));
    return bf.readLine();
  }

  public static void main(String[] args) {
	new ssmtp();
  }

  private void selectCertificate() {
    try {
      String buffer;
      certmgr.setCertStoreType(Certificate.cstJKSFile);
      System.out.print("Please enter java key store path [myidentities.jks]: ");
      buffer = input();
      if ( buffer.length()==0 ) {
        buffer = "myidentities.jks";
      }
      certmgr.setCertStore(buffer);
      System.out.print("Please enter store password [password]: ");
      buffer = input();
      if ( buffer.length() == 0 ) {
        buffer = "password";
      }
      certmgr.setCertStorePassword(buffer);
      System.out.println("Please select a certificate:");
      certmgr.listStoreCertificates();
      int selection = Integer.parseInt(input());
      certmgr.setCert(new Certificate(
          Certificate.cstJKSFile,
          certmgr.getCertStore(),
          certmgr.getCertStorePassword(),
          (String) al.get(selection - 1) // noneed for cast if you are using 1.5 generics
                      ));

    }
    catch (IPWorksSMIMEException ex) {
      System.out.println("IPWorksSMIMEException thrown: " + ex.getCode() + " [" +
                         ex.getMessage() + "].");
    }
    catch (Exception ex) {
      System.out.println(ex.getMessage());
    }
  }

  public void certList(CertMgrCertListEvent args) {
    al.add(args.certSubject); //jdk1.5 should throw a warning here because of typed vectors in 1.5 (see vector definitons above)
    index++;
    System.out.println(index + ". " + args.certSubject);
  }

  public void error(CertMgrErrorEvent args) {
    System.out.println("CertMgr error: " + args.errorCode + " [" +
                       args.description + "].");
  }
}

class CertMgrEvents implements CertMgrEventListener{
		ssmtp instance;
  public CertMgrEvents(ssmtp instance) {
    this.instance = instance;
  }

  public void certChain(CertMgrCertChainEvent args) {

  }

  public void certList(CertMgrCertListEvent args) {
    instance.certList(args);
  }

  public void error(CertMgrErrorEvent args) {
    instance.error(args);
  }

  public void keyList(CertMgrKeyListEvent args) {

  }

  public void storeList(CertMgrStoreListEvent args) {

  }
  
  public void log(CertMgrLogEvent args){}
}

class ConsoleDemo {
  private static BufferedReader bf = new BufferedReader(new InputStreamReader(System.in));

  static String input() {
    try {
      return bf.readLine();
    } catch (IOException ioe) {
      return "";
    }
  }
  static char read() {
    return input().charAt(0);
  }

  static String prompt(String label) {
    return prompt(label, ":");
  }
  static String prompt(String label, String punctuation) {
    System.out.print(label + punctuation + " ");
    return input();
  }
  static String prompt(String label, String punctuation, String defaultVal) {
      System.out.print(label + " [" + defaultVal + "]" + punctuation + " ");
      String response = input();
      if (response.equals(""))
        return defaultVal;
      else
        return response;
  }

  static char ask(String label) {
    return ask(label, "?");
  }
  static char ask(String label, String punctuation) {
    return ask(label, punctuation, "(y/n)");
  }
  static char ask(String label, String punctuation, String answers) {
    System.out.print(label + punctuation + " " + answers + " ");
    return Character.toLowerCase(read());
  }

  static void displayError(Exception e) {
    System.out.print("Error");
    if (e instanceof IPWorksSMIMEException) {
      System.out.print(" (" + ((IPWorksSMIMEException) e).getCode() + ")");
    }
    System.out.println(": " + e.getMessage());
    e.printStackTrace();
  }

  /**
   * Takes a list of switch arguments or name-value arguments and turns it into a map.
   */
  static java.util.Map<String, String> parseArgs(String[] args) {
    java.util.Map<String, String> map = new java.util.HashMap<String, String>();
    
    for (int i = 0; i < args.length; i++) {
      // Add a key to the map for each argument.
      if (args[i].startsWith("-")) {
        // If the next argument does NOT start with a "-" then it is a value.
        if (i + 1 < args.length && !args[i + 1].startsWith("-")) {
          // Save the value and skip the next entry in the list of arguments.
          map.put(args[i].toLowerCase().replaceFirst("^-+", ""), args[i + 1]);
          i++;
        } else {
          // If the next argument starts with a "-", then we assume the current one is a switch.
          map.put(args[i].toLowerCase().replaceFirst("^-+", ""), "");
        }
      } else {
        // If the argument does not start with a "-", store the argument based on the index.
        map.put(Integer.toString(i), args[i].toLowerCase());
      }
    }
    return map;
  }
}



