curl --location --request POST 'https://api.juspay.in/orders/testorder1/refunds' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--header 'Authorization: Basic <base64 of Merchant API Key>' \
--data-urlencode 'unique_request_id=refundstar7695' \
--data-urlencode 'amount=1'
