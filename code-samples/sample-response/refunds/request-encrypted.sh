curl --location --request POST 'https://smartgatewayuat.hdfcbank.com/orders/{order_id}/refunds \
-H "version:2023-06-30" \
-H 'Content-Type: application/x-www-form-urlencoded'\
-H 'x-merchantid: merchant_id'\
-H 'x-customerid: customer_id'\
-d "unique_request_id=xyz123" \
-d "amount=100.00"
