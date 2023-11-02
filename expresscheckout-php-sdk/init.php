<?php
namespace server;
use Exception;
require realpath(__DIR__ .  '/vendor/autoload.php');
use Juspay\JuspayEnvironment;
use Juspay\Model\JuspayJWT;

$config = file_get_contents("config.json");
$config = json_decode($config, true);

$privateKey = array_key_exists("PRIVATE_KEY", $config) ? $config["PRIVATE_KEY"] : file_get_contents($config["PRIVATE_KEY_PATH"]);
$publicKey =  array_key_exists("PUBLIC_KEY", $config) ? $config["PUBLIC_KEY"] : file_get_contents($config["PUBLIC_KEY_PATH"]);

if ($privateKey == false || $publicKey == false) {
    http_response_code(500);
    $response = $privateKey == false ? array("message" => "private key file not found") : array("message" => "public key file not found");
    echo json_encode($response);
    if ($privateKey == false) {
        error_log("private key file not found");
        throw new Exception ("private key file not found");
    } else {
        error_log("public key file not found");
        throw new Exception ("public key file not found");
    }
}
JuspayEnvironment::init()
->withBaseUrl("https://smartgatewayuat.hdfcbank.com")
->withJuspayJWT(new JuspayJWT($config["KEY_UUID"], $publicKey, $privateKey)); #Add key id
class ServerEnv {
    public function __construct($config) {
        self::$config = $config;
    }
    public static $config;
}
new ServerEnv($config);
?>

