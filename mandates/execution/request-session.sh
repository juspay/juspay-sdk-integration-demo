curl --location 'https://api.juspay.in/txns' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--header 'Authorization: Basic <base64 of key:>' \
--data-urlencode 'order.order_id=unique_order_id' \
--data-urlencode 'order.amount=1.00' \
--data-urlencode 'order.customer_id=customer_id' \
--data-urlencode 'merchant_id=merchantid' \
--data-urlencode 'mandate_id=mandate_id' \
--data-urlencode 'mandate.execution_date=1622369936' \
--data-urlencode 'format=json'