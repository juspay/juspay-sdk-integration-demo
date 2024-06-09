--data-raw '{
    "order_id": "jp_1716372859",
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
        "allowDefaultOptions": true,
        "options": [
            {
                "paymentMethodType": "CARD",
                "enable": true,
                "cardFilters": [
                    {
                        "enable": false,
                        "cardBrands": [
                            "VISA"
                        ]
                    }
                ]
            }
        ]
    }
}'
