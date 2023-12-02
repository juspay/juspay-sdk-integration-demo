curl --location --request POST 'https://sandbox.juspay.in/txns' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--header 'Authorization: Basic RE*********************************Og==' \
--header 'x-merchantid: JPTEST' \
--data-urlencode 'order_id=JP_172424231' \
--data-urlencode 'merchant_id=JPTEST' \
--data-urlencode 'payment_method_type=CONSUMER_FINANCE' \
--data-urlencode 'payment_method=SNAPMINT' \
--data-urlencode 'format=json' \
--data-urlencode 'redirect_after_payment=true'