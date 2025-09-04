# 
# IPWorks S/MIME 2024 Python Edition - Sample Project
# 
# This sample project demonstrates the usage of IPWorks S/MIME in a 
# simple, straightforward way. It is not intended to be a complete 
# application. Error handling and other checks are simplified for clarity.
# 
# www.nsoftware.com/ipworkssmime
# 
# This code is subject to the terms and conditions specified in the 
# corresponding product license agreement which outlines the authorized 
# usage and restrictions.
# 

import sys
import string
from ipworkssmime import *

input = sys.hexversion < 0x03000000 and raw_input or input


def ensureArg(args, prompt, index):
    if len(args) <= index:
        while len(args) <= index:
            args.append(None)
        args[index] = input(prompt)
    elif args[index] is None:
        args[index] = input(prompt)



def fireCertList(e):
  global i
  i = i + 1
  print(str(i) + ". " + e.cert_subject)

def fireError(e):
  print("ERROR: %s" % e)

def bufferCheck(val):
  temp = input()
  if temp == "":
    temp = val
  return temp

global i
i = 0

print("Welcome to the CertMgr demo. This demo will read the available\ncertificates from a provided certificate store (e.g. PFX, PEM, etc.).\n")

try:
  certmgr1 = CertMgr()

  certmgr1.on_error = fireError
  certmgr1.on_cert_list = fireCertList
  
  buffer = 0
  while buffer not in range(1,4):
    print("Select Certificate Store Type:")
    print("1: PFX File")
    print("2: PEMKey File")
    print("3: Java Key Store File")
    buffer = int(input("Selection: "))
  
  if buffer == 1:
    certmgr1.set_cert_store_type(2)
    print("Please Enter PFX File Path (./test.pfx):"),
    buffer = bufferCheck("./test.pfx")
  elif buffer == 2:
    certmgr1.set_cert_store_type(6)
    print("Please Enter PEMKey File Path:"),
    buffer = bufferCheck("./something.pem")
  else:
    certmgr1.set_cert_store_type(4)
    print("Please Enter JKS File Path:"),
    buffer = bufferCheck("./something.jks")

  certmgr1.set_cert_store(buffer)
  
  print("Please enter store password [test]: "),
  buffer = bufferCheck("test")
  certmgr1.set_cert_store_password(buffer)
  
  certmgr1.list_store_certificates()
  
except IPWorksSMIMEError as e:
  print("IPWorks Error: %s" %e.message)

except Exception as e:
  fireError(e)

