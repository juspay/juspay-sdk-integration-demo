package com;
import java.io.FileReader;
import java.io.IOException;
import java.security.KeyFactory;
import java.security.KeyPair;
import java.security.NoSuchAlgorithmException;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.security.interfaces.RSAPublicKey;
import java.security.spec.InvalidKeySpecException;
import java.security.spec.X509EncodedKeySpec;
​
import org.bouncycastle.openssl.PEMKeyPair;
import org.bouncycastle.openssl.PEMParser;
import org.bouncycastle.openssl.jcajce.JcaPEMKeyConverter;
import org.bouncycastle.util.io.pem.PemObject;
import org.bouncycastle.util.io.pem.PemReader;
​
import com.nimbusds.jose.*;
import com.nimbusds.jose.crypto.RSADecrypter;
import com.nimbusds.jose.crypto.RSAEncrypter;
import com.fasterxml.jackson.annotation.JsonInclude.Include;
import com.fasterxml.jackson.databind.ObjectMapper;  
​
​
public class App {
​
    public static void main(String[] args) throws Exception {
        String keyId = "<public key uuid as shared by Juspay>";
        String payload="{\"cardNumber\":\"<card_number>\",\"expMonth\":\"<month>\",\"expYear\":\"<4digits_year>>\",\"cardSecurityCode\":\"<3digit/4digit>\"}";
        
        String encPayload = getEncryptedPayload(payload, keyId);
        System.out.println(encPayload);
​
        //In order to decrypt the encrypted response you get from API response, you can assign it to encryptedResponse variable for decrypting details.
        String encryptedResponse = "<encrypted response>";
        String decryptedResponse = getDecryptedPayload(encryptedResponse, String.class);
​
        System.out.println(decryptedResponse);
    }
​
​
    public static <T> T getDecryptedPayload(String response, Class<T> returnType)  {
    
        T decryptedResponse = null;
        try {
            JWEObject jweObject = JWEObject.parse(response);
           //If you have used passphrase while generating the csr make sure you the same while getting the private key. Otherwise decryption will fail.
            jweObject.decrypt(new RSADecrypter(getRSAPrivateKey()));
            response = jweObject.getPayload().toString();
            ObjectMapper mapper = new ObjectMapper();
            decryptedResponse = mapper.readValue(response, returnType);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return decryptedResponse;
    }
​
    private static PrivateKey getRSAPrivateKey() throws IOException, NoSuchAlgorithmException, InvalidKeySpecException {
        String pemFilePath = "<path where private key is present>";
​
        FileReader fileReader = new FileReader(pemFilePath);
        PEMParser pemParser = new PEMParser(fileReader);
​
        try {
            Object pemObject = pemParser.readObject();
​
            if (pemObject instanceof PEMKeyPair) {
                PEMKeyPair pemKeyPair = (PEMKeyPair) pemObject;
                JcaPEMKeyConverter converter = new JcaPEMKeyConverter();
                KeyPair keyPair = converter.getKeyPair(pemKeyPair);
                
                if (keyPair != null) {
                    return keyPair.getPrivate();
                } else {
                    throw new IllegalArgumentException("The PEM file does not contain a valid private key.");
                }
            } else {
                throw new IllegalArgumentException("The PEM file does not contain a private key.");
            }
        } finally {
            pemParser.close();
            fileReader.close();
        }
    }
​
​
    //Make sure you are reading and passing the correct keyId from credentials. This is required and is passed in headers.
    public static String getEncryptedPayload(Object payload, String keyId) throws Exception {
​
        ObjectMapper mapper = new ObjectMapper();
        mapper.setSerializationInclusion(Include.NON_NULL);
        mapper.setSerializationInclusion(Include.NON_EMPTY);
​
        String plainText = payload == null ? "" : mapper.writeValueAsString(payload);
        JWEHeader.Builder headerBuilder = new JWEHeader.Builder(JWEAlgorithm.RSA_OAEP_256, EncryptionMethod.A128GCM);
​
        headerBuilder.keyID(keyId);
        headerBuilder.customParam("iat", System.currentTimeMillis());
​
        JWEObject jweObject = new JWEObject(headerBuilder.build(), new Payload(plainText));
        jweObject.encrypt(new RSAEncrypter(getRSAPublicKey()));
        return "{\"encData\":\""+jweObject.serialize()+"\"}";
    }
​
    /*
    * Converts PEM file content to RSAPublicKey
    */
    private static RSAPublicKey getRSAPublicKey() throws Exception {
​
        String pemFilePath = "<path where Juspay's public key is available>";
​
        FileReader fileReader = new FileReader(pemFilePath);
        PemReader pemReader = new PemReader(fileReader);
​
        try {
            PemObject pemObject = pemReader.readPemObject();
​
            if (pemObject != null) {
                if ("PUBLIC KEY".equalsIgnoreCase(pemObject.getType())) {
                    byte[] publicKeyBytes = pemObject.getContent();
                    X509EncodedKeySpec keySpec = new X509EncodedKeySpec(publicKeyBytes);
                    KeyFactory keyFactory = KeyFactory.getInstance("RSA");
​
                    PublicKey publicKey = keyFactory.generatePublic(keySpec);
​
                    if (publicKey instanceof RSAPublicKey) {
                        return (RSAPublicKey) publicKey;
                    } else {
                        throw new IllegalArgumentException("The loaded key is not an RSAPublicKey.");
                    }
                } else {
                    throw new IllegalArgumentException("The PEM file does not contain a public key.");
                }
            } else {
                throw new IllegalArgumentException("No PEM data found in the file.");
            }
        } finally {
            pemReader.close();
            fileReader.close();
        }
    }
​
    public static RSAPublicKey readPEMPublicKey(String pemFilePath) throws Exception {
        FileReader fileReader = new FileReader(pemFilePath);
        PemReader pemReader = new PemReader(fileReader);

        try {
            PemObject pemObject = pemReader.readPemObject();
​
            if (pemObject != null) {
                if ("PUBLIC KEY".equalsIgnoreCase(pemObject.getType())) {
                    byte[] publicKeyBytes = pemObject.getContent();
                    X509EncodedKeySpec keySpec = new X509EncodedKeySpec(publicKeyBytes);
                    KeyFactory keyFactory = KeyFactory.getInstance("RSA");
​
                    PublicKey publicKey = keyFactory.generatePublic(keySpec);
​
                    if (publicKey instanceof RSAPublicKey) {
                        return (RSAPublicKey) publicKey;
                    } else {
                        throw new IllegalArgumentException("The loaded key is not an RSAPublicKey.");
                    }
                } else {
                    throw new IllegalArgumentException("The PEM file does not contain a public key.");
                }
            } else {
                throw new IllegalArgumentException("No PEM data found in the file.");
            }
        } finally {
            pemReader.close();
            fileReader.close();
        }
    }
}