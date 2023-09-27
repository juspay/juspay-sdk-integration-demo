curl -X POST https://api.juspay.in/txns \
-d "order_id=:order_id" \
-d "merchant_id=:merchant_id" \
-d "payment_method_type=NB" \
-d "payment_method=NB_BCA" \
-d "redirect_after_payment=true2" \
-d "format=json"