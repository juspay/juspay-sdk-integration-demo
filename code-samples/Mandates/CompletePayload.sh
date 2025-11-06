curl --location --request POST 'https://smartgateway.hdfc.bank.in/session' \
--header 'Content-Type: application/json' \
--header 'x-customerid: CUST001' \
--header 'merchant_id: testhdfc1' \
--header 'Authorization: Basic <Base64 API key>' \
--data-raw '{
    "order_id": "T_9110234219",
    "amount": "1.00",
    "customer_id": "C_AYUSH",
    "payment_page_client_id": "hdfcmaster",
    "action": "paymentPage",
    "description": "Complete your payment",
    "first_name": "Srikanth",
    "last_name": "Mitra",
    "options.create_mandate": "REQUIRED",
    "mandate.start_date": "1747362095",
    "mandate.rule_value": "15",
    "mandate.amount_rule" : "FIXED",
    "mandate.max_amount": "3.00",
    "mandate.revokable_by_customer": true,
    "mandate.block_funds": false,
    "mandate.frequency": "FORTNIGHTLY",
    "mandate.end_date": "1747534895"
}'
