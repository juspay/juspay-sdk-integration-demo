curl --location --request POST 'https://smartgatewayuat.hdfcbank.com/txns' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'order_id=DW-1dvn6nL9AD' \
--data-urlencode 'merchant_id=merchantId' \
--data-urlencode 'should_create_mandate=true' \
--data-urlencode 'payment_method_type=UPI' \
--data-urlencode 'payment_method=UPI_PAY' \
--data-urlencode 'txn_type=UPI_PAY' \
--data-urlencode 'sdk_params=true' \
--data-urlencode 'mandate_type=EMANDATE'\
--data-urlencode 'redirect_after_payment=true' \
--data-urlencode 'format=json' 
