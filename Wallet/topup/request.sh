curl -X POST https://smartgateway.hdfcbank.com/wallets/$wallet_id/topup \
-u your_api_key: \
-d "amount=1.00"
-d "topup_txn_id=topup_sdj4kjr8"
-d "return_url=https://shop.merchant.com/payments/handleResponse"