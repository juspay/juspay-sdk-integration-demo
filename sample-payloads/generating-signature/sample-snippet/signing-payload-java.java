package com.newjuspay;

import sun.security.util.DerInputStream;
import sun.security.util.DerValue;

import javax.xml.bind.DatatypeConverter;
import java.io.*;
import java.math.BigInteger;
import java.net.URLEncoder;
import java.net.URLDecoder;
import java.security.*;
import java.security.spec.InvalidKeySpecException;
import java.security.spec.PKCS8EncodedKeySpec;
import java.security.spec.RSAPrivateCrtKeySpec;


public class JuspayUtil {

    //The method that signs the data using the private key that is stored in keyFile path
    public static String sign(String data, String keyContentOrFile,Boolean urlEncodeSignature) throws Exception {
        Signature rsa = Signature.getInstance("SHA256withRSA");
        PrivateKey privateKey = null;
        data = URLDecoder.decode(data);

        if (keyContentOrFile.startsWith("--")) {
            privateKey = readPrivateKey(keyContentOrFile);
        } else {
            privateKey = readPrivateKeyFromFile(keyContentOrFile);
        }
        rsa.initSign(privateKey);
        rsa.update(data.getBytes());
        byte[] sign =  rsa.sign();
        if (urlEncodeSignature) {
            return URLEncoder.encode(DatatypeConverter.printBase64Binary(sign), "UTF-8");
        } else {
            return DatatypeConverter.printBase64Binary(sign);
        }
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
        byte[] keyBytes = DatatypeConverter.parseBase64Binary(content.toString());
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
        String data = "{\"merchant_id\":\"mid\",%20\"customer_id\":%20\"8600143648\",\"mobile_number\":%20\"8600143648\",\"email_address\":%20\"siddharth@gmail.com\",\"time_stamp\":\"1576227696\"}";
        String fileContent = "-----BEGIN RSA PRIVATE KEY-----\r\n" + 
        		"MIIEpAIBAAKCAQEAzEHPYKNYRcZoWtgTvYPEmTeiSlMxJwNPf8bRJ5U6cXiup2j/\r\n" + 
        		"a/l1oAiuVNQiDRzvSflS80FoRjQjcGRyqTYcYYYUTYOTh6j1WY1SQuPqrsvGNR3L\r\n" + 
        		"NG0owiXTheDd4S6NlK9zBXI1Gtf6Q/mGowfOje/W1i6AwDl1stPmplA7YleiHOUU\r\n" + 
        		"X5XW3jKFChnLFcmD1hpvNrDbCYhy0xVHv2Pc0GhmFlavCTc2yPHYWwTyFYzY7PsX\r\n" + 
        		"UVn3gSuL6w+aW7h7/1OkSYQzr6siLSqfGUfDIXqF2Oke4+PdhmbyqJ6vqNhH7C3e\r\n" + 
        		"PuK8jGyaOsRWDgg1Sxc7fLFyA3CU7B00KIfcKwIDAQABAoIBAQCP8kkdh8Ar3Dmq\r\n" + 
        		"2+B9jKE+gVCkJKDdJ54dJJY92RMI6M3dOUfYZkOY9sU1DxK4Pw38CfOFbzD3WMMo\r\n" + 
        		"8AFGctXpfL5OKk4MKuxNoiS48zpu2TjkMg0E83Dn8hRxoxl7Gn24rTTYP7ZhJpg+\r\n" + 
        		"01kpB9VvffjflIIz9cqWrnM7/gr7sBZjfNFFXmq2D9mvUrJVeyEWdJc5//2OuJKS\r\n" + 
        		"tlDJmW6vrGM9K28Q8btyJcQOWl2IrIhICGMoSVdIJeRssd9mm1x4dVPaM315tQHe\r\n" + 
        		"/CIFbENWI5jmutGfwb0lmiZJXayxEB5+4CPsYd+vxac+DSsbpZ3KJGWdrm+SFBsK\r\n" + 
        		"WoM1Wq6hAoGBAP7MiOV/7Z9zJVVcwW3/R7BgW6T/fszqKfFdOcOCHq+IMH9gU/K/\r\n" + 
        		"qwf5LTCOfeK4yQLg+uY/27D2IhIbRapp60BJ0PB2AT6lp5WnZHjO0llYknJsGVmW\r\n" + 
        		"axMUi3+h+h1+UXfkb8yosY3PQcIdVp/zlJWT4qRQ5DWCPJLj6ah15V7JAoGBAM04\r\n" + 
        		"SVsD+axQMvTRLs46B0V9JCLlr/fNol1Y8PhRNka3qsmUmE0eYwrAMoBsFJczHbDX\r\n" + 
        		"JuViFTg5LKLemPi7lr3SY8LC2oCF0LZv8klyHxMD9ysw1wp5QKBHW+BxkFQMoqPT\r\n" + 
        		"jxgzr78hh2/KN7qk1yR9RWAemTRjHlzU6/q7ZJlTAoGAf8lMju0N234AJ0ORrvzs\r\n" + 
        		"k0SAMcwBZ/u4dVhv8+F6SkZfLEK/V2tQ93q8czHDaMWL6mmy627zW1jV1Ybf9YuR\r\n" + 
        		"dHiQ1UgZb7Xcym1dMklnrW+CYuhb/lY19SfEnoo5yjjj2uEyQM4J3jknnZbhLu8W\r\n" + 
        		"gb3dWNNI4J0ki/bJ5LbcBiECgYBcZAfaewqvwhd+0qJQ5B0b8sAPGftEBAciIYWz\r\n" + 
        		"NdTKt6ujP0vmBFUwpODXolEO1Ut7rxFq2eKVwl/PH4odCU9PPGX/a/w1OomBaRra\r\n" + 
        		"aA+HXxSrFDzsETTANAAwJtCEln+uY/ObQMHRucWg1ZiLZeUaH2/ZW008IZes0YtA\r\n" + 
        		"AZfD0wKBgQCyVj0GyMwnHdF4p8M9TFYWb6BbRIeE7iUXqPvX6bzksylBPngpBF+J\r\n" + 
        		"uEV0+VQiAjXwwzb8peuCNWZiyfpAn3v15GLPqOPURsL+HvIDwEBYerIh9p3Z2G38\r\n" + 
        		"/6CfbI2iD4bPRx2XdPbxr6UoHNvh6y1hAscZy5oxSCT6WW5jCpW1Bg==\r\n" + 
        		"-----END RSA PRIVATE KEY-----\r\n";

        // Sign with content in code
        String p1 = sign(data, fileContent, true);

        // Sign with content in file on given absolute path
        String p2 = sign(data, "D:\\eclipse-workspaces\\general-projects\\Juspay\\lib\\idea-private-key.pem",true);

        System.out.println(p1.equals(p2));
        System.out.println(p1);
        System.out.println(p2);
    }
}