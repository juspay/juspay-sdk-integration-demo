curl -X POST https://api.juspay.in/wallets/$wallet_id \
-u your_api_key: \
-H 'x-routing-id: customer_1122'\
-d "command=delink"
