curl --location -g --request POST 'https://api.juspay.in/orders/{order_id}/fulfillment' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--header 'Authorization: <Your Base64 Encoded API Key>' \
--header 'x-merchantid: merchant_id' \
--data-urlencode 'fulfillment_status=SUCCESS' \
--data-urlencode 'fulfillment_command=NO_ACTION' \
--data-urlencode 'fulfillment_time=2024-07-08T16:30:33' \
--data-urlencode 'fulfillment_id=<Committed PNR>' \
--data-urlencode 'fulfillment_data=test_data_nvewnvubbewnv'
