curl --location --request POST 'https://sandbox.juspay.in/orders/yourUniqueOrderId/fulfillment' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--header 'Postman-Token: 98866fa8-de08-4b18-b46e-1b0e73f2b00d' \
--header 'cache-control: no-cache' \
--header 'Authorization: Basic base64encodedkey==' \
--data-urlencode 'fulfillment_status=SUCCESS' \
--data-urlencode 'fulfillment_command=POST_TXN_SPLIT_SETTLEMENT' \
--data-urlencode 'split_settlement_details={"marketplace":{"amount":0},"mdr_borne_by":"ALL","vendor":{"split":[{"amount":5,"merchant_commission":0,"sub_mid":"test_sub_account_1"}]}}'