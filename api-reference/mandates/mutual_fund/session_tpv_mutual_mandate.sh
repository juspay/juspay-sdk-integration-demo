curl --location 'https://api.juspay.in/session' \
--header 'Authorization: Basic NjQ4RTZjc0=' \
--header 'x-merchantid: test' \
--header 'Content-Type: application/json' \
--data-raw '{
    "order_id": "06022023",
    "amount": "2.0",
    "customer_id": "cst_3uh6gumy3esndhdr",
    "customer_email": "test@mail.com",
    "customer_phone": "9876543210",
    "payment_page_client_id": "test",
    "currency": "INR",
    "action": "paymentPage",
    "return_url": "https://www.test.com",
    "order_type":"TPV_PAYMENT",
    "mutual_fund_details": "[{\"memberId\": \"ABCDE\", \"userId\": \"ABCDEFGHIJ\", \"mfPartner\": \"BSE\", \"orderNumber\": \"1727380577\", \"amount\": \"1\", \"investmentType\": \"SIP\", \"schemeCode\": \"LT\",\"folioNumber\": \"190983010\",\"amcCode\": \"UYTIUI\",\"panNumber\": \"TYLIO7823U\"}, {\"memberId\": \"ABCDE\", \"userId\": \"ABCDEFGHIJ\", \"mfPartner\": \"BSE\", \"orderNumber\": \"1727380577-1\", \"amount\": \"1\", \"investmentType\": \"SIP\", \"schemeCode\": \"LT\",\"folioNumber\": \"190983010\",\"amcCode\": \"UYTIUI\",\"panNumber\": \"TYLIO7823U\"}]",
    "gateway_id":"514",
    "metadata.bank_account_details" : "[{\"bank_account_number\":\"83748239234872\",\"bank_ifsc\":\"AABD0000011\", \"bank_beneficiary_name\" : \"Abc\"}]",
    "options.create_mandate":"REQUIRED",
    "mandate_max_amount": "2000"
}'
