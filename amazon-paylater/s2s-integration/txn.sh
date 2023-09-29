curl --location --request POST 'https://sandbox.juspay.in/txns' \
--header 'Authorization: Basic MEQ1N0*********QUIzOUVCOTdGQzhCOg==' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'order_id=amazonpay1694704038' \
--data-urlencode 'merchant_id=azhar_test' \
--data-urlencode 'payment_method_type=CONSUMER_FINANCE' \
--data-urlencode 'direct_wallet_token=tk_caee6c********80c075d9f0464b' \
--data-urlencode 'payment_method=AMAZONPAYLATER' \
--data-urlencode 'redirect_after_payment=true' \
--data-urlencode 'format=json'
