const privateKeyString = "-----BEGIN RSA PRIVATE KEY-----\nMIIEowIBAA70vuNEyFLz2FzpPYzwN5aX1rYhPBmS89Yt6pu6McT7jlnw\n-----END RSA PRIVATE KEY-----"    
 
// This is a sample snippet. Always store and fetch the private key from crypto vault

privateKey = new NodeRSA(privateKeyString);

function createSignature (payload, privateKey) {
    const requiredFields = ["order_id", "merchant_id", "amount", "timestamp", "customer_id"];
    var objKeys = Object.keys(payload);

    if (requiredFields.every(key => objKeys.includes(key))){
        const signaturePayload = JSON.stringify(payload);
        const signature = privateKey.sign(signaturePayload, "base64", "utf8");
        return {signature, signaturePayload}
    }
    throw Error ("Not a valid JSON payload");
}