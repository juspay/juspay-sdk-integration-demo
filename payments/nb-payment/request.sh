curl -X POST https://smartgateway.hdfcbank.com/txns \
--header 'Authorization: Basic QTA0QT*******ODg1Og==' \
--header 'Content-Type: application/x-www-form-urlencoded' 
-d "order_id=:order_id" \
-d "merchant_id=:merchant_id" \
-d "payment_method_type=NB" \
-d "payment_method=NB_ICICI" \
-d "redirect_after_payment=true" \
-d "format=json"