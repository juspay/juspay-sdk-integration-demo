curl --location 'https://sandbox.juspay.in/refunds' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--header 'version: 2019-03-19' \
--header 'Authorization: Basic N0JBRDA4xxxxxxxxxxxxxxxxxxlCNjY3QTVCMUQzM0Q6' \ 
--data-urlencode 'unique_request_id=refund_7800a8ed-eb1f-42a4-b6e0-f3798737cf03' \
--data-urlencode 'amount=1' \
--data-urlencode 'order_id=o1704709095' \
--data-urlencode 'metadata.merchant_capture_id=moz1704449291'