curl -X POST https://smartgateway.hdfcbank.com/txns \
-H 'Authorization: Basic QTA0QT*******ODg1Og==' \
-H 'Content-Type: application/x-www-form-urlencoded' \
-d "merchant_id=juspay" \
-d "order_id=9727125664Q20200107180320" \
-d "payment_method_type=UPI" \
-d "payment_method=UPI_PA" \
-d "txn_type=UPI_PAY" \
-d "redirect_after_payment=true" \
-d "format=json&sdk_params=true"
