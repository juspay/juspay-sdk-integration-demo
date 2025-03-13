curl -X POST https://api.juspay.in/txns \
-u your_api_key: \
-H 'x-routing-id: customer_1122'\
-d "order_id=:order_id" \
-d "merchant_id=:merchant_id" \
-d "payment_method_type=CARD" \
-d "card_token=:card_token" \
-d "format=json" \
-d "auth_type=OTP" 
