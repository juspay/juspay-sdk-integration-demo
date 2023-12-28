//———Sample Code For Signing the Payload (JWS)———
const jose = require('node-jose');

async function jwtEncryptRequest(
    data,
    keyId,
    publicKeyString,
    privateKeyString
) {
    const privateKey = await jose.JWK.asKey(privateKeyString, `pem`);
    const publicKey = await jose.JWK.asKey(publicKeyString, 'pem');
    let userPayload;
    
   //block:start:generate-signature-using-private-key
    
    try {
        userPayload = JSON.stringify(data);// Step 2.1: Convert the JSON payload to string
} catch (error) {
        throw new Error(
            `Error parsing the payload, here's the error log:- ${error.message}`
);
}
    console.log(typeof data);
    console.log(userPayload);

    if (keyId === undefined || keyId === '') {
        throw new Error('Key id cannot be empty/undefined');
}

// Step 2.2: Generate a signature using Private Key
    const signer = jose.JWS.createSign(
{ fields: { alg: 'RS256', kid: keyId }, format: 'flattened' },
        privateKey
).update(userPayload);

    const signedResult = await signer.final();

 //block:end:generate-signature-using-private-key


//block:start:serialize-signature-to-json

// Step 3: Serialize the Signature (JWS) to JSON Format
    const signedJws = JSON.parse(JSON.stringify(signedResult));
    const signedJwsTransform = {
        payload: signedJws.payload,
        signature: signedJws.signature,
        header: signedJws.protected,
};

//block:start:serialize-signature-to-json


//———Sample Code For Encrypting the Payload (JWE)———

//block:start:stringify-json-payload

// Step 1: Stringify the JSON payload

jwsPayload = JSON.stringify(signedJwsTransform);

//block:end:stringify-json-payload

//block:start:encrypt-payload

//Step 2: Encrypt the Payload using Bank’s Public Key 
    const encryptHandler = jose.JWE.createEncrypt(
{
            format: 'flattened',
            contentAlg: 'RSA-OAEP-256',
            fields: {
                enc: 'A256GCM',
                cty: 'JWT',
                kid: keyId,
                alg: 'RSA-OAEP-256',
},
            protect: ['kid', 'enc', 'cty', 'alg'],
},
        publicKey
).update(jwsPayload);

const res = await encryptHandler.final();
const encryptedJWE = JSON.parse(JSON.stringify(res));

//block:end:encrypt-payload

//block:start:serialize-encrypted-payload

//Step 3: Serialize the Encrypted Payload (JWE) to JSON Format
    const encryptedJWETransform = {
        header: encryptedJWE.protected,
        encryptedKey: encryptedJWE.encrypted_key,
        iv: encryptedJWE.iv,
        encryptedPayload: encryptedJWE.ciphertext,
        tag: encryptedJWE.tag,
};
    return encryptedJWETransform;
}

//block:start:serialize-encrypted-payload
