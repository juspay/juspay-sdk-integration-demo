using System;
using System.IO;
using Juspay;
using Newtonsoft.Json;
namespace  dotnet_server
{
    class Init
    {
        public Init()
        {
            Config = JsonConvert.DeserializeObject<Config>(File.ReadAllText("config.json"));
            if (Config == null)
            {
                throw new Exception("unable to find config file");
            }
            else
            {
                if (Config.PrivateKey == null && Config.PrivateKeyPath == null)
                {
                    throw new Exception("private key not found");
                }
                if (Config.PublicKey == null && Config.PublicKeyPath == null)
                {
                    throw new Exception("public key not found");
                }
                if (Config.PrivateKey == null && Config.PrivateKeyPath != null)
                {
                    // block:start:read-keys-from-file
                    Config.PrivateKey = File.ReadAllText(Config.PrivateKeyPath);
                    // block:end:read-keys-from-file
                }
                if (Config.PublicKey == null && Config.PublicKeyPath != null)
                {
                    Config.PublicKey = File.ReadAllText(Config.PublicKeyPath);
                }
                // block:start:initialize-juspay-config
                JuspayEnvironment.Instance.JuspayJWT = new JuspayJWTRSA(Config.KeyUuid, Config.PublicKey, Config.PrivateKey);
                JuspayEnvironment.Instance.MerchantId = Config.MerchantId;
                JuspayEnvironment.Instance.BaseUrl = "https://sandbox.juspay.in";
                // block:end:initialize-juspay-config
            }
        }
        public static Config Config { get; set; }
    }

    public class Config
    {
        [JsonProperty("MERCHANT_ID")]
        public string MerchantId { get; set; }
        [JsonProperty("PUBLIC_KEY_PATH")]
        public string PublicKeyPath { get; set; }
        [JsonProperty("PRIVATE_KEY_PATH")]
        public string PrivateKeyPath { get; set; }
        [JsonProperty("KEY_UUID")]
        public string KeyUuid { get; set; }
        [JsonProperty("PAYMENT_PAGE_CLIENT_ID")]
        public string PaymentPageClientId { get; set; }
        [JsonProperty("PUBLIC_KEY")]
        public string PublicKey { get; set; }
        [JsonProperty("PRIVATE_KEY")]
        public string PrivateKey { get; set; }
    }
}