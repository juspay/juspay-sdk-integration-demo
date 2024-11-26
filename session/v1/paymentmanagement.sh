curl --location 'https://sandbox.juspay.in/session' \
--header 'Content-Type: application/json' \
--header 'Authorization: Basic Auth' \
--data '{
    "customer_id": "customer",
    "payment_page_client_id": "clientId",
    "action": "paymentManagement"  
}'
