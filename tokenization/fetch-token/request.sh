curl -L 'https://smartgateway.hdfcbank.com/v4/card/get' \
-H 'Content-Type: application/json' \
-H 'Authorization: Basic XXXXXXk0QjJEQTlBQjc0QThCOg==' \
-d '{
    "card_reference": "cref_16b951273f5b411dbbf7c252e0696f72",
    "customer_id" : "juspaytest_cust",
    "check_cvv_less_support": true
}'