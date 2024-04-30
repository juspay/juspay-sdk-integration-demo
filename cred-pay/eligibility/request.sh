curl --location --request POST 'https://api.juspay.in/v3/eligibility' \
--header 'Authorization: Basic <API_KEY>' \
--header 'Content-Type: application/json' \
--data-raw '{
"merchant_id": "merchant_id", //mandatory field
"order_id": "order_id", //non-mandatory field
"amount": 1.0, //non-mandatory field
"customer_id": "customer_id", //non-mandatory field
"payment_instrument": [
        {
            "gateway_reference_id": "<gateway_reference_id>",
            "payment_method": "CRED",
            "payment_method_type": "WALLET",
            "command": "verify_user",
            "gateway": "CRED",
            "command_input": {
                "platform": "APP",
                "os": "IOS",
                "device": "MOBILE",
                "countryCode": "+91",
                "phoneNumber": "enc-<encrypted phone number>",
                "credAppPresent": false/true ,
                "isWebSupported": "true",
                "metadata": {
                    "abc": "123",
                    "def": "efe"
                }
            }
        }
    ]
}
