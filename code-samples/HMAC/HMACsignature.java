import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.security.*;
import java.util.*;

public class SignatureVerification {
    public static void main(String[] args) throws UnsupportedEncodingException, NoSuchAlgorithmException, InvalidKeyException {
        /**
         * EVERYTHING will be included in hash except signature and signature_algorithm
         */
        Map<String, String> params = new LinkedHashMap<>();
        params.put("order_id", "order_1727694028");
        params.put("status", "AUTHORIZATION_FAILED");
        params.put("status_id", "27");
        params.put("myQP", "aGVsbG9Xb3JsZA==");

        String expectedHash = "8Esx2nrz3KE059rdsTkffYKu6AXXk07KzBo3KOexl3I=";
        String localHooposResponseKey = "92206A0A4A75499C9B11206C2B3B9A53";
        System.out.println(validateHMAC_SHA256(params, expectedHash, localHooposResponseKey));
    }

    public static boolean validateHMAC_SHA256(Map<String, String> params, String expectedHash, String key) throws java.security.NoSuchAlgorithmException,
            java.security.InvalidKeyException, java.io.UnsupportedEncodingException {
        if (key == null) {
            return false;
        }

        Map<String, String> sortedParams = new TreeMap<String, String>(params);

        StringBuilder queryStr = new StringBuilder();
        for (String curkey : sortedParams.keySet())
            queryStr.append(URLEncoder.encode(curkey, "UTF-8")).append("=").append(URLEncoder.encode(sortedParams.get(curkey), "UTF-8")).append("&");
        queryStr.deleteCharAt(queryStr.length() - 1);
        System.out.println("queryStr:- "+queryStr);
        String message = URLEncoder.encode(queryStr.toString(), "UTF-8");
        System.out.println("message:- "+message);
        Mac hasher = Mac.getInstance("HmacSHA256");
        hasher.init(new SecretKeySpec(key.getBytes(), "HmacSHA256"));
        byte[] hash = hasher.doFinal(message.getBytes());
        String generatedSign = (URLEncoder.encode(Base64.getEncoder().encodeToString(hash), "UTF-8"));
        System.out.println("generatedSign:- "+generatedSign);
        System.out.println("encoded expectedHash:= "+URLEncoder.encode(expectedHash, "UTF-8"));
        return (generatedSign.equals(URLEncoder.encode(expectedHash, "UTF-8")));
    }
}
