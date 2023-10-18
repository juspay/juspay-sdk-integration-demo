curl --location 'https://sandbox.juspay.in/txns' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--header 'Authorization: Basic <auth>==' \
--data-urlencode 'order_id=<order-id>' \
--data-urlencode 'merchant_id=merchant_id' \
--data-urlencode 'payment_method_type=CARD' \
--data-urlencode 'payment_method=VISA' \
--data-urlencode 'redirect_after_payment=true' \
--data-urlencode 'format=json' \
--data-urlencode 'additional_payment_details=[
    {
        "payment_method_type": "REWARD",
        "payment_method": "TWID",
        "split_amount": "254",
        "reward_id": "212217",
        "reward_mode": "burn",
        "voucher_id": "1641"
    }
]' \
--data-urlencode 'card_number=4111111111111111' \
--data-urlencode 'card_exp_month=11' \
--data-urlencode 'card_exp_year=25' \
--data-urlencode 'name_on_card=Test' \
--data-urlencode 'card_security_code=123'