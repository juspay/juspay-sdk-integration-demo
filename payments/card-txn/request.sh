// A regular card transaction
curl -X POST https://smartgateway.hdfcbank.com/txns \
--header 'Content-Type: application/x-www-form-urlencoded' \
--header 'x-merchantid: merchant_id'\
--header 'Authorization: Basic QTA0QT*******ODg1Og==' \
-d "order_id=:order_id" \
-d "merchant_id=:merchant_id" \
-d "payment_method_type=CARD" \
-d "payment_method=VISA" \
-d "card_number=4242424242424242" \
-d "card_exp_month=10" \
-d "card_exp_year=20" \
-d "name_on_card=Name" \
-d "card_security_code=111" \
-d "save_to_locker=true" \
-d "tokenize=true" \
-d "redirect_after_payment=true" \
-d "format=json"

// A Stored card transaction
curl -X POST https://smartgateway.hdfcbank.com/txns \
-d "order_id=:order_id" \
-d "merchant_id=:merchant_id" \
-d "payment_method_type=CARD" \
-d "card_token=:card_token" \
-d "card_security_code=111" \ #optional field for CVV less supported transactions
-d "redirect_after_payment=true" \
-d "format=json"
