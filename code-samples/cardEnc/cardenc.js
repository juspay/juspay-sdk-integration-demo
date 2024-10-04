const crypto = require('crypto');

// Data to be encrypted
const data = "4012000000001097";

// Public key in Base64
const publicKeyBase64 = `MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAizgY4XSKoSmDoSK5g5Ma
JS9hZvX5C6rgSYQui9rbdBw+WZq2pRSV6MDMJQFTb9grXx3Ztj1wt1ESN5VAA5Gf
f2EO77ffiUtX716dYNq7NfOM3y8ssQ3Kh02Ow1xnlb9vc3gRfG+LpblCEa+vE+2f
oZa1/AhbRuZkvferOjB3YwacUVc0y25gO9HIL9iGd8aCl2cVhvFg3NOfJRQK3yhv
1mEar2k3AqGDj95Vw/stWytYFLDFzwU3xYlHxb3vNLunbMlfxCqluveOBh2huGEh
b0QNT4pSBK2UVaCZmukjcTXKD0c97brip2ZOHLo50V+njxn46mq6gJfE7RKFjPd5
/QIDAQAB`;

// Encrypt the data using the public key
const encryptedData = encrypt(data, publicKeyBase64);
console.log("Encrypted Data: " + "enc-" + encryptedData);

function encrypt(data, publicKeyBase64) {
    try {
        // Decode the public key from Base64
        const publicKeyBuffer = Buffer.from(publicKeyBase64, 'base64');

        // Create a public key from the decoded key
        const publicKey = crypto.createPublicKey({
            key: publicKeyBuffer,
            format: 'der',
            type: 'spki',
        });

        // Encrypt the data
        const encrypted = crypto.publicEncrypt(
            {
                key: publicKey,
                padding: crypto.constants.RSA_PKCS1_OAEP_PADDING,
                oaepHash: "sha256",
            },
            Buffer.from(data)
        );

        // Return Base64-encoded encrypted data
        return encrypted.toString('base64');
    } catch (err) {
        console.error("Encryption error:", err);
        return "";
    }
}
