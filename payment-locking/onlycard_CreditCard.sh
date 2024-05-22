--data-raw '{
    "order_id": "jp_1716371837",
    "amount": "10.0",
    "customer_id": "1234",
    "customer_phone": "9110234217",
    "payment_page_client_id": "hdfcmaster",
    "action": "paymentPage",
    "return_url": "https://www.google.com",
    "description": "Complete your payment",
    "first_name": "John",
    "last_name": "wick",
    "payment_filter": {
        "allowDefaultOptions": false,
        "options": [
            {
                "paymentMethodType": "CARD",
                "enable": true,
                "cardFilters": [
                    {
                        "enable": true,
                        "cardTypes": [
                            "CREDIT"
                        ]
                    }
                ]
            }
        ]
    }
}'
