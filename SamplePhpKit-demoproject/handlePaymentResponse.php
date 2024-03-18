<?php
use PaymentHandler\APIException;
require_once realpath("./PaymentHandler.php");
use PaymentHandler\PaymentHandler;
// block:start:order-status-function
function getOrder($params) {
    $paymentHandler = new PaymentHandler("resources/config.json");
    if ($paymentHandler->validateHMAC_SHA256($params) === false) {
        throw new APIException(-1, false, "Signature verification failed", "Signature verification failed");
    } else {
        $order = $paymentHandler->orderStatus($params["order_id"]);
        return $order;
    }

}
// block:end:order-status-function
function getStatusMessage($order) {
    $message = "Your order with order_id " . $order["order_id"] . " and amount " . $order["amount"] . " has the following status: ";
    $status = $order["status"];

    switch ($status) {
        case "CHARGED":
            $message = $message . "order payment done successfully";
            break;
        case "PENDING":
        case "PENDING_VBV":
            $message = $message ."order payment pending";
            break;
        case "AUTHORIZATION_FAILED":
            $message = $message ."order payment authorization failed";
            break;
        case "AUTHENTICATION_FAILED":
            $message = $message . "order payment authentication failed";
            break;
        default:
            $message = $message ."order status " . $status;
            break;
    }
    return $message;
}
 
 // POST ROUTE
 // block:start:construct-params
 if (isset($_POST["order_id"])) {
     try {
        $inputParams = $_POST;
        $orderId = $_POST["order_id"];
        $status = $_POST["status"];
        $signature = $_POST["signature"];
        $statusId = $_POST["status_id"];
        $params = ["order_id" => $orderId, "status" => $status, "signature" => $signature, "status_id" => $statusId];
// block:end:construct-params
        $order = getOrder($params);
        $message = getStatusMessage($order);
     } catch (APIException $e ) {
        http_response_code(500);
        $error = json_encode(["message" => $e->getErrorMessage(), "error_code" => $e->getErrorCode(), "http_response_code" => $e->getHttpResponseCode()]);
        echo "<p> Payment server threw a non-2xx error. Error message: {$error} </p>";
        exit;
     } catch (Exception $e) {
        http_response_code(500);
        echo "<p> Unexpected error occurred, Error message:  {$e->getMessage()} </p>";
        exit;
    }
 } else if (isset($_GET["order_id"])) { // GET ROUTE
    $inputParams = $_GET;
    $orderId = $_GET["order_id"];
    $status = $_GET["status"];
    $signature = $_GET["signature"];
    $statusId = $_GET["status_id"];
    $params = ["order_id" => $orderId, "status" => $status, "signature" => $signature, "status_id" => $statusId];
    $order = getOrder($params);
    $message = getStatusMessage($order);
 } else {
     http_response_code(400);
     echo "<p>Required Parameter Order Id is missing</p>";
     exit;
 }
?>
<html>
<head>
    <title>Merchant payment status page</title>
</head>
<body>
    <h1><?php echo $message ?></h1>

    <center>
        <font size="4" color="blue"><b>Return url request body params</b></font>
        <table border="1">
            <?php
                foreach ($inputParams as $key => $value) {
                    echo "<tr><td>{$key}</td>";
                    $pvalue = "";
                    if ($value !== null) {
                        $pvalue = json_encode($value);
                    }
                    echo "<td>{$pvalue}</td></tr>";
                }
            ?>
        </table>
    </center>

    <center>
        <font size="4" color="blue"><b>Response received from order status payment server call</b></font>
        <table border="1">
            <?php
                foreach ($order as $key => $value) {
                    echo "<tr><td>{$key}</td>";
                    $pvalue = "";
                    if ($value !== null) {
                        $pvalue = json_encode($value);
                    }
                    echo "<td>{$pvalue}</td></tr>";
                }
            ?>
        </table>
    </center>
</body>
</html>