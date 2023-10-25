<?php
use Juspay\RequestOptions;
require realpath(__DIR__ .  '/vendor/autoload.php'); # Required while running it as standalone, not required while integrating into existing project
use Juspay\Exception\JuspayException;
use Juspay\JuspayEnvironment;
use Juspay\Model\JuspayJWT;
use Juspay\Model\Order;
use Juspay\Model\Session;

class PHPKit {

    public string $orderId;
    public function __construct($orderId) {
        $this->orderId = $orderId;
    }
    public function orderStatus() {
       try {
        $params = array();
        $params ['order_id'] = $this->orderId;
        $requestOption = new RequestOptions();
        $requestOption->withCustomerId("testing-customer-one")->withMerchantId("SG017"); # Add merchant id
        $order = Order::status($params, $requestOption);
        echo "id: ". $order->orderId . PHP_EOL;
        echo "amount: ". $order->amount . PHP_EOL;
        echo "status: " . $order->status . PHP_EOL;
       } catch ( JuspayException $e ) {
            echo "error code" . $e->getHttpResponseCode() . PHP_EOL;
            echo "error message: " . $e->getErrorMessage() . PHP_EOL;
            echo "error code" . $e->getErrorCode() . PHP_EOL;
        }
    }

    public function session() {
        try {
            $params = array();
            $params['amount'] = 1;
            $params['order_id'] = $this->orderId;
            $params["merchant_id"] = "SG017"; # Add merchant id
            $params['customer_id'] = "testing-customer-one";
            $params['payment_page_client_id'] = "hdfcmaster";
            $params['action'] = "paymentPage";
            $params['return_url'] = "https://www.hdfc.com";
            $requestOption = new RequestOptions();
            $requestOption->withCustomerId("testing-customer-one")->withMerchantId("SG017"); # Add merchant id
            $session = Session::create($params, $requestOption);
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
}


$privateKey = file_get_contents("./privateKey.pem");
$publicKey = file_get_contents("./publicKey.pem");

$orderId = uniqid();

echo "order id: " . $orderId . PHP_EOL;

JuspayEnvironment::init()
->withBaseUrl("https://smartgatewayuat.hdfcbank.com")
->withJuspayJWT(new JuspayJWT("key_85860aaf863c48ea9e0bb572b6571656", $publicKey, $privateKey)); #Add key id
$phpKit = new PHPKit($orderId);
echo "Executing Session" . PHP_EOL;
$phpKit->session();
echo "Executing Order Status:" . PHP_EOL;
$phpKit->orderStatus();
