curl --location --request POST 'https://api.juspay.in/orders/123test/refunds' \
--header 'Authorization: Basic base_64_encoded_api_key==' \
--header 'x-merchantid: Merchant' \
--header 'Content-Type: application/json' \
--data-raw '{
   "unique_request_id": "xyz26",
   "amount": 88648.0,
   "product_details": [
       {
           "product_id": "30191",
           "imei_details": [
               {
                   "imei_no": "351204850035422"
               }
           ]
       }
   ]
}'
