curl --location 'https://sandbox.juspay.in/offers/list' \
--header ‘Content-Type: application/json' \
--header ‘Authorization: Basic NThBQMwRDYxMzIxxEvICQJHFMTKLRUESODU40g==' \
--data '{
"customer": {
"id": "test_filter_customer_1462",
"phone": "9741000605"
},
"order": {
"amount": "1000",
"currency": "INR",
"merchant_id": "merchant_id",
"order_id": "1234"
},
"payment_method_info": []
}'
