curl --location --request POST 'https://smartgateway.hdfcbank.com/v2/upi/verify-vpa' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--header 'Authorization: Basic QTA0QT*******ODg1Og==' \
--data-urlencode 'vpa=9999999999@upi' \
--data-urlencode 'merchant_id=merchantId'