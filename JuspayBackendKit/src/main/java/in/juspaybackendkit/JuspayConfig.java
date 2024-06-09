package in.juspaybackendkit;

import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import in.juspay.model.JuspayEnvironment;
import in.juspay.model.JweJwsEncryptionKeys;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import java.io.IOException;
import java.net.URL;
import java.nio.charset.Charset;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.regex.Pattern;

public class JuspayConfig implements ServletContextListener {
    public static String merchant_id;
    public static String private_key_path;
    public static String public_key_path;
    public static String key_uuid;
    public static String payment_page_client_id;

    public static final String SANDBOX_BASE_URL = "https://sandbox.juspay.in";
    public static final String PRODUCTION_BASE_URL = "https://api.juspay.in";

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        try {
            URL resource = getClass().getClassLoader().getResource("config.json");
            if (resource == null) {
                throw new RuntimeException("cannot find config.json in resources folder");
            }

            String jsonObject = readFileAsString(resource.getFile());
            ObjectMapper objectMapper = new ObjectMapper();
            objectMapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
            ObjectNode configObject = objectMapper.readValue(jsonObject, ObjectNode.class);

            String keyUUID = resolveConfigValue(configObject, "KEY_UUID");
            String privateKeyPath = resolveConfigValue(configObject, "PRIVATE_KEY_PATH", true);
            String publicKeyPath = resolveConfigValue(configObject, "PUBLIC_KEY_PATH", true);
            String merchantId = resolveConfigValue(configObject, "MERCHANT_ID");
            String paymentPageClientId = resolveConfigValue(configObject, "PAYMENT_PAGE_CLIENT_ID");

            String privateKey = readKeyFromPath(privateKeyPath, "private-key.pem");
            String publicKey = readKeyFromPath(publicKeyPath, "public-key.pem");

            // block:start:initialize-juspay-config
            JweJwsEncryptionKeys jweJwsEncryptionKeys = new JweJwsEncryptionKeys(keyUUID, publicKey, privateKey);
            JuspayEnvironment.withMerchantId(merchantId);
            JuspayEnvironment.withJweJwsEncryption(jweJwsEncryptionKeys);
            JuspayEnvironment.withBaseUrl(JuspayConfig.SANDBOX_BASE_URL);
            // block:end:initialize-juspay-config

            JuspayConfig.merchant_id = merchantId;
            JuspayConfig.key_uuid = keyUUID;
            JuspayConfig.private_key_path = privateKeyPath;
            JuspayConfig.public_key_path = publicKeyPath;
            JuspayConfig.payment_page_client_id = paymentPageClientId;
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    // block:start:read-keys-from-file
    private static String readFileAsString(String filePath) throws IOException {
        return new String(Files.readAllBytes(Paths.get(filePath)), Charset.defaultCharset());
    }
    // block:end:read-keys-from-file

    private static String resolveConfigValue(ObjectNode configObject, String key, boolean optional) {
        if (configObject.get(key) != null) {
            return configObject.get(key).asText();
        } else if (configObject.get(key.toLowerCase()) != null) {
            return configObject.get(key.toLowerCase()).asText();
        } if (optional) {
            return null;
        } else {
            throw new RuntimeException("cannot resolve " + key + " in config.json");
        }
    }

    private static String resolveConfigValue(ObjectNode configObject, String key) {
        return resolveConfigValue(configObject, key, false);
    }

    private static String readKeyFromPath(String filePath, String keyName) throws IOException {
        if (filePath == null) {
            URL resource = JuspayConfig.class.getClassLoader().getResource(keyName);
            if (resource != null) {
                return readFileAsString(resource.getFile());
            } else {
                throw new RuntimeException(keyName + "not found either in config.json or resources folder");
            }
        } else {
            Pattern pattern = Pattern.compile("^~|\\$\\{[a-zA-Z0-9_]+\\}");
            if (pattern.matcher(filePath).find()) {
                if (filePath.startsWith("~")) {
                    // handles:- ~/private-key.pem
                    filePath = Paths.get(System.getProperty("user.home"), filePath.substring(1)).toString();
                } else if (filePath.startsWith("${") && filePath.endsWith("}")) {
                    // handles:- ${HOME}/private-key.pem
                    // handles:- /Users/user.name/${PROJECT_DIRECTORY}/private-key.pem
                    String envVar = filePath.substring(2, filePath.length() - 1);
                    String envValue = System.getenv(envVar);
                    if (envValue != null) {
                        filePath = envValue;
                    }
                }
            }
            String resolvedFilePath = Paths.get(filePath).toString();
            return readFileAsString(resolvedFilePath);
        }
    }
}
