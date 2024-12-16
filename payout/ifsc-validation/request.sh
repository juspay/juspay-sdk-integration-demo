curl --location --request POST 'https://api.juspay.io/payout/merchant/v1/benedetails' \
-u your_api_key: \
--header 'Content-Type: application/json' \
--header 'x-merchantid: <merchant-id>' \
--data-raw '{
    "beneId":"Arunsbx1014",
    "beneDetails" : {
                "details": {
                    "ifsc": "YESB0000262"
                },
                "type": "IFSC"
            },
    "preferredGateway" : "CFGEN"
    
}'