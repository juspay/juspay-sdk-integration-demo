import java.nio.charset.StandardCharsets;
import java.security.KeyFactory;
import java.security.PublicKey;
import java.security.spec.X509EncodedKeySpec;
import javax.crypto.Cipher;
import java.util.Base64;
import java.security.spec.MGF1ParameterSpec;
import javax.crypto.spec.OAEPParameterSpec;
import javax.crypto.spec.PSource;
public class encrypt {
    public static void main(String[] args) throws Exception {
        // Data to be encrypted
        String data = "124";
        // Public key in Base64
        String publicKeyBase64 = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAizgY4XSKoSmDoSK5g5MaJS9hZvX5C6rgSYQui9rbdBw+WZq2pRSV6MDMJQFTb9grXx3Ztj1wt1ESN5VAA5Gff2EO77ffiUtX716dYNq7NfOM3y8ssQ3Kh02Ow1xnlb9vc3gRfG+LpblCEa+vE+2foZa1/AhbRuZkvferOjB3YwacUVc0y25gO9HIL9iGd8aCl2cVhvFg3NOfJRQK3yhv1mEar2k3AqGDj95Vw/stWytYFLDFzwU3xYlHxb3vNLunbMlfxCqluveOBh2huGEhb0QNT4pSBK2UVaCZmukjcTXKD0c97brip2ZOHLo50V+njxn46mq6gJfE7RKFjPd5/QIDAQAB";
        // Encrypt the data using the public key
        PublicKey publicKey = getPublicKey(publicKeyBase64);
        String encryptedData = encrypt(data, publicKey);
        // Print the encrypted data
        System.out.println("Encrypted Data: " +"enc-"+encryptedData);
    }
    public static PublicKey getPublicKey(String publicKeyBase64) throws Exception {
        byte[] publicKeyBytes = Base64.getDecoder().decode(publicKeyBase64);
        X509EncodedKeySpec keySpec = new X509EncodedKeySpec(publicKeyBytes);
        KeyFactory keyFactory = KeyFactory.getInstance("RSA");
        return keyFactory.generatePublic(keySpec);
    }
    public static String encrypt(String data, PublicKey publicKey) throws Exception {
        Cipher cipher = Cipher.getInstance("RSA/ECB/OAEPWithSHA-256AndMGF1Padding");
        OAEPParameterSpec oaepParams = new OAEPParameterSpec("SHA-256", "MGF1", new MGF1ParameterSpec("SHA-256"), PSource.PSpecified.DEFAULT);
        cipher.init(Cipher.ENCRYPT_MODE, publicKey, oaepParams);
        byte[] encryptedBytes = cipher.doFinal(data.getBytes(StandardCharsets.UTF_8));
        return Base64.getEncoder().encodeToString(encryptedBytes);
    }
}
