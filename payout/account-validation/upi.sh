curl --location --request POST 'https://api.juspay.in/payout/merchant/v1/benedetails' \
-u your_api_key: \
--header 'Content-Type: application/json' \
--header 'x-merchantid: <merchant-id>' \
--data-raw '{
    "beneId":"ravibene1",
    "beneDetails" : {
                "details": {
                    "name": "Shubham Kumar",
                    "vpa": "success@upi"    
  },
                "type": "UPI_ID"
            },
    "preferredGateway" : "CFGEN",
    "command" : "validate",
    "customerId" : "ravi1",
    "email": "dummy@gmail.com",
    "phone": "99999999"

}'
