curl --location 'https://sandbox.biz.juspay.in/ardra/vt/cvv/v2' \
--header 'KeyId: <key Id>>' \
--header 'Content-Type: application/json' \
--header 'X-merchantid: <merchant id>' \
--header 'Authorization: Basic (b64 encoded API key)' \
--data '{
    
    "payoutId": "Juspay123456789",
    "isCardImageRequired": true
}'