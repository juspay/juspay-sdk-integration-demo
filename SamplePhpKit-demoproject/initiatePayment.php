<?php
use PaymentHandler\APIException;
require_once realpath("./PaymentHandler.php");
use PaymentHandler\PaymentHandler;

$paymentHandler = new PaymentHandler("resources/config.json");

$orderId = "php_sdk_" . uniqid();
$customerId = "php_sdk_customer" . uniqid();
$params = json_decode("{\n\"amount\":\"10.00\",\n\"order_id\":\"$orderId\",\n\"customer_id\":\"$customerId\",\n\"action\":\"paymentPage\",\n\"return_url\": \"http://localhost:5000/handlePaymentResponse.php\"\n}", true);
try {
    $session = $paymentHandler->orderSession($params);
    $redirect = $session["payment_links"]["web"];
    header("Location: {$redirect}");
    exit;

} catch (APIException $e ) {
    http_response_code(500);
    $error = json_encode(["message" => $e->getErrorMessage(), "error_code" => $e->getErrorCode(), "http_response_code" => $e->getHttpResponseCode()]);
    echo "<p> Payment server threw a non-2xx error. Error message: {$error} </p>";
    exit;
 } catch (Exception $e) {
    http_response_code(500);
    echo " <p> Unexpected error occurred, Error message:  {$e->getMessage()} </p>";
    exit;
}
?>
