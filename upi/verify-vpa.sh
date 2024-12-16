curl --location --request POST 'https://api.juspay.io/v2/upi/verify-vpa' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--header 'Authorization: Basic RDR****DQkVC****BQjc0QThCOg==' \
--data-urlencode 'vpa=99999999@upi' \
--data-urlencode 'merchant_id=merchantId'