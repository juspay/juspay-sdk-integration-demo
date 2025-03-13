curl -X POST https://api.juspay.in/orders/JPAYNEW035 \
-u your_api_key: \
-H 'x-routing-id: customer_1122'\
-H 'Content-Type: application/x-www-form-urlencoded'\
-H 'x-merchantid: merchant_id'\
-d "amount=90.00"
