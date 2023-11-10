using Juspay;
using Newtonsoft.Json;
using System;
using System.IO;
using System.Web;
using System.Web.Http;
using System.Web.Mvc;
using System.Web.Optimization;
using System.Web.Routing;
namespace DotnetServer
{
    public class WebApiApplication : System.Web.HttpApplication
    {
        protected void Application_Start()
        {
            AreaRegistration.RegisterAllAreas();
            GlobalConfiguration.Configure(WebApiConfig.Register);
            FilterConfig.RegisterGlobalFilters(GlobalFilters.Filters);
            RouteConfig.RegisterRoutes(RouteTable.Routes);
            BundleConfig.RegisterBundles(BundleTable.Bundles);
            new Init(Server);
        }
    }

    class Init
    {
        public Init(HttpServerUtility server)
        {

            Config = JsonConvert.DeserializeObject<Config>(File.ReadAllText(server.MapPath("config.json")));
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
                    Config.PrivateKey = File.ReadAllText(server.MapPath(Config.PrivateKeyPath));
                    // block:end:read-keys-from-file
                }
                if (Config.PublicKey == null && Config.PublicKeyPath != null)
                {
                    Config.PublicKey = File.ReadAllText(server.MapPath(Config.PublicKeyPath));
                }
                // block:start:initialize-juspay-config
                JuspayEnvironment.JuspayJWT = new JuspayJWTRSA(Config.KeyUuid, Config.PublicKey, Config.PrivateKey);
                JuspayEnvironment.MerchantId = Config.MerchantId;
                JuspayEnvironment.BaseUrl = "https://smartgatewayuat.hdfcbank.com";
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
