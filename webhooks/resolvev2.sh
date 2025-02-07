curl --location 'https://api.juspay.in/payout/merchant/v2/benedetails' \
--header 'Content-Type: application/json' \
--header 'x-merchantid: <merchantId>' \
--header 'Authorization: *****' \
--data-raw '{
    "beneId":"beneID11",
    "beneDetails" : {
                "details": {
                    "name": "Aditya Kadrolkar",
                    "mobile": "8088375524"
                    },
                "type": "UPI_ID"
            },
    "preferredGatewayList" : ["YESBIZ_UPI"],
    "command" : "RESOLVE",
    "customerId" : "14212551",
    "email": "test@gmail.com",
    "phone": "8088375524"
}'
