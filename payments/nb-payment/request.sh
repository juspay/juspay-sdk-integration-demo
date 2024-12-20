curl --location 'https://smartgatewayuat.hdfcbank.com/txns' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--header 'x-merchantid: merchant_id' \
--data-urlencode 'order_id=TEST23' \
--data-urlencode 'merchant_id=merchant_id' \
--data-urlencode 'payment_method_type=NB' \
--data-urlencode 'payment_method=NB_ICICI' \
--data-urlencode 'redirect_after_payment=true' \
--data-urlencode 'format=json'
