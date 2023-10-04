# Note: The input payload for encrypt method should be a json object
from jwcrypto import jwk, jwe
​
import json
import time
from calendar import timegm  
from datetime import datetime  
from hashlib import sha256  
import hmac 
​
def encrypt(payload):
        # config = Configuration()
        payload = json.dumps(payload)
        protected_header = {
            "alg": "RSA-OAEP-256",
            "enc": "A128GCM",
            "kid": "<public key uuid as shared by Juspay>"
        }
        jwetoken = jwe.JWE(payload.encode('utf-8'),
                            recipient=loadPem('<path where public key is present>'),
                            protected=protected_header)
        encryptedPayload = jwetoken.serialize(compact=True)
        return json.dumps({"encData": encryptedPayload})
​
def loadPem(filePath):
    with open(filePath, "rb") as pemfile:
        return jwk.JWK.from_pem(pemfile.read())
    
​
def decrypt(encPayload):
        if type(encPayload) is str:
            payload = json.loads(encPayload)
            if payload.get('encData', False):
                jwetoken = jwe.JWE()
                jwetoken.deserialize(payload["encData"], key=loadPem('<path where private key is present>'))
                return json.dumps(json.loads(jwetoken.payload))
        return encPayload
​
​
#Command to encrypt card details 
print(encrypt('{"cardNumber": "<card_number>","expMonth": "<MM>","expYear": "<YYYY>","cardSecurityCode": "<3 digits/ 4 digits>"}'))
​
​
#Command to get the decrypted details
print(decrypt('{"encData": "<encrypted data from API response>"}'))