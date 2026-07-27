curl --location 'https://smartgateway.hdfc.bank.in/paymentLink/notify' \
--header 'Authorization: BASE 64 Encoded API KEY' \
--header 'User-Agent: curl/7.64.1' \
--header 'X-Auth-Scope: scope_value' \
--header 'X-Forwarded-For: 203.0.113.42' \
--header 'x-merchantid: merchant_id' \
--header 'Content-Type: application/json' \
--data '{
    "send_mail" : true,
    "send_sms" : true,
    "order_id" : "TestingOrderID"
}'
