curl --location --request POST 'https://sandbox.juspay.in/txns' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'order_id=1591896736' \
--data-urlencode 'merchant_id=JuspayUAT' \
--data-urlencode 'payment_method_type=UPI' \
--data-urlencode 'payment_method=COLLECT' \
--data-urlencode 'redirect_after_payment=true' \
--data-urlencode 'format=json' \
--data-urlencode 'upi_vpa=star7695@upi'
