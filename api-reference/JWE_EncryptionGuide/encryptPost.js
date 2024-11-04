const crypto = require("crypto");

(async () => {
  const claims     = "{ \"order_id\" : \"test_2340\", \"options.add_full_gateway_response\" : \"true\"}"; // add Stringify JSON Request Here
  const keyId      = "key_XXXXXXXXXXXXXXXXX"; // add Key ID Here
  const publicKey  = readPublicKey("-----BEGIN PUBLIC KEY-----********************-----END PUBLIC KEY-----"); // add Public Key Here
  const privateKey = readPrivateKey("-----BEGIN RSA PRIVATE KEY-----*************-----END RSA PRIVATE KEY-----"); // add Private Key Here

  const encryptedPayload = jwtEncrypt(claims, keyId, publicKey, privateKey);
  const serializedApiRequest = {
    JWT: encryptedPayload,
  };
  console.log(JSON.stringify(serializedApiRequest));
})();


//  ENCRYPT
/**
 * Encrypts the given data.
 * @param {string} data - Data to encrypt.
 * @param {string} keyId - Key ID.
 * @param {crypto.KeyObject} publicKey - Public key.
 * @returns {string} Encrypted token.
 * @throws {Error} If encryption fails.
 */
function encrypt(data, keyId, publicKey) {
  const headers = {
    alg: "RSA-OAEP",
    enc: "A256GCM",
    cty: "JWT",
    kid: keyId,
  };
  const aad = encodeBase64Url(JSON.stringify(headers));
  const cek = crypto.randomBytes(32);
  const cekOptions = {
    key: publicKey,
    padding: crypto.constants.RSA_PKCS1_OAEP_PADDING,
  };
  const encryptedKey = encodeBase64UrlFromBuffer(
    crypto.publicEncrypt(cekOptions, cek)
  );
  const iv = crypto.randomBytes(12);
  const cipher = crypto.createCipheriv("aes-256-gcm", cek, iv);
  cipher.setAutoPadding(false);
  cipher.setAAD(Buffer.from(aad));
  const cipherOutput = Buffer.concat([cipher.update(data), cipher.final()]);
  const authTag = cipher.getAuthTag();
  const ivText = encodeBase64UrlFromBuffer(iv);
  const cipherText = encodeBase64UrlFromBuffer(cipherOutput);
  const tag = encodeBase64UrlFromBuffer(authTag);
  return `${aad}.${encryptedKey}.${ivText}.${cipherText}.${tag}`;
}

/**
 * Signs the given claims.
 * @param {string} claims - Claims to sign.
 * @param {string} keyId - Key ID.
 * @param {crypto.KeyObject} privateKey - Private key.
 * @returns {string} Signed string.
 * @throws {Error} If signing fails.
 */
function sign(claims, keyId, privateKey) {
  const signer = crypto.createSign('RSA-SHA256');
  const signatureHeader = `{"alg":"RS256","kid":"${keyId}"}`;
  const header = encodeBase64Url(signatureHeader);
  const payload = encodeBase64Url(claims);
  const data = `${header}.${payload}`;
  signer.update(data);
  const signedBuffer = signer.sign(privateKey);
  const signed = encodeBase64UrlFromBuffer(signedBuffer);
  return `${header}.${payload}.${signed}`;
}

/**
 * Encrypts the given data and returns a jwe token.
 * @param {string} data - Data to encrypt.
 * @param {string} keyId - Key ID.
 * @param {crypto.KeyObject} publicKey - Public key.
 * @param {crypto.KeyObject} privateKey - Private key.
 * @returns {string} Encrypted token.
 */
function jwtEncrypt(data, keyId, publicKey, privateKey) {
  const signed = sign(data, keyId, privateKey);
  return encrypt(signed, keyId, publicKey);
}

// UTILS

/**
 * Encodes a string into Base64 URL format.
 * @param {string} original - The original string to encode.
 * @returns {string} The Base64 URL encoded string.
 */
function encodeBase64Url(original) {
  return encodeBase64UrlFromBuffer(Buffer.from(original));
}

/**
 * Encodes a buffer into Base64 URL format.
 * @param {Buffer} buffer - The buffer to encode.
 * @returns {string} The Base64 URL encoded string.
 */
function encodeBase64UrlFromBuffer(buffer) {
  return buffer
    .toString('base64')
    .replace(/\+/g, '-')
    .replace(/\//g, '_')
    .replace(/=/g, '');
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
