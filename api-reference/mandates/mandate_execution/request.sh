curl -X  POST 'https://api.hyperpg.in/txns' \
-H 'Content-Type: application/x-www-form-urlencoded' \
-H 'Authorization: Basic <base64 of key:>'
-d 'order.order_id=26234761248249834753485721' \
-d 'order.amount=1.00' \
-d 'order.customer_id=cst_lz7zmpemoo5okgav' \
-d 'order.metadata.BILLDESK:AdditionalInfo1=info' \
-d 'mandate_id=4rKxSj3bNXs7RQcdtajAkb' \
-d 'mandate.notification_id=2QNPw8KSbpHL122bNP926' \
-d 'mandate.display_invoice_number=JUS1239881' \
-d 'mandate.execution_date=1622369936' \
-d 'merchant_id=merchantid' \
-d 'format=json'