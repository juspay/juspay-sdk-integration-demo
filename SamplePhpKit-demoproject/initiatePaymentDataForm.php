<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Form</title>
</head>
<body>
<form method="post" name="customerData" action="initiatePayment.php">
    <table width="50%" height="100" border='1' align="center">
        <tr>
            <td>Merchant Checkout Page</td>
            <td>This are just example value, initiatePayment route will randomly generate order_id and amount for demo purposes.</td>
        </tr>
        <tr></tr>
        <tr></tr>
        <tr></tr>
        <tr></tr>
        <tr></tr>
        <tr></tr>
        <tr></tr>
        <tr></tr>
        <tr></tr>
        <tr>
            <td>Parameter Name:</td>
            <td>Parameter Value:</td>
        </tr>
        <tr>
            <td>order_id (required)</td>
            <td><input type="text" name="order_id" id="order_id" value="" readonly/></td>
        </tr>
        <tr>
            <td>amount (required)</td>
            <td><input type="text" name="amount" value="1.00" readonly/></td>
        </tr>
        <tr>
            <td>payment_page_client_id (required)</td>
            <td><input type="text" name="payment_page_client_id" value="hdfcmaster" readonly/></td>
        </tr>
        <tr>
            <td>currency</td>
            <td><input type="text" name="currency" value="INR" readonly/></td>
        </tr>
        <tr>
            <td>return_url</td>
            <td><input type="text" name="redirect_url"
                value="http://localhost:5000/handlePaymentResponse.php" readonly/>
            </td>
        </tr>
        <tr>
            <td></td>
            <td><INPUT TYPE="submit" value="Submit"></td>
        </tr>
    </table>
</form>
<script>
        document.getElementById("order_id").value = "ord_" + Date.now();
</script>
</body>
</html>