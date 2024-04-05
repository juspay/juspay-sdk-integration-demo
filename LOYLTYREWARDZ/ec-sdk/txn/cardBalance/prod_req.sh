curl --location 'https://api.juspay.in/cards/balance' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--header 'Authorization: Basic xxxxxxxxxxxxxxxxxxxxxxxx' \
--data-urlencode 'merchant_id=<merchant_id>' \
--data-urlencode 'card_type=LOYLTYREWARDZ' \
--data-urlencode 'card_number=xxxx xxxx xxxx xxxx' \
--data-urlencode 'mobile_number=xxxxxxxxxx' \
--data-urlencode 'invoice_amount=xxx'
