curl --location 'https://smartgatewayuat.hdfcbank.com/v2/card/fingerprint' \
--header 'Content-Type: application/json' \
--header 'Authorization: Basic <MASKED API KEY>' \
--data '{
    "card_number": "Card Number",
    "is_token": false
}'