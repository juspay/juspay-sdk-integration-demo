curl --location 'https://sandbox.juspay.in/v2/card/fingerprint' \
--header 'Content-Type: application/json' \
--header 'Authorization: Basic <MASKED API KEY>' \
--data '{
    "card_token": "Card Token"
}'