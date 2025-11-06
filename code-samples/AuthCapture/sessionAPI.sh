curl --location --request POST 'https://smartgateway.hdfc.bank.in/session' \
--header 'x-merchantid: 34436' \
--header 'Content-Type: application/json' \
--header 'version: 2024-05-01' \
--header 'Authorization: Basic <Base64 Encoded API Key>' \
--data-raw '{
    "order_id": "T1742198078",
    "amount": "10000.0",
    "customer_id": "123444",
    "payment_page_client_id": "34436",
    "action": "paymentPage",
    "description": "Complete your payment",
    "first_name": "first_name",
    "last_name": "last_name",
    "metadata.txns.auto_capture": "false"
}'
