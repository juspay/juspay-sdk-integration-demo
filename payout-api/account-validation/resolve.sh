curl --location 'https://api.juspay.in/payout/merchant/v1/benedetails' \
--header 'Content-Type: application/json' \
--header 'x-merchantid: <merchant id>' \
--header 'Authorization: Basic (b64 encoded API key)' \
--data-raw '{
    "beneId":"beneID11",
    "beneDetails" : {
                "details": {
                    "name": "Aditya Kadrolkar",
                    "mobile": "8088375524"
                    },
                "type": "UPI_ID"
            },
    "preferredGateway" : "YESBIZ",
    "command" : "resolve",
    "customerId" : "14212551",
    "email": "test@gmail.com",
    "phone": "8088375524"
}'
