using System.Text;
using Org.BouncyCastle.Crypto;
using Org.BouncyCastle.Security;
using Org.BouncyCastle.Crypto.Parameters;
using Org.BouncyCastle.Asn1.Pkcs;
using Org.BouncyCastle.OpenSsl;
using Newtonsoft.Json.Linq;

class SignatureUtil {
    // string filePath = "/<absolute-path-to-folder-containing-pem-file>/private-key.pem";
    public static Dictionary<string,string> createSignature (JObject payload, string filePath){
        string[] requiredFields = {"order_id", "merchant_id", "amount", "timestamp", "customer_id"};
        foreach (string key in requiredFields)
            if(!payload.ContainsKey(key))
                throw new Exception (key + " not found in payload");
        string signaturePayload = payload.ToString();
        byte[] byteArrayPayload = ASCIIEncoding.ASCII.GetBytes(signaturePayload);
        StreamReader sr = new StreamReader(filePath);
        PemReader pr = new PemReader(sr);
        AsymmetricCipherKeyPair keyPair = (AsymmetricCipherKeyPair)pr.ReadObject();
        RsaKeyParameters privateKey = (RsaKeyParameters) keyPair.Private;
        ISigner sign = SignerUtilities.GetSigner(PkcsObjectIdentifiers.Sha256WithRsaEncryption.Id);
        sign.Init(true, privateKey);
        sign.BlockUpdate(byteArrayPayload, 0, byteArrayPayload.Length);
        byte[] signature = sign.GenerateSignature();
        string encodeSignature = Convert.ToBase64String(signature);
        Dictionary<string, string> response = new Dictionary<string, string>();
        response.Add("signature", encodeSignature);
        response.Add("signaturePayload", signaturePayload);
        Console.Write(encodeSignature);
        return response;
    }
}