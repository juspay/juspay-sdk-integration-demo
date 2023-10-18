curl --location 'https://api.juspay.in/orders/txns/<txnId>/refunds' \
--header 'Accept: application/json' \
--header 'version: 2022-03-16' \
--header 'x-merchantid:<merchantId>' \
--header 'Authorization: Basic Auth' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'unique_request_id=req-1695671557' \
--data-urlencode 'amount=998'