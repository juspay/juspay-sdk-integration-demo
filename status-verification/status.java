import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.TreeMap;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import javax.xml.bind.DatatypeConverter;


public class Util {

    /**
     * @param args
     */
    public static void main(String[] args) {
        Ccw8ZE5fkr0%3D&signature_algorithm=HMAC-SHA256
        LinkedHashMap<String, String> param = new LinkedHashMap<String, String>();
        param.put("order_id", ":order_id");
        param.put("status", ":status");
        param.put("status_id", ":status_id");
        
        System.out.println("param :: "+param);
        
        String expectedHashparam="OHEZ3sYJa%2F9ZyNZ79u3r4p4F2p9O8%2FjSCcw8ZE5fkr0%3D";
        
         String scretkey=":Response key";
        
        try {
            System.out.println(" return value :: "+validateHMAC_SHA256(param,expectedHashparam,scretkey));
        } catch (InvalidKeyException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        } catch (UnsupportedEncodingException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        } catch (NoSuchAlgorithmException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
    }
     public static boolean validateHMAC_SHA256(Map<String, String> params, String expectedHash, String key)
                throws java.io.UnsupportedEncodingException, java.security.NoSuchAlgorithmException,
                java.security.InvalidKeyException, java.io.UnsupportedEncodingException {
            if (key == null) return false;

            Map<String, String> sortedParams = new TreeMap<String, String>(params);
            
            System.out.println(""+sortedParams);

            StringBuilder queryStr = new StringBuilder("");
            for (String curkey : sortedParams.keySet())
                queryStr.append(curkey + "=" + sortedParams.get(curkey) + "&");
            queryStr.deleteCharAt(queryStr.length() - 1);
            System.out.println("queryStr ::"+queryStr);
            String message = URLEncoder.encode(queryStr.toString(), "UTF-8");
           
            Mac hasher = Mac.getInstance("HmacSHA256");
            hasher.init(new SecretKeySpec(key.getBytes(), "HmacSHA256"));
            byte[] hash = hasher.doFinal(message.getBytes());
            String generatedSign = (URLEncoder.encode(DatatypeConverter.printBase64Binary(hash), "UTF-8"));
            System.out.println("generatedSign ::"+generatedSign);
            return (generatedSign.equals(expectedHash));
        }

}
"test"