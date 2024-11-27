curl --location 'https://sandbox.juspay.in/payout/merchant/v2/benedetails' \
--header 'Content-Type: application/json' \
--header 'x-merchantId: <merchant-id>' \
--header 'Authorization: Basic (b64 encoded API key)' \
--data-raw '{
    "beneId":"paypal8",
    "beneDetails" : {
                "details": {
                    "walletIdentifier" : "FSMRBANCV8PSG",
                    "brand" : "PAYPAL"
                },
                "type": "WALLET"
            },
    
    "preferredGatewayList" : ["PAYPAL_WALLET"],
    "command" : "CREATE",
    "customerId" : "tusharverma",
    "email": "dummy@gmail.com",
    "phone": "8974659374"
}'
