curl --location 'https://api.juspay.in/txns' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--header 'Authorization: Basic <base64 of key:>' \
--data-urlencode 'order.order_id=26234761248249834753485721' \
--data-urlencode 'order.amount=1.00' \
--data-urlencode 'order.customer_id=cst_lz7zmpemoo5okgav' \
--data-urlencode 'merchant_id=merchantid' \
--data-urlencode 'mandate_id=4rKxSj3bNXs7RQcdtajAkb' \
--data-urlencode 'mandate.execution_date=1622369936' \
--data-urlencode 'format=json'