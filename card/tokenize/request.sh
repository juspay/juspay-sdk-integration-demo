curl https://api.juspay.in/card/tokenize \
    -H 'x-routing-id: customer_1122'\
    -d "card_number=4111111111111111" \
    -d "card_exp_year=2015" \
    -d "card_exp_month=07" \
    -d "card_security_code=123" \
    -d "merchant_id=myshop" \
    -d "name_on_card=123"
