curl --location --request POST 'https://smartgateway.hdfcbank.com/payout/merchant/v1/benedetails' \
-u your_api_key: \
--header 'Content-Type: application/json' \
--header 'x-merchantId: <merchant-id>' \
--data-raw '{
    "beneId":"ravibene4",
    "beneDetails" : {
                "details": {
                    "name": "Shubham Kumar",
                    "ifsc": "YESB0000262",
                    "account": "026291800001191"
                },
                "type": "ACCOUNT_IFSC"
            },
    "preferredGateway" : "CFGEN",
    "command" : "validate",
    "customerId" : "ravi1",
    "email": "dummy@gmail.com",
    "phone": "9999999999"

}
