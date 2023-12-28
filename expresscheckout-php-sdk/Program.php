<?php
date_default_timezone_set('UTC');
use Juspay\RequestOptions;
require realpath(__DIR__ .  '/vendor/autoload.php'); # Required while running it as standalone, not required while integrating into existing project
use Juspay\Exception\JuspayException;
use Juspay\JuspayEnvironment;
use Juspay\Model\JuspayJWT;
use Juspay\Model\Order;
use Juspay\Model\OrderSession;

class PHPKit {

    public $orderId;

    private $config;

    public function __construct($orderId, $config) {
        $this->orderId = $orderId;
        $this->config = $config;
    }

    // block:start:order-status-function
    public function orderStatus() {
       try {
        $params = array();
        $params ['order_id'] = $this->orderId;
        $requestOption = new RequestOptions();
        $requestOption->withCustomerId("testing-customer-one");
        $order = Order::status($params, $requestOption);
        echo "id: ". $order->orderId . PHP_EOL;
        echo "amount: ". $order->amount . PHP_EOL;
        echo "status: " . $order->status . PHP_EOL;
        echo "order env" . getenv("ORDER_ID") . PHP_EOL;
       } catch ( JuspayException $e ) {
            echo "error code" . $e->getHttpResponseCode() . PHP_EOL;
            echo "error message: " . $e->getErrorMessage() . PHP_EOL;
            echo "error code" . $e->getErrorCode() . PHP_EOL;
        }
    }
    // block:end:order-status-function
    
    // block:start:session-function
    public function session() {
        try {
            $params = array();
            $params['amount'] = 1;
            $params['order_id'] = $this->orderId;
            $params["merchant_id"] = $this->config["MERCHANT_ID"]; # Add merchant id
            $params['customer_id'] = "testing-customer-one";
            $params['payment_page_client_id'] = $this->config["MERCHANT_ID"];
            $params['action'] = "paymentPage";
            $params['return_url'] = "http://0.0.0.0:5000/handleResponse";
            $requestOption = new RequestOptions();
            $requestOption->withCustomerId("testing-customer-one");
            $session = OrderSession::create($params, $requestOption);
            echo "id: " . $session->id . PHP_EOL;
            echo "order id: ". $session->orderId . PHP_EOL;
            echo "status" . $session->status . PHP_EOL;
            echo "payment link: " . $session->paymentLinks["web"] . PHP_EOL;
            echo "sdk payload" . json_encode($session->sdkPayload) . PHP_EOL;
        } catch ( JuspayException $e ) {
            echo "error code" . $e->getHttpResponseCode() . PHP_EOL;
            echo "error message: " . $e->getErrorMessage() . PHP_EOL;
            echo "error code" . $e->getErrorCode() . PHP_EOL;
        }
    }
    // block:end:session-function
}


$config = file_get_contents("config.json");
$config = json_decode($config, true);
$privateKey = array_key_exists("PRIVATE_KEY", $config) ? $config["PRIVATE_KEY"] : file_get_contents($config["PRIVATE_KEY_PATH"]);
$publicKey =  array_key_exists("PUBLIC_KEY", $config) ? $config["PUBLIC_KEY"] : file_get_contents($config["PUBLIC_KEY_PATH"]);

if ($privateKey == false || $publicKey == false) {
    if ($privateKey == false) {
        throw new Exception ("private key file not found");
    }
    throw new Exception ("public key file not found");
}

JuspayEnvironment::init()
->withBaseUrl("https://smartgatewayuat.hdfcbank.com")
->withMerchantId($config["MERCHANT_ID"])
->withJuspayJWT(new JuspayJWT($config["KEY_UUID"], $publicKey, $privateKey)); #Add key id

$orderId = uniqid();

echo "order id: " . $orderId . PHP_EOL;

$phpKit = new PHPKit($orderId, $config);

echo "Executing Session" . PHP_EOL;
$phpKit->session();
echo "Executing Order Status:" . PHP_EOL;
$phpKit->orderStatus();
