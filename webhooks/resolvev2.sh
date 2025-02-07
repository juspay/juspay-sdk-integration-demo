curl --location 'https://api.juspay.in/payout/merchant/v2/benedetails' \
--header 'Content-Type: application/json' \
--header 'x-merchantid: <merchantId>' \
--header 'Authorization: ••••••' \
--data-raw '{
    "beneId":"34143110214",
    "beneDetails" : {
                "details": {
                    "name": "Aditya Kadrolkar",
                    "mobile": "8088375524"
                    },
                "type": "UPI_ID"
            },
    "preferredGatewayList" : ["YESBIZ_UPI"],
    "command" : "RESOLVE",
    "customerId" : "cth_59Yibs1JauYP6WJP",
    "email": "test@gmail.com",
    "phone": "8088375524"
}'
