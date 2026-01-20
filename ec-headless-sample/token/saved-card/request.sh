curl -X POST https://api.juspay.in/txns \
-d "order_id=:order_id" \
-d "merchant_id=:merchant_id" \
-d "payment_method_type=CARD" \
-d "card_token=:card_token" \
-d "card_security_code=111" \
-d "redirect_after_payment=true" \
-d "tokenize=true" \
-d "format=json"