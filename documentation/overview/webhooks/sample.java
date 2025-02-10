// Sample code in Java

import java.util.Base64;
import javax.crypto.Cipher;
import javax.crypto.SecretKey;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

public class WebHookDecrpyt
{   
    public static void main(String[] args) throws Exception
    {   
        // webhook_payload => {serialized_response: <encrypted_json_string>}
        String encr_data = <encrypted_json_string>;
        String key = <webhook_encryption_key>;
        byte[] iv = encr_data.substring(0, 16).getBytes();
        System.out.println("String : "+ encr_data.substring(16));
        byte[] cipher_text = Base64.getMimeDecoder().decode(encr_data.substring(16).getBytes("UTF-8"));
        byte[] byte_key = key.getBytes();
        SecretKey secret_key = new SecretKeySpec(byte_key, 0, byte_key.length, "AES"); 
        String decr_data = decrypt(cipher_text, secret_key, iv);
        System.out.println("DeCrypted Text : "+ decr_data);
    }

    public static String decrypt (byte[] cipherText, SecretKey key,byte[] IV) throws Exception
    {
        Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
        SecretKeySpec keySpec = new SecretKeySpec(key.getEncoded(), "AES");
        IvParameterSpec ivSpec = new IvParameterSpec(IV);
        cipher.init(Cipher.DECRYPT_MODE, keySpec, ivSpec);
        byte[] decryptedText = cipher.doFinal(cipherText);
        return new String(decryptedText);
    }
}
