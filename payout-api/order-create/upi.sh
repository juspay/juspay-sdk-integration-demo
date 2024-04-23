curl --location 'https://sandbox.biz.juspay.in/ardra/vt/provision/v2' \
--header 'KeyId: <key Id>>' \
--header 'Content-Type: application/json' \
--header 'X-merchantid: <merchant id>' \
--header 'Authorization: Basic (b64 encoded API key)' \
--data '{
    "payoutId": "Juspay123456789",
    "orderAmount": "20",
    "gst": "1",
    "action": "Create",
    "startDate": "2024-04-23",
    "endDate": "2024-05-01",
    "cardAlias": "{to be taken from JusBiz Dashboard}",
    "expenseCategoryId":"{to be taken from JusBiz Dashboard}",
    "currency": "INR",
    "isCardImageRequired": true,
    "rules": {
        "blockPayments": [
            "ATM"
        ],
        "amountRange": {
            "min": "3",
            "max": "21"
        },
         "exactAmountApply": [
            "1"
         ],
        "mccBlock": [
            {
                "min": "5013",
                "max": "6051"
            }
        ]
        // "mccAllow": [
        //     {
        //         "min": "3",
        //         "max": "2"
        //     },
        //     {
        //         "min": "3",
        //         "max": "2"
        //     }
        // ]
    },
    "udf1": "XYZ",
    "udf2": "XYZ",
    "udf3": "XYZ",
    "udf4": "XYZ",
    "udf5": "XYZ",
    "udf6": "XYZ",
    "udf7": "XYZ",
    "udf8": "XYZ",
    "udf9": "XYZ",
    "udf10": "XYZ"
}'