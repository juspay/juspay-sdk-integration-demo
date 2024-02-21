curl -X POST https://smartgateway.hdfcbank.com/txns \
--header 'Content-Type: application/x-www-form-urlencoded' \
--header 'Authorization: Basic QTA0QT*******ODg1Og==' \
-d "order_id=:order_id" \
-d "merchant_id=:merchant_id" \
-d "payment_method_type=WALLET" \
-d "payment_method=MOBIKWIK" \
-d "redirect_after_payment=true" \
-d "format=json"
