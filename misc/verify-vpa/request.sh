curl --location --request POST 'https://smartgateway.hdfcbank.com/v2/upi/verify-vpa' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--header 'Authorization: Basic RDRGQkRDQkVC****BQjc0QThCOg==' \
--data-urlencode 'vpa=9999999999@upi' \
--data-urlencode 'merchant_id=merchantId'