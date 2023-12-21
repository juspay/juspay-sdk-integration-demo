curl --location --request POST 'https://smartgateway.hdfcbank.com/orders' \
--header 'Authorization: Basic <API_KEY>' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'order_id=Test1608304994' \
--data-urlencode 'amount=100'
--data-urlencode 'metadata.CRED:offers_applied:false'