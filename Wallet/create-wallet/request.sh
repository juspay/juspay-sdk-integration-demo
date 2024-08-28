curl -X POST https://api.juspay.in/customers/$customer_id/wallets \
-u your_api_key: \
-d "gateway=MOBIKWIK" \
-d "command=authenticate"