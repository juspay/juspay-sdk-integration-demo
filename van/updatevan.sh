curl --location --request PUT 'https://sandbox.juspay.in/customers/:customer_id/virtual-accounts/:virtual_account_reference' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--header 'Authorization: Basic QTA0QT*******ODg1Og==' \
--header 'x-merchantid: merchant_id' \
--data-urlencode 'command=enable'
