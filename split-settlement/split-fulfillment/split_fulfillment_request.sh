curl --location 'https://sandbox.juspay.in/orders/order1730187936/fulfillment' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--header 'Postman-Token: 98866fa8-de08-4b18-b46e-1b0e73f2b00d' \
--header 'cache-control: no-cache' \
--header 'Authorization: Basic QzQ3NEE3MjYyQ0M0NjhCQTYzQzIwNDVFRUM3RDgwOg==' \
--data-urlencode 'fulfillment_status=SUCCESS' \
--data-urlencode 'fulfillment_command=POST_TXN_SPLIT_SETTLEMENT' \
--data-urlencode 'split_settlement_details={"marketplace":{"amount":2},"mdr_borne_by":"ALL","vendor":{"split":[{"amount":3,"merchant_commission":1,"sub_mid":"Vendor1"},{"amount":3,"merchant_commission":1,"sub_mid":"Vendor2"}]}}'