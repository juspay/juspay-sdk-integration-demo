curl --location 'https://sandbox.juspay.in/payout/merchant/v1/orders' \
--header 'Content-Type: application/json' \
--header 'x-merchantid: <merchantId>' \
--header 'Authorization: Basic (b64 encoded API key)' \
--data-raw '{
    "orderId": "1703350468",
    "fulfillments": [
        {
            "preferredMethodList": ["DUMMY_IMPS"],
            "amount": 1,
            "beneficiaryDetails": {
                "details": {
                    "name": "Aditya Kadrolkar",
                    "account": "026291800001191",
                    "ifsc" : "YESB0000262"
                },
                "type": "ACCOUNT_IFSC"
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
                "attemptThreshold": 25,
                "isRetriable": false
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
