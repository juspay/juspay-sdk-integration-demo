curl -L -X POST 'https://api.juspay.in/v2/emi/plans' \
-H 'Authorization: Basic <base64 of Merchant API Key>' \
-H 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'order_amount=25123.25' \
--data-urlencode 'merchant_id=<JusPay Merchant ID>' \
--data-urlencode 'mobile_number=99999999' \
--data-urlencode 'order_basket=[{"id":"491838009","description":"Test Product","quantity":1,"unitPrice":25123.25,"category":"Electronics","sku":"12345","productUrl":"https://www.google.com","sellerType":"VENDOR","customParams":{"name1":"value1","name2":"value2"}}]'