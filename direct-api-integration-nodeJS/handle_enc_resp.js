//———Sample Code For Handling Encrypted Response———
const jose = require('node-jose');


async function jwtDecryptRequest(body, publicKeyString, privateKeyString) {
    const privateKey = await jose.JWK.asKey(privateKeyString, `pem`);
    const publicKey = await jose.JWK.asKey(publicKeyString, 'pem');
    const jweBody = {
        protected: body.header,
        ciphertext: body.encryptedPayload,
        encrypted_key: body.encryptedKey,
        iv: body.iv,
        tag: body.tag,
};

//block:start:decrypt-response-payload

//Step 1:  Decrypt the response payload using your Private Key
    return await jose.JWE.createDecrypt(privateKey)
.decrypt(JSON.parse(JSON.stringify(jweBody)))
.then(async (jws) => {
            const jwsBody = JSON.parse(Buffer.from(jws.payload).toString());

            const token = `${jwsBody.header}.${jwsBody.payload}.${jwsBody.signature}`;

//block:end:decrypt-response-payload

//block:start:verify-signature

//Step 2: Verify the signature using the Bank’s Public Key.
            return await jose.JWS.createVerify(publicKey)
.verify(token)
.then((verifiedRes) =>
                    JSON.parse(Buffer.from(verifiedRes.payload).toString())
);
});
}

//block:end:verify-signature
