curl -L -X POST 'https://api.juspay.in/v2/emi/plans' \
-H 'Authorization: Basic <base64 of Merchant API Key>' \
-H 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'order_amount=25123.25' \
--data-urlencode 'merchant_id=<JusPay Merchant ID>' \
--data-urlencode 'mobile_number=9999999999' \
--data-urlencode 'customer_id=vcxdfghgfg'\
--data-urlencode 'order_basket=[{"id":"491838009","unitPrice":25123.25,"quantity":3},{"id":"123","unitPrice":765.7,"quantity":3}]'
