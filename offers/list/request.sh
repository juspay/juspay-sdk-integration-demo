curl --location --request POST 'https://api.juspay.in/v1/offers/list' \
--header 'Authorization: <API KEY>' \
--header 'Content-Type: application/json' \
--data-raw '{
    "order": {
        "order_id": "SDEA5645",
        "amount": "1000",
        "currency": "INR"
    },
    "payment_method_info": [
        {
            "payment_method_type": "CARD",
            "payment_method_reference": "card_number_identifier",
            "card_number": "4111111111111111"
        },
        {
            "payment_method_type": "CARD",
            "payment_method_reference": "card_tkn_identifier",
            "card_token": "tkn_89876654365"
        },
        {
            "payment_method_type": "WALLET",
            "payment_method_reference": "MOBIKWIK",
            "payment_method": "MOBIKWIK"
        },
        {
            "upi_vpa": "testcustomer@oksbi",
            "payment_method_type": "UPI",
            "payment_method_reference": "navyamotaiah@oksbi",
            "payment_method": "UPI",
            "txn_type": "UPI_COLLECT"
        },
        {
            "upi_app": "com.google.android.apps.nbu.paisa.user",
            "payment_method_type": "UPI",
            "payment_method_reference": "com.google.android.apps.nbu.paisa.user",
            "payment_method": "UPI",
            "txn_type": "UPI_PAY"
        },
        {
            "payment_method_type": "CONSUMER_FINANCE",
            "payment_method_reference": "ZESTMONEY",
            "payment_method": "ZESTMONEY"
        },
        {
            "payment_method_type": "NB",
            "payment_method_reference": "AXIS_BANK_NB",
            "payment_method": "NB_AXIS"
        }
    ],
    "customer": {
        "id": "customer123",
        "email": "customer5453@gmail.com",
        "mobile": "9999999999"
    }
}'