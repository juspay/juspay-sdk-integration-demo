curl --location 'https://smartgateway.hdfc.bank.in/merchants/{merchant_id}/order/{order_id}/cancel' \
--header 'version: 2019-08-19' \
--header 'Content-Type: application/json' \
--header 'x-merchantid: merchant_id' \
--header 'Authorization: BASE 64 Encoded API KEY' \
--data '{
    "cancel_reason": "Testing"
}'
