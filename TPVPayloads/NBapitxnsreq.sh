curl --location --request POST 'https://sandbox.juspay.in/txns' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'order_id=1591896736' \
--data-urlencode 'merchant_id=paypal' \
--data-urlencode 'payment_method_type=NB' \
--data-urlencode 'payment_method=JP_HDFC' \
--data-urlencode 'redirect_after_payment=true' \
--data-urlencode 'format=json'
