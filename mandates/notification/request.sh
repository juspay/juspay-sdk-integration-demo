curl --location --request POST 'https://api.juspay.in/mandates/b70vxxxxxjGyUhVrV8' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--header 'x-routing-id: customer_1122'\
--header 'Authorization: Basic BaxxxxxxxxERTxxxxxxxxx0Og==' \
--data-urlencode 'command=pre_debit_notify' \
--data-urlencode 'object_reference_id=abcxyz' \
--data-urlencode 'description=Sending pre-debit notification' \
--data-urlencode 'source_info={"amount": "1","txn_date": "1686576938"}'
