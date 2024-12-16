curl --location --globoff 'https://sandbox.juspay.io/orders/{order_id}/refunds' \
--header 'x-merchantid: merchant_id' \
--header 'x-customerid: customer_id' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--header 'Authorization: Basic base_64_encoded_api_key==' \
--data-urlencode 'unique_request_id=xyz123' \
--data-urlencode 'amount=100.00'