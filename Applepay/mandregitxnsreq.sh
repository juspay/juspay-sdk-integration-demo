curl --location 'https://sandbox.juspay.in/txns' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--header 'Authorization: Basic Q********==' \
--data-urlencode 'order_id=test_1728734749' \
--data-urlencode 'merchant_id=MerchantID' \
--data-urlencode 'payment_method_type=WALLET' \
--data-urlencode 'payment_method=JP_APPLEPAY' \
--data-urlencode 'format=json' \
--data-urlencode 'redirect_after_payment=true' \
--data-urlencode 'should_create_mandate=true' \
--data-urlencode 'sdk_params=true' \
--data-urlencode 'mandate_type=EMANDATE' \
--data-urlencode 'metadata={"requestor_domain":"29af-152-58-24-143.ngrok-free.app"}'
