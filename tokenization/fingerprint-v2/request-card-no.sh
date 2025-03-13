curl --location 'https://sandbox.juspay.in/v2/card/fingerprint' \
--header 'Content-Type: application/json' \
--header 'x-routing-id: customer_1122'\
--header 'Authorization: Basic <MASKED API KEY>' \
--data '{
    "card_number": "Card Number",
    "is_token": false
}'
