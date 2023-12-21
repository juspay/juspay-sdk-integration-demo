curl -X POST 'https://smartgateway.hdfcbank.com/txns' \
-H 'Content-Type: application/x-www-form-urlencoded' \
-d 'order_id=ORD1622098688' \
-d 'merchant_id=guest' \
-d 'payment_method_type=NB' \
-d 'payment_method=JP_HDFC' \
-d 'bank_ifsc=HDFC0000053' \
-d 'bank_account_number=50100013132000' \
-d 'bank_beneficiary_name=test' \
-d 'should_create_mandate=true' \
-d 'mandate_type=EMANDATE' \
-d 'format=json' \
-d 'redirect_after_payment=true'

