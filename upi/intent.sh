curl -X POST https://api.juspay.in/txns \
-H 'Content-Type: application/x-www-form-urlencoded' \
-d 'merchant_id=juspay&order_id=9727125664Q20200107180320&payment_method_type=
UPI&payment_method=UPI&txn_type=UPI_PAY&redirect_after_payment=true& format=json&sdk_params=true'
