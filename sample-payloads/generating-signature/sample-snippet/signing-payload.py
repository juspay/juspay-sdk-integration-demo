#!/bin/python
# pip install pycryptodome 

import json

from Crypto.PublicKey import RSA # ignore this
from Crypto.Signature import PKCS1_v1_5
from Crypto.Hash import SHA256
from base64 import b64encode

privateKeyString = "-----BEGIN RSA PRIVATE KEY-----\nMIIEowIBAA70vuNEyFLz2FzpPYzwN5...aX1rYhPBmS89Yt6pu6McT7jlnw\n-----END RSA PRIVATE KEY-----"
# This is a sample snippet. Always store and fetch the private key from crypto vault

privateKey = RSA.import_key(privateKeyString)

def createSignature (payload, privateKey):
    requiredFields = ["order_id", "merchant_id", "amount", "timestamp", "customer_id"]
    signaturePayload = json.dumps(payload)
    for key in requiredFields:
        if key not in payload:
            raise ValueError (key , " not found in payload")
    signer = PKCS1_v1_5.new(privateKey)
    digest = SHA256.new()
    digest.update(signaturePayload.encode('utf-8'))
    signature = signer.sign(digest)
    encodedSignature = b64encode(signature)
    return encodedSignature, signaturePayload