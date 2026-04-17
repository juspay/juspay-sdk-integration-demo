curl --location 'https://sandbox.biz.juspay.in/ardra/vt/fetchStatus/v2' \
--header 'KeyId: <key Id>' \
--header 'x-merchant-id: <merchant id>' \
--header 'Content-Type: application/json' \
--header 'Authorization: Basic MktCUUJaVVJMQkU3WVVHUjo=' \
--data '{
    "payoutId" : "Juspay123456789"
}'