curl --location 'https://sandbox.juspay.in/generateToken' \
--header 'Content-Type: application/json' \
--header 'x-routing-id: customer_1122'\
--header 'Authorization: Basic MDRFRDU3Mzc1Q0Q0NzMxQTMzN0QzQjJEQzlENTBCOg==' \
--data '{
    "service" : "NETWORK_TOKEN",
    "cardData": "xxxxxxx",
    "orderData" : {
        "consentId" : "xxxxxxx",
        "customerId" : "xxxxxxx"
    },
    "audit": {
        "authRefNo" : "test12324"
    },
    "shouldSendToken": true
}'
