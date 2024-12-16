curl GET 'https://api.juspay.io/orders/{{order_id}}' \
--header 'x-merchantid: merchant_id' \
--header 'Authorization: Basic <base64 of key:>'
--header 'version: 2020-12-31'
