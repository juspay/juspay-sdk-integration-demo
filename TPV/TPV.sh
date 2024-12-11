curl --location --request POST 'https://smartgatewayuat.hdfcbank.com/session' \
--header 'Content-Type: application/json' \
--header 'x-merchantid: <merchant_id>' \
--header 'x-customerid: CUST001' \
--header 'Authorization: Basic base_64_encoded_api_key==' \
--data-raw '{
    "order_id": "dedSdfd4",
    "amount": "1",
    "customer_id": "CUST001",
    "customer_email": "rahuls@gmail.in",
    "customer_phone": "8604613494",
    "payment_page_client_id": "hdfcmaster",
    "action": "paymentPage",
    "currency": "INR",
    "return_url": "https://www.google.com",
    "order_type" : "TPV_PAYMENT",
  "metadata.bank_account_details" : "[{\"bank_account_number\":\"833239234872\",\"bank_ifsc\":\"HDFC0876543\"}]"
}'
