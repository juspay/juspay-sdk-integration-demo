curl --location 'https://sandbox.juspay.in/v2/refunds/400102025106853888/sync' \
--header 'Content-Type: application/json' \
--header 'Authorization: Basic RThFNzk0REIwNTQ0MTdGOUMxMDQyMTk3NEFBNjhFOg==' \
--data '{
    "force_sync" : true
}'