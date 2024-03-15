<?php
use PaymentHandler\APIException;
require_once realpath("./PaymentHandler.php");
use PaymentHandler\PaymentHandler;
$orderId = $_POST["order_id"];
$amount = $_POST["amount"];
$refundId = $_POST["unique_request_id"];
$paymentHandler = new PaymentHandler("resources/config.json");
try {
    $refund = $paymentHandler->refund(["order_id" => $orderId, "amount" => $amount, "unique_request_id" => $refundId]);
}  catch (APIException $e ) {
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
<html>
<head>
    <title>Merchant Refund</title>
</head>
<body>
    <h1>Refund status:- <?php $refund["status"]?></h1>
    <p>Here is the stringified map response:- </p>
    <p><?php echo json_encode($refund) ?></p>
    <center>
        <font size="4" color="blue"><b>Response received from order status payment server call</b></font>
        <table border="1">
            <?php
                foreach ($refund as $key => $value) {
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