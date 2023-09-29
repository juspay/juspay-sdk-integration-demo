curl --location --request POST ‘https://api.juspay.in/session’ \
--header ‘x-merchantid: yourMerchantId’ \
--header ‘Authorization: Basic base64encodedkey==’ \
--header ‘Content-Type: application/json’ \
--data-raw ‘{
“amount”:“10.00“,
“order_id”:“yourUniqueOrderId”,
“customer_id”:“dummyCustId”,
“customer_phone”:“9876543210“,
“customer_email”:“dummyemail@gmail.com”,
“payment_page_client_id”:“<YOUR_CLIENT_ID>“,
“action”:“paymentPage”,
“metadata.JUSPAY:gateway_reference_id”: “TRAIN”
}’
