curl --location --request POST 'https://api.juspay.in/orders/123test/fulfillment' \
--header 'Authorization: Basic base_64_encoded_api_key==' \
--header 'x-merchantid: Merchant' \
--header 'Content-Type: application/json' \
--data-raw '{
   "fulfillment_status": "SUCCESS",
   "fulfillment_command": "BLOCK_IMEI",
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
