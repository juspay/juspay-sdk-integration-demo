curl --location 'https://api.juspay.in/v1/offers/list?emi=true' \
--header 'Content-Type: application/json' \
--header 'Authorization: <API KEY>' \
--data-raw '{
    "order": {
        "order_id": "SDEA5645",
        "amount": "12000",
        "currency": "INR",
        "basket": "[{\"id\":\"id1\",\"unitPrice\":10000,\"quantity\":1},{\"id\":\"id2\",\"unitPrice\":2000,\"quantity\":1}]"
    },
    "payment_method_info": [
        {
            "payment_method_type": "CARD",
            "payment_method_reference": "card_number_identifier",
            "card_number": "4111111111111111",
            "bank_code": "SBI",
            "card_type": "CREDIT"
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
        },
        {
            "payment_method_type": "CARD",
            "payment_method_reference": "AMEX_EMI_6",
            "is_emi": "true",
            "emi_bank": "AMEX",
            "emi_tenure":"6"
        }
    ],
    "customer": {
        "id": "customer123",
        "email": "customer5453@gmail.com",
        "mobile": "9999999999"
    }
    
}'