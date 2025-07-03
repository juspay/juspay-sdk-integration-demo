#———Sample Code For Encrypted Request (JWE)———

from jwcrypto import jwk, jws, jwe
import json

def jwt_encrypt_request(data, key_id):
    public_key_path = "/Users/srikanthmitra/Downloads/MechantTEst/key_bd0bee7543a74435a8f4ce426c7cc234.pem" #Enter the actual path of Public key
    private_key_path = "/Users/srikanthmitra/Downloads/MechantTEst/privateKey.pem" #Enter the actual path of Private key

    with open(private_key_path, "rb") as f:
        private_key_string = f.read()
    with open(public_key_path, "rb") as f:
        public_key_string = f.read()

    private_key = jwk.JWK.from_pem(private_key_string)
    public_key = jwk.JWK.from_pem(public_key_string)

    try:
        user_payload = json.dumps(data)
    except Exception as error:
        raise Exception(f"Error parsing the payload: {str(error)}")

    if not key_id:
        raise ValueError("Key id cannot be empty/undefined")
    
    #———Sample Code For Signing the Payload (JWS)———

    #Step 2.1: Convert the JSON payload to string

    token = jws.JWS(user_payload.encode("utf-8"))
    token.add_signature(private_key, protected={"alg": "RS256", "kid": key_id})
    signed_result = token.serialize(compact=False)

    #Step 2.2: Generate a signature using Private Key

    signed_jws = json.loads(signed_result)
    signed_jws_transform = {
        "payload": signed_jws["payload"],
        "signature": signed_jws["signature"],
        "header": signed_jws["protected"],
    }

    # Step 3: Serialize the Signature (JWS) to JSON Format

    jws_payload = json.dumps(signed_jws_transform)

    #———Sample Code For Encrypting the Payload (JWE)———

    #Step 2: Encrypt the Payload using Bank’s Public Key

    encrypted = jwe.JWE(
        jws_payload.encode("utf-8"),
        protected={
            "enc": "A256GCM",
            "cty": "JWT",
            "kid": key_id,
            "alg": "RSA-OAEP-256",
        },
    )
    encrypted.add_recipient(public_key)
    encrypted_result = encrypted.serialize(compact=False)
    enc_json = json.loads(encrypted_result)


    #Step 3: Serialize the Encrypted Payload (JWE) to JSON Format
    encrypted_jwe_transform = {
        "header": enc_json["protected"],
        "encryptedKey": enc_json["encrypted_key"],
        "iv": enc_json["iv"],
        "encryptedPayload": enc_json["ciphertext"],
        "tag": enc_json["tag"],
    }

    return encrypted_jwe_transform

#data to be encrypted. 

data = {"order_id": "testing-order-one13","amount": "1.0","customer_id": "testing-customer-one","customer_email": "test@mail.com","customer_phone": "9876543210","payment_page_client_id":"hdfcmaster",
  "action": "paymentPage",
  "return_url": "https://shop.merchant.com",
  "description": "Complete your payment",
  "first_name": "John",
  "last_name": "wick"
}
key_id = "key_bd0bee7543a74435a8f4ce426c7cc234"   #Replace with the value in KEY_UUID obtained in config.json file. 
value = jwt_encrypt_request(data, key_id)
print(value)
