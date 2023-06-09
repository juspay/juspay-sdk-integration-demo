curl --location --request POST 'https://api.juspay.in/orders' \
--header 'version: 2018-10-25' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--header 'x-merchantid: merchant_id'\
--header 'Authorization: Basic QTA0QT*******ODg1Og==' \
--data-urlencode 'order_id=14183944763' \
--data-urlencode 'amount=100.00' \
--data-urlencode 'currency=INR' \
--data-urlencode 'customer_id=guest_user_101' \
--data-urlencode 'customer_email=customer@gmail.com' \
--data-urlencode 'customer_phone=9988665522' \
--data-urlencode 'product_id=prod-141833' \
--data-urlencode 'return_url=http://shop.merchant.com/payments/handleResponse' \
--data-urlencode 'description=Sample description' \
--data-urlencode 'options.get_client_auth_token=true' \