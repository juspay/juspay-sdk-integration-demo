curl -X POST https://api.juspay.io/orders/JPAYNEW035 \
-u your_api_key: \
-H 'Content-Type: application/x-www-form-urlencoded'\
-H 'x-merchantid: merchant_id'\
-d "amount=90.00"