curl --location --request POST 'https://api.juspay.io/orders/splitsettlement_1619009418_test/refunds' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--header 'Authorization: Basic <base64 of Merchant API Key>' \
--data-urlencode 'unique_request_id=refund_1619010416' \
--data-urlencode 'amount=1' \
--data-urlencode 'metadata.split_settlement_details={"marketplace": {"refund_amount": 0}, "vendor": {"split": [{"sub_mid": "Vendor2", "refund_amount": 1}]}}'