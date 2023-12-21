curl -X POST https://smartgateway.hdfcbank.com/txns \
-d "order_id=:order_id" \
-d "merchant_id=:merchant_id" \
-d "payment_method_type=CARD" \
-d "payment_method=ATM_CARD_BOB" \
-d "auth_type=ATMPIN"
-d "redirect_after_payment=true" \
-d "format=json"
