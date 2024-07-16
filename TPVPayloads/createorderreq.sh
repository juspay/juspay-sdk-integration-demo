curl --location --request POST 'https://api.juspay.in/orders' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--header 'Authorization: Basic <base64 of Merchant API Key>' \
--data-urlencode 'order_id=test' \
--data-urlencode 'amount=3' \
--data-urlencode 'return_url=https://www.google.co.in' \
--data-urlencode 'metadata.bank_account_details : [{"bank_account_number":"23940293840","bank_ifsc":"HDFC011211", "juspay_bank_code" :"JP_HDFC","bank_beneficiary_name" : "test", "bank_account_id" : "bank_atghjv5hgh795"},{"bank_account_number":"23940293841","bank_ifsc":"ICIC011211", "juspay_bank_code" : "JP_ICICI","bank_beneficiary_name" : "test", "bank_account_id" : "bank_atghjv5hgh796"}]'
