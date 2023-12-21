curl --location --request POST 'https://smartgateway.hdfcbank.com/txns' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'order_id=test_1610009874' \
--data-urlencode 'merchant_id=Symbol' \
--data-urlencode 'payment_method_type=WALLET' \
--data-urlencode 'payment_method=CRED' \
--data-urlencode 'redirect_after_payment=true' \
--data-urlencode 'format=json' \
--data-urlencode 'sdk_params=true' \
--data-urlencode
'sdk_pg_params={"platform":"web","os":"macOS","device":"desktop","countryCode":"+91","phoneNumber":"enc-<encrypted phonenumber>","credAppPresent":false,"metadata": {"abc":"123","def":"456"}}'