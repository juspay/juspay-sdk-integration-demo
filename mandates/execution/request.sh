curl -X  POST 'https://api.juspay.io/txns' \
-H 'Content-Type: application/x-www-form-urlencoded' \
-H 'Authorization: Basic <base64 of key:>'
-d 'order.order_id=26234761248249834753485721' \
-d 'order.amount=1.00' \
-d 'order.customer_id=cst_lz7zmpemoo5okgav' \
-d 'mandate_id=4rKxSj3bNXs7RQcdtajAkb' \
-d 'mandate.execution_date=1622369936' \
-d 'merchant_id=merchantid' \
-d 'format=json'
