curl -X POST https://smartgateway.hdfcbank.com/orders/1418394476/refunds \
-u your_api_key: \
-H "version:2023-06-30" \
-H 'Content-Type: application/x-www-form-urlencoded'\
-H 'x-merchantid: merchant_id'\
-H 'x-routing-id: <customer_id>' \
-H 'Authorization: Basic QTA0QT*******ODg1Og==' \
-d "unique_request_id=xyz123" \
-d "amount=100.00"