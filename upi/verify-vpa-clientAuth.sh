curl --location --request POST 'https://api.juspay.in/v2/upi/verify-vpa' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'vpa=9999999999@upi' \
--data-urlencode 'merchant_id=MerchantId' \
--data-urlencode 'client_auth_token=tkn_f4c63734420644dd8849ff17b926bf062' \
--data-urlencode 'customer_id=CustObj_refid_2217_36'