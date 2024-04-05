curl --location 'https://api.juspay.in/txns' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--header 'Authorization: Basic xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx' \
--data-urlencode 'order_id=<order_id>' \
--data-urlencode 'merchant_id=<merchant_id>' \
--data-urlencode 'payment_method_type=CARD' \
--data-urlencode 'payment_method=VISA' \
--data-urlencode 'redirect_after_payment=true' \
--data-urlencode 'format=json' \
--data-urlencode 'additional_payment_details=[
    {
        "payment_method_type": "REWARD",
        "payment_method": "LOYLTYREWARDZ",
        "split_amount": "x",
        "mobile_number":"xxxxxxxxxx",
        "reward_details": "{\"card_last_four\": \"xxxx\",\"program_code\": \"xxxxx\"}"
    }
]' \
--data-urlencode 'card_number=xxxx xxxx xxxx xxxx' \
--data-urlencode 'card_exp_month=xx' \
--data-urlencode 'card_exp_year=xxxx' \
--data-urlencode 'name_on_card=<name>' \
--data-urlencode 'card_security_code=xxx' \
--data-urlencode 'Split_amount=x'
