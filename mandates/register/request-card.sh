curl -X POST 'https://api.juspay.io/txns' \
-H 'Content-Type: application/x-www-form-urlencoded'\
-d 'order_id=152664118690577-910' \
-d 'merchant_id=guest' \
-d 'payment_method_type=CARD' \
-d 'payment_method=MASTERCARD' \
-d 'card_number=5243681100075285' \
-d 'card_exp_month=10' \
-d 'card_exp_year=20' \
-d 'name_on_card=name' \
-d 'card_security_code=111' \
-d 'save_to_locker=true' \
-d 'should_create_mandate=true'
