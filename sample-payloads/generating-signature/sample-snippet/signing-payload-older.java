import sun.security.util.DerInputStream;
import sun.security.util.DerValue;
import javax.xml.bind.DatatypeConverter;
import java.io.*;
import java.math.BigInteger;
import java.security.*;
import java.security.spec.InvalidKeySpecException;
import java.security.spec.PKCS8EncodedKeySpec;
import java.security.spec.RSAPrivateCrtKeySpec;
import java.util.HashMap;

import org.json.JSONObject;

public class SignatureUtil {

    //The method that signs the data using the private key that is stored in keyFile path
    public static HashMap<String, String> createSignature (JSONObject payload, String keyContentOrFile) throws Exception {
        Signature rsa = Signature.getInstance("SHA256withRSA");
        PrivateKey privateKey = null;

        if (keyContentOrFile.startsWith("--")) {
            privateKey = readPrivateKey(keyContentOrFile);
        } else {
            privateKey = readPrivateKeyFromFile(keyContentOrFile);
        }
        String[] requiredFields = {"order_id", "merchant_id", "amount", "timestamp", "customer_id"};
        for (String key : requiredFields)
            if(!payload.has(key))
                throw new Exception(key + " not found in payload");
        String signaturePayload = payload.toString();
        rsa.initSign(privateKey);
        rsa.update(signaturePayload.getBytes());
        byte[] sign =  rsa.sign();
        String encodedSignature = DatatypeConverter.printBase64Binary(sign);
        HashMap<String,String> response = new HashMap<String,String>();
        response.put("signature",encodedSignature);
        response.put("signaturePayload", signaturePayload);
        return response;
    }

    //Method to retrieve the Private Key from a file
    public static PrivateKey readPrivateKeyFromFile(String filename) throws Exception {
        File keyFile = new File(filename);
        BufferedReader reader = new BufferedReader(new FileReader(keyFile));
        String line;
        StringBuffer fileContent = new StringBuffer();
        Boolean isPkcs1Content = false;
        while ((line = reader.readLine()) != null) {
            if (!line.startsWith("--")) {
                fileContent.append(line).append("\n");
            } else if (!isPkcs1Content && line.startsWith("-----BEGIN RSA PRIVATE KEY-----")){
                isPkcs1Content = true;
            }
        }
        byte[] keyBytes = DatatypeConverter.parseBase64Binary(fileContent.toString());
        return generatePrivateKey(keyBytes, isPkcs1Content);
    }

    //Method to retrieve the Private Key from a variable
    public static PrivateKey readPrivateKey(String content) throws Exception {
        Boolean isPkcs1Content = false;

        if (content.startsWith("-----BEGIN RSA PRIVATE KEY-----")){
            isPkcs1Content = true;
        }
        content = content.replaceAll("-----BEGIN RSA PRIVATE KEY-----","");
        content = content.replaceAll("-----BEGIN PRIVATE KEY-----","");
        content = content.replaceAll("-----END RSA PRIVATE KEY-----","");
        content = content.replaceAll("-----END PRIVATE KEY-----","");
        byte[] keyBytes = DatatypeConverter.parseBase64Binary(content);
        return generatePrivateKey(keyBytes, isPkcs1Content);
    }

    private static PrivateKey generatePrivateKey(byte[] keyBytes, Boolean isPkcs1Content) throws IOException, NoSuchAlgorithmException, InvalidKeySpecException {
        PrivateKey privateKey = null;
        if (isPkcs1Content) {
            DerInputStream derReader = new DerInputStream(keyBytes);
            DerValue[] seq = derReader.getSequence(0);
            // skip version seq[0];
            BigInteger modulus = seq[1].getBigInteger();
            BigInteger publicExp = seq[2].getBigInteger();
            BigInteger privateExp = seq[3].getBigInteger();
            BigInteger prime1 = seq[4].getBigInteger();
            BigInteger prime2 = seq[5].getBigInteger();
            BigInteger exp1 = seq[6].getBigInteger();
            BigInteger exp2 = seq[7].getBigInteger();
            BigInteger crtCoef = seq[8].getBigInteger();

            RSAPrivateCrtKeySpec keySpec =
                    new RSAPrivateCrtKeySpec(modulus, publicExp, privateExp, prime1, prime2, exp1, exp2, crtCoef);
            KeyFactory keyFactory = KeyFactory.getInstance("RSA");
            privateKey = keyFactory.generatePrivate(keySpec);
        } else {
            PKCS8EncodedKeySpec spec = new PKCS8EncodedKeySpec(keyBytes);
            KeyFactory kf = KeyFactory.getInstance("RSA");
            privateKey = kf.generatePrivate(spec);
        }
        return privateKey;
    }

    public static void main(String[] args) throws Exception{
        JSONObject data = new JSONObject("{'order_id': 'venkatesh12','first_name': 'Test','last_name': 'Customer','customer_phone': '9876543210','customer_email': 'test@gmail.com','merchant_id': 'udit_juspay','amount': '1.00','customer_id': '9876543210','return_url': 'https://sandbox.juspay.in/end','currency': 'INR','mandate.start_date': '1638535683287','mandate.end_date': '2134731745451','timestamp': '312342'}");
        
        //This is a sample snippet. Always store and fetch the private key from crypto vault
        String fileContent = "-----BEGIN RSA PRIVATE KEY-----\r\n" +
                "MIIEpAIBAAKCAQEAzEHPYKNYRcZoWtgTvYPEmTeiSlMxJwNPf8bRJ5U6cXiup2j/\r\n" +
                "a/l1oAiuVNQiDRzvSflS80FoRjQjcGRyqTYcYYYUTYOTh6j1WY1SQuPqrsvGNR3L\r\n" +
                "/6CfbI2iD4bPRx2XdPbxr6UoHNvh6y1hAscZy5oxSCT6WW5jCpW1Bg==\r\n" +
                "-----END RSA PRIVATE KEY-----\r\n";

        // Sign with content in code
        HashMap<String,String> p1 = createSignature(data, fileContent);

        // Sign with content in file on given absolute path
        HashMap<String,String> p2 = createSignature(data, "/<absolute-path-to-folder-containing-pem-file>/private-key.pem");
    
    }
}