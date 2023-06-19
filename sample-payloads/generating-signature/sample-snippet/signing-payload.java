import org.bouncycastle.jce.provider.BouncyCastleProvider;
import org.bouncycastle.openssl.PEMKeyPair;
import org.bouncycastle.openssl.PEMParser;
import org.bouncycastle.openssl.jcajce.JcaPEMKeyConverter;
import org.json.JSONObject;

import java.io.FileReader;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.security.*;
import java.util.HashMap;

import javax.xml.bind.DatatypeConverter;

public class SignatureUtil {
    public static void main(String ...args) {
        JSONObject data = new JSONObject("{'order_id': 'venkatesh12','first_name': 'Test','last_name': 'Customer','customer_phone': '9876543210','customer_email': 'test@gmail.com','merchant_id': 'udit_juspay','amount': '1.00','customer_id': '9876543210','return_url': 'https://sandbox.juspay.in/end','currency': 'INR','mandate.start_date': '1638535683287','mandate.end_date': '2134731745451','timestamp': '1576227696'}");
        String filePath = "/<absolute-path-to-folder-containing-pem-file>/private-key.pem";
        HashMap<String,String> response = createSignature(data, filePath);
    }

    public static HashMap<String,String> createSignature(JSONObject payload, String filePath) {
        try {
            PrivateKey privateKey = readPrivateKeyFromFile(filePath);
            Signature privateSignature = Signature.getInstance("SHA256withRSA");
            String[] requiredFields = {"order_id", "merchant_id", "amount", "timestamp", "customer_id"};
            for (String key : requiredFields)
                if(!payload.has(key))
                    throw new Exception(key + " not found in payload");
            String signaturePayload = payload.toString();
            privateSignature.initSign(privateKey);
            privateSignature.update(signaturePayload.getBytes(StandardCharsets.UTF_8));
            byte[] signature = privateSignature.sign();
            String encodedSignature = DatatypeConverter.printBase64Binary(signature);
            HashMap<String,String> response = new HashMap<String,String>();
            response.put("signature",encodedSignature);
            response.put("signaturePayload", signaturePayload);
            return response;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return new HashMap<String, String>();
    }

    private static PrivateKey readPrivateKeyFromFile(String filePath) throws IOException {
        Security.addProvider(new BouncyCastleProvider());
        PEMParser pemParser = new PEMParser(new FileReader(filePath));
        JcaPEMKeyConverter converter = new JcaPEMKeyConverter().setProvider("BC");
        PEMKeyPair pemKeyPair = (PEMKeyPair) pemParser.readObject();
        KeyPair keyPair = converter.getKeyPair(pemKeyPair);
        return keyPair.getPrivate();
    }
}