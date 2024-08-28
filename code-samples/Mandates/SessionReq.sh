curl --location --request POST 'https://smartgatewayuat.hdfcbank.com/session' \
--header 'x-merchantid: testhdfc1' \
--header 'Content-Type: application/json' \
--header 'Authorization: Basic MEVG************************************Og==' \
--data-raw '{
    "order_id": "JP_1724825386",
    "amount": "10.0",
    "customer_id": "test9117",
    "customer_phone": "9999999999",
    "payment_page_client_id": "hdfcmaster",
    "action": "paymentPage",
    "return_url": "https://www.google.com",
    "description": "Complete your payment",
    "options.create_mandate": "REQUIRED",
    "mandate.max_amount": "300.00"
}'
