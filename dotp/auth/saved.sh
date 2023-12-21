curl -X POST https://smartgateway.hdfcbank.com/txns \
-u your_api_key: \
-d "order_id=:order_id" \
-d "merchant_id=:merchant_id" \
-d "payment_method_type=CARD" \
-d "card_token=:card_token" \
-d "format=json" \
-d "auth_type=OTP" 
