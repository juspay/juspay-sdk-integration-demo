curl --location 'https://sandbox.juspay.io/orders' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--header 'Authorization: Basic OTgwZERERCOg==' \
--data-urlencode 'order_id=1692783824' \
--data-urlencode 'return_url=https://merchant.in/payments' \
--data-urlencode 'amount=100' \
--data-urlencode 'metadata.PAYPAL%3Agateway_reference_id=' \
--data-urlencode 'gateway_id=20' \
--data-urlencode 'currency=BRL'

