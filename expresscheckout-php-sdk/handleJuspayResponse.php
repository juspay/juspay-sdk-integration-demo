<?php
namespace server;
use Exception;
require realpath(__DIR__ .  '/vendor/autoload.php'); # Required while running it as standalone, not required while integrating into existing project
require_once __DIR__ . '/init.php';
use Juspay\RequestOptions;
use Juspay\Model\Order;
use Juspay\Exception\JuspayException;

$config = ServerEnv::$config;

$response = "";

function getOrder($orderId, $config) {
   try {
    $params = array();
    $params ['order_id'] = $orderId;
    $requestOption = new RequestOptions();
    $requestOption->withCustomerId("testing-customer-one");
    return Order::status($params, $requestOption);
   } catch (JuspayException $e) {
    http_response_code($e->getHttpResponseCode());
    $response = array("message" => $e->getErrorMessage());
    error_log($e->getErrorMessage());
    echo json_encode($response);
    throw new Exception ($e->getErrorMessage());
   }
}

function orderStatusMessage ($order) {
    $response = array("order_id" => $order->orderId);
    switch ($order->status) {
        case "CHARGED":
            $response += ["message" => "order payment done successfully"];
            break;
        case "PENDING":
        case "PENDING_VBV":
            $response += ["message" => "order payment pending"];
            break;
        case "AUTHENTICATION_FAILED":
            $response += ["message" => "authentication failed"];
            break;
        case "AUTHORIZATION_FAILED":
            $response += ["message"=> "order payment authorization failed"];
            break;
        default:
            $response += ["message"=> "order status " . $order->status];
    }
    $response += ["order_status"=> $order->status];
    return $response;
}

// POST ROUTE
if (isset($_POST["order_id"])) {
    try {
        $orderId = $_POST["order_id"];
        $order = getOrder($orderId, $config);
        $response = orderStatusMessage($order);
        
    }
    catch (JuspayException $e ) {
        http_response_code(500);
        $response = array("message" => $e->getErrorMessage());
        error_log($e->getMessage());
    }
} else if (isset($_GET["order_id"])) { // GET ROUTE
    $orderId = $_GET["order_id"];
    $order = getOrder($orderId, $config);
    $response = orderStatusMessage($order);
} else {
    http_response_code(400);
    $response = array('message' => 'order id not found');
}
header('Content-Type: application/json');
echo json_encode($response);
?>

