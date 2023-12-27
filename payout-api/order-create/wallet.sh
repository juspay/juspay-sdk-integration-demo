curl --location 'https://sandbox.juspay.in/payout/merchant/v1/orders' \
--header 'Content-Type: application/json' \
--header 'x-merchantid: <merchant id>' \
--header 'Authorization: Basic (b64 encoded API key)' \
--data-raw '{
    "orderId": "1703665523",
    "fulfillments": [
        {
            "preferredMethodList": [],
            "amount": 1,
            "beneficiaryDetails": {
                "details": {
                    "name": "Aditya Kadrolkar",
                    "brand": "PAYTM",
                    "walletIdentifier" : "9999999999"
                },
                "type": "WALLET"
            },
               "udf1" : "String1"
            ,  "udf2" : "String2"
            ,  "udf3" : "String3"
            ,  "udf4" : "String4"
            ,  "udf5" : "String5"
            ,
            "additionalInfo": {
                "remark":"Payout Transaction",
                "useThisAsTR":"ef9eb194e664a319549e644c08be2b",
                "scheduleTime":"2023-12-23T16:51:51Z",
                "attemptThreshold": 1440,
                "webhookDetails":{
                    "url" : "https://www.test.com/callback/dynamicwebhook/example"
                    , "username" : "test"
                    , "password" : "password"
                    , "customHeader" :  "123456789"
                }
            }
        }
    ],
    "amount": 1,
    "customerId": "cth_59Yibs1JauYP6WJP",
    "customerPhone": "9999999999",
    "customerEmail": "test@gmail.com",
    "type": "FULFILL_ONLY",
    "udf1":"udf1",
    "udf2":"udf2",
    "udf3":"udf3",
    "udf4":"udf4",
    "udf5":"udf5"
}'
