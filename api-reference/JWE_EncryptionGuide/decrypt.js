const crypto = require("crypto");

(async () => {
  const apiResponse = {
    JWT : "xxxxxxxxxxxxxxxxxxxxxx" // Add Message here
  };
  const JWTToken   = apiResponse.JWT;
  const publicKey  = readPublicKey("-----BEGIN PUBLIC KEY-----********************-----END PUBLIC KEY-----"); // add Public Key Here
  const privateKey = readPrivateKey("-----BEGIN RSA PRIVATE KEY-----*********-----END RSA PRIVATE KEY-----"); // add Private Key Here

  const decryptedResponse = jwtDecrypt(JWTToken, publicKey, privateKey);
  console.log(decryptedResponse);
})();

// UTILS
/**
 * Decodes a Base64 URL encoded string.
 * @param {string} base64url - The Base64 URL encoded string to decode.
 * @returns {string} The decoded string.
 */
function decodeBase64Url(base64url) {
  return decodeBase64UrlToBuffer(base64url).toString();
}

/**
 * Decodes a Base64 URL encoded string into a buffer.
 * @param {string} base64url - The Base64 URL encoded string to decode.
 * @returns {Buffer} The decoded buffer.
 */
function decodeBase64UrlToBuffer(base64url) {
  // Decode the Base64 URL encoded string to a Base64 encoded string
  const base64 = base64url.replace(/-/g, '+').replace(/_/g, '/');
  return Buffer.from(base64, 'base64');
}

/**
 * Reads a public key from a string.
 * @param {string} [keyString] - Public key string in PEM format.
 * @returns {crypto.KeyObject} Public key object.
 * @throws {Error} If the key string is undefined or invalid.
 */
function readPublicKey(keyString) {
  if (keyString === undefined) {
    throw new Error("IllegalPublicKey");
  }
  return crypto.createPublicKey({
    key: keyString,
    format: "pem",
  });
}

/**
 * Reads a private key from a string.
 * @param {string} [keyString] - Private key string in PEM format.
 * @returns {crypto.KeyObject} Private key object.
 * @throws {Error} If the key string is undefined or invalid.
 */
function readPrivateKey(keyString) {
  if (keyString === undefined) {
    throw new Error("IllegalPrivateKey");
  }
  return crypto.createPrivateKey({
    key: keyString,
    format: "pem",
  });
}

// DECRYPT

/**
 * Decrypts the given encrypted token.
 * @param {string} cipher - Encrypted token or string representation of it.
 * @param {crypto.KeyObject} privateKey - Private key.
 * @returns {string} Decrypted data.
 * @throws {Error} If decryption fails.
 */
function decrypt(cipher, privateKey) {
  const cipherParts = cipher.split(".");
  if (cipherParts.length !== 5) {
    throw new Error("EncryptedCipherIllformed");
  }
  const data = {
    header: cipherParts[0],
    encryptedKey: cipherParts[1],
    iv: cipherParts[2],
    encryptedPayload: cipherParts[3],
    tag: cipherParts[4],
  };
  const aad = Buffer.from(data.header);
  const encryptedKey = decodeBase64UrlToBuffer(data.encryptedKey);
  const iv = decodeBase64UrlToBuffer(data.iv);
  const encryptedPayload = decodeBase64UrlToBuffer(data.encryptedPayload);
  const tag = decodeBase64UrlToBuffer(data.tag);
  const cekOptions = {
    key: privateKey,
    oaepHash: "sha256",
    padding: crypto.constants.RSA_PKCS1_OAEP_PADDING,
  };
  const cek = crypto.privateDecrypt(cekOptions, encryptedKey);
  const decipher = crypto.createDecipheriv("aes-256-gcm", cek, iv);
  decipher.setAutoPadding(false);
  decipher.setAAD(aad);
  decipher.setAuthTag(tag);
  const cipherOutput = Buffer.concat([
    decipher.update(encryptedPayload),
    decipher.final(),
  ]);
  return decodeBase64Url(cipherOutput.toString("base64"));
}

/**
 * Verifies the given signed object or string.
 * @param {string} signed - Signed object or string representation of it.
 * @param {crypto.KeyObject} publicKey - Public key.
 * @returns {string} Verified payload.
 * @throws {Error} If verification fails.
 */
function verify(signed, publicKey) {
  const signedParts = signed.split(".");
  if (signedParts.length !== 3) {
    throw new Error("SignatureIllformed");
  }
  const data = {
    header: signedParts[0],
    payload: signedParts[1],
    signature: signedParts[2],
  };
  const verifier = crypto.createVerify("RSA-SHA256");
  const protect = `${data.header}.${data.payload}`;
  verifier.update(protect);
  const isVerified = verifier.verify(publicKey, data.signature, "base64");
  if (isVerified) {
    return decodeBase64Url(data.payload);
  } else {
    throw new Error("SignatureValidationFailed");
  }
}

/**
 * Decrypts the given data and returns the decrypted string.
 * @param {string} data - Data to decrypt.
 * @param {crypto.KeyObject} publicKey - Public key.
 * @param {crypto.KeyObject} privateKey - Private key.
 * @returns {string} Decrypted data.
 */
function jwtDecrypt(data, publicKey, privateKey) {
  const signed = decrypt(data, privateKey);
  return verify(signed, publicKey);
}

