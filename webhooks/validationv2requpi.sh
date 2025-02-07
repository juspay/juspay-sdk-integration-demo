curl --location 'https://sandbox.juspay.in/payout/merchant/v2/benedetails' \
--header 'Content-Type: application/json' \
--header 'x-merchantId: morpheusdemo' \
--header 'Authorization: ••••••' \
--data-raw '{
    "beneId":"339178511402",
    "beneDetails" : {
                "details": {
                    "name": "Aditya Kadrolkar",
                    "vpa": "success@upi",
                    },
                "type": "UPI_ID"
            },
    "command" : "VALIDATE",
    "customerId" : "cth_59Yibs1JauYP6WJP",
    "email": "test@gmail.com",
    "phone": "9999999999"
}'
