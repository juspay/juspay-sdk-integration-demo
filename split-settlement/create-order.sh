curl --location --request POST 'https://smartgateway.hdfcbank.com/orders' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--header 'Authorization: Basic <base64 of Merchant API Key>' \
--data-urlencode 'order_id=splitsettlement_1619009418_test' \
--data-urlencode 'amount=5' \
--data-urlencode 'return_url=https://www.google.co.in' \
--data-urlencode 'metadata.split_settlement_details={"marketplace":{"amount":0},"mdr_borne_by":"ALL","vendor":{"split":[{"amount":3,"merchant_commission":0,"sub_mid":"Vendor1"},{"amount":2,"merchant_commission":0,"sub_mid":"Vendor2"}]}}'