curl --location 'https://api.juspay.in/customers/<customerId>/eligibility' \
--header 'Authorization: <Auth Key>' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--header 'version: <current date>' \           --- This is mandatory for Twid v2 
--data-urlencode 'amount=100' \
--data-urlencode 'gateway_reference_id=refId' \
--data-urlencode 'order_id=orderId' \
--data-urlencode 'mobile_number=mobile_number'
