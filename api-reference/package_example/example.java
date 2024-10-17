package org.example;

import com.nimbusds.jose.*;
import com.nimbusds.jose.crypto.RSADecrypter;
import com.nimbusds.jose.crypto.RSASSAVerifier;
import com.nimbusds.jose.crypto.bc.BouncyCastleProviderSingleton;
import org.apache.commons.codec.binary.Base64;

import javax.xml.bind.DatatypeConverter;
import java.security.*;
import java.security.interfaces.RSAPublicKey;
import java.security.spec.InvalidKeySpecException;
import java.security.spec.PKCS8EncodedKeySpec;
import java.security.spec.X509EncodedKeySpec;
import java.text.ParseException;

public class DecryptAndVerifyApiResponse {
    final private static String keyId = "your api key";
    // private key secretly stored at merchant's side
    final private static String fileContentPrivateKey = "-----BEGIN RSA PRIVATE KEY----- .......... -----END RSA PRIVATE KEY-----";
    // public key secretly stored at merchant's side
    final static private String fileContentPublicKey = "-----BEGIN PUBLIC KEY----- .......... -----END PUBLIC KEY-----";

    final private static PrivateKey privateKey;
    final private static PublicKey publicKey;

    static {
        // This is required if you are reading pkcs1 format i.e. keys have BEGIN/END RSA PUBLIC/PRIVATE KEY
        Provider bc = BouncyCastleProviderSingleton.getInstance();
        Security.addProvider(bc);
        try {
            privateKey = readPrivateKeyFromString(fileContentPrivateKey);
            publicKey = readPublicKeyFromString(fileContentPublicKey);
        } catch (NoSuchAlgorithmException | InvalidKeySpecException e) {
            System.out.println("Invalid key format");
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    public static void main(String[] args) throws ParseException, JOSEException {
        // api request will of {"JWT": "eyJhbGciOiJSU0EtT0FFUC0yNTYiLCJlbmMiOiJBMjU2R0NNIiwia2lkIjoia2V5X2NjY2NjZGE5N2U4YjRkMWJhZDZjYTcyYzF ------------------- ei3wyuhxsVpN_XP-mUlODA"} extract the value of JWT field for decryption
        String encryptedApiResponseToken = "eyJhbGciOiJSU0EtT0FFUC0yNTYiLCJlbmMiOiJBMjU2R0NNIiwia2lkIjoia2V5X2NjY2NjZGE5N2U4YjRkMWJhZDZjYTcyYzF ------------------- ei3wyuhxsVpN_XP-mUlODA";
        String decryptedAndVerifiedApiResponse = decryptAndVerifyPayload(encryptedApiResponseToken);
        System.out.println(decryptedAndVerifiedApiResponse);
    }

    public static String decryptAndVerifyPayload(String signedAndEncryptedPayload) throws ParseException, JOSEException {
        // jwe decrypt the request
        JWEObject jweObject = JWEObject.parse(signedAndEncryptedPayload);
        jweObject.decrypt(new RSADecrypter(privateKey));
        String jweData = jweObject.getPayload().toString();
        // jws verify the signature
        JWSObject jwsObject = JWSObject.parse(jweData);
        jwsObject.verify(new RSASSAVerifier((RSAPublicKey) publicKey));
        return jwsObject.getPayload().toString();
    }

    static PrivateKey readPrivateKeyFromString(String key) throws NoSuchAlgorithmException, InvalidKeySpecException {
        String privateKeyPEM = key
                .replace("-----BEGIN PRIVATE KEY-----", "")
                .replace("-----BEGIN RSA PRIVATE KEY-----", "")
                .replace("-----END RSA PRIVATE KEY-----", "")
                .replace(System.lineSeparator(), "")
                .replace("-----END PRIVATE KEY-----", "");
        byte[] encoded = Base64.decodeBase64(privateKeyPEM);
        KeyFactory keyFactory = KeyFactory.getInstance("RSA");
        PKCS8EncodedKeySpec keySpec = new PKCS8EncodedKeySpec(encoded);
        return keyFactory.generatePrivate(keySpec);
    }

    static RSAPublicKey readPublicKeyFromString(String key) throws NoSuchAlgorithmException, InvalidKeySpecException {
        KeyFactory kf = KeyFactory.getInstance("RSA");
        String keyContent = key.replaceAll("\\n", "")
                .replace("-----BEGIN PUBLIC KEY-----", "")
                .replace("-----END PUBLIC KEY-----", "")
                .replace("-----BEGIN RSA PUBLIC KEY-----", "")
                .replace("-----END RSA PUBLIC KEY-----", "")
                .replace(System.lineSeparator(), "");
        byte[] pkey = DatatypeConverter.parseBase64Binary(keyContent);
        return (RSAPublicKey)kf.generatePublic(new X509EncodedKeySpec(pkey));
    }
}package org.example;

import com.nimbusds.jose.*;
import com.nimbusds.jose.crypto.RSADecrypter;
import com.nimbusds.jose.crypto.RSASSAVerifier;
import com.nimbusds.jose.crypto.bc.BouncyCastleProviderSingleton;
import org.apache.commons.codec.binary.Base64;

import javax.xml.bind.DatatypeConverter;
import java.security.*;
import java.security.interfaces.RSAPublicKey;
import java.security.spec.InvalidKeySpecException;
import java.security.spec.PKCS8EncodedKeySpec;
import java.security.spec.X509EncodedKeySpec;
import java.text.ParseException;

public class DecryptAndVerifyApiResponse {
    final private static String keyId = "your api key";
    // private key secretly stored at merchant's side
    final private static String fileContentPrivateKey = "-----BEGIN RSA PRIVATE KEY----- .......... -----END RSA PRIVATE KEY-----";
    // public key secretly stored at merchant's side
    final static private String fileContentPublicKey = "-----BEGIN PUBLIC KEY----- .......... -----END PUBLIC KEY-----";

    final private static PrivateKey privateKey;
    final private static PublicKey publicKey;

    static {
        // This is required if you are reading pkcs1 format i.e. keys have BEGIN/END RSA PUBLIC/PRIVATE KEY
        Provider bc = BouncyCastleProviderSingleton.getInstance();
        Security.addProvider(bc);
        try {
            privateKey = readPrivateKeyFromString(fileContentPrivateKey);
            publicKey = readPublicKeyFromString(fileContentPublicKey);
        } catch (NoSuchAlgorithmException | InvalidKeySpecException e) {
            System.out.println("Invalid key format");
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    public static void main(String[] args) throws ParseException, JOSEException {
        // api request will of {"JWT": "eyJhbGciOiJSU0EtT0FFUC0yNTYiLCJlbmMiOiJBMjU2R0NNIiwia2lkIjoia2V5X2NjY2NjZGE5N2U4YjRkMWJhZDZjYTcyYzF ------------------- ei3wyuhxsVpN_XP-mUlODA"} extract the value of JWT field for decryption
        String encryptedApiResponseToken = "eyJhbGciOiJSU0EtT0FFUC0yNTYiLCJlbmMiOiJBMjU2R0NNIiwia2lkIjoia2V5X2NjY2NjZGE5N2U4YjRkMWJhZDZjYTcyYzF ------------------- ei3wyuhxsVpN_XP-mUlODA";
        String decryptedAndVerifiedApiResponse = decryptAndVerifyPayload(encryptedApiResponseToken);
        System.out.println(decryptedAndVerifiedApiResponse);
    }

    public static String decryptAndVerifyPayload(String signedAndEncryptedPayload) throws ParseException, JOSEException {
        // jwe decrypt the request
        JWEObject jweObject = JWEObject.parse(signedAndEncryptedPayload);
        jweObject.decrypt(new RSADecrypter(privateKey));
        String jweData = jweObject.getPayload().toString();
        // jws verify the signature
        JWSObject jwsObject = JWSObject.parse(jweData);
        jwsObject.verify(new RSASSAVerifier((RSAPublicKey) publicKey));
        return jwsObject.getPayload().toString();
    }

    static PrivateKey readPrivateKeyFromString(String key) throws NoSuchAlgorithmException, InvalidKeySpecException {
        String privateKeyPEM = key
                .replace("-----BEGIN PRIVATE KEY-----", "")
                .replace("-----BEGIN RSA PRIVATE KEY-----", "")
                .replace("-----END RSA PRIVATE KEY-----", "")
                .replace(System.lineSeparator(), "")
                .replace("-----END PRIVATE KEY-----", "");
        byte[] encoded = Base64.decodeBase64(privateKeyPEM);
        KeyFactory keyFactory = KeyFactory.getInstance("RSA");
        PKCS8EncodedKeySpec keySpec = new PKCS8EncodedKeySpec(encoded);
        return keyFactory.generatePrivate(keySpec);
    }

    static RSAPublicKey readPublicKeyFromString(String key) throws NoSuchAlgorithmException, InvalidKeySpecException {
        KeyFactory kf = KeyFactory.getInstance("RSA");
        String keyContent = key.replaceAll("\\n", "")
                .replace("-----BEGIN PUBLIC KEY-----", "")
                .replace("-----END PUBLIC KEY-----", "")
                .replace("-----BEGIN RSA PUBLIC KEY-----", "")
                .replace("-----END RSA PUBLIC KEY-----", "")
                .replace(System.lineSeparator(), "");
        byte[] pkey = DatatypeConverter.parseBase64Binary(keyContent);
        return (RSAPublicKey)kf.generatePublic(new X509EncodedKeySpec(pkey));
    }
}
