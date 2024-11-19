curl --location 'https://sandbox.juspay.in/orders/yourUniqueOrderId/fulfillment' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--header 'cache-control: no-cache' \
--header 'Authorization: Basic base64encodedkey==' \
--data-urlencode 'fulfillment_status=SUCCESS' \
--data-urlencode 'fulfillment_command=POST_TXN_SPLIT_SETTLEMENT' \
--data-urlencode 'split_settlement_details={"marketplace":{"amount":2},"mdr_borne_by":"ALL","vendor":{"split":[{"amount":3,"merchant_commission":1,"sub_mid":"Vendor1"},{"amount":3,"merchant_commission":1,"sub_mid":"Vendor2"}]}}'
