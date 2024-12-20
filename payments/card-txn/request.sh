// A regular card transaction
curl --location 'https://smartgatewayuat.hdfcbank.com/txns' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--header 'x-merchantid: merchant_id' \
--data-urlencode 'order_id=TEST23' \
--data-urlencode 'merchant_id=merchant_id' \
--data-urlencode 'payment_method_type=CARD' \
--data-urlencode 'payment_method=VISA' \
--data-urlencode 'card_number=4012000000001097' \
--data-urlencode 'card_exp_month=08' \
--data-urlencode 'card_exp_year=26' \
--data-urlencode 'name_on_card=testing' \
--data-urlencode 'card_security_code=123' \
--data-urlencode 'save_to_locker=true' \
--data-urlencode 'redirect_after_payment=true' \
--data-urlencode 'format=json'

// A Stored card transaction
curl -X POST https://smartgateway.hdfcbank.com/txns \
-d "order_id=:order_id" \
-d "merchant_id=:merchant_id" \
-d "payment_method_type=CARD" \
-d "card_token=:card_token" \
-d "card_security_code=111" \ #optional field for CVV less supported transactions
-d "redirect_after_payment=true" \
-d "format=json"
