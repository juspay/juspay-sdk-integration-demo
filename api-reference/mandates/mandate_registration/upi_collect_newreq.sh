curl --location 'https://api.hyperpg.in/txns' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--header 'Authorization: Basic MzJCNDM3QTZCNUI0OEE5OUEwQTQ4ODU4RDNCQzU1Og==' \
--data-urlencode 'order_id=test_4_aj' \
--data-urlencode 'merchant_id=mandate_juspay' \
--data-urlencode 'payment_method_type=UPI' \
--data-urlencode 'payment_method=UPI_COLLECT' \
--data-urlencode 'redirect_after_payment=true' \
--data-urlencode 'format=json' \
--data-urlencode 'should_create_mandate=true' \
--data-urlencode 'mandate_type=EMANDATE'
