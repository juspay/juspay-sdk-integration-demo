curl --location --request POST 'https://smartgateway.hdfcbank.com/v1/offers/list' \
--header 'Authorization: <API KEY>' \
--header 'Content-Type: application/json' \
--data-raw '{
    "order": {
        "order_id": "1698406955",
        "amount": "12000",
        "currency": "INR",
        "amount_info": "{\"base_amount\":\"11000\",\"add_on_amounts\":[{\"name\":\"deliverytip\",\"amount\":\"100\"},{\"name\":\"deliverycharge\",\"amount\":\"400\"},{\"name\":\"donation\",\"amount\":\"100\"},{\"name\":\"surgecharge\",\"amount\":\"100\"},{\"name\":\"packingcharge\",\"amount\":\"100\"},{\"name\":\"tax\",\"amount\":\"100\"},{\"name\":\"othercharges\",\"amount\":\"100\"}]}"
    },
    "payment_method_info": [
        {
            "payment_method_type": "CARD",
            "payment_method_reference": "AMEX_EMI_6",
            "is_emi": "true",
            "emi_bank": "AMEX",
            "emi_tenure":"6"
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
    ]
}'