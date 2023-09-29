curl --location --request POST 'https://sandbox.juspay.in/session' \
--header 'Content-Type: application/json' \
--header 'Authorization: Basic 82Q19002******==' \
--data-raw '{
    "order_id": "ref_939",
    "amount": "100.0",
    "customer_id": "cth_pKL9ayw75febC1Dd",
    "customer_email": "test@mail.com",
    "customer_phone": "9986028298",
    "payment_page_client_id": "sugar",
    "action": "paymentPage",
    "return_url": "http://www.juspay.in",
    "description": "Complete your payment",
    "first_name": "Monkey.D",
    "last_name": "Luffy",
    "product_id": "test123",
    "quantity": "1",
    "merchant_id": "merchant_success",
    "currency": "INR",
    "metadata.AMAZONPAY:gateway_reference_id": "amazon_test"
    }'