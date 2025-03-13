curl -X POST https://api.juspay.in/customers/$customer_id/wallets \
-u your_api_key: \
-H 'x-routing-id: customer_1122'\
-d "gateway=MOBIKWIK" \
-d "command=authenticate"
