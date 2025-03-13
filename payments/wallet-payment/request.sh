curl -X POST https://api.juspay.in/txns \
-H 'x-routing-id: customer_1122'\
-d "order_id=:order_id" \
-d "merchant_id=:merchant_id" \
-d "payment_method_type=WALLET" \
-d "payment_method=MOBIKWIK" \
-d "redirect_after_payment=true" \
-d "format=json"
