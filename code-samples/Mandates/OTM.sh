curl --location --request POST 'https://smartgateway.hdfcbank.com/session' \
--header 'Content-Type: application/json' \
--header 'x-customerid: testhdfc1' \
--header 'merchant_id: 44910' \
--header 'Authorization: Basic <Base64 API Key>' \
--data-raw '{
    "order_id": "T_9110234219",
    "amount": "1.00",
    "customer_id": "C_AYUSH",
    "payment_page_client_id": "hdfcmaster",
    "action": "paymentPage",
    "description": "Complete your payment",
    "first_name": "Srikanth",
    "last_name": "Mitra",
    "options.create_mandate": "REQUIRED",
    "mandate.max_amount": "3.00",
    "mandate.revokable_by_customer": false,
    "mandate.block_funds": true,
    "mandate.frequency": "ONETIME",
    "mandate.end_date": "1747534895"
}'
