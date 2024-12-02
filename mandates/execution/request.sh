curl --location 'https://smartgatewayuat.hdfcbank.com/txns' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--header 'x-merchant-id: <merchant_id>' \
--header 'Authorization: Basic <api key in base64 format>' \
--data-urlencode 'order.order_id=mandateexecution1' \
--data-urlencode 'order.amount=1' \
--data-urlencode 'merchant_id=<merchant_id>' \
--data-urlencode 'mandate_id=<mandate_id>' \
--data-urlencode 'format=json'
