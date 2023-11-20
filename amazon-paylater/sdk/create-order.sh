curl --location 'https://sandbox.juspay.in/orders' \\
--header 'Content-Type: application/x-www-form-urlencoded' \
--header 'Authorization: Basic RTk4O*********5RDkwQjg1QUI3Og==' \
--data-urlencode 'order_id=MOTOINR1695191749' \
--data-urlencode 'amount=1' \
--data-urlencode 'currency=INR' \
--data-urlencode 'customer_id=cth_oKFk2gKvJUuwQ8Dq' \
--data-urlencode 'customer_email=nagendra.p@juspay.in' \
--data-urlencode 'customer_phone=7892369201' \
--data-urlencode 'product_id=product_187' \
--data-urlencode 'return_url=https://e3b6c0d9b8c8c44fc1ab2b6ee8ff1183.m.pipedream.net' \
--data-urlencode 'description=Sample_Description_1000' \
--data-urlencode 'metadata.AMAZONPAY%3Agateway_reference_id=juspay_test' \
--data-urlencode 'gateway_id=38'

