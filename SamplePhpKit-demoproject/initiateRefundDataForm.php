<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Form</title>
</head>
<body>
<form method="post" name="customerData" action="initiateRefund.php">
    <table width="50%" height="100" border='1' align="center">
        <tr>
            <td>Refund Page</td>
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
            <td><input type="text" name="order_id" id="order_id" value="" required/></td>
        </tr>
        <tr>
            <td>unique_request_id (required)</td>
            <td><input type="text" name="unique_request_id" id="unique_request_id" value=""readonly/></td>
        </tr>
        <tr>
            <td>amount (required)</td>
            <td><input type="text" name="amount" value="1.00"/></td>
        </tr>
        <tr>
            <td></td>
            <td><INPUT TYPE="submit" value="Submit"></td>
        </tr>
    </table>
</form>
<script>
        document.getElementById("unique_request_id").value = "ref_" + Date.now();
        function getQueryParam(name) {
            const urlParams = new URLSearchParams(window.location.search);
            return urlParams.get(name);
        }
        const refundValue = getQueryParam('order_id');
        const orderIdInput = document.getElementById('order_id');
        if (orderIdInput && refundValue !== null) {
            orderIdInput.value = refundValue;
        }
</script>
</body>
</html>