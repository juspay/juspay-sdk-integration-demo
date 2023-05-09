curl -X POST https://api.juspay.in/orders/1418394476/refunds \
-u your_api_key: \
-H "version:2018-10-25" \
-H 'Content-Type: application/x-www-form-urlencoded'\
-H 'x-merchantid: merchant_id'\
-d "unique_request_id=1" \
-d "amount=100.00"