curl -X POST https://api.hyperpg.in/txns \
-d "order_id=9727125664Q20200107180320" \
-d "merchant_id=juspay" \
-d "payment_method_type=UPI" \
-d "payment_method=UPI_PAY" \
-d "redirect_after_payment=true" \
-d "format=json"\
-d "sdk_params=true"\
-d "upi_app=com.phonepe.app"
