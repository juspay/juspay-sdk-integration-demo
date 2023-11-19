curl -L 'https://api.juspay.in/v4/card/get' \
-H 'Content-Type: application/json' \
-H 'Authorization: Basic XXXXXXk0QjJEQTlBQjc0QThCOg==' \
-d '{
    "card_reference": "token_a0c16957f9bf46b0966a91a35b555353",
    "customer_id" : "juspaytest_cust",
    "submerchantId" : "airline1"
}'