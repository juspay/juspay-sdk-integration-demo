
curl --location 'https://smartgateway.hdfc.bank.in/v2/emi/plans' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--header 'Authorization: Basic <base64 of Merchant API Key>' \
--data-urlencode 'merchant_id=merchant_id' \
--data-urlencode 'order_amount=1500' \
--data-urlencode 'mobile_number=9999999999' \
--data-urlencode 'order_basket=[{"id":"491838009","description":"Test Product","quantity":1,"unitPrice":1500,"category":"Electronics","sku":"12345","productUrl":"https://www.google.com","sellerType":"VENDOR","customParams":{"name1":"value1","name2":"value2"}}]'
