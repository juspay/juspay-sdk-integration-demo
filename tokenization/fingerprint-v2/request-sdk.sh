curl --location 'https://smartgatewayuat.hdfcbank.com/v2/card/fingerprint' \
--header 'Content-Type: application/json' \
--header 'Authorization: Basic <MASKED API KEY>' \
--data '{
    "requestId": "Unique Request ID",
    "service": "in.juspay.hyperapi",
    "payload": {
        "action": "cardFingerprintV2",
        "card_token": "Juspay Generated 15 min valid token",
        "istoken": "true",
        "clientAuthToken": "tkn_0e37edc631d647fdb606ab48ccfc4213"
    }
}'