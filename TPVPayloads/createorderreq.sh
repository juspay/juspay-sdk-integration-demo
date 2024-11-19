curl --location --request POST 'https://sandbox.juspay.in/orders' \
--header 'version: 2018-07-01' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--header 'Authorization: Basic XXXXXXXXXXXXXXXXXXXXX==' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'order_id=158791897003' \
--data-urlencode 'amount=1' \
--data-urlencode 'currency=INR' \
--data-urlencode 'return_url=https://google.com' \
--data-urlencode 'customer_id=cst_co0o92cz8maetw' \
--data-urlencode 'customer_phone=7076654366' \
--data-urlencode 'customer_email=abc@juspay.in' \
--data-urlencode 'metadata.PAYU:gateway_reference_id=TPV' \
--data-urlencode 'metadata.bank_account_details=[{"bank_account_number":"08791610032772","bank_ifsc":"HDFC011211", "juspay_bank_code" : "JP_HDFC", "bank_beneficiary_name" : "ABC"},{"bank_account_number":"055971532221","bank_ifsc":"ICICI015214", "juspay_bank_code" : "JP_ICICI"}]' \
--data-urlencode 'order_type=TPV_PAYMENT'
